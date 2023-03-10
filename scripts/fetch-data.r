library(tidyverse)

DISPENSARIES_FILEPATH <- "data/acgo_dispensary_data.csv"
NEIGHBOURHOODS_FILEPATH <- "data/opendata_toronto_neighbourhoods.csv"
BUSINESSES_FILEPATH <- "data/opendata_toronto_business_licenses.csv"
POSTAL_CODES_FILEPATH <- "data/postal_codes.csv"

if (!file.exists(DISPENSARIES_FILEPATH)) {
    data.dispensaries <- read_csv(
        "https://www.agco.ca/sites/default/files/opendata/AGCOWebSiteCannabisMapData.csv"
    )
    write.csv(data.dispensaries, DISPENSARIES_FILEPATH)
} else {
    print("Reading dispensary data from existing file")
    data.dispensaries <- read_csv(DISPENSARIES_FILEPATH)
}

if (!file.exists(NEIGHBOURHOODS_FILEPATH)) {
    data.neighbourhoods <- read_csv(
        "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/neighbourhoods/resource/db634f74-36c9-4caa-84be-256e304a89de/download/Neighbourhoods%20-%204326.csv"
    )
    write.csv(data.neighbourhoods, NEIGHBOURHOODS_FILEPATH)
} else {
    print("Reading neighbourhood data from existing file")
    data.neighbourhoods <- read_csv((NEIGHBOURHOODS_FILEPATH))
}

if (!file.exists(POSTAL_CODES_FILEPATH)) {
    temp <- tempfile()
    download.file(
        "https://www.serviceobjects.com/public/zipcode/ZipCodeFiles.zip", temp
    )
    data.postal_codes <- read_csv(unz(temp, "CanadianPostalCodes202208.csv"))
    write.csv(data.postal_codes, POSTAL_CODES_FILEPATH)
    unlink(temp)
} else {
    print("Reading postal codes data from existing file")
    data.postal_codes <- read_csv(POSTAL_CODES_FILEPATH)
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
