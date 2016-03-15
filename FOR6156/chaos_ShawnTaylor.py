import numpy as np
import pylab

#Generic function to plot a time series with many variables
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

#############################################################################
#[x, y, px, py] <- locations of variables inside v
#[0, 1,  2,  3]
def system1(v, t):
    #dpx = -x - 2*x*y
    dpx= -v[0] - 2*v[0]*v[1]

    #dpy = -y - x**2 + y**2
    dpy= -v[1] - v[0]**2 + v[1]**2

    #dx=px
    dx=v[2]
    #dx=py
    dy=v[3]

    return(dx, dy, dpx, dpy)


x=0.02
y=0.2
px=0.001
py=0.2

#Values to go into the rk4 function
dt=0.01
fintime=20.0
tim=np.arange(0.0, fintime, dt)
t0 = (x,y,px,py)

Xout=pylab.rk4(system1, t0, tim)
plotTimeSeries(Xout, ['x','y','px','py'], tim)
########################################################
#2nd system
a=0.2
b=0.2
c=5.7

#[x,y,z]
#[0,1,2]
def system2(v,t):
    #dx= -y - z
    dx=-v[1] - v[2]

    #dy= x + a*y
    dy= v[0] + a*v[1]

    #dz= b + x*z - c*z
    dz= b + v[0]*v[2] - c*v[2]


x=0.02
y=0.2
z=0.1

fintime=150.0
dt=0.01
tim=np.arange(0.0, fintime, dt)

t0=(x,y,z)
Xout=pylab.rk4(system2, t0, tim)
plotTimeSeries(Xout, ['x','y','z'], tim)
