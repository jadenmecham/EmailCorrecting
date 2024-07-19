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
from tkinter import filedialog

root = tk.Tk()
root.withdraw()

# list of common email domains
emailDomains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'msn.com', 'outlook.com', 'umail.utah.edu', 'me.com', 'mac.com', 'ymail.com', 'imail.org', 'math.utah.edu', 'va.gov', 'email.utcourts.gov', 'math.usu.edu', 'email.com']

# Function to read the altru data
def getData():
  print('')
  input("press [enter] to select a .csv file from altru...")
  print('')
  altruListPath = filedialog.askopenfilename() # path of the .csv file from altru
  # opening the .csv file containing all of the exported emails
  with open(altruListPath, newline='') as csvfile:
      data = list(csv.reader(csvfile))
  return data

# function to correct any typos in the domain of an email
def domainCorrection(bouncedEmails, commonDomains):
   for i in range(len(bouncedEmails)-1):
      j = i+1
      currentEmail = bouncedEmails[j][2] # reading only the email adress in the list of user information
      sugg = pymc.suggest(currentEmail, domains=commonDomains) # suggesting a correction to the domain based on the given email and list of common domains
      # if there is no suggestion, append a dash to the list. If there is a suggestion, append that suggestion to the list
      if sugg == False:
         bouncedEmails[j].append('-')
         bouncedEmails[j].append('-')
      else:
         bouncedEmails[j].append('misspelled domain')
         bouncedEmails[j].append(sugg['full'])

# function for name similarity checking (used to flag possible name typos)
def similarity(a,b):
    sim = SequenceMatcher(None, a, b).ratio()
    return sim

# function to flag possible name typos
def nameCorrection(bouncedEmails):
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
    elif (first in email) and (similarity(username.replace(first,''), last) > 0.7): # possible typo if the first name is in the email and the last name is very similar to the remaining username 
       bouncedEmails[j][9] = "possible name typo"
       bouncedEmails[j][10] = "fix typo"
    elif (last in email) and (similarity(username.replace(last,''), first) > 0.7): # possible typo if the last name is in the email and the first name is very similar to the remaining username 
       bouncedEmails[j][9] = "possible name typo"
       bouncedEmails[j][10] = "fix typo"
    else:
       continue
   
# function to create the nice looking table 
def createCSV(list):
  print('')
  resultsName = input("input a name for the results spreadsheet, then press [enter]: ")
  print('')
  input("press [enter] to select a location for the results spreadsheet to go...")
  print('')
  resultsPath = filedialog.askdirectory() #Path where you want the results.csv file to go
  headers = ["Name", "Lookup ID", "Given Email", "Primary Email?", "Bounced?", "Inactive?", "Email Date Changed", "System Record ID", "QUERYRECID", "Suspected Issue", "Suggested Fix"]
  m = np.array(list[1:])

  with open(resultsPath + '/' + resultsName + '.csv', 'w') as f:
     write = csv.writer(f)
     write.writerow(headers)
     write.writerows(list[1:])
   
def main():
  os.system('clear')
  print('red butte garden IT')
  print('')
  print('')
  print('welcome to typos.command')
  print('')
  print('')
  altruData = getData()
  domainCorrection(altruData, emailDomains)
  nameCorrection(altruData)
  createCSV(altruData)
  print('')
  print('done!')
  print('')

main()

