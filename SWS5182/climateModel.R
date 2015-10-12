library(melt)
library(ggplot2)
setwd('~/Documents/Class/SWS5128/Lag Climate System')

#Variables
#Comments for each are: description, default value, unit, notes

#Geometry
Ae=5.10E+14 #	surface area of the earth, 5.10E+14, m2
Ao=3.60E+14	# surface area of the ocean, 3.60E+14, m2
DEPTHdo = 1.00E+02	# depth of surface ocean, 1.00E+02, m, to yield ~900 PgC at preindustrial time
Vso=3.60E+16	# volume of the surface ocean, 3.60E+16, m3
DEPTHdo=3.70E+03	# depth of the deep ocean, 3.70E+03, m
Vdo=1.33E+18	# volumne of the deep ocean, 1.33E+18, m3

#Parameters			
#Physical Parameters			
preIndustryOceanTemp=291	# pre-industrial surface ocean temp, 291, K
surfaceOceanSalinity = 3.50E-03	# surface ocean salinity, 3.50E-03
p = 1.03E+03	# density of sea water, 1.03E+03, kg m-3
lambda=0.34	#climate sensitivity, 0.68, K/(Wm-2)
lambdaRF=3.7	#radiative forcing for doubling of CO2, 3.7, Wm-2
cp=4.18E+03 #heat capacity of ocean water,	4.18E+03, J K-1 kg-1
Vdf=5.01E+15 # oceanic overturning (deepwater formation?), 5.01E+15, m3 yr-1, obtained to match DIC gradients

#Ocean Carbon Cycle Parameters			
#k2/(k0k1) (kg mol atm) 		1.99E-02	1.99E-02
#sensitivity of DIC solubility to T ((kg mol atm)/K)		1.98E-02	1.98E-02
#Atmosphere Ocean CO2 exchange rate mol m-2 yr-1 ppm-1		5.00E-02	5.00E-02

#Land Carbon Cycle Parameters			
#beta_factor		6.00E-01	6.00E-01
#Vegetation turnover		8.33E-02	8.33E-02
#Soil basic turnover		3.30E-02	3.30E-02
#Q10		2.00E+00	2.00E+00

#Useful conversions			
sec2years = 31536000	#seconds in a year, 31536000
ppm2PgC =	2.1	# 2.1, (PgC ppm-1)	
mol2PgC =	1.2E-014 #	1.2E-014, (PgC mol-1)	

#Initial conditions			
pCO2_a = 2.80E-04	#2.80E-04,  (atm)
pCO2_s = 2.80E-04	#2.80E-04,  (atm)
Alkalinity_S = 2.31E-03	#2.31E-03, (mol kg-1)
Alkalinity_D = 2.38E-03	#2.38E-03, (mol kg-1)
DIC_S	=2.07E-03	#2.07E-03
DIC_D	=2.28E-03	#2.28E-03
#DIC Soft and Hard Tissue Pump (mol yr-1)		1083333333333330	1083333333333330
#Alk Soft Tissue and Hard Tissue Pump (mol yr-1)		3.77E+14	3.77E+14
#NPP		4.58E+15	4.58E+15
#C_Veg		5.50E+16	5.50E+16
#C_Soil		1.39E+17	1.39E+17

#Boundary conditions			
timeStep=1	# time step, 1, years


oneToOne=function(obs, pred){
  return(1 - sum((obs-pred)**2) / sum((obs - mean(obs))**2))
  
  #return(1-((sum(pred-obs)^2)/sum(pred*2)))
}
############################################
#Define model

#takes the prior time step and makes calculates for the current one. the only update that doesn't get
#calculated here is the current level of CO2
processTimeStep = function(climatePrior, currentCO2=FALSE, year, currentRF=FALSE){
  #Empty 1 row DF to store new time step
  climateCurrent=data.frame(time=year, pCO2=currentCO2, RF=0, deltaTSurface=0, deltaTDeep=0, d_deltaTSurface=0, d_deltaTDeep=0)

  #If an RF value is passed, use that. Otherwise calculate it from co2. 
  if(!currentRF){
    climateCurrent$RF = lambdaRF * (log(currentCO2/pCO2_a)/log(2))
  } else{
    climateCurrent$RF = currentRF
  }
  
  climateCurrent$deltaTSurface = climatePrior$deltaTSurface + (climatePrior$d_deltaTSurface*timeStep)
  climateCurrent$deltaTDeep = climatePrior$deltaTDeep + (climatePrior$d_deltaTDeep*timeStep)
  
  #Add a small amount to this variable if it equals 0, otherwise the model divides by 0 in the very beginning and na's propegate throughout
  #if(climateCurrent$deltaTDeep==0) { climateCurrent$deltaTDeep = climateCurrent$deltaTDeep+1e-50 }
  climateCurrent$d_deltaTSurface = with(climateCurrent, RF - deltaTSurface/lambda) * sec2years * (Ae/(cp*Vso*p)) #- (with(climateCurrent, deltaTSurface-deltaTDeep) * Vdf/Vso)
  
  climateCurrent$d_deltaTDeep    = with(climateCurrent, deltaTSurface-deltaTDeep) * Vdf/Vdo
  
  return(climateCurrent)
}

#time = years, starting from 0,
#pCO2 = atmospheric CO2 concentration
#RF = total radiative forcing increase since time 0
#deltaTSurface = change in surface ocean temp since time 0
#deltaTDeep = change in deep ocean temp since time 0
#d_deltaTSurface = derivative (slope) change in deltaTSurface since last time step
#d_deltaTDeep = derivative (slop) change in deltaTDeep since last time step
#This initializes and sets the initial conditions for year 0
conditions=data.frame(time=0, pCO2=pCO2_a, RF=0, deltaTSurface=0, deltaTDeep=0, d_deltaTSurface=0, d_deltaTDeep=0)

#Co2 increase. Integer: incriment the yearly co2 by this amount
#              vector:  a pre-process list of co2 values for each year, must match the timestep

#Use crowley 2000 radiative forcing.
crowley=read.csv('crowley2000.csv')
crowleyRF=crowley$totalRF

timeSteps=999
for(year in 1:timeSteps){
  #co2=CO2vector[year+1]
  conditions=rbind(conditions, processTimeStep(tail(conditions, 1),pCO2_a*2, year, currentRF=crowleyRF[year] ))
}

conditionsLong=melt(conditions[,c('time','deltaTSurface','deltaTDeep')], id='time')
ggplot(conditionsLong, aes(x=time, y=value, colour=variable)) + 
  geom_line(size=3) + 
  labs(y='Change in temperature (K)', title='Increase in surface & deep ocean temperature \n using Crowley 2000 Radiative Forcing (minus volcanos)') +
  theme(text=element_text(size=20))


#Run model using crowleys data, and compare it to crowley temp data
plot(crowley$CL2[1:994]~conditions$deltaTSurface[1:994])
abline(0,1)
lm1=lm(crowley$CL2[1:994]~conditions$deltaTSurface[1:994])
