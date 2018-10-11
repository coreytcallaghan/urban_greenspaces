library(sf)
library(geojsonio)
library(purrr)
library(dplyr)
library(stringr)
library(jsonlite)

geos <- list.files('greenspaces/', pattern = '*.geojson', recursive = T, full.names = T)

geos %>%   map_dfr(function(file) {
  p <-file %>% read_sf() %>% st_coordinates() %>% .[,1:2] %>% geosphere::centroid()
  data.frame(file, lon = p[1], lat = p[2])
}) -> centers

metadata_files <- list.files('greenspaces/', pattern = 'meta.*.*json', recursive = T, full.names = T)
metadata <- metadata_files %>% map_dfr( function(f) as.data.frame(read_json(f), stringsAsFactors = F))
centers %>% mutate(
  id = gsub('.*/|.geojson', '', file)
) %>% left_join(metadata, by = c("id" = "name")) %>%
mutate(
  geojson = file,
  file = NULL,
  country = str_split(id, '-', simplify = T)[,1] %>% toupper(),
  state = str_split(id, '-', simplify = T)[,2] %>% toupper(),
  name =  str_split(id, '-', simplify = T)[,3] %>% gsub('_', ' ', .) %>% tools::toTitleCase()
) %>% geojsonio::geojson_write(file = 'greenspace_centers.geojson')


#library(leaflet)
#leaflet(centers) %>% addTiles %>% addMarkers(~lon, ~lat, label = ~file)