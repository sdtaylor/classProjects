
import random

class seir:

	''' Susceptible, Exposed, Infected, Resistant '''

	def __init__(self):

		self.healthy = 0
		self.exposed = 1
		self.infected = 2
		self.immune = 3

		self.exp_time = 3
		self.inf_time = 3
		self.imm_time = 3

		self.inf_rate = 0.35
		self.init_exp = 0.1  # initial fraction infected

		self.max_time = 100
		self.cells = 1000

		self.state = [0]*self.cells
		self.timer = [0]*self.cells

		self.xdata = [ ]
		self.ydataH = [ ]
		self.ydataE = [ ]
		self.ydataI = [ ]
		self.ydataR = [ ]

		self.p = 0 # 1 allows local printing

		random.seed()


	def Setup(self):

		for i in range(self.cells):

			x = random.random()
			if x < self.init_exp:
				self.state[i] = self.exposed
				self.timer[i] = int(self.exp_time*random.random() + 1)



	def SpreadDisease(self):

		#lattice wraps around  cell 0 is adjacent to cell 999, and cell 1

		if self.state[0] == self.healthy: self.StoE(0,self.cells-1,1)  #Suscept to Exposed sub

		for i in range(1,self.cells-1):

			if self.state[i] == self.healthy: self.StoE(i, i-1, i+1)

		if self.state[self.cells-1] == self.healthy: self.StoE(self.cells-1,self.cells-2,0) 


	def StoE(self, cell, cellL, cellR):

		cnt = 0

		if self.state[cellL] == self.infected: cnt = 1
		if self.state[cellR] == self.infected: cnt = cnt +1

		if cnt > 0:

			if random.random() < float(cnt*self.inf_rate):

				self.state[cell] = self.exposed
				self.timer[cell] = self.exp_time


	def ChangeStates(self):


		for i in range(self.cells):

			if self.state[i] == self.immune:

				self.timer[i] = self.timer[i] - 1
				if self.timer[i] == 0: self.state[i] = self.healthy

			elif self.state[i] == self.infected:

				self.timer[i] = self.timer[i] - 1
				if self.timer[i] == 0:

					self.state[i] = self.immune
					self.timer[i] = self.imm_time

			elif self.state[i] == self.exposed:

				self.timer[i] = self.timer[i] - 1
				if self.timer[i] == 0:

					self.state[i] = self.infected
					self.timer[i] = self.inf_time

			else:

				pass  # healthy not changed




	def Measurements(self):


		scnt = ecnt = icnt = rcnt = 0.0

		for i in range(self.cells):

			if self.state[i] == self.healthy: scnt = scnt + 1.0
			if self.state[i] == self.exposed: ecnt = ecnt + 1.0
			if self.state[i] == self.infected: icnt = icnt + 1.0
			if self.state[i] == self.immune: rcnt = rcnt + 1.0

		self.sfrac = scnt/self.cells
		self.efrac = ecnt/self.cells
		self.ifrac = icnt/self.cells
		self.rfrac = rcnt/self.cells



	def Run(self):


		self.Setup()
		self.Measurements()
		if self.p == 1: print self.sfrac, self.efrac, self.ifrac, self.rfrac
		self.xdata.append(0.0)
		self.ydataH.append(self.sfrac)
		self.ydataE.append(self.efrac)
		self.ydataI.append(self.ifrac)
		self.ydataR.append(self.rfrac)

		for t in range(self.max_time):

			self.SpreadDisease()
			self.ChangeStates()
			self.Measurements()
			if self.p ==1: print self.sfrac, self.efrac, self.ifrac, self.rfrac
			self.xdata.append(float(t))
			self.ydataH.append(self.sfrac)
			self.ydataE.append(self.efrac)
			self.ydataI.append(self.ifrac)
			self.ydataR.append(self.rfrac)	


		if self.p ==1:	
			print '  '
			zzz = raw_input('OK')


if __name__ == '__main__':

        test = seir()
        #test.p = 1
        test.Run()

        y = test.ydataH
        y2 = test.ydataE
        y3 = test.ydataI
        y4 = test.ydataR

        from pylab import *

        plot(y,'b',label = 'Susceptible')
        plot(y2,'g',label = 'Exposed')
        plot(y3,'r',label = 'Infected')
        plot(y4,'k',label = 'Resistant')

        legend()

        show()

