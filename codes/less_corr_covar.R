less_corr_covar = function (Mcovar, n, limit = 0.5) {
  m = ncol(Mcovar)
  possibilities = combn(m, n)
  correlated = which(sapply(1:ncol(possibilities), function(j) any( abs(cor(Mcovar[,possibilities[, j]])) - diag(n) > limit ) ))
  return(possibilities[,-correlated])
}
