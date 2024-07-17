# EmailCorrecting
For Red Butte Garden IT. Takes email list from Altru and flags potential spelling errors in the domain or username. It checks a user's email from a given .csv file against a list of common email domains and detects typos in the username based on the user's actual name. 

***typos.py*** is the email correction program. ***Domains.xlsx*** is a list of common email domains to check against. ***fake emails.csv*** is a recreation of an Altru export using fake email accounts with typos on purpose for testing. ***executable.command*** is an executable version of typos.py that runs in the terminal after after opening the file instead of needing to open an IDE to run it manually. 
