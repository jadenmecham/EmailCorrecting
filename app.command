#!/usr/bin/env python3

from tkinter import *
  
# import filedialog module
from tkinter import filedialog
  
# Function for opening the 
# file explorer window
def browseFiles():
    filename = filedialog.askopenfilename(initialdir = "/", filetypes=[("CSV files", "*.csv")],title = "Select a File")
    fileLabel = Label(window, text = filename)
    fileLabel.grid(column = 0, row = 3)
      
def createFrame():                                                                                                   
    # Create the root window
    window = Tk()
    # Set window title
    window.title('Altru Email Corrector')
    # Set window size
    window.geometry("550x300")
    #Set window background color
    window.config(background = "white")

    # Create a File Explorer label
    label_file_explorer = Label(window, text = "Please select a .csv file from Altru:", width = 55, height = 4, fg = "black")
    button_explore = Button(window, text = "Browse Files", fg="blue", command = browseFiles) 


    label_file_explorer.grid(column = 0, row = 1)
    button_explore.grid(column = 0, row = 2)

    return window
  
window = createFrame()
window.mainloop()