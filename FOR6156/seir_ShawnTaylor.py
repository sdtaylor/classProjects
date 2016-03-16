from SEIR_homework import *
import pylab

for infection_time in [1,2,3,4,5]:
    ca=seir()
    ca.inf_time=infection_time
    ca.max_time=300
    ca.Run()

    pylab.plot(ca.ydataH, 'b', label='Susceptible')
    pylab.plot(ca.ydataE, 'g', label='Exposed')
    pylab.plot(ca.ydataI, 'r', label='Infected')
    pylab.plot(ca.ydataR, 'k', label='Resistant')

    pylab.title('Infection time: '+str(infection_time))
    pylab.legend()
    pylab.figure()

pylab.show()
