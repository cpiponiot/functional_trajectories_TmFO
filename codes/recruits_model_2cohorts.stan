
data {
  
  int<lower=0> N;                        // nb of observations
  int<lower=1> K;                        // nb of traits
  int<lower=1> P;                        // number of plots
  int<lower=1,upper=P> np[N];            // plot the observation belongs to
  
  real<lower=1> t[N];                       // time since logging (logging at t= -1)
  matrix<lower=0>[N,K] TR;                  // recruits traits values in time, relative to initial value (-> same scale)
  real<lower=0> agbR[N];                    // recruits aboveground carbon stock (in Mg -> not standardized per ha, except if all plots have the same size then it's ok)
  
  matrix<lower=0>[P,K] T0;                  // Survivors pre-logging value of traits
  
}

parameters {
  
  matrix<lower=0,upper=0.5>[P,2] Delta;               // max value of the hump (relative to TS0)
  real<lower=5, upper=30> tmax1;                // time of maximum value for each trait
  real<lower=tmax1, upper=100> tmax2;     // time of maximum value for each trait
  real<lower=0, upper=3> theta[2];                 // shape parameter for the hump
  real<lower=-1, upper=1> dT[K,2];                // shape parameter for the hump
  real<lower=0> sigmaT[K];                       // trait variability in time 
  
  // hyperparameters
  real<lower=0,upper=0.5> mu_Delta[2];
  real<lower=0,upper=0.25> sigma_Delta;
  // real<lower=5,upper=100> mu_tmax[2];
  // real<lower=0,upper=10> sigma_tmax;
  real<lower=0,upper=3> mu_theta;
  real<lower=0,upper=0.25> sigma_theta;
  real<lower=-1,upper=1> mu_dT;
  real<lower=0,upper=0.5> sigma_dT;
}

model{
  
  matrix[N,K] muT;
   
  for ( k in 1:K){
    
      for (i in 1:N)
    { 
      muT[i,k] = T0[np[i],k] * ( 1 + 
        dT[k,1] * Delta[np[i],1] * ( t[i] / tmax1 * exp( 1 - t[i] / tmax1))^theta[1] + 
        dT[k,2] * Delta[np[i],2] * ( t[i] / tmax2 * exp( 1 - t[i] / tmax2))^theta[2] ) ;
      
      target += normal_lpdf(log(TR[i,k]) | log(muT[i,k]), sigmaT[k]/agbR[i]);
      
    }

    // Hyperdistributions
    for (c in 1:2) {
    Delta[,c] ~ normal(mu_Delta[c],sigma_Delta);
    dT[,c] ~ normal(mu_dT,sigma_dT);
    }
  }
  
  // tmax1 ~ normal(mu_tmax[1],sigma_tmax);
  // tmax2 ~ normal(mu_tmax[2],sigma_tmax);
  theta ~ normal(mu_theta,sigma_theta);
  
  // Priors
  sigmaT ~ normal(0,1);
  sigma_Delta ~ normal(0,1);
  // sigma_tmax ~ normal(0,1);
  sigma_theta ~ normal(0,1);
}
