library(PROreg)
library(gamlss)
library(numDeriv)
library(rootSolve)

source("Simulation_function.R")

####################################
# SET THE VALUES OF THE PARAMETERS #
####################################

set.seed(8) # Set the seed
nSim <- 100 # Number of simulations
nObs <- 200 # Number of observations of the dependent variable for each simulation
nTrial <- sample(1:30,nObs,replace=T) # Random number of trials (form 1 to 30) for each observation of the dependent variable
nRand <- 50 # Number of random effects


x <- rnorm(nObs,1,2) # Simulate the covariate
z <- as.factor(PROreg::rBB(nObs, nRand-1,0.5,0.5)) # Simulate the levels of the random effects
nlevels(z)==nRand # Verify that the number of levels is equal to the number of random effects
X <- cbind(1,x) # Construct the model matrix for the fixed effects
Z <- model.matrix(~z-1) # Construct the model matrix for the random effects
beta <- c(1,-1.5)
beta.real <- beta

sigma <- 1.5 # Set the standard deviation of the random effects
phi <- 1.5 # Set the dispersion parameter of the beta-binomial distribution

u <- rnorm(nRand,0,sigma) # Simulate the random effects
dat <- data.frame(cbind(x,z)) # Generate a data frame with the covariate and random effects
dat$z <- as.factor(dat$z)

#############
# SIMULATE  #
#############

out <- simulation.function(nSim,nObs,nTrial,beta,u,phi,sigma,dat) # get the results of the simulations for the given values

#####################################
# ANALYSE THE RESULTS AS IN TABLE 2 #
#####################################

# Slope parameter

beta1 <- out$beta1.est # Estimates
mean.beta1 <- apply(beta1,2,mean) # Mean of the estimates
B.beta1 <- mean.beta1-beta.real[2] # Difference between the real value and mean estimate
V.beta1 <- apply(beta1,2,var) # Variance
EMS.beta1 <- B.beta1^2+V.beta1 # EMS
ESD.beta1 <- sqrt(V.beta1) # Empirical standard deviation
ASE.beta2 <- cbind(out$ASE.BBmm[2],out$ASE.GAMLSS[2]) # Average estandard deviation

# Show the results
mean.beta1
ESD.beta1
ASE.beta2
EMS.beta1
out$prop.in.ic.beta # Coverage probability


# Logarithm of the dispersion parameter of the beta-binomial distribution (psi)

psi.real <- log(0.5)
psi <- out$psi.est # Estimates
mean.psi <- apply(psi,2,mean) # Mean of the estimates
B.psi <- mean.psi-psi.real # Difference between real value and mean estimate
V.psi <- apply(psi,2,var) # Variance
EMS.psi <- B.psi^2+V.psi # EMS
ESD.psi <- sqrt(V.psi)  # Empirical standard deviation
ASE.psi <- apply(out$psi.se,2,mean) # Average standard deviation

mean.psi
ESD.psi
ASE.psi
EMS.psi

#Convergence
out$no.conv
