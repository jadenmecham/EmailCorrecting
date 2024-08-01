#!/usr/bin/env python3

reqs = ['numpy', 'pymailcheck'] # required packages that are not built into python

import os
import subprocess
import sys

subprocess.check_call([sys.executable, "-m", "pip", "install", reqs[0]]) # install the required packages 
subprocess.check_call([sys.executable, "-m", "pip", "install", reqs[1]])

# import all packages
import csv
import pymailcheck as pymc
from difflib import SequenceMatcher
import numpy as np
import tkinter as tk
from tkinter import *
from tkinter import filedialog

# list of common email domains to check against. Add more as needed
emailDomains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'msn.com', 'outlook.com', 'umail.utah.edu', 'me.com', 'mac.com', 'ymail.com', 'imail.org', 'math.utah.edu', 'va.gov', 'email.utcourts.gov', 'math.usu.edu', 'email.com']

# A class for the imported data set. Makes it easier to update a few things throughout the program. 
class Correction:
  def __init__(self, altruPath, resultsName, resultsLocation):
    self.altruPath = altruPath
    self.resultsName = resultsName
    self.resultsLocation = resultsLocation

  # Function to read the altru data
  def getData(self):
    with open(self.altruPath, newline='') as csvfile:
      data = list(csv.reader(csvfile))  # open the csv file and return it as a 2D list to read it easier later
    return data

# function to correct domain errors. 
  def domainCorrection(self, bouncedEmails):
    for i in range(len(bouncedEmails)-1): # for loop runs through every line. Use len - 1 and j later to excllude the headers from the loop. 
      j = i+1
      currentEmail = bouncedEmails[j][2] # reading only the email adress in the list of user information
      sugg = pymc.suggest(currentEmail, domains=emailDomains) # suggesting a correction to the domain based on the given email and list of common domains
      # if there is no suggestion, append a dash to the list. If there is a suggestion, append that suggestion to the list
      if sugg == False:
         bouncedEmails[j].append('-') # if there is no suggestion, append a dash
         bouncedEmails[j].append('-')
      else:
         bouncedEmails[j].append('misspelled domain') # if there is a domain error, append that there is a mispelled domain and the suggestion
         bouncedEmails[j].append(sugg['full'])

  # function to evaluate the similarity between two strings
  def similarity(self,a,b):
    sim = SequenceMatcher(None, a, b).ratio() # similarity of two strings. It is a ratio our of 1. The closer to 1, the more similar. 
    return sim 

  # Function for detecting typos in a persons name. 
  def nameCorrection(self,bouncedEmails):
    for i in range(len(bouncedEmails)-1): # for loop that goes through each email. Use len -1 and j to exclude headers from the spreadsheet. 
        j = i+1
        email = bouncedEmails[j][2] # index the name and email of the person
        name = bouncedEmails[j][0]
        first = ((name.split())[0]).lower() # split the name into first and last
        last = ((name.split())[-1]).lower()
        username = (email.split('@'))[0] # take the username of the email. Everything before @  (excluding the domain)

        # Check for typos:
        # the two typo cases work in a similar way. First one: If the first name is contained within the username, it is removed from the username. 
        # Then, the remaining username string is compared to the last name. There is a possible typo if the remaining username is very similar to the last name.
        # The second typo case works in a very similar way.  

        if first in username and last in username: # no obvious typo if the first and last name are spelled correctly in the username
            continue
        elif (first in email) and (self.similarity(username.replace(first,''), last) > 0.7): # possible typo if the first name is in the email and the last name is very similar to the remaining username 
            bouncedEmails[j][-2] = "possible name typo"
            bouncedEmails[j][-1] = "fix typo"
        elif (last in email) and (self.similarity(username.replace(last,''), first) > 0.7): # possible typo if the last name is in the email and the first name is very similar to the remaining username 
            bouncedEmails[j][-2] = "possible name typo"
            bouncedEmails[j][-1] = "fix typo"
        else: # if no obvious errors, move on. 
            continue

  # function to create the nice looking table 
  def createCSV(self, list):
    resultsPath = self.resultsLocation # location where the .csv file will go
    resultsName = self.resultsName # name of the .csv file

    with open(resultsPath + '/' + resultsName + '.csv', 'w') as f:
        write = csv.writer(f) # write the .csv file using the data list that we corrected. 
        write.writerows(list)

  # like a main() function. Just tells the program to do all the typo checking work. 
  def correct(self):
    altruData = self.getData()
    self.domainCorrection(altruData)
    self.nameCorrection(altruData)
    self.createCSV(altruData)

# this function is what the select file button does. It gets the path of the altru file
def browseFiles():
    filename = filedialog.askopenfilename(initialdir = "/", filetypes=[("CSV files", "*.csv")],title = "Select a File") # open file select window
    fileLabel = Label(window, text = "Selected file: " + filename, width = 60, height = 4, fg = "black", bg="white") # print the selected file path
    fileLabel.grid(column = 0, row = 4) # set the print location
    c.altruPath = filename # update class to include the altru file location. 

# this function is what the download button does. Asks for a desination path, does all the data correction, and puts the file where you want.     
def saveFile():
   resultsPath = filedialog.askdirectory() #Path where you want the results.csv file to go
   c.resultsLocation = resultsPath # update class
   resultsFileName = resultsEntry.get() # get the name entered into the textbox 
   c.resultsName = resultsFileName # update class with the file name
   c.correct() # do all the email correction
   doneLabel = Label(window, text = "Done!", fg="black", bg="white") # make text come up that says "done!"
   doneLabel.grid(column=0, row=9) # location of the done text 

# this function is what the reset button does. It resets the app
def reset():
   fileLabel = Label(window, text = "No selected file", width = 60, height = 4, fg = "black", bg="white") # replace the selected file text with no file selected
   fileLabel.grid(column = 0, row = 4) # no file selected text location
   resultsEntry = Entry(width=10, fg="black",bg="white") # make the text box empty again
   resultsEntry.grid(column=0, row=6) # text box location
   doneLabel = Label(window, text = "             ", bg="white") # put some empty space where the "done!" text is
   doneLabel.grid(column=0, row=9) # empty space location. 

c = Correction('-', '-', '-') # create instace of correction class 

window = Tk() # Create the root window
window.title('Altru Email Corrector') # Set window title
window.geometry("575x350") # Set window size
window.config(background = "white") #Set window background color
window.tk_setPalette(background='white', foreground='white',activeBackground='white', activeForeground='white') # set the default color palette

label_file_explorer = Label(window, text = "Please select a .csv file from Altru:", width = 62, height = 4, fg = "black", bg="white") # Create file selection text
label_file_explorer.grid(column = 0, row = 1) # location of the text 

button_explore = Button(window, text = "Browse Files", fg="blue", command = browseFiles, bg="white") # Create a button that does the browse file function
button_explore.grid(column = 0, row = 2) # button location

fileLabel = Label(window, text = "No selected file", width = 60, height = 4, fg = "black", bg="white") # create text that shows that no file is selected 
fileLabel.grid(column = 0, row = 4) # text locaiton

resultsNameLabel = Label(window, text = "Name your results file:", fg="black",bg="white") # text that asks user to name the results file
resultsNameLabel.grid(column=0, row=5) # text location

resultsEntry = Entry(width=10,fg="black", bg="white") # text box to enter file name for the results
resultsEntry.grid(column=0, row=6) # text box location

buttonDownload = Button(window, text = "Download Results", fg="blue", command = saveFile, bg="white") # button that does the save file function
buttonDownload.grid(column=0, row=7) # button location

button_reset = Button(window, text = "Reset", fg="red", command = reset, bg="white") # button that does the reset function
button_reset.grid(column = 0, row = 10) # button location

space = Label(window, text = " ", bg="white") # create some white space
space.grid(column=0, row=8) # white space location

window.mainloop() # run the window

# EmailCorrecting by Jaden Mecham
# Red Butte Garden IT