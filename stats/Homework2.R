############################################################
#Assignment 2 - 3d

#liklehood function for the estimate of lambda
negloglike.H1 <- function(guess, ntot, obs){
	  lambda=guess
		if(lambda<0){return(5000)}
		  else{
		    p1=exp(-lambda)
		    p2=(exp(-lambda)*lambda)
		    p3=((exp(-lambda)*lambda**2)/factorial(2))
		    p4=((exp(-lambda)*lambda**3)/factorial(3))
		    p5=((exp(-lambda)*lambda**4)/factorial(4))
		    p6=((exp(-lambda)*lambda**5)/factorial(5))
		    p7=((exp(-lambda)*lambda**6)/factorial(6))
		    p8=(1-sum(p1,p2,p3,p4,p5,p6,p7))
		    
		    pvec=c(p1,p2,p3,p4,p5,p6,p7,p8)
		    
		    negloglike <- -dmultinom(x=obs.counts, size=ntot, prob=pvec, log=TRUE)
		    
		  }
		return(negloglike)
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

#Set an initial guess for lambda
guess1 <- 0.5
#The number of quadrats
n=100
#Run optimize with the data and liklehood function.
#optimize() is just like optim(), but for when you only have 1 parameter to estimate
mlest = optimize(f=negloglike.H1, interval=0.001, ntot=n, obs=obs.counts, lower=0, upper=20)

#pull out the maximum likelood for lambda, and the log likelhood. 
#the log likelhood is negative from up above, so make it positive. 
lambdaMLE=mlest$minimum
lnMLE=mlest$objective*-1
print(lambdaMLE)
####################################################################
#Problem 3e, expected values
expected.counts=dpois(c(0,1,2,3,4,5,6), lambdaMLE) #Get probabilites for 1-6 trees/quadrat
expected.counts=c(expected.counts, 1-sum(expected.counts)) #Add on >= 7 trees
expected.counts=expected.counts*n #expected frequency

plot(obs.counts~expected.counts)

##################################################################################
#  3f, goodness of fit test

#The probabilites for a fully parameterized model
phats = obs.counts[-8]/n
phats = c(phats, 1-sum(phats)) #Add on >=7 trees

lnNullModel=dmultinom(x=obs.counts, size=n,prob=phats, log=TRUE)

Gsq= -2*(lnMLE - lnNullModel) #liklehood ratio. They are already ln, so we only need to subtract them. 
df=length(phats)-1-1   #number of parameters in fully parameterized model, minus 1 cause we don't estimate teh final, minus 1 from the lambda only model.
Gsq.crit <- qchisq(p=0.95,df)
pvalue <- 1-pchisq(Gsq,df)
print(pvalue)

###################################################################
#   3g

obs.counts=c(7,16,20,24,17,9,5,1,1)
numTrees=0:8

meanX=sum(obs.counts*numTrees)/100 #Total number of trees / 100
print(meanX)

#########
#  3h
#
#Liklihood using neg binomial
negloglike_negbinomial.H1 <- function(guess, ntot, obs){
  lambda=guess
  if(lambda<0){return(5000)}
  else{
    #Probabilites for a neg binomial. 
    pvec=dnbinom(x=0:(length(obs)-2), size=ntot, mu=lambda)
    pvec=c(pvec, 1-sum(pvec))
    negloglike <- -dmultinom(x=obs.counts, size=ntot, prob=pvec, log=TRUE)
    
  }
  return(negloglike)
}

mlest = optimize(f=negloglike_negbinomial.H1, interval=0.001, ntot=n, obs=obs.counts, lower=0, upper=20)

#pull out the maximum likelood for lambda, and the log likelhood. 
#the log likelhood is negative from up above, so make it positive. 
lambdaMLE=mlest$minimum
lnMLE=mlest$objective*-1
print(lambdaMLE)

#The probabilites for a fully parameterized model
phats = obs.counts[-8]/n
phats = c(phats, 1-sum(phats)) #Add on >=7 trees

lnNullModel=dmultinom(x=obs.counts, size=n,prob=phats, log=TRUE)

Gsq= -2*(lnMLE - lnNullModel) #liklehood ratio. They are already ln, so we only need to subtract them. 
df=length(phats)-1-1   #number of parameters in fully parameterized model, minus 1 cause we don't estimate teh final, minus 1 from the lambda only model.
Gsq.crit <- qchisq(p=0.95,df)
pvalue <- 1-pchisq(Gsq,df)
print(pvalue)
