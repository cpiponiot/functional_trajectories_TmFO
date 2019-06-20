

df = subset(dfTraits, size=="small" & treat != "ctrl")
name_traits = unique(df$trait)
df = dcast(df, site + idplot + tlog + year + idplot.size ~ trait , value.var = "WMT")
df0 = subset(df, year <= tlog)
df = subset(df, year > tlog)

for (sit in unique(df$site)){
  
  df_sub = subset(df, site != sit)
  N = nrow(df_sub)
  K = length(name_traits)
  np = as.numeric(as.factor(as.character(df_sub$idplot)))
  P = length(unique(np))
  ns = as.numeric(as.factor(as.character(df_sub$site)))
  S = length(unique(ns))
  ps = unique(cbind(ns, np))[,1]
  plot_size = unique(cbind(df_sub$idplot.size, np))[,1]
  
  covars =  subset(df_Delta, trait == "SLA" & site != sit)
  dist = covars$loss_rel
  Covar = as.matrix(covars[,paste(cov_names, "sc", sep="_"), with = FALSE])
  M = ncol(Covar)
  
  t = df_sub$year - df_sub$tlog
  TR = as.matrix(df_sub[, name_traits, with = FALSE])
  dfT0 = melt(subset(df0, site != sit), measure.vars = name_traits, id.vars = "idplot")
  dfT0 = dfT0[,.(value = mean(value)),.(variable,idplot)]
  T0 = as.matrix(dcast(dfT0, idplot ~ variable, value.var = "value")[,-"idplot"])
  T0_sc = scale(T0)
  
  
  if (!with_initial_traits) {  ## when we do not include initial trait value to the covariates
    model_covar = stan("codes/model_covariates.stan")
  } else {
    model_covar = stan("codes/model_covariates_traits.stan")
  }
  
  ## keep lambdas 
  pars_cov = data.table(iter = rep(1:1000, K),
                         k = rep(1:K, each = 1000), 
                        lambda0 = c(rstan::extract(model_covar, pars= "lambda0")[[1]][1:1000,]))
  lambda = sapply(1:M, function(m) c(rstan::extract(model_covar, pars= "lambda")[[1]][1:1000,m,]))
  colnames(lambda) = paste0("lambda_", cov_names)
  pars_cov = cbind(pars_cov, lambda)
  
  ## trait effect
  if (with_initial_traits) {  
    pars_cov$lambda_WMT = c(rstan::extract(model_covar, pars= "gamma")[[1]][1:1000,])
  }
  pars_cov$trait = name_traits[pars_cov$k]
  
  save(pars_cov, file = paste0("data/pars_cov_without_", sit, ".Rdata"))
}

