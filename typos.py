import csv
import pandas as pd
import pymailcheck as pymc
from difflib import SequenceMatcher
import numpy as np
from tabulate import tabulate

# -----------------------------------------------------------------------------------------------------------------
# ONLY CHANGE THINGS IN THIS BOX!
folderpath = '/Users/u1531715/Desktop/Email Correcting/' # Path to the folder containing the altru list and email domain list
altruList = 'fake emails.csv' # name of the .csv file from altru
commonDomains = 'Domains.xlsx'
resultsPath = '/Users/u1531715/Desktop/' #Path where you want the results.csv file to go
# DO NOT EDIT ANYTHING UNDER THIS LINE
#-------------------------------------------------------------------------------------------------------------------

# Function to read all the data needed for later (bounced emails, common email domains)
def getData(altruList, domainsList):
  # opening the .csv file containing all of the exported emails
  with open(altruList, newline='') as csvfile:
      rawData = list(csv.reader(csvfile))

  # trimming the data. Only want to look at the name, lookup ID, and email address 
  data = []
  for i in range(len(rawData)):
    data.append(rawData[i][:3])

  # open an excel file with a list of common domains and put it in a list
  df = pd.read_excel(domainsList)
  customDomains = df["Full Domains"].tolist()

  return data, customDomains

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
       bouncedEmails[j][3] = "possible name typo"
       bouncedEmails[j][4] = "fix typo"
    elif (last in email) and (similarity(username.replace(last,''), first) > 0.7): # possible typo if the last name is in the email and the first name is very similar to the remaining username 
       bouncedEmails[j][3] = "possible name typo"
       bouncedEmails[j][4] = "fix typo"
    else:
       continue
   
# function to create the nice looking table 
def createTable(list):
  headers = ["Name", "Lookup ID", "Given Email", "Suspected Issue", "Suggested Fix"]
  m = np.array(list[1:])

  # Generate the table in fancy format.
  table = tabulate(m, headers, tablefmt="fancy_grid")

  with open(resultsPath + 'results.csv', 'w') as f:
     write = csv.writer(f)
     write.writerow(headers)
     write.writerows(list[1:])

  return table 
   


def main():
  a = folderpath + altruList
  b = folderpath + commonDomains
  people, emailDomains = getData(a, b) 
  domainCorrection(people, emailDomains)
  nameCorrection(people)
  table = createTable(people)
  print(table)

main()