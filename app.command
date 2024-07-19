#!/usr/bin/env python3

from tkinter import *
  
# import filedialog module
from tkinter import filedialog
  
# Function for opening the 
# file explorer window
def browseFiles():
    filename = filedialog.askopenfilename(initialdir = "/", filetypes=[("CSV files", "*.csv")],title = "Select a File")
    # add new text 
    label_file.configure(text="File Opened: "+filename)
      
      
                                                                                                  
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

label_file = Label(window, text = "", width = 60, height = 4, fg = "black")
  
# Grid method is chosen for placing
# the widgets at respective positions 
# in a table like structure by
# specifying rows and columns
label_file_explorer.grid(column = 0, row = 1)
  
button_explore.grid(column = 0, row = 2)

label_file.grid(column = 0, row = 3)
  
# Let the window wait for any events
window.mainloop()