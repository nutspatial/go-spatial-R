################################################################################
#                          SPATIAL DATA OPERATIONS                             #
################################################################################


## Subset simple features of the "West" region ----
west_haiti <- haiti_adm2 |> 
  filter(adm1_en == "West")

# ---- Extract the centroids of a polygon ---------------------------------

## Extract the centroids ----
centroids <- st_centroid(west_haiti)

## Plot the results using `{ggplot2}` ----
west_haiti |> 
  ggplot() +
  geom_sf() +
  geom_sf(
    data = centroids, 
    color = "salmon", 
    alpha = 0.5
  )

# ---- Unify the Westen region into one shape ----------------------------------

west_haiti |> 
  st_union() |> 
  ggplot() +
  geom_sf()

# ---- Create a 30km buffer ----------------------------------------------------

## Filter out Port-au-Prince shapefile ----
port_au_prince <- west_haiti |>
  filter(adm2cod == "HT0111") |> 
  st_centroid()

## Create a 30 km buffer around the capital ----
buffer_30km <- st_buffer(
  x = port_au_prince, 
  dist = 30000
)

## Plot the results using ggplot2
west_haiti |> 
  ggplot() +
  geom_sf(
    fill = "lightblue", 
    color = "black"
    ) +
  geom_sf(
    data = buffer_30km, 
    fill = "transparent", 
    color = "red", 
    linetype = "dashed"
    ) +
  geom_sf(
    data = port_au_prince,
    color = "red"
    ) +
  theme_minimal() +
  labs(
    title = "20 km Buffer around Port-au-Prince"
    )

# ---- Create an intersection around the buffer --------------------------------

## Find the intersection between the west and capital buffer ----
intersect_30km <- st_intersection(
  x = west_haiti, 
  y = buffer_30km
)

## Plot the results using `{ggplot2}` ----
intersect_30km |> 
  ggplot() +
  geom_sf()

## Plot the results using `{tmap}` ----
intersect_30km |> 
  tm_shape() +
  tm_polygons()

# ---- Create difference around the buffer --------------------------------

## Find the difference between the west and the capital buffer ----
difference_30km <- st_difference(
  x = west_haiti, 
  y = buffer_30km
)

## Plot the results using `{ggplot2}` ----
difference_30km |> 
  ggplot() +
  geom_sf()

## Plot the results using `{tmap}` ----
difference_30km |> 
  tm_shape() +
  tm_polygons()


################################################################################
#                                    EXERCISE                                  #
# 1. Create a 10k buffer around the capital and plot the 30 and 10k buffer on the same map
# 2. Turn the 10k buffer into a single shape using st_union and plot.
# 3. Check the intersection between the Haiti and the 10km buffer and plot.
# 4. Try some further manipulations of your choice.
################################################################################

## 1. Create a 10k buffer around the capital and plot the 30 and 10k buffer on the same map
buffer_10km <- st_buffer(
  x = port_au_prince, 
  dist = 10000
)

### Plot the results using `{ggplot2}` ----
west_haiti |> 
  ggplot() +
  geom_sf(color = "salmon", fill = "white") +
  geom_sf(
    data = port_au_prince, 
    color = "#1B7810"
  ) +
  geom_sf(
    data = buffer_30km, 
    fill = "transparent", 
    color = "blue"
  ) +
  geom_sf(
    data = buffer_10km,
    fill = "transparent", 
    color = "#486744"
  ) +
  theme_void() + 
  labs(
    title = "WWWWW", 
    subtitle = "It looks super coool", 
    caption = "Thanks LSHTM"
  )

# ---- 2. Turn the 10k buffer into a single shape using st_union and plot ------

## Intersect the the areas around 10 km ----
west_haiti |> 
  st_intersection(st_transform(buffer_10km, crs = 32618)) |> 
  st_union() |> 
  ggplot() +
  geom_sf(
    fill = "#F4F6F6", 
    color = "#486744"
  )

# ---- 3. Check the intersection between the Haiti and the 10km buffer and plot

## Plot the difference around the 10km buffer; use `{ggplot2}` ----
west_haiti |> 
  st_difference(y = buffer_10km) |> 
  ggplot() +
  geom_sf()

## Plot the difference around the 30km buffer; use `{ggplot2}` ----
west_haiti |> 
  st_difference(y = buffer_30km) |> 
  ggplot() +
  geom_sf()

################################## DISTANCES ###################################
