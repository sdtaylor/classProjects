
#Assignment 2 - 3d
#minimizer for the ML estimate of lambda
negloglike.Ho <- function(guess, ntot, obs){
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
	
	

max.loglike.H1 <- function(ntot,obs.counts){
	# returns the maximized log-likelihood function under the alternative model	
	len       <- length(obs.counts)
	phats     <- obs.counts/ntot 
	return(dmultinom(x=obs.counts, size=ntot,prob=phats, log=TRUE))	
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
mlest = optimize(f=negloglike.Ho, interval=0.001, ntot=n, obs=obs.counts, lower=0, upper=20)$minimum

####################################################################
#Problem 2e, expected values
expected.counts=dpois(c(0,1,2,3,4,5,6), mlest) #Get probabilites for 1-6 trees/quadrat
expected.counts=c(expected.counts, 1-sum(expected.counts)) #Add on >= 7 trees
expected.counts=expected.counts*n #expected frequency

plot(obs.counts~expected.counts)

##################################################################################
#  2f, goodness of fit test
 