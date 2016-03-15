import numpy as np
from matplotlib import pyplot as plt

X1= np.array([ 0.0, 0.0, 0.0, 1.0, 0.0], 'f')

A = np.array([[0,0,1,0,0],
              [0,0,0,1,0],
              [0,1,0,0,0],
              [0,0,0,0,1],
              [1,0,0,0,0]], 'f')

B = np.array([[0.5 ,0.25,0.25,0.0 ,0.0 ,0.0,],
              [0.0 ,0.0 ,0.0 ,0.0 ,.25 ,.75],
              [0.0 ,0.0 ,0.0 ,0.0 ,0.0 ,1.0],
              [0.5 ,0.5 ,0.0 ,0.0 ,0.0 ,0.0],
              [.25 ,.75 ,0.0 ,0.0 ,0.0 ,0.0]], 'f')


#Return a 2d matrix of observed states over time
#rows are the 6 observed states, columns are the timesteps
def doTimeSteps(X,A,B, numSteps):
    obs=np.zeros(6*numSteps).reshape((6,numSteps))
    for i in range(numSteps):
        X=np.dot(X,A)
        obs[:,i]=np.dot(X,B)
    return(obs)

#Plot observations of the 6 states over the number of timesteps
def plotObs(y, numSteps):
    x=range(numSteps)
    colors=['r','g','b','m','y','k']
    for state in range(6):
        plt.plot(x, y[state], color=colors[state], marker='o', linestyle='solid')
    plt.figure()

timeSteps=20

#####################################################################
#Sensitivity analysis.
####################################################################
#Plot out trajectories of having 1 in each initial hidden state, and 0's in the rest.
X1= np.array([ 1.0, 0.0, 0.0, 0.0, 0.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)

X1= np.array([ 0.0, 1.0, 0.0, 0.0, 0.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)

X1= np.array([ 0.0, 0.0, 1.0, 0.0, 0.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)

X1= np.array([ 0.0, 0.0, 0.0, 1.0, 0.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)

X1= np.array([ 0.0, 0.0, 0.0, 0.0, 1.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)
plt.show()
# Altering things like above offsets each observed state in time, but trends remain the same.
#####################################################################


X1= np.array([ 20.0, 15.0, 10.0, 5.0, 1.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)

X1= np.array([ 1.0, 5.0, 10.0, 15.0, 20.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)
plt.show()
#Different starting values above have very different highs and lows for
#the dominant observed states, but overal means look to be unchanged. 
#smaller observed states remain relatively the same. 

#######################################################################

X1= np.array([ 1.0, 1.0, 1.0, 1.0, 1.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)

X1= np.array([ 10.0, 10.0, 10.0, 10.0, 10.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)

X1= np.array([ 100.0, 100.0, 100.0, 100.0, 100.0], 'f')
plotObs(doTimeSteps(X1,A,B,timeSteps), timeSteps)

plt.show()
#Stable states all around!
