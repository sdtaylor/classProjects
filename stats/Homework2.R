
#Assignment 2 - 3d
#minimizer for the ML estimate of lambda
negloglike.H1 <- function(guess, ntot, obs){
	  lambda=guess
		if(lambda<0){return(5000)}
		  else{
		    p1=exp(-lambda)**obs[1]
		    p2=(exp(-lambda)*lambda)**obs[2]
		    p3=((exp(-lambda)*lambda**2)/factorial(2))**obs[3]
		    p4=((exp(-lambda)*lambda**3)/factorial(3))**obs[4]
		    p5=((exp(-lambda)*lambda**4)/factorial(4))**obs[5]
		    p6=((exp(-lambda)*lambda**5)/factorial(5))**obs[6]
		    p7=((exp(-lambda)*lambda**6)/factorial(6))**obs[7]
		    p8=1-sum(p1,p2,p3,p4,p5,p6,p7)
		    
		    pvec=c(p1,p2,p3,p4,p5,p6,p7,p8)
		    
		    negloglike <- -dmultinom(x=obs.counts, size=ntot, prob=pvec, log=TRUE)
		    
		  }
		
		}
	
	


#Setup the observed data
y1=7
y2=16
y3=20
y4=24
y5=17
y6=9
y7=5
y8=2

obs.counts <- c(y1,y2,y3,y4,y5,y6,y7,y8)

#Run ML
guess1 <- log(0.5)
n=100
mlest = optimize(f=negloglike.H1, interval=0.001, ntot=n, obs=obs.counts, lower=0, upper=20)
lambdaMLE=mlest$minimum
lnMLE=log(mlest$objective)

####################################################################
#Problem 2e, expected values
expected.counts=dpois(c(0,1,2,3,4,5,6), lambdaMLE) #Get probabilites for 1-6 trees/quadrat
expected.counts=c(expected.counts, 1-sum(expected.counts)) #Add on >= 7 trees
expected.counts=expected.counts*n #expected frequency

plot(obs.counts~expected.counts)

##################################################################################
#  2f, goodness of fit test

#The probabilites for a fully parameterized model
phats = obs.counts/n

lnNullModel=dmultinom(x=obs.counts, size=n,prob=phats, log=TRUE)

Gsq= -2*(lnMLE - lnNullModel)
df=length(phats)-1   #question: the altenative model has only 1 parameter, so df will be negative
Gsq.crit <- qchisq(p=0.95,df=df)
pvalue <- 1-pchisq(Gsq,df)

###################################################################
#   2g

obs.counts=c(7,16,20,24,17,9,5,1,1)
numTrees=0:8

meanX=sum(obs.counts*numTrees)/100

#########
#  2h
#should this use the zero inflated poisson on pg 35 on notes? Not sure how else to model a neg binomial.
