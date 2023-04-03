# Create choropleth map with ggplot2

# Sidewalk cafe vs dispensaries
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = sidewalk_cafe)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("Sidewalk Cafe", option = "cividis") +
  theme_void()

# adult_entertainment_club vs dispensaries
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = adult_entertainment_club)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("adult entertainment club", option = "cividis") +
  theme_void()

# eating_establishment vs dispensaries
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = eating_establishment)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("eating establishment", option = "cividis") +
  theme_void()

# entertainment_establishment_nightclub vs dispensaries 
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = entertainment_establishment_nightclub)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("entertainment establishment nightclub", option = "cividis") +
  theme_void()

# pawn_shop vs dispensaries 
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = pawn_shop)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("pawn shop", option = "cividis") +
  theme_void()

# payday_loan vs dispensaries 
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = payday_loan)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("payday loan", option = "cividis") +
  theme_void()

# retail_store_food vs dispensaries 
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = retail_store_food)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("retail store (food)", option = "cividis") +
  theme_void()

# smoke_shop vs dispensaries 
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = smoke_shop)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("smoke shop", option = "cividis") +
  theme_void()

# vapour_product_retailer vs dispensaries 
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = vapour_product_retailer)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("vapour product retailer", option = "cividis") +
  theme_void()

# holistic_centre vs dispensaries
ggplot() +
  geom_sf(data = toronto_fsas_businesses_x, aes(fill = holistic_centre)) +
  geom_point(
    data = clean_dispensaries3,
    mapping = aes(x = longitude, y = latitude),
    color = "green",
    size = .5,
    alpha = .5,
    inherit.aes = F
  ) +
  scale_size_continuous(range = c(2, 10)) + 
  scale_fill_viridis_c("holistic centre", option = "cividis") +
  theme_void()
