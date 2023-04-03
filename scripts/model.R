# Set up
library(skimr)
library(modelsummary)
library(carData)
library(car)
library(MASS)
library(sf)
library(ggplot2)
library(summarytools)

###### Summary of Data ######

# Summary of data
potential_predictors <- merged_data_wclass1[, c("holistic_centre", "adult_entertainment_club", "eating_establishment", "entertainment_establishment_nightclub", "pawn_shop", "payday_loan", "sidewalk_cafe", "retail_store_food", "smoke_shop", "vapour_product_retailer", "class")]

merged_data_wclass_summary <-
  datasummary_skim(merged_data_wclass1)

merged_data_wclass_summary

# check correlation matrix between predictors
cor(potential_predictors)

###### Graphs ######
### put all the files under ON under the directory ###
# Distribution of predictors - (e.g. Sidewalk Cafe)
# Load ONfsa.shp
toronto_fsas <- st_read("ONfsa.shp")

# Change column name for later merge
colnames(clean_businesses_count)[colnames(clean_businesses_count) == "FSA_postal_code"] <- "FSA"

# merge two dataset
toronto_fsas_businesses <- merge(toronto_fsas, clean_businesses_count, by = "FSA")

# Convert the clean_dispensaries_final to a spatial dataframe:
clean_dispensaries_final_sf <- st_as_sf(clean_dispensaries_final, coords = c("longitude", "latitude"), crs = 4326)

# Convert the clean_dispensaries_final_sf to the same projection as toronto_fsas_businesses:
x_data_sf_proj <- st_transform(clean_dispensaries_final_sf, st_crs(toronto_fsas_businesses))

# Spatially join the x_data_sf_proj with the toronto_fsas_businesses:
toronto_fsas_businesses_x <- st_join(toronto_fsas_businesses, x_data_sf_proj)

# Change the coloumn names for easier reference
colnames(toronto_fsas_businesses_x) <- tolower(gsub(" ", "_", colnames(toronto_fsas_businesses_x)))

names(toronto_fsas_businesses_x)[names(toronto_fsas_businesses_x) == "entertainment_establishment/nightclub"] <- "entertainment_establishment_nightclub"

names(toronto_fsas_businesses_x) <- gsub("[()]", "", names(toronto_fsas_businesses_x))

# Create a choropleth map with ggplot2:
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = sidewalk_cafe)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "skyblue",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) +
  scale_fill_gradientn("Sidewalk Cafe", colours = pal)+
  theme_void()

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

