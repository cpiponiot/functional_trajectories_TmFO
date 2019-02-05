# # # # # # # # # # # # # # # # # # # # # # # # # # # #
####                 INFERENCE DATA                ####
# # # # # # # # # # # # # # # # # # # # # # # # # # # #

dynData_inf = subset(dynData, treatment != "T0" & trait %in% name_traits )
dynData_inf$np = as.numeric(as.factor(dynData_inf$idplot))
setorder(dynData_inf, np)

md0 = dynData_inf[year <= tlogging & cohort=="surv",
                  .(WMT0 = mean(WMT)),.(np, trait)]

dynData_recr = subset(dynData_inf, cohort == "recr" & year > tlogging)

K = length(unique(dynData_recr$trait))
P = max(dynData_recr$np)

T0 = dcast(md0, np ~ trait, value.var = "WMT0")
T0 = as.matrix(T0[,name_traits, with=F])

TR = dcast(dynData_recr, np + year + agb ~ trait, value.var = "WMT")
N = nrow(TR)
t = TR$year - tlogging
np = TR$np
agbR = TR$agb
TR = as.matrix(TR[,name_traits, with=F])
