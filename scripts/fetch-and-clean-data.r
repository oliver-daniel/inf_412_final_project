library(tidyverse)
library(janitor)
library(sf)

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
  write.csv(data.businesses, BUSINESSES_FILEPATH)
} else {
  print("Reading businesses data from existing file")
  data.businesses <- read_csv((BUSINESSES_FILEPATH))
}

# IMPORTANT: see README for instructions on properly installing FSA shapefiles.
data.fsas <- st_read("data/shp/ONfsa.shp")

desired_businesses <- c(
  "HOLISTIC CENTRE",
  "EATING ESTABLISHMENT",
  "ENTERTAINMENT ESTABLISHMENT/NIGHTCLUB",
  "PAWN SHOP",
  "PAYDAY LOAN",
  "SIDEWALK CAFE",
  "RETAIL STORE (FOOD)",
  "SMOKE SHOP",
  "VAPOUR PRODUCT RETAILER",
  "ADULT ENTERTAINMENT CLUB"
)

# Clean
clean_businesses <-
  clean_names(data.businesses) |>
  # filter to get needed FSAs
  filter(str_starts(licence_address_line_3, "M")) |>
  # filter to only have desirable business types
  filter(category %in% desired_businesses) |>
  # convert postal code to FSA
  mutate(
    fsa = substr(licence_address_line_3, 1, 3),
    category = category |>
      tolower() |>
      str_replace_all("[ /]", "_") |>
      str_replace_all("[()]", ""),
       # select required values only
      .keep = "used"
  )

clean_dispensaries <-
  clean_names(data.dispensaries) |>
  # Keep only the dispensaries with the application status "Authorized to Open"
  filter(application_status == "Authorized to Open") |>
  # filter to get needed FSAs
  filter(str_starts(postal_code, "M")) |>
  # convert postal code to FSA
  mutate(
    fsa = substr(postal_code, 1, 3)
  ) |>
  # select required values only
  select(
    fsa,
    latitude,
    longitude
  )

clean_fsas <-
  clean_names(data.fsas) |>
  filter(str_starts(fsa, "M")) |>
  select(
    fsa, geometry
  )

# Getting counts of businesses and dispensaries by FSA

business_counts <- clean_businesses |>
  count(fsa, category)

dispensary_counts <- clean_dispensaries |>
  count(fsa) |>
  mutate(
    class = as.numeric(n >= 3)
  )

fsa_counts <- clean_fsas |>
  left_join(dispensary_counts, by = "fsa") |>
  left_join(business_counts,
    by = "fsa",
    suffix = c(".dispensaries", ".businesses")
  ) |>
  as_tibble() |>
  mutate(across(where(is.numeric), ~ replace_na(., 0)))
