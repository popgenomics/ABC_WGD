library(abcrf)

# read the data
diso1 = read.table("ABCstat_diso1.txt", h=T)
diso2_allo = read.table("ABCstat_diso2_allo.txt", h=T)
diso2_auto = read.table("ABCstat_diso2_auto.txt", h=T)
#hetero1 = read.table("ABCstat_hetero1.txt", h=T)
#hetero2_allo = read.table("ABCstat_hetero2_allo.txt", h=T)
#hetero2_auto = read.table("ABCstat_hetero2_auto.txt", h=T)
tetra1 = read.table("ABCstat_tetra1.txt", h=T)
tetra2_allo = read.table("ABCstat_tetra2_allo.txt", h=T)
tetra2_auto = read.table("ABCstat_tetra2_auto.txt", h=T)

# sum stats:
ss = c(2:11, 14:31, 40:41)

# build the forest
nSim = 5000

## indexes of compared models
#modIndex = c(rep('diso1', nSim), rep('diso2_auto', nSim), rep('diso2_allo', nSim), rep('hetero1', nSim), rep('hetero2_auto', nSim), rep('hetero2_allo', nSim), rep('tetra1', nSim), rep('tetra2_auto', nSim), rep('tetra2_allo', nSim))
modIndex = c(rep('diso1', nSim), rep('diso2_auto', nSim), rep('diso2_allo', nSim), rep('tetra1', nSim), rep('tetra2_auto', nSim), rep('tetra2_allo', nSim))

## simulated datasets
#sumsta = rbind(diso1[1:nSim, ss], diso2_auto[1:nSim, ss], diso2_allo[1:nSim, ss], hetero1[1:nSim, ss], hetero2_auto[1:nSim, ss], hetero2_allo[1:nSim, ss], tetra1[1:nSim, ss], tetra2_auto[1:nSim, ss], tetra2_allo[1:nSim, ss])
sumsta = rbind(diso1[1:nSim, ss], diso2_auto[1:nSim, ss], diso2_allo[1:nSim, ss], tetra1[1:nSim, ss], tetra2_auto[1:nSim, ss], tetra2_allo[1:nSim, ss])

# model comparisons
## diso versus tetra
modIndex = c(rep('diso', nSim), rep('diso', nSim), rep('diso', nSim), rep('tetra', nSim), rep('tetra', nSim), rep('tetra', nSim))
sumsta = rbind(diso1[1:nSim, ss], diso2_auto[1:nSim, ss], diso2_allo[1:nSim, ss], tetra1[1:nSim, ss], tetra2_auto[1:nSim, ss], tetra2_allo[1:nSim, ss])
mod_diso_tetra = abcrf(modIndex~., data=data.frame(modIndex, sumsta), ntree = 1000, paral = T, ncores=3)
mod_diso_tetra

## auto versus allo
modIndex = c(rep('auto', nSim), rep('allo', nSim), rep('auto', nSim), rep('allo', nSim))
sumsta = rbind(diso2_auto[1:nSim, ss], diso2_allo[1:nSim, ss], tetra2_auto[1:nSim, ss], tetra2_allo[1:nSim, ss])
mod_auto_allo = abcrf(modIndex~., data=data.frame(modIndex, sumsta), ntree = 1000, paral = T, ncores=3)
mod_auto_allo

## all models
modIndex = c(rep('diso1', nSim), rep('diso2_auto', nSim), rep('diso2_allo', nSim), rep('tetra1', nSim), rep('tetra2_auto', nSim), rep('tetra2_allo', nSim))
sumsta = rbind(diso1[1:nSim, ss], diso2_auto[1:nSim, ss], diso2_allo[1:nSim, ss], tetra1[1:nSim, ss], tetra2_auto[1:nSim, ss], tetra2_allo[1:nSim, ss])
mod = abcrf(modIndex~., data=data.frame(modIndex, sumsta), ntree = 1000, paral = T, ncores=3)
mod


