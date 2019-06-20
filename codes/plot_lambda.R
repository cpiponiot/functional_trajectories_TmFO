plot_lambda = function(trait, lambdas, cov_type = 1) {
  df_lambda = melt(data.table(trait, lambdas),
                   id.vars = "trait",
                   variable.name = "covariate")
  
  df_lambda[, covariate := gsub("lambda_", "", covariate)]
  
  lambda_ci = df_lambda[, .(
    inf95 = quantile(value, 0.025),
    inf80 = quantile(value, 0.1),
    med = quantile(value, 0.5),
    sup80 = quantile(value, 0.9),
    sup95 = quantile(value, 0.975)
  ), .(trait, covariate)]
  
  lambda_ci = merge(lambda_ci, cov_type, by = "covariate", all.x = TRUE)
  
  lambda_ci$covar_typ[is.na(lambda_ci$covar_typ)] = "intercept"
  
  lambda_ci$covariate = factor(lambda_ci$covariate, levels = rev(gsub("lambda_", "", colnames(lambdas))))
  
  ## does the parameter attenuate resilience or not
  attenuation = lambda_ci[, .(attenuation =  (med * med[covariate == "lambda0"] < 0), covariate), .(trait)]
  
  lambda_ci = merge(lambda_ci, attenuation, by = c("covariate", "trait"))
  
  ## how significantly is the value different from zero
  lambda_ci$signif = "0"
  lambda_ci[sup80 < 0 | inf80 > 0, signif := "80%"]
  lambda_ci[sup95 < 0 | inf95 > 0, signif := "95%"]
  
  ## colour scale
  lambda_ci$colour = as.numeric(as.factor(lambda_ci$signif)) - 1
  lambda_ci[!lambda_ci$attenuation]$colour = -1 * lambda_ci[!lambda_ci$attenuation]$colour
  lambda_ci[covariate == "lambda0" & colour < 0, colour := colour - 2 ]
  
  ggplot(
    lambda_ci,
    aes(
      x = covariate,
      y = med,
      group = covariate
    )
  ) +
    geom_hline(yintercept = 0, lty = 2) + 
    geom_linerange(aes(ymin = inf95, ymax = sup95)) + 
    geom_linerange(aes(ymin = inf80, ymax = sup80, col = colour), lwd = 2) + 
    geom_point(size=3) + 
    coord_flip() + 
    scale_colour_gradientn(colours = c("black","darkgrey","red","pink","white","lightblue","blue"), 
                          breaks = c(-4:1)+0.5) +
    facet_wrap( ~ trait) + 
    theme(legend.position = "none")
}
