#!/usr/bin/env python3

from tkinter import *
from tkinter import filedialog

class Correction:
  def __init__(self, altruPath, resultsName, resultsLocation):
    self.altruPath = altruPath
    self.resultsName = resultsName
    self.resultsLocation = resultsLocation

def browseFiles():
    filename = filedialog.askopenfilename(initialdir = "/", filetypes=[("CSV files", "*.csv")],title = "Select a File") # open file select window
    fileLabel = Label(window, text = "Selected file: " + filename, width = 60, height = 4, fg = "black") # print the selected file path
    fileLabel.grid(column = 0, row = 4) # set the print location
    c.altruPath = filename # update class
    
                                                                                                       
c = Correction('-', '-', '-') # create instace of correction class 

window = Tk() # Create the root window
window.title('Altru Email Corrector') # Set window title
window.geometry("575x350") # Set window size
window.config(background = "white") #Set window background color

# Create a File Explorer label
label_file_explorer = Label(window, text = "Please select a .csv file from Altru:", width = 62, height = 4, fg = "black")
# Create browse files button
button_explore = Button(window, text = "Browse Files", fg="blue", command = browseFiles)
label_file_explorer.grid(column = 0, row = 1)
button_explore.grid(column = 0, row = 2)


# file select label
fileLabel = Label(window, text = "No selected file", width = 60, height = 4, fg = "black") 
fileLabel.grid(column = 0, row = 4)

window.mainloop()