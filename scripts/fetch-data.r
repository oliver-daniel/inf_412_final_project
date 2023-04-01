library(tidyverse)
library(sf)

DISPENSARIES_FILEPATH <- "data/acgo_dispensary_data.csv"
# NEIGHBOURHOODS_FILEPATH <- "data/opendata_toronto_neighbourhoods.geojson"
# INTERSECTIONS_FILEPATH <- "data/opendata_toronto_intersections.geojson"
BUSINESSES_FILEPATH <- "data/opendata_toronto_business_licenses.csv"
# POSTAL_CODES_FILEPATH <- "data/postal_codes.csv"
FSA_DIRECTORY <- "data/shp"

if (!file.exists(DISPENSARIES_FILEPATH)) {
    data.dispensaries <- read_csv(
        "https://www.agco.ca/sites/default/files/opendata/AGCOWebSiteCannabisMapData.csv"
    )
    write.csv(data.dispensaries, DISPENSARIES_FILEPATH)
} else {
    print("Reading dispensary data from existing file")
    data.dispensaries <- read_csv(DISPENSARIES_FILEPATH)
}

# if (!file.exists(NEIGHBOURHOODS_FILEPATH)) {
#     download.file(
#         "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/neighbourhoods/resource/1d38e8b7-65a8-4dd0-88b0-ad2ce938126e/download/Neighbourhoods.geojson",
#         NEIGHBOURHOODS_FILEPATH
#     )
# } else {
#     print("Reading neighbourhood data from existing file")
# }

# if (!file.exists(INTERSECTIONS_FILEPATH)) {
#     download.file(
#         "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/2c83f641-7808-49ba-b80f-7011851d4e27/resource/8e825e33-d7e1-4e59-b247-5868bf7d66a9/download/Centreline%20Intersection.geojson",
#         INTERSECTIONS_FILEPATH
#     )
# } else {
#     print("Reading intersection data from existing file")
# }

# data.intersections <- st_read(INTERSECTIONS_FILEPATH)

# data.neighbourhoods <- st_read(NEIGHBOURHOODS_FILEPATH)

# if (!file.exists(POSTAL_CODES_FILEPATH)) {
#     temp <- tempfile()
#     download.file(
#         "https://www.serviceobjects.com/public/zipcode/ZipCodeFiles.zip", temp
#     )
#     zipped_files <- unzip(temp, list = TRUE)
#     codes_file <- files[str_starts(files$Name, "CanadianPostalCodes"), "Name"]

#     data.postal_codes <- read_csv(unz(temp, codes_file))
#     write.csv(data.postal_codes, POSTAL_CODES_FILEPATH)
#     unlink(temp)
# } else {
#     print("Reading postal codes data from existing file")
#     data.postal_codes <- read_csv(POSTAL_CODES_FILEPATH)
# }

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
data.fsas <- read_sf('data/shp', 'ONfsa')