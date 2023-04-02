# Set up
library(skimr)
library(modelsummary)
library(carData)
library(car)
library(MASS)

###### Summary of Data ######

# Summary of data
potential_predictors <- merged_data_wclass1[, c("holistic_centre", "adult_entertainment_club", "eating_establishment", "entertainment_establishment_nightclub", "pawn_shop", "payday_loan", "sidewalk_cafe", "retail_store_food", "smoke_shop", "vapour_product_retailer", "class")]

merged_data_wclass_summary <-
  datasummary_skim(merged_data_wclass1)

merged_data_wclass_summary

# check correlation matrix between predictors
cor(potential_predictors)

# Distribution of predictors



###### logistic model ######

# Fit a logistic regression model
logistic_model <- glm(class ~ adult_entertainment_club + eating_establishment + entertainment_establishment_nightclub + pawn_shop + payday_loan + sidewalk_cafe + retail_store_food + smoke_shop + vapour_product_retailer + holistic_centre, data = merged_data_wclass1, family = binomial)

# Summarize the model
summary(logistic_model)

# Exponentiate the coefficients
exp(coef(logistic_model))

# VIF
vif(logistic_model) 

# AIC 
stepAIC(logistic_model, direction = "both")

# Improved logistic model
logistic_model2 <- glm(class ~ adult_entertainment_club + entertainment_establishment_nightclub + pawn_shop + sidewalk_cafe + retail_store_food + smoke_shop, data = merged_data_wclass1, family = binomial)

# Summarize the Improved model
summary(logistic_model2)

# Exponentiate the coefficients
exp(coef(logistic_model2))

