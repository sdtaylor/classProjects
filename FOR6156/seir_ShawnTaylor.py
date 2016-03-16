from SEIR_homework import *
import pylab

for infection_time in [1,3,5]:
    ca=seir()
    ca.inf_time=infection_time
    ca.Run()

    pylab.plot(ca.ydataH, 'b', label='Susceptible')
    pylab.plot(ca.ydataE, 'g', label='Exposed')
    pylab.plot(ca.ydataI, 'r', label='Infected')
    pylab.plot(ca.ydataR, 'k', label='Resistant')

    pylab.title('Infection time: '+str(infection_time))
    pylab.legend()
    pylab.show()
