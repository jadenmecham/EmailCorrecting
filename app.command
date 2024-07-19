#!/usr/bin/env python3
# Import Module
from tkinter import *
 
# create root window
root = Tk()
 
# root window title and dimension
root.title("test app")
# Set geometry (widthxheight)
root.geometry('400x300')

# function to display text when
# button is clicked
def clicked():
    lbl.configure(text = "how dare you")
 

# widgets: 

#adding a label to the root window
lbl = Label(root, text = "red butte garden IT")
lbl.grid()

# button widget with red color text
btn = Button(root, text = "don't click this button" ,
             fg = "red", command=clicked)
# set Button grid
btn.grid(column=1, row=0)



# Execute Tkinter
root.mainloop()