# We chose a random dice from the 4, 6, 8, 12 and 20 side dices.
#This dice was rolled twice with the following observations:
observations = c(7, 8)

# problem: classify the dices according to their ability to produce observations.
# with have to estimate P(dice,i | observations) = [ p(observations | dice,i) * p(dice,i) ] / p(observations)
# I) lets estimate the required factors, by starting to calculate the probabilities for each dice taking into account only the first observation, i.e, observations[1] = 7.

# 1) p(observations | dice, i)
dices = c(4, 6, 8, 12, 20)

P_observations_given_dice = NULL

for(i in dices){ # loop over the list of dices
	if(observations[1] > i){
		# if the observed value is greater than the largest number on the dice, then the proba to observe this value for the dice 'i' is equal to zero
		P_observations_given_dice = c(P_observations_given_dice, 0)
	}else{
		# if the observed value is smaller or equal the largest number on the dice, then the proba to observe this value for the dice 'i' is equal to 1/i
		P_observations_given_dice = c(P_observations_given_dice, 1/i)
	}
}


# 2) p(dice,i) is the prior distribution for the models (i.e, the dices)
# Because we have no reason to justify that the dice to be inferred was taken in a biased manner, each dice has the same initial probability of being rolled, i.e, 1/(the number of dices) = 1/5
P_dice = rep(1/length(dices), length(dices))

# 3) P(observations) is the global probability to observe observations[1], i.e, the sum of the probabilities to sample a dice multiplied by the probability to the probability of making observations[1] with this dice.
P_observation = 0
for(i in 1:length(dices)){
	P_observation = P_observation +  (P_dice[i] * P_observations_given_dice[i])
}

print(P_observation) # by randomly sampling one dice, and by throwing it, we have a probability equal to P_observation to observe observations[1]

## Posterior probabilities
### let's compute the posterior probabilities P(dice,i | observations) for each dice given the first observation observations[1]
P_dice_given_observations = ( P_observations_given_dice * P_dice ) / P_observation
names(P_dice_given_observations) = dices

print(P_dice_given_observations) # posterior probabilities of all of the dices given the first observation observation[1]


# II) What about the second observation?
## How do these probas evolve according to the second observation?
# 1) p(observations | dice, i)
P_observations_given_dice = NULL

### we apply the same loop over the dices to estimate the probability to observe observations[2] for each dice,i
for(i in dices){ # loop over the list of dices
	if(observations[2] > i){
		# if the observed value is greater than the largest number on the dice, then the proba to observe this value for the dice 'i' is equal to zero
		P_observations_given_dice = c(P_observations_given_dice, 0)
	}else{
		# if the observed value is smaller or equal the largest number on the dice, then the proba to observe this value for the dice 'i' is equal to 1/i
		P_observations_given_dice = c(P_observations_given_dice, 1/i)
	}
}


# 2) p(dice,i) is the prior distribution for the models (i.e, the dices)
# contrary to the first observation, we now have clues on each dice that make them not equiprobable. Thus, the a priori probability of each dice is here equal to their a posteriori probability calculated from the previous observation.
P_dice = P_dice_given_observations

# 3) P(observations) is the global probability to observe observations[1], i.e, the sum of the probabilities to sample a dice multiplied by the probability to the probability of making observations[1] with this dice.
P_observation = 0
for(i in 1:length(dices)){
	P_observation = P_observation +  (P_dice[i] * P_observations_given_dice[i])
}

print(P_observation) # by randomly sampling one dice, and by throwing it, we have a probability equal to P_observation to observe observations[1]

## Posterior probabilities
### let's compute the posterior probabilities P(dice,i | observations) for each dice given the two observations
P_dice_given_observations = ( P_observations_given_dice * P_dice ) / P_observation
names(P_dice_given_observations) = dices

print(P_dice_given_observations) # posterior probabilities of all of the dices given the two observations


### If we compute the same probabilities with a third observation (=5, for instance), we will adjust our apriori as and when clues are found. We will never be convinced that it is really an 8-sided die, but this die is becoming the most plausible.

