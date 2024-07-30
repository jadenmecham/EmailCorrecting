#!/usr/bin/env python3

reqs = ['numpy', 'pymailcheck']

import os
import subprocess
import sys

subprocess.check_call([sys.executable, "-m", "pip", "install", reqs[0]])
subprocess.check_call([sys.executable, "-m", "pip", "install", reqs[1]])

import csv
import pymailcheck as pymc
from difflib import SequenceMatcher
import numpy as np
import tkinter as tk
from tkinter import *
from tkinter import filedialog

# list of common email domains
emailDomains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'msn.com', 'outlook.com', 'umail.utah.edu', 'me.com', 'mac.com', 'ymail.com', 'imail.org', 'math.utah.edu', 'va.gov', 'email.utcourts.gov', 'math.usu.edu', 'email.com']

class Correction:
  def __init__(self, altruPath, resultsName, resultsLocation):
    self.altruPath = altruPath
    self.resultsName = resultsName
    self.resultsLocation = resultsLocation

  # Function to read the altru data
  def getData(self):
    with open(self.altruPath, newline='') as csvfile:
      data = list(csv.reader(csvfile))
    return data

# function to correct domain errors. 
  def domainCorrection(self, bouncedEmails):
    for i in range(len(bouncedEmails)-1):
      j = i+1
      currentEmail = bouncedEmails[j][2] # reading only the email adress in the list of user information
      sugg = pymc.suggest(currentEmail, domains=emailDomains) # suggesting a correction to the domain based on the given email and list of common domains
      # if there is no suggestion, append a dash to the list. If there is a suggestion, append that suggestion to the list
      if sugg == False:
         bouncedEmails[j].append('-')
         bouncedEmails[j].append('-')
      else:
         bouncedEmails[j].append('misspelled domain')
         bouncedEmails[j].append(sugg['full'])

  def similarity(self,a,b):
    sim = SequenceMatcher(None, a, b).ratio()
    return sim

  def nameCorrection(self,bouncedEmails):
    for i in range(len(bouncedEmails)-1):
        # index the name and email of the person
        j = i+1
        email = bouncedEmails[j][2]
        name = bouncedEmails[j][0]
        # split the name into first, middle, and last, take only the username of the email
        first = ((name.split())[0]).lower()
        last = ((name.split())[-1]).lower()
        username = (email.split('@'))[0]

        if first in username and last in username: # no obvious typo if the first and last name are spelled correctly in the username
            continue
        elif (first in email) and (self.similarity(username.replace(first,''), last) > 0.7): # possible typo if the first name is in the email and the last name is very similar to the remaining username 
            bouncedEmails[j][9] = "possible name typo"
            bouncedEmails[j][10] = "fix typo"
        elif (last in email) and (self.similarity(username.replace(last,''), first) > 0.7): # possible typo if the last name is in the email and the first name is very similar to the remaining username 
            bouncedEmails[j][9] = "possible name typo"
            bouncedEmails[j][10] = "fix typo"
        else:
            continue

  # function to create the nice looking table 
  def createCSV(self, list):
    resultsPath = self.resultsLocation
    resultsName = self.resultsName
    headers = ["Name", "Lookup ID", "Given Email", "Primary Email?", "Bounced?", "Inactive?", "Email Date Changed", "System Record ID", "QUERYRECID", "Suspected Issue", "Suggested Fix"]
    m = np.array(list[1:])

    with open(resultsPath + '/' + resultsName + '.csv', 'w') as f:
        write = csv.writer(f)
        write.writerow(headers)
        write.writerows(list[1:])

  def correct(self):
    altruData = self.getData()
    self.domainCorrection(altruData)
    self.nameCorrection(altruData)
    self.createCSV(altruData)

def browseFiles():
    filename = filedialog.askopenfilename(initialdir = "/", filetypes=[("CSV files", "*.csv")],title = "Select a File") # open file select window
    fileLabel = Label(window, text = "Selected file: " + filename, width = 60, height = 4, fg = "black", bg="light grey") # print the selected file path
    fileLabel.grid(column = 0, row = 4) # set the print location
    c.altruPath = filename # update class
    
def saveFile():
   resultsPath = filedialog.askdirectory() #Path where you want the results.csv file to go
   c.resultsLocation = resultsPath # update class
   resultsFileName = resultsEntry.get()
   c.resultsName = resultsFileName
   c.correct() 
   doneLabel = Label(window, text = "Done!", bg="light grey")
   doneLabel.grid(column=0, row=9)

def reset():
   fileLabel = Label(window, text = "No selected file", width = 60, height = 4, fg = "black", bg="light grey") 
   fileLabel.grid(column = 0, row = 4)
   resultsEntry = Entry(width=10, bg="light grey")
   resultsEntry.grid(column=0, row=6)
   doneLabel = Label(window, text = "             ", bg="light grey")
   doneLabel.grid(column=0, row=9)

c = Correction('-', '-', '-') # create instace of correction class 

window = Tk() # Create the root window
window.title('Altru Email Corrector') # Set window title
window.geometry("575x350") # Set window size
window.config(background = "light grey") #Set window background color

# Create a File Explorer label
label_file_explorer = Label(window, text = "Please select a .csv file from Altru:", width = 62, height = 4, fg = "black", bg="light grey")
label_file_explorer.grid(column = 0, row = 1)
# Create browse files button
button_explore = Button(window, text = "Browse Files", fg="blue", command = browseFiles, bg="light grey")
button_explore.grid(column = 0, row = 2)

# file select label
fileLabel = Label(window, text = "No selected file", width = 60, height = 4, fg = "black", bg="light grey") 
fileLabel.grid(column = 0, row = 4)

# download labels 
resultsNameLabel = Label(window, text = "Name your results file:", bg="light grey")
resultsNameLabel.grid(column=0, row=5)
resultsEntry = Entry(width=10, bg="light grey")
resultsEntry.grid(column=0, row=6)
buttonDownload = Button(window, text = "Download Results", fg="blue", command = saveFile, bg="light grey")
buttonDownload.grid(column=0, row=7)

# reset button
button_reset = Button(window, text = "Reset", fg="red", command = reset, bg="light grey")
button_reset.grid(column = 0, row = 10)

# space
space = Label(window, text = " ", bg="light grey")
space.grid(column=0, row=8)


window.mainloop()