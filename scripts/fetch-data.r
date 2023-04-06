library(tidyverse)
library(sf)

DISPENSARIES_FILEPATH <- "data/acgo_dispensary_data.csv"
BUSINESSES_FILEPATH <- "data/opendata_toronto_business_licenses.csv"
FSA_DIRECTORY <- "data/shp"

if (!file.exists(DISPENSARIES_FILEPATH)) {
    data.dispensaries <- read_csv(
        "https://www.agco.ca/sites/default/files/opendata/AGCOWebSiteCannabisMapData.csv"
    )
    write.csv(data.dispensaries, DISPENSARIES_FILEPATH)
} else {
    message("Reading dispensary data from existing file")
    data.dispensaries <- read_csv(DISPENSARIES_FILEPATH)
}



if (!file.exists(BUSINESSES_FILEPATH)) {
    data.businesses <- read_csv(
        "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/57b2285f-4f80-45fb-ae3e-41a02c3a137f/resource/54bddc5e-92d9-4102-89c1-43e82f8f4d2d/download/Business%20licences%20data.csv"
    )
    write.csv(data.businesses, BUSINESSES_FILEPATH)
} else {
    message("Reading businesses data from existing file")
    data.businesses <- read_csv((BUSINESSES_FILEPATH))
}

# IMPORTANT: see README for instructions on properly installing FSA shapefiles.
data.fsas <- read_sf("data/shp", "ONfsa")