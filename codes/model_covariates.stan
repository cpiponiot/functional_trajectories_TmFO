
data {
  int<lower=0> N;                        // nb of observations
  int<lower=1> K;                        // nb of traits
  int<lower=1> P;                        // number of plots
  int<lower=1> S;                        // number of sites
  int<lower=1> M;                        // number of covariates (value defined per plot)
  int<lower=1,upper=P> np[N];            // plot the observation belongs to
  int<lower=1,upper=S> ns[N];            // site the observation belongs to
  int<lower=1,upper=S> ps[P];            // site the plot belongs to
  
  real<lower=1> t[N];                       // time since logging (logging at t= -1)
  matrix<lower=0>[N,K] TR;                  // recruits traits values in time, relative to initial value (-> same scale)
  matrix<lower=0>[P,K] T0;                  // pre-logging value of traits
  real<lower=0,upper=1> dist[P];            // disturbance intensity (proportion of initial biomass lost after logging)
  matrix [P,M] Covar;                       // covariates (value defined per plot)
  real<lower=0> plot_size[P];
  
}

parameters {
  //model 1
  matrix<lower=-0.5,upper=0.5>[P,K] Delta;          // max value of the hump (relative to TS0)
  matrix<lower=0, upper=100>[P,K] tmax;        // time of maximum value for each trait
  real<lower=0, upper=3> theta[P,K];            // shape parameter for the hump
  real<lower=0> sigmaT[K];                      // trait variability in time 
  
  // model 2 - Delta vs dist * covariates
  real<lower=-5,upper=5> lambda0 [K];
  matrix<lower=-1,upper=1> [M,K] lambda;
  real<lower=0,upper=0.25> sigma_Delta [K];
  
  // hyperparameters
  real<lower=0,upper=3> mu_theta;
  real<lower=0,upper=0.25> sigma_theta;
  
  matrix<lower=0,upper=100> [S,K] mu_tmax;
  real<lower=0,upper=10> sigma_tmax;
  real<lower=0,upper=100>  mu_mu_tmax [S];
  real<lower=0,upper=10> sigma_mu_tmax;
  real<lower=0,upper=100> mu_mu_mu_tmax;
  real<lower=0,upper=10> sigma_mu_mu_tmax;
}

model{
  
  matrix[N,K] muT;
  matrix[P,K] pred_Delta;
  matrix[P,K] covar_effect;
  
  covar_effect = Covar*lambda; 
  
  for ( k in 1:K){
    
    // model 1 - trait change after logging in small trees (10-35cm dbh)
    for (i in 1:N)
    { 
      muT[i,k] =  Delta[np[i],k] * ( t[i] / tmax[np[i],k] * exp( 1 - t[i] / tmax[np[i],k]))^theta[np[i],k]  ;
      
      target += normal_lpdf( ( TR[i,k] - T0[np[i],k] ) / T0[np[i],k]  | muT[i,k], sigmaT[k]/plot_size[np[i]]);
    }
    
    // Hyperdistributions
    for (p in 1:P) {
      target += normal_lpdf(tmax[p,k] | mu_tmax[ps[p],k], sigma_tmax);
      target += normal_lpdf(theta[p,k] | mu_theta, sigma_theta);
      
      // model 2 - relation between Delta value and disturbance intensity 
      // + covariates effet
      pred_Delta[p,k] = dist[p] * (lambda0[k] + covar_effect[p,k]);
      target += normal_lpdf(Delta[p,k] | pred_Delta[p,k], sigma_Delta[k]);
    }
    
    for (s in 1:S) {
      target += normal_lpdf(mu_tmax[s,k] | mu_mu_tmax[k], sigma_tmax);
    }
  }
  
  mu_mu_tmax ~ normal(mu_mu_mu_tmax, sigma_mu_mu_tmax);
  
  // Priors
  sigmaT ~ normal(0,1);
  sigma_Delta ~ normal(0,1);
  sigma_tmax ~ normal(0,1);
  sigma_theta ~ normal(0,1);
}
