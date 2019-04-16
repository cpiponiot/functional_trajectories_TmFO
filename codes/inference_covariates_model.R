df = subset(dfTraits, size=="small" & treat != "ctrl")
name_traits = unique(df$trait)
df = dcast(df, site + idplot + tlog + year + idplot.size ~ trait , value.var = "WMT")
df0 = subset(df, year <= tlog)
df = subset(df, year > tlog)

N = nrow(df)
K = length(name_traits)
np = as.numeric(as.factor(as.character(df$idplot)))
P = length(unique(np))
ns = as.numeric(as.factor(as.character(df$site)))
S = length(unique(ns))
ps = unique(cbind(ns, np))[,1]
plot_size = unique(cbind(df$idplot.size, np))[,1]

covars =  subset(df_Delta, trait == "SLA")
dist = covars$loss_rel
Covar = as.matrix(covars[,paste(cov_names, "sc", sep="_"), with = FALSE])
M = ncol(Covar)

t = df$year - df$tlog
TR = as.matrix(df[, name_traits, with = FALSE])
dfT0 = melt(df0, measure.vars = name_traits, id.vars = "idplot")
dfT0 = dfT0[,.(value = mean(value)),.(variable,idplot)]
T0 = as.matrix(dcast(dfT0, idplot ~variable, value.var = "value")[,-"idplot"])

model_covar = stan("codes/model_covariates.stan")
pars_cov = data.table(iter = 1:1000, do.call(cbind, rstan::extract(model_covar, 
                                                                   pars = c("sigma_Delta", "sigma_tmax", 
                                                                            "mu_theta", "sigma_theta", "lp__" )))[1:1000])
pars_covb = data.table(Delta = c(rstan::extract(model_covar, pars= "Delta")[[1]][1:1000,,]), 
                       theta = c(rstan::extract(model_covar, pars= "theta")[[1]][1:1000,,]),
                       tmax = c(rstan::extract(model_covar, pars= "tmax")[[1]][1:1000,,]), 
                       iter = rep(1:1000, P*K), 
                       p = rep(rep(1:P, each = 1000), K), 
                       s = rep(rep(ps, each = 1000), K), 
                       k = rep(1:K, each = 1000*P))
pars_cov = merge(pars_cov, pars_covb, by = "iter")
pars_covb = data.table(sigmaT = c(rstan::extract(model_covar, pars= "sigmaT")[[1]][1:1000,]),
                       sigma_Delta = c(rstan::extract(model_covar, pars= "sigma_Delta")[[1]][1:1000,]),
                       lambda0 = c(rstan::extract(model_covar, pars= "lambda0")[[1]][1:1000,]),
                       iter = rep(1:1000, K), 
                       k = rep(1:K, each = 1000))
lambda = sapply(1:M, function(m) c(rstan::extract(model_covar, pars= "lambda")[[1]][1:1000,m,]))
colnames(lambda) = paste0("lambda_", cov_names)
pars_covb = cbind(pars_covb, lambda)
pars_cov = merge(pars_cov, pars_covb, by = c("iter", "k"))
pars_covb = data.table(mu_tmax = c(rstan::extract(model_covar, pars= "mu_tmax")[[1]][1:1000,,]), 
                       iter = rep(1:1000, S*K), 
                       s = rep(rep(1:S, each = 1000), K), 
                       k = rep(1:K, each = 1000*S))
pars_cov = merge(pars_cov, pars_covb, by = c("iter","s","k"))
pars_cov$trait = name_traits[pars_cov$k]
pars_cov$site = levels(as.factor(as.character(df$site)))[pars_cov$s]
pars_cov$idplot = levels(as.factor(as.character(df$idplot)))[pars_cov$p]