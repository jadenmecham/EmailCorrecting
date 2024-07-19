#!/usr/bin/env python3
# Import Module
from tkinter import *
 
# create root window
root = Tk()
 
# root window title and dimension
root.title("test app")
# Set geometry (widthxheight)
root.geometry('400x300')
 
#adding a label to the root window
lbl = Label(root, text = "red butte garden IT")
lbl.grid()

# Execute Tkinter
root.mainloop()