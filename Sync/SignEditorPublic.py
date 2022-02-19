from tkinter import *
import re

# Create main window.
window = Tk()
window.title("Sign Pixel Editor")
window.geometry("400x400")
window.resizable(False, False)
window.grid_columnconfigure(0,weight=1)

pixelOrder = []
buttons = {}
dataValues = []
# it does something, don't know much about it other than it takes in args for a new button. Also, custom attributes
class NewButton(Button):
    def __init__(self, master, isActive=False,bIndex = 0, currentPixelIndex = 0, *args, **kwargs):
        Button.__init__(self, master, *args, **kwargs)
        self.master, self.isActive,self.bIndex,self.currentPixelIndex = master, isActive, bIndex,currentPixelIndex


# First part of selection
def changeArray(selected):
    if (selected.isActive == False):
        newPixelIndex = len(pixelOrder)
        pixelOrder.append([dataValues[selected.bIndex][0],selected])
        selected.currentPixelIndex = newPixelIndex
        selected.isActive = True
        selected.configure(bg="green")
        #print("New data values:")
        #print(pixelOrder)
    else:
        selected.isActive = False
        selected.configure(bg="black")
        markedIndex = selected.currentPixelIndex
        pixelOrder.pop(markedIndex)
        selected.currentPixelIndex = 0
        print(markedIndex+1,len(pixelOrder)+1)
        for x in range(markedIndex+1,len(pixelOrder)+1):
            pixelOrder[x-1][1].currentPixelIndex -= 1
            #print(pixelOrder[x-1][1].currentPixelIndex, "deleted")
        #print("New data values:")
        #print(pixelOrder)

def clearEntry():
    currentEntry.configure(text="")

def assignButton(button):
    buttonValue = int(Tk.cget(button,"text"))
    button.configure(command=lambda: changeArray(button),text="")
    button.bIndex = buttonValue - 1

# Default button schema best looking button
for i in range(1,21):
    buttons[str(i)] = NewButton(window,text=i,padx=8,pady=8,width=5,bg="black")

currentSet = 1
currentRow = 0
# When you're too tired to copy and paste 20 buttons but you take longer to do it this way anyway:
for i in range(1,21):
    index = buttons[str(i)]
    number = int(Tk.cget(index,"text"))
    assignButton(buttons[str(i)])
    currentRow +=1
    dataValues.append([(currentSet,currentRow),buttons[str(i)],0])
    index.grid(row=currentRow, rowspan=1, column=currentSet)
    if (i % 5 == 0):
        currentRow = 0
        currentSet += 1


#print("Initial data values:")
#print(dataValues)

def removeData():
    global dataValues
    global pixelOrder
    for button in buttons:
        buttonValue = buttons[button]
        dataValues[buttonValue.bIndex-1][1] = buttonValue
        buttonValue.isActive = False
        buttonValue.configure(bg="black")
        buttonValue.currentPixelIndex = 0
    pixelOrder = []

def printData():
    assembledRDict = "{"
    if len(pixelOrder) == 1:
        print("{" + re.sub("[() ]", "",  str(pixelOrder[0][0])) + "}")
        return
    for value in range(1,len(pixelOrder)+1):
        if (not value >= len(pixelOrder)):
            assembledRDict += re.sub("[() ]", "",  str(pixelOrder[value-1][0])) + ", "
        else:
            assembledRDict += re.sub("[() ]", "",  str(pixelOrder[value-1][0])) + "}"
    print(assembledRDict)



clearData = Button(window,text="Clear",padx=8,pady=8,width=5,bg="white",command=removeData)
clearData.grid(row=11,rowspan=1,column=1)

clearData = Button(window,text="Print Data",padx=8,pady=8,width=5,bg="white",command=printData)
clearData.grid(row=12,rowspan=1,column=1)


currentEntry = Label(window,text = "",font=("Arial","15"),padx=45)
currentEntry.grid(row=0, rowspan=1, column=5)

window.mainloop()

