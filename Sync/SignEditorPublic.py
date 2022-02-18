from tkinter import *

# Create main window.
window = Tk()
window.title("Number panel")
window.geometry("400x400")
window.resizable(False, False)
window.grid_columnconfigure(0,weight=1)

# First part of selection
def changeArray(a,b,c):
    selected = a
    buttonNumber = b
    data = c
    if (dataValues[data][1] == False):
        dataValues[data][1] = True
        selected.configure(bg="green")
    else:
        dataValues[data][1] = False
        selected.configure(bg="black")

def clearEntry():
    currentEntry.configure(text="")

def assignButton(button,index):
    buttonValue = int(Tk.cget(button,"text"))
    button.configure(command=lambda: changeArray(button,buttonValue,index),text="")

buttons = {}
dataValues = {}
for i in range(1,26):
    buttons[str(i)] = Button(window,text=i,padx=8,pady=8,width=5,bg="black")

currentSet = 1
currentRow = 7
# When you're too tired to copy and paste 20 buttons but you take longer to do it this way anyway:
for i in range(1,21):
    index = buttons[str(i)]
    number = int(Tk.cget(index,"text"))
    assignButton(buttons[str(i)],i)
    currentRow -=1
    dataValues[i] = [(currentSet,(abs(6-currentRow))),False,0]
    index.grid(row=currentRow, rowspan=1, column=currentSet)
    if (i % 5 == 0):
        currentRow = 7
        currentSet += 1

print(dataValues)

currentEntry = Label(window,text = "",font=("Arial","15"),padx=45)
currentEntry.grid(row=0, rowspan=1, column=5)

window.mainloop()

