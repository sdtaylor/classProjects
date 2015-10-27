
#Assignment 2 - 3d

# Function to compute the NEGATIVE log-likelihood under the Null hypothesis: the Hardy-Weinberg model
# (note that here, the skeptic/researcher's roles are reversed: the hypothesis of interest 
# in a goodness of fit test is usually the null hypothesis -so we would be happy if we fail to reject Ho-)
# We will minimize this function using a numerical algorithm:  The nelder-mead simplex.
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


y1=7
y2=16
y3=20
y4=24
y5=17
y6=9
y7=5
y8=2

obs.counts <- c(y1,y2,y3,y4,y5,y6,y7,y8)

guess1 <- log(0.5)
n=100
mlest  <- optim(par=guess1, fn= negloglike.Ho, method="Nelder-Mead", ntot=n,obs=obs.counts)
mlest = optimize(f=negloglike.Ho, interval=0.01, ntot=n, obs=obs.counts, lower=0, upper=55)
mlest

##################################################################################

ab.mles<- 1/(1+exp(-mlest$par))
a.mle <- ab.mles[1]
b.mle <- ab.mles[2]
o.mle  <- 1-sum(ab.mles)
lnL0.hat <- (-1)*mlest$value
lnL1.hat <- max.loglike.H1(ntot=n,obs.counts = obs.counts)  


Gsq <- (-2)*(lnL0.hat - lnL1.hat)
Like.ratio <- exp(-0.5*Gsq) # Compute the likelihood ratio, a number between 0 and 1

npar.H1 <- 4-1 #(p1,p2,p3,p4)
npar.H0 <- 3-1 #(a,b,o)

df  <-  npar.H1 - npar.H0
Gsq.crit <- qchisq(p=0.95,df=df)
if(Gsq>Gsq.crit){print("Reject Ho")}else{print("Fail to reject Ho")}
pvalue <- 1-pchisq(Gsq,df)
print(pvalue)

# Expected number of counts:
p1.hat <- a.mle*a.mle + 2*a.mle*o.mle
p2.hat <- b.mle*b.mle + 2*b.mle*o.mle
p3.hat <- 2*a.mle*b.mle
p4.hat <- o.mle*o.mle
phat.vec <- c(p1.hat,p2.hat,p3.hat,p4.hat)
sum(phat.vec)
Expected.vec <- n*phat.vec


# Hand calculation of Gsq:
# if we had 0 counts, the log(0) would give us problem
# to protect against that we just make 0 the terms that have a log(0)
obs.counts[obs.counts==0] <- 1
Gsq.hand <- 2*sum(obs.counts*log(obs.counts/Expected.vec))
Gsq.hand
Gsq

# Printing a table of expected vs. observed
blood.types <- c("A", "B", "AB", "O")
Exp.vs.Obs <- cbind(obs.counts,Expected.vec)
row.names(Exp.vs.Obs) <- blood.types
print(Exp.vs.Obs)


 