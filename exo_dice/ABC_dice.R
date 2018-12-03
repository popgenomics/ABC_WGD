# small script using ABC to compute the likelihood of the best dice
## we will use the abcrf library
library(abcrf)

## observations after rolling dwice an 8-sided dice
obs1 = 7
obs2 = 8
observations = data.frame(obs1, obs2)

## 10,000 random simulations of each of the 5 alternative models
nSimulations = 10000
D4 = D6 = D8 = D12 = D20 = NULL

for(i in 1:nSimulations){
	D4 = rbind(D4, sample(1:4, 2))
	D6 = rbind(D6, sample(1:6, 2))
	D8 = rbind(D8, sample(1:8, 2))
	D12 = rbind(D12, sample(1:12, 2))
	D20 = rbind(D20, sample(1:20, 2))
}

colnames(D4) = c('obs1', 'obs2')
colnames(D6) = c('obs1', 'obs2')
colnames(D8) = c('obs1', 'obs2')
colnames(D12) = c('obs1', 'obs2')
colnames(D20) = c('obs1', 'obs2')

## gathering all simulations in one table names sumsta (for summary statistics)
sumsta = rbind(D4, D6, D8, D12, D20)

## producing a vector of model indicators, to associate a row of sumsta to any of the 5 compared models
modIndex = rep(c('D4', 'D6', 'D8', 'D12', 'D20'), each = nSimulations)

## model comparison
mod = abcrf(modIndex~., data = data.frame(modIndex, sumsta), ntree = 1000, paral = T, ncores = 3)

## model prediction
predicted_dice = predict(mod, observations, training=data.frame(modIndex, sumsta), ntree = 1000, paral = T, ncores=3)

