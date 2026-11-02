library(dplyr)

set.seed(67)

ins = read.csv("257_P1/cleaned.csv")
ins = na.omit(ins)
ins = ins %>% mutate(row_id = row_number())

train_set = ins %>% slice_sample(prop = .8)
test_set = ins %>% anti_join(train_set, by = "row_id")
train_set = train_set %>% select(-row_id)
test_set = test_set %>% select(-row_id)

train_vars = train_set %>%
	select(
		power_to_weight_ratio,
		years_licensed,
		vehicle_age,
		vehicle_value,
		driver_age,
	)
test_vars = test_set %>%
	select(
		power_to_weight_ratio,
		years_licensed,
		vehicle_age,
		vehicle_value,
		driver_age,
	)

train_targets = train_set %>% select(total_incurred)
test_targets = test_set %>% select(total_incurred)

train_scaled = scale(train_vars)
test_scaled = scale(test_vars)

fa = factanal(train_scaled, factors = 2, scores = "regression")

fa$loadings

train_set$Factor1 = fa$scores[, 1]
train_set$Factor2 = fa$scores[, 2]

# transform factors on test data
score_weights = solve(fa$correlation, fa$loadings)
test_scores = test_scaled %*% score_weights
test_set$Factor1 = test_scores[, 1]
test_set$Factor2 = test_scores[, 2]

factors = lm(total_incurred ~ Factor1 + Factor2, train_set)
normal = lm(
	total_incurred ~ years_licensed +
		vehicle_age +
		power_to_weight_ratio +
		vehicle_value +
		driver_age,
	train_set
)

summary(factors)
summary(normal)

yhat_factors = predict(factors, newdata = test_set)
yhat_normal = predict(normal, newdata = test_set)

predictions = data.frame(
	actual = test_set$total_incurred,
	factor_prediction = yhat_factors,
	normal_prediction = yhat_normal
)
head(predictions, 20)

train_yhat_factors = predict(factors, newdata = train_set)
train_yhat_normal = predict(normal, newdata = train_set)

factors_train_mse = mean((train_set$total_incurred - train_yhat_factors)^2)
factors_test_mse = mean((test_set$total_incurred - yhat_factors)^2)

normal_train_mse = mean((train_set$total_incurred - train_yhat_normal)^2)
normal_test_mse = mean((test_set$total_incurred - yhat_normal)^2)


mse = data.frame(
	model = c("factors", "normal"),
	train_mse = c(
		factors_train_mse,
		normal_train_mse
	),
	test_mse = c(
		factors_test_mse,
		normal_test_mse
	)
)
print(mse)

rmse = data.frame(
	model = c("factors", "normal"),
	train_rmse = c(
		sqrt(factors_train_mse),
		sqrt(normal_train_mse)
	),
	test_rmse = c(
		sqrt(factors_test_mse),
		sqrt(normal_test_mse)
	)
)
print(rmse)
