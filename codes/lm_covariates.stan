
data {
  int<lower=1> K;                        // nb of traits
  int<lower=1> P;                        // number of plots
  int<lower=1> M;                        // number of covariates (value defined per plot)
  
  real<lower=0,upper=1> dist[P];            // disturbance intensity (proportion of initial biomass lost after logging)
  matrix [P,M] Covar;                       // covariates (value defined per plot)

  matrix<lower=-0.5,upper=0.5>[P,K] Delta;          // max value of the hump from model 1
}

parameters { 
  // model 2 - Delta vs dist * covariates
  real<lower=-5,upper=5> lambda0 [K];
  matrix<lower=-1,upper=1> [M,K] lambda;
  real<lower=0,upper=0.25> sigma_Delta [K];
}

model{
  
  matrix[P,K] pred_Delta;
  matrix[P,K] covar_effect;
  
  covar_effect = Covar*lambda; 
  
  for ( k in 1:K){
    
    for (p in 1:P) {
      // model 2 - relation between Delta value and disturbance intensity 
      // + covariates effet
      pred_Delta[p,k] = dist[p] * (lambda0[k] + covar_effect[p,k]);
      target += normal_lpdf(Delta[p,k] | pred_Delta[p,k], sigma_Delta[k]);
    }
  }
  // prior
  sigma_Delta ~ normal(0,1);
}
