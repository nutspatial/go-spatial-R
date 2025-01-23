# ---- load required libraries -------------------------------------------------

library(readr)
library(sf)
library(dplyr)
library(ggplot2)
library(tmap)

# ---- Read in the data --------------------------------------------------------

## Read the data ----
haiti_hf <- read_csv(
  file = "data/haiti/haiti-healthsites.csv"
)

## Set the data as a Simple Feature object ----
haiti_hf <- st_as_sf(
  x = haiti_hf, 
  coords = c("x", "y")
)

## Set the Coordinate Reference System (CRS) ----
haiti_hf <- st_set_crs(
  x = haiti_hf, 
  value = 4326
)

## Read in the shape files ----
haiti_shp <- st_read(dsn = "data/haiti/adm2.shp")
