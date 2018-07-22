
simulation.function <- function(nSim, nObs, nTrial, beta, u, phi, sigma, dat){
  
  proportion <- function(b, se, true, level = .95, df = Inf){ 
    # Estimate, standard error, confidence level, true parameter, and df
    
    qtile <- level + (1 - level)/2 # Compute the proper quantile
    lower.bound <- b - qt(qtile, df = df)*se # Lower bound
    upper.bound <- b + qt(qtile, df = df)*se # Upper bound
    # Is the true parameter in the confidence interval? (yes = 1)
    in.ci <- ifelse(true >= lower.bound & true <= upper.bound, 1, 0)
    cp <- mean(in.ci) # The coverage probability
    
    return(list(proportion = cp, # Return results
                in.ci = in.ci,
                ci = cbind(lower.bound, upper.bound)))
  }
  
  X <- model.matrix(~x,data=dat) # Compute the model matrix for the fixed effects
  Z <- model.matrix(~z-1,data=dat) # Copmute the model matrix for the random effects
  p <- 1/(1+exp(-(X%*%beta+Z%*%u))) # Compute the antilogit of the linear predictor to get the probability
  
  y.all <- NULL
  
  coef.bb <- coef.gamlss  <- NULL
  se.bb <- se.gamlss  <- NULL
  sigma.bb <- sigma.gamlss  <-  NULL
  phi.bb <- phi.gamlss <- NULL
  psi.bb <- psi.gamlss <- NULL
  psi.bb.se <- psi.gamlss.se <- NULL
  
  rand.bb <- rand.gamlss <- NULL
  mean.bb <- mean.gamlss <- NULL
  significance.bb <- 0
  significance.gamlss <- 0
  significance.bb.sigma <- 0
  se.sigma <- NULL
  total.iter <- 0
  
  bb.no.conv <- gamlss.no.conv <- 0
  
  for(i in 1:nSim){
    
    while.iter <- 1
    
    no.conv <- 1
    
    while(no.conv==1){
      
      no.conv <- 0
      cat("iter",i,"while iter",while.iter,"\n")
      
      y <- rBB(nObs,nTrial,p,phi) # Simulate the dependent variable
      
      dat <- cbind(dat,y) # Construct the matrix of dependent variables for each simualtion
      
      BB <- try(BBmm1(fixed.formula=y~x,random.formula=~z,m=nTrial,data=dat,method="rootSolve")) # Apply the BBmm() function

      GAMLSS <- try(gamlss(cbind(y,nTrial-y)~re(fixed=~x,random=~1|z),family=BB(),data=dat)) # Apply the GAMLSS function

      # Look for the convergences of the methodologies
      if (class(BB)[1]=="try-error"){
        no.conv <- 1 
        bb.no.conv <- bb.no.conv+1
        dat <- dat[,-3]
      } else if (BB$conv=="no"){
        no.conv <- 1 
        bb.no.conv <- bb.no.conv+1
        dat <- dat[,-3]
      }
      
      if ((class(GAMLSS)[1]=="try-error")){
        no.conv <- 1
        gamlss.no.conv <- gamlss.no.conv+1
        dat <- dat[,-3]
      } else if (GAMLSS$converged==FALSE){
        no.conv <- 1
        gamlss.no.conv <- gamlss.no.conv+1
        dat <- dat[,-3]
      }
      
      while.iter <- while.iter+1 # Apply one more iteration
      
      total.iter <- total.iter+1 # Apply one more iteration
    }
    
    # Geting the smooth part of the GAMLSS
    smo.GAMLSS <- getSmo(GAMLSS)
    
    # Summarizing the BBmm and GAMLSS
    sum.BB <- summary(BB)
    sum.GAMLSS <- summary(smo.GAMLSS)
    
    # Saving the outcome variables
    y.all <- cbind(y.all,y)
    
    # Fixed coefficients
    coef.bb <- cbind(coef.bb,BB$fixed.coef)
    coef.gamlss. <- smo.GAMLSS$coefficients$fixed
    coef.gamlss.[1] <- coef.gamlss.[1]+GAMLSS$mu.coefficients[1]
    coef.gamlss <- cbind(coef.gamlss,coef.gamlss.)
    
    # Fixed parameter standard errors
    se.bb <- cbind(se.bb,sqrt(diag(BB$fixed.vcov)))
    se.gamlss <- cbind(se.gamlss,sqrt(diag(smo.GAMLSS$varFix)))
    
    # Dispersion parameter phi
    phi.bb <- c(phi.bb,BB$phi.coef)
    phi.gamlss <- c(phi.gamlss,exp(GAMLSS$sigma.coefficients))
    
    # Dispersion parameter psi
    psi.bb <- c(psi.bb,BB$psi.coef)
    psi.gamlss <- c(psi.gamlss,GAMLSS$sigma.coefficients)
    
    # Standard deviation of dispersion parameter psi
    psi.bb.se <- c(psi.bb.se,sqrt(BB$psi.var))
    psi.gamlss.se <- c(psi.gamlss.se,sqrt(summary(GAMLSS)[4]))
    
    # Random effects u
    rand.bb <- c(rand.bb,BB$random.coef)
    rand.gamlss <- rbind(rand.gamlss,t(t(as.vector(ranef(smo.GAMLSS)))))  
    
    # Variance parameter sigma
    sigma.bb <- c(sigma.bb, BB$sigma.coef)
    sigma.gamlss <- c(sigma.gamlss, as.numeric(VarCorr(smo.GAMLSS)[1,2]))
    
    # Significance of the slope
    if (sum.BB$fixed.coefficients[,4][2]<0.05){
      significance.bb <- significance.bb+1
    }
    if (sum.GAMLSS$tTable[2,5]<0.05){
      significance.gamlss <- significance.gamlss+1
    }
    
    # Standard deviation of the estimation of sigma
    se.sigma <- cbind(se.sigma,sum.BB$sigma[1,2])
    
    # Renewing the data
    dat <- dat[,-3]
  }
  
  # EMS
  B.bb1 <- mean(coef.bb[1,])-beta[1]
  B.bb2 <- mean(coef.bb[2,])-beta[2]
  V.bb <- apply(coef.bb,1,var)
  EMS.bb1 <- (B.bb1)^2+V.bb[1]
  EMS.bb2 <- (B.bb2)^2+V.bb[2]
  
  B.gamlss1 <- mean(coef.gamlss[1,])-beta[1]
  B.gamlss2 <- mean(coef.gamlss[2,])-beta[2]
  V.gamlss <- apply(coef.gamlss,1,var)
  EMS.gamlss1 <- (B.gamlss1)^2+V.gamlss[1]
  EMS.gamlss2 <- (B.gamlss2)^2+V.gamlss[2]
  
  EMS <- cbind(c(EMS.bb1,EMS.bb2),c(EMS.gamlss1,EMS.gamlss2))
  
  
  # Mean, standard deviation and EMS of the estimations of the fixed parameters
  means <- cbind(rbind(mean(coef.bb[1,]),mean(coef.bb[2,])),rbind(mean(coef.gamlss[1,]),mean(coef.gamlss[2,])))
  sds <- cbind(sqrt(V.bb),sqrt((V.gamlss)))
  mean.sd <- rbind(means,sds,EMS)
  rownames(mean.sd) <- c("beta0","beta1","sd.beta0","sd.beta1","EMS.beta0","EMS.beta1")
  colnames(mean.sd) <- c("BBmm","gamlss")
  
  # Estimations of the random effects
  rand.gamlss <- as.vector(as.numeric(rand.gamlss))
  random.est <- cbind(rand.bb,t(t(rand.gamlss)))
  colnames(random.est) <- c("BBmm","gamlss")
  
  # Estimation of the dispersion parameters
  #phi
  phi.est <- cbind(phi.bb,phi.gamlss)
  colnames(phi.est) <- c("BBmm","gamlss")
  #psi
  psi.est <- cbind(psi.bb,psi.gamlss)
  colnames(psi.est) <- c("BBmm","gamlss")
  psi.se <- cbind(psi.bb.se,psi.gamlss.se)
  colnames(psi.se) <- c("BBmm","gamlss")
  # sigma
  sigma.est <- cbind(sigma.bb,sigma.gamlss)
  colnames(sigma.est) <- c("BBmm","gamlss")
  
  # Vector of the estimation of beta0 and beta1
  coef1 <- cbind(coef.bb[1,],coef.gamlss[1,])
  coef2 <- cbind(coef.bb[2,],coef.gamlss[2,])
  colnames(coef2) <- colnames(coef1) <- c("BBmm","gamlss")
  
  # Proportion of the beta coefficients that are in the IC of 95%
  prop.bb <- proportion(coef.bb,se.bb,beta)
  prop.gamlss <- proportion(coef.gamlss,se.gamlss,beta)
  prop.table <- cbind(t(prop.bb$in.ci),t(prop.gamlss$in.ci))
  prop.both <- cbind(prop.bb$proportion,prop.gamlss$proportion)
  prop <- apply(prop.table,2,sum)/nSim
  
  # Percentage of the significance of the slope
  significance <- cbind(significance.bb,significance.gamlss)
  colnames(significance) <- c("BBmm","gamlss")
  
  # Number of times that each algorithm has not converged
  no.conv <- cbind(bb.no.conv,gamlss.no.conv)
  colnames(no.conv) <- c("BBmm","gamlss")
  
  # BIAS
  Beta1 <- rep(beta[1],nObs)
  Beta2 <- rep(beta[2],nObs)
  BIAS1.BBmm <- 100*(sum(coef.bb[1,]-Beta1)/sum(Beta1))
  BIAS2.BBmm <- 100*(sum(coef.bb[2,]-Beta2)/sum(Beta2))
  BIAS1.GAMLSS <- 100*(sum(coef.gamlss[1,]-Beta1)/sum(Beta1))
  BIAS2.GAMLSS <- 100*(sum(coef.gamlss[2,]-Beta2)/sum(Beta2))
  BIAS <- cbind(BIAS1.BBmm,BIAS2.BBmm,BIAS1.GAMLSS,BIAS2.GAMLSS)
  colnames(BIAS) <- c("BBmm1","BBmm2","GAMLSS1","GAMLSS2")
  
  # Average standar error
  ASE1.BBmm <- mean(se.bb[1,])
  ASE2.BBmm <- mean(se.bb[2,])
  ASE.BBmm <- cbind(ASE1.BBmm,ASE2.BBmm)
  ASE1.GAMLSS <- mean(se.gamlss[1,])
  ASE2.GAMLSS <- mean(se.gamlss[2,])
  ASE.GAMLSS <- cbind(ASE1.GAMLSS,ASE2.GAMLSS)
  
  # Empirical standar deviation
  ESD.BBmm <- sqrt(as.vector(V.bb))
  ESD.BBmm <- cbind(ESD.BBmm[1],ESD.BBmm[2])
  colnames(ESD.BBmm) <- c("ESD1.BBmm","ESD2.BBmm")
  ESD.GAMLSS <- sqrt(as.vector(V.gamlss))
  ESD.GAMLSS <- cbind(ESD.GAMLSS[1],ESD.GAMLSS[2])
  colnames(ESD.GAMLSS) <- c("ESD1.GAMLSS","ESD2.GAMLSS")
  
  # Output
  out <- list(Fixed.effects.table=mean.sd,prop.in.ic.beta=prop,sigma.est=sigma.est,y.all=y.all,
              beta0.est=coef1,beta1.est=coef2,random.effects.est=random.est,phi.est=phi.est,
              psi.est=psi.est,psi.se=psi.se,significance.beta1=significance,no.conv=no.conv,
              total.iter=total.iter,BIAS=BIAS,ASE.BBmm=ASE.BBmm,ASE.GAMLSS=ASE.GAMLSS,ESD.BBmm=ESD.BBmm,
              ESD.GAMLSS=ESD.GAMLSS)
  
  out
}