#!/usr/bin/env python3

from tkinter import *
 
# create root window
root = Tk()
 
# root window title and dimension
root.title("test app")
# Set geometry(widthxheight)
root.geometry('350x200')
 
# add top text
topText = Label(root, text = "altru email corrector by rbgit")
topText.grid()
blankTxt = Label(root, text = "").grid(row=1)

# add file select text
fileText = Label(root, text = "select a .csv file from altru")
fileText.grid(column = 0, row = 2)
 
# button is clicked
def clicked():
    pass
 
# button widget with red color text inside
btn = Button(root, text = "click here" ,
             fg = "red", command=clicked)
# Set Button Grid
btn.grid(column=1, row=2)
 
# Execute Tkinter
root.mainloop()