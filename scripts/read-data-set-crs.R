# ---- Read in the data --------------------------------------------------------

## Haiti health centers ----
haiti_hc <- read_csv(
  file = "data/haiti/haiti-healthsites.csv"
)

## Haiti shape files ----
haiti_adm2 <- st_read(dsn = "data/haiti/adm2.shp")

## Haiti's rivers ----
river_shp <- st_read(dsn = "data/haiti/rivers.shp")


# ---- Set CRS and Reproject  --------------------------------------------------

## Set the Haiti's health center data as a simple feature object ----
haiti_hc <- st_as_sf(
  x = haiti_hc, 
  coords = c("x", "y")
)

## Set the geographic Coordinate Reference System (CRS) ----
haiti_hc <- st_set_crs(
  x = haiti_hc, 
  value = 4326
)

## Transform the geographic CRS into Haiti's local UTM  ----
haiti_hc_utm <- st_transform(
  x = haiti_hc, 
  crs = 32618
)

## Transform Haiti's shapefiles into UTM ----
haiti_adm2 <- st_transform(
  x = haiti_shp,
  crs = 32618
)