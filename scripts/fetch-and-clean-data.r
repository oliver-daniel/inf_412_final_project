library(tidyverse)
library(janitor)
library(sf)
library(dplyr)

DISPENSARIES_FILEPATH <- "data/acgo_dispensary_data.csv"
BUSINESSES_FILEPATH <- "data/opendata_toronto_business_licenses.csv"

if (!file.exists(DISPENSARIES_FILEPATH)) {
  data.dispensaries <- read_csv(
    "https://www.agco.ca/sites/default/files/opendata/AGCOWebSiteCannabisMapData.csv"
  )
  write.csv(data.dispensaries, DISPENSARIES_FILEPATH)
} else {
  print("Reading dispensary data from existing file")
  data.dispensaries <- read_csv(DISPENSARIES_FILEPATH)
}

if (!file.exists(BUSINESSES_FILEPATH)) {
  data.businesses <- read_csv(
    "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/57b2285f-4f80-45fb-ae3e-41a02c3a137f/resource/54bddc5e-92d9-4102-89c1-43e82f8f4d2d/download/Business%20licences%20data.csv"
  )
  data.businesses <- data.businesses |>
    left_join(
      data.postal_codes |>
        select(c(
          POSTAL_CODE,
          Latitude = LATITUDE, Longitude = LONGITUDE
        )),
      by = c("Licence Address Line 3" = "POSTAL_CODE")
    )
  write.csv(data.businesses, BUSINESSES_FILEPATH)
} else {
  print("Reading businesses data from existing file")
  data.businesses <- read_csv((BUSINESSES_FILEPATH))
}

# Clean
clean_businesses <- 
  clean_names(data.businesses)

clean_dispensaries <-
  clean_names(data.dispensaries)

# Cleaning the dataset to get the count of each variables 

###### Clean dispensaries data ######
# Keep only the dispensaries with the application status "Authorized to Open" 
clean_dispensaries %>%
  filter(application_status == "Authorized to Open") -> clean_dispensaries1

# Remove columns not needed
clean_dispensaries2 <- clean_dispensaries1[-c(1:5,8:11,13:21)]

# filter to get needed FSAs
clean_dispensaries3 <- clean_dispensaries2 %>%
  filter(grepl("^M", postal_code))

clean_dispensaries3$FSA_postal_code <- substr(clean_dispensaries3$postal_code, 1, 3)

clean_dispensaries_final <- clean_dispensaries3[-c(3)]

# Count the number of dispensaries in each FSA zone
clean_dispensaries_count <- clean_dispensaries_final %>%
  count(FSA_postal_code, name = "count_dispensaries")

# Store the cleaned dataset in CSV
write_csv(clean_dispensaries_final, "data/clean_dispensaries_final.csv")
write_csv(clean_dispensaries_count, "data/clean_dispensaries_count.csv")

###### Clean businesses data ######
# Remove columns not needed
clean_businesses1 <- clean_businesses[-c(1,2,4:11,13:19)]

# filter to get needed FSAs
clean_businesses2 <- clean_businesses1 %>%
  filter(grepl("^M", licence_address_line_3))

clean_businesses2$FSA_postal_code <- substr(clean_businesses2$licence_address_line_3, 1, 3)

clean_businesses2 <- clean_businesses2[-c(2)]

# get the count of businesses by FSAs
clean_businesses2 %>%
  dplyr::select(-c(2, 3)) %>%
  group_by(FSA_postal_code, category) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = category, values_from = n, values_fill = 0) ->
  clean_businesses_count

# Save outputs as CSV
write_csv(clean_businesses2, "data/clean_businesses_final.csv")
write_csv(clean_businesses_count, "data/clean_businesses_count.csv")

###### merge datasets ######
merged_data <- merge(clean_dispensaries_count, clean_businesses_count, by = "FSA_postal_code", all = TRUE)
merged_data[is.na(merged_data)] <- 0

# New column - class (dependent variable)
merged_data_wclass <- merged_data %>%
  mutate(class = ifelse(count_dispensaries >= 3, 1, 0))

# Remove columns (independent) not needed
merged_data_wclass1 <- merged_data_wclass %>%
  dplyr::select("FSA_postal_code", "count_dispensaries", "class", "HOLISTIC CENTRE", "EATING ESTABLISHMENT", "ENTERTAINMENT ESTABLISHMENT/NIGHTCLUB", "PAWN SHOP", "PAYDAY LOAN", "SIDEWALK CAFE", "RETAIL STORE (FOOD)", "SMOKE SHOP", "VAPOUR PRODUCT RETAILER", "ADULT ENTERTAINMENT CLUB")

colnames(merged_data_wclass1) <- tolower(gsub(" ", "_", colnames(merged_data_wclass1)))

names(merged_data_wclass1)[names(merged_data_wclass1) == "entertainment_establishment/nightclub"] <- "entertainment_establishment_nightclub"

names(merged_data_wclass1) <- gsub("[()]", "", names(merged_data_wclass1))


# Save output as CSV
write_csv(merged_data, "data/merged_data.csv")
write_csv(merged_data_wclass1, "data/merged_data_wclass.csv")

