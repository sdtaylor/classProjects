import pylab
import numpy as np


#values: numpy array. columns are variables, rows are time steps
#labels: variable names for each of the columns
#time: numpy 1d array for the x axis
def plotTimeSeries(values, labels, time,
                   title='', xlabel='', ylabel='',legendLocation='upper left'):
    colors=['-b','-g','-r','-c','-m','-y']

    for colNum, labelName in enumerate(labels):
        pylab.plot(time, values[:,colNum], colors[colNum], label=labelName)
    pylab.xlabel(xlabel)
    pylab.ylabel(ylabel)
    pylab.legend(loc=legendLocation)
    pylab.show()
