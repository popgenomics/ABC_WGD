### Method one : exact likelihood following the Bayes formula
bayes = function(observations, dices){
	for(obs in 1:length(observations)){
		if(obs==1){
			P_dice = rep(1/length(dices), length(dices))
		}else{
			P_dice = P_dice_given_observations
		}
		
		P_observations_given_dice = NULL
		for(i in dices){ # loop over the list of dices
			if(observations[obs] > i){
				# if the observed value is greater than the largest number on the dice, then the proba to observe this value for the dice 'i' is equal to zero
				P_observations_given_dice = c(P_observations_given_dice, 0)
			}else{
				# if the observed value is smaller or equal the largest number on the dice, then the proba to observe this value for the dice 'i' is equal to 1/i
				P_observations_given_dice = c(P_observations_given_dice, 1/i)
			}
		}

		P_observation = 0
		for(i in 1:length(dices)){
			P_observation = P_observation +  (P_dice[i] * P_observations_given_dice[i])
		}

		P_dice_given_observations = ( P_observations_given_dice * P_dice ) / P_observation
	}
	
	# format the output for easier interpretations	
	names(P_dice_given_observations) = dices
	best_model = paste('D', names(which(P_dice_given_observations == max(P_dice_given_observations))), sep='')
	proba_best_model = as.numeric(round(max(P_dice_given_observations),5))
	
	res = NULL
	for(i in P_dice_given_observations){
		res = c(res, round(i,5))
	}
	
	res = c(res, best_model, proba_best_model)
	res = as.data.frame(t(res))

	names(res) = c(names(P_dice_given_observations), 'best_model', 'post_proba')
	
	return(res) # posterior probabilities of all of the dices given the two observations

}


### Method two : approximate Bayesian computation 
abc = function(observations, nSimulations){
	# observations is a data.frame with: each row=a set of observations; each row=the observation for each of the nRolls
	# nSimulations = number os simulations for the ABC inference
	library(abcrf)

	nRolls = ncol(observations)

	## random simulations of each of the 5 alternative models
	D4 = D6 = D8 = D12 = D20 = NULL

	for(i in 1:nSimulations){
		D4 = rbind(D4, sample(1:4, nRolls, replace=T))
		D6 = rbind(D6, sample(1:6, nRolls, replace=T))
		D8 = rbind(D8, sample(1:8, nRolls, replace=T))
		D12 = rbind(D12, sample(1:12, nRolls, replace=T))
		D20 = rbind(D20, sample(1:20, nRolls, replace=T))
	}

	colnames(D4) = paste(rep("obs", nRolls), 1:nRolls, sep="")
	colnames(D6) = paste(rep("obs", nRolls), 1:nRolls, sep="")
	colnames(D8) = paste(rep("obs", nRolls), 1:nRolls, sep="")
	colnames(D12) = paste(rep("obs", nRolls), 1:nRolls, sep="")
	colnames(D20) = paste(rep("obs", nRolls), 1:nRolls, sep="")

	## gathering all simulations in one table names sumsta (for summary statistics)
	sumsta = rbind(D4, D6, D8, D12, D20)

	## producing a vector of model indicators, to associate a row of sumsta to any of the 5 compared models
	modIndex = rep(c('D4', 'D6', 'D8', 'D12', 'D20'), each = nSimulations)

	## model comparison
	mod = abcrf(modIndex~., data = data.frame(modIndex, sumsta), ntree = 1000, paral = T, ncores = 3)

	## model prediction
	predicted_dice = predict(mod, observations, training=data.frame(modIndex, sumsta), ntree = 1000, paral = T, ncores=3)
	return(data.frame(best_model=predicted_dice$allocation, post_proba=predicted_dice$post.prob))
}




### comparisons between the two methods
#### let's assume a 8-sided dice with 2 rolls
#real_dice = 8
#nObservations = 100
#obs1 = sample(1:real_dice, nObservations, replace=T)
#obs2 = sample(1:real_dice, nObservations, replace=T)
#
#observations= data.frame(obs1,obs2) # data frame gathering all of the 100 observations
#
#res_bayes = NULL # store the relative posterior probabilities of the 5 dice
## loop over the observations: compute the relative posterior probabilities by using the Bayes formula
#for(i in 1:nrow(observations)){
#	res_bayes = rbind(res_bayes, bayes(observations[i,], dices=c(4,6,8,12,20)))
#}
#
#res_abc = abc(observations, nSimulations=5000)
#
#
#### now, let's assume a 8-sided dice with 10 rolls
#real_dice = 20
#nObservations = 1000
#nRolls = 10
#
#observations = NULL
#for(i in 1:nRolls){
#	observations = cbind(observations, sample(1:real_dice, nObservations, replace=T))
#}
#
#observations = as.data.frame(observations)
#colnames(observations) = paste(rep("obs", nRolls), 1:nRolls, sep="")
#
#
#res_bayes = NULL # store the relative posterior probabilities of the 5 dice
## loop over the observations: compute the relative posterior probabilities by using the Bayes formula
#for(i in 1:nrow(observations)){
#	res_bayes = rbind(res_bayes, bayes(observations[i,], dices=c(4,6,8,12,20)))
#}
#
#res_abc = abc(observations, nSimulations=5000)
#
# table(res_bayes$best_model)
# table(res_abc$best_model)
#
