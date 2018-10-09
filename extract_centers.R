library(sf)
library(geojsonio)
library(purrr)

geos <- list.files('greenspaces/', pattern = '*.geojson', recursive = T, full.names = T)

geos %>% map_dfr(function(file) {
  p <-file %>% read_sf() %>% st_coordinates() %>% .[,1:2] %>% geosphere::centroid()
  data.frame(file, lon = p[1], lat = p[2])
}) -> centers


# library(leaflet)
# leaflet(centers) %>% addTiles %>% addMarkers(~lon, ~lat, label = ~file)
library(dplyr)
centers %>% mutate(
  id = gsub('.*/|.geojson', '', file),
  geojson = file,
  file = NULL,
  country = strsplit(id, '-')[[1]][1] %>% toupper(),
  state = strsplit(id, '-')[[1]][2] %>% toupper(),
  name = strsplit(id, '-')[[1]][3] %>% gsub('_', ' ', .) %>% tools::toTitleCase()
) %>% geojsonio::geojson_write(file = 'greenspace_centers.geojson')
