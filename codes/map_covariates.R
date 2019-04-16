map_covariates = function(Mcov, coords, point.size = 5) {
  df = data.table(cbind(coords, scale(Mcov)))
  colnames(df) = c("long","lat",colnames(Mcov))
  df = melt(df, id.vars = c("long","lat"))
  ggplot(df , aes(x = long, y = lat, colour = value)) + borders() + 
    geom_point(size = point.size) + lims(x=c(-80,-40), y =c(-20,10))  + coord_equal() + theme(legend.position="none") +
    scale_colour_gradientn(colours = rev(heat.colors(10))) + facet_wrap( ~ variable)
}