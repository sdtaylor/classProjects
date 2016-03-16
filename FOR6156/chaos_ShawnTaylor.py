import numpy as np
import pylab
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


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


#Values to go into the rk4 function
dt=0.01
fintime=500.0
tim=np.arange(0.0, fintime, dt)

# (x,y,px,py) <- intial values
Xout1=pylab.rk4(system1, (0.02, 0.2, 0.001, 0.2), tim)
Xout2=pylab.rk4(system1, (0.01, 0.3, 0.002, 0.1), tim)

fig=plt.figure()
ax = fig.gca(projection='3d')

#Graphs taken from http://matplotlib.org/examples/mplot3d/lorenz_attractor.html
#This system has 4 dimmensions but just looking at 3 still shows different patterns between the two starting conditions.
#Oringal initial values in red, slight change in them in blue.
ax.plot(Xout1[:,0], Xout1[:,1], Xout1[:,2], '-r')
ax.plot(Xout2[:,0], Xout2[:,1], Xout2[:,2], '-b')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('z')
ax.set_title('System 1')
ax.legend()
plt.show()
########################################################
########################################################
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

    return(dx, dy, dz)


fintime=500.0
dt=0.01
tim=np.arange(0.0, fintime, dt)

#(x,y,z)# <- initial conditions
Xout1=pylab.rk4(system2, (0.02, 0.2, 0.1), tim)
Xout2=pylab.rk4(system2, (0.03, 0.1, 0.2), tim)


fig=plt.figure()
ax = fig.gca(projection='3d')

#Oringal initial values in red, slight change in them in blue.
ax.plot(Xout1[:,0], Xout1[:,1], Xout1[:,2], '-r')
ax.plot(Xout2[:,0], Xout2[:,1], Xout2[:,2], '-b')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('z')
ax.set_title('System 2')
plt.show()
