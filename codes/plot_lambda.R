plot_lambda = function(trait, lambdas, cov_type = 1) {
  df_lambda = melt(data.table(trait, lambdas), 
                 id.vars = "trait", variable.name = "covariate")
  df_lambda[,covariate := gsub("lambda_", "", covariate)]
  lambda_ci = df_lambda[, .(inf = quantile(value, 0.025), 
                          med = quantile(value, 0.5), 
                          sup = quantile(value, 0.975)), .(trait, covariate)]
  lambda_ci = merge(lambda_ci, cov_type, by = "covariate", all.x = TRUE)
  lambda_ci[is.na(covar_typ), covar_typ := "intercept"]
  lambda_ci$covariate = factor(lambda_ci$covariate, levels = rev(gsub("lambda_","",colnames(lambdas))))
  ggplot(lambda_ci, aes(x = covariate, y = med, ymin = inf, ymax = sup, colour = covar_typ, group = covariate)) + 
    geom_hline(yintercept = 0, lty= 2) + geom_pointrange() + coord_flip() + facet_wrap(~trait)
}
