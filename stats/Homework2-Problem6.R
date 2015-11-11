

#Likelood function for logistic regression
logisticLikelihood=function(guess, x,y){
  a=guess[1]
  b=guess[2]
  
  #likelihood=function(xi,yi) { ((1/(1+exp(-(a+b*xi))))**yi) * (1-(1/(1+exp(-(a+b*xi))))**(1-yi))}
  likelihood=function(xi, yi) {  return(yi*log(1/(1+exp(-(a+b*xi)))) + (1-yi)*log(1-(1/(1+exp(-(a+b*xi))))))}
  
  return(-sum( unlist(mapply(likelihood, x,  y))))
}

set.seed(1)
data.sim <- rbinom(n=nreps, size=ntrials, prob=real.p)
x <- runif(n=200,min=-3, max=3)
y = sample(c(1,0), 200, replace=TRUE)
guess1 <- c(1.5, 2.5)
mlest  <- optim(par=guess1, fn= logisticLikelihood, method="Nelder-Mead", x=x, y=y, hessian=TRUE)
mlest

a.est=mlest$par[1]
b.est=mlest$par[2]

fish.Inv=solve(mlest$hessian)
zalphahalf <- qnorm(p=0.975, mean=0,sd=1)
st.err <- zalphahalf*sqrt(diag(fish.Inv)) # This is a vector of standard errors

print('Estimates =- standard error')
print(paste(a.est,' +-',st.err[1]))
print(paste(b.est,' +-',st.err[2]))

#Simulating the data
ntrials <- 1; # Binomial with number of trials = 1 is a Bernoulli!!
nreps <- 200;
x <- runif(n=200,min=-3, max=3); # Values of the covariate chosen at random
hist(x);
#Setting P(success) as a function of a covariate
beta0 <- 1.5;
beta1 <- 2.85; # Try lower values and higher values
real.p <- 1/(1+exp(-(beta0+beta1*x)));
plot(x,real.p, pch=16)
# Checking out that simulations make sense
# Simulating data
data.sim <- rbinom(n=nreps, size=ntrials, prob=real.p)
# "raw data"
my.data <- cbind(x,data.sim)
colnames(my.data) <- c("covariate", "Successes!")
