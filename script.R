################################################################################
###                 WORKFLOW FOR SPATIAL DATA SCIENCE                        ###
################################################################################

# ---- Load required libraries -------------------------------------------------
library(readr)
library(sf)
library(dplyr)
library(ggplot2)
library(tmap)
library(ggspatial)
library(mapview)

# ---- Data wrangling ----------------------------------------------------------
source("scripts/read-data-set-crs.R")

# ---- Making maps -------------------------------------------------------------
source("scripts/make-maps.R")

# ---- Spatial operations  -----------------------------------------------------
source("scripts/spatial-operations.R")
