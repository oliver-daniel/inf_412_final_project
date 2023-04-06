# Set up
library(janitor)
library(dplyr)
library(tidyverse)

# Cleaning Script
clean_businesses <- 
  clean_names(data.businesses)

clean_dispensaries <-
  clean_names(data.dispensaries)

clean_neighbourhoods <-
  clean_names(data.neighbourhoods)

clean_intersections <-
  clean_names(data.intersections)

clean_postal_codes <-
  clean_names(data.postal_codes)

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
write_csv(clean_dispensaries_final, "clean_dispensaries_final.csv")
write_csv(clean_dispensaries_count, "clean_dispensaries_count.csv")

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
  select(-c(2, 3)) %>%
  group_by(FSA_postal_code, category) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = category, values_from = n, values_fill = 0) ->
  clean_businesses_count

# Save outputs as CSV
write_csv(clean_businesses2, "clean_businesses_final.csv")
write_csv(clean_businesses_count, "clean_businesses_count.csv")

###### merge datasets ######
merged_data <- merge(clean_dispensaries_count, clean_businesses_count, by = "FSA_postal_code", all = TRUE)
merged_data[is.na(merged_data)] <- 0

# New column - class (dependent variable)
merged_data_wclass <- merged_data %>%
  mutate(class = ifelse(count_dispensaries >= 3, 1, 0))

# Remove columns (independent) not needed
merged_data_wclass1 <- merged_data_wclass %>%
  select("FSA_postal_code", "count_dispensaries", "class", "HOLISTIC CENTRE", "EATING ESTABLISHMENT", "ENTERTAINMENT ESTABLISHMENT/NIGHTCLUB", "PAWN SHOP", "PAYDAY LOAN", "SIDEWALK CAFE", "RETAIL STORE (FOOD)", "SMOKE SHOP", "VAPOUR PRODUCT RETAILER", "ADULT ENTERTAINMENT CLUB")

colnames(merged_data_wclass1) <- tolower(gsub(" ", "_", colnames(merged_data_wclass1)))

names(merged_data_wclass1)[names(merged_data_wclass1) == "entertainment_establishment/nightclub"] <- "entertainment_establishment_nightclub"

names(merged_data_wclass1) <- gsub("[()]", "", names(merged_data_wclass1))


# Save output as CSV
write_csv(merged_data, "merged_data.csv")
write_csv(merged_data_wclass1, "merged_data_wclass.csv")

