###### logistic model ######

# Fit a logistic regression model
logistic_model <- glm(class ~ commercial_parking_lot + eating_establishment + entertainment_establishment_nightclub + holistic_centre + mobile_vending_food_truck + mobile_vending_ice_cream_truck + retail_store_food + smoke_shop + vapour_product_retailer, data = merged_data_wclass1, family = binomial)

# Summarize the model
summary(logistic_model)

# Exponentiate the coefficients
exp(coef(logistic_model))

