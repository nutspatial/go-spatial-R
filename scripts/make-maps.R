############################### STATIC MAPS  ###################################

# ---- Static maps with base R -------------------------------------------------

## Plot the map ----
plot(st_geometry(haiti_adm2))
plot(
  st_geometry(haiti_hc_utm),
  col = c("lightblue"),
  lw = 5, 
  pch = 1, 
  cex = 0.5, 
  main = "Map of Haiti",
  add = TRUE
)
plot(st_geometry(river_shp), add = TRUE, col = "grey")

# ---- Static maps with ggplot2 ------------------------------------------------

## Cloropleth map ----
haiti_adm2 |> 
  ggplot() +
  geom_sf(aes(fill = (female / total) * 100)) +
  scale_fill_viridis_c() +
  theme_light() + 
  annotation_north_arrow(
    location = "tl",
    which_north = "grid",
    style = north_arrow_fancy_orienteering()
  ) +
  annotation_scale() +
  labs(
    title = "Spatial distribution of females",
    fill = "%"
  )

## Cloropleth map using `dplyr::filter()` ----
haiti_adm2 |> 
  filter(adm1_en == "West") |> 
  ggplot() +
  geom_sf(aes(fill = (female / total) * 100)) +
  scale_fill_viridis_c() +
  theme_light() + 
  annotation_north_arrow(
    location = "tr",
    which_north = "grid",
    style = north_arrow_fancy_orienteering()
  ) +
  annotation_scale(
    line_width = 0.5,
  ) +
  labs(
    title = "Spatial distribution of females in West Haiti",
    fill = "%"
  )

## Cloropleth map using `dplyr::filter()` ----

central <- filter(haiti_hc_utm, adm1_en == "Centre")
haiti_adm2 |> 
  filter(adm1_en == "Centre") |> 
  ggplot() +
  geom_sf( color = "salmon") +
  geom_sf(data = central, color = "salmon") +
  scale_fill_viridis_c() +
  theme_light() +
  labs(
    title = "Spatial distribution of females in Central Haiti",
    fill = "%"
  )
  

# ---- Static maps with `{tmap}` -----------------------------------------------

## Set `mode` to "plot" ----
tmap_mode(mode = "plot")

## Cloropleth map of Nippes Haiti ----
Nippes_Haity <- haiti_adm2 |> 
  filter(adm1_en == "Nippes") |> 
  tm_shape() +
  tm_polygons(
    col = "female",
    border.alpha = 0.3,
    border.col = "white"
  )

## Cloropleth map of Nippes Haiti by location of residence ----
haiti_adm2 |> 
  filter(adm1_en == "Nippes") |> 
  tm_shape() +
  tm_polygons(
    col = c("urbanpct", "femalepct"), 
    title = c("Urban %", "Female %")
  ) +
  tm_legend(legend.position = c("left", "bottom"))


########################### INTERACTIVE MAPS  ################################

# ---- Interactive maps with `{mapview}` ----------------------------------------

## Plot iterative map ----
haiti_adm2 |> 
  mapview() +
  mapview(haiti_hc_utm, col.regions = "red")

## Plot iterative map ----
haiti_adm2 |> 
  filter(adm1_en == "Centre") |> 
  mapview() +
  mapview(
    central, 
    col.regions = "red",
    color = "red"
    )

# ---- Interactive maps with `{tmap}` ----------------------------------------

## Set `{tmap}` mode to interactive view ----
tmap_mode(mode = "view")
Nippes_Haity
