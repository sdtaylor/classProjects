import numpy as np
import pylab


def simulate(X, t):
    global a,b
    dX1=100 - a*X[0]*X[1]
    dX2=a*X[0]*X[1] - b*X[1]

    return(dX1, dX2)


#Values to go into the rk4 function
timeStep=0.001
timeSeries=np.arange(0,20, timeStep)
X = (10.0, 1.0)

#Ranges of a and b to test over
a_range=np.arange(0.001, 0.05, 0.001).tolist()
b_range=np.arange(0.01, 1.0, 0.01).tolist()

#Default values of a and b
a=0.0025
b=0.1

#Record the values of X1 and X2 at t=20 for each value in a_range
a_sens=[]
for i in a_range:
    a=i
    Xout=pylab.rk4(simulate, X, timeSeries)
    t20_values=Xout[19].tolist()
    #third column will be a value. b remains default throughout
    t20_values.append(i)

    a_sens.append(t20_values)

a_sens=np.array(a_sens)


#Reset a to default to test sensitivity to b
a=0.0025

b_sens=[]
for i in b_range:
    b=i
    Xout=pylab.rk4(simulate, X, timeSeries)
    t20_values=Xout[19].tolist()
    #third column will be b value. a remains default throughout
    t20_values.append(i)

    b_sens.append(t20_values)
b_sens=np.array(b_sens)

#Plot range of a on x axis, values of X1,X2 at t20 on y axis
pylab.plot(a_sens[:,2], a_sens[:,0], '-b', label='X1')
pylab.plot(a_sens[:,2], a_sens[:,1], '-r', label='X2')
pylab.xlabel('Value of a')
pylab.ylabel('Values of X1 & X2 at t=20')
pylab.title('Values of X1 and X2 and t=20 with b=0.1 and a varying')
pylab.legend(loc='upper left')
pylab.show()

#ditto with sensitivity of b
pylab.plot(b_sens[:,2], b_sens[:,0], '-b', label='X1')
pylab.plot(b_sens[:,2], b_sens[:,1], '-r', label='X2')
pylab.xlabel('Value of b')
pylab.ylabel('Values of X1 & X2 at t=20')
pylab.title('Values of X1 and X2 and t=20 with a=0.0025 and b varying')
pylab.legend(loc='upper left')
pylab.show()
