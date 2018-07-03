## An R script to convert a flat text file 
## into a MySQL database hosted on a remote MySQL server

options(readr.show_progress = FALSE)

get_wkt_of_greenspace <- function (geojson_data){ 
  polys <- lapply(geojson_data$features, function(feature) {
    list(feature$geometry$coordinates)
  })
  names(polys) <- sapply(geojson_data$features, function(feature) {
    list(feature$geometry$type)
  })
  wellknown::geojson2wkt(polys)
}
parse_gs_file <- function (filename) {
  x <- gsub('^geojson_greenspace_files/|.geojson$', '', filename)
  x <- unlist(strsplit(x, '-'))
  data.frame(filename = filename, country = x[1], state = x[2], name = x[3])
}

checklists_from_file <- function (con, gs_file) {
  geojson_data <- geojsonR::FROM_GeoJson(gs_file)
  wkt <- get_wkt_of_greenspace(geojson_data)
  lists <- dbGetQuery(con, paste0(" SELECT SAMPLING_EVENT_IDENTIFIER, LATITUDE, LONGITUDE FROM spatial_table WHERE MBRContains( GeomFromText(\'", wkt, "\'), pt);"))
  lists <- as.data.frame(lists)
  meta <- parse_gs_file(gs_file)
  if(nrow(lists) == 0)
   lists
  else {
    cat(paste(meta$name, nrow(lists), 'lists \n'))
    cbind(meta, lists)
  } 
}
observations_from_file_to_rds <- function (con, gs_file) {
  geojson_data <- geojsonR::FROM_GeoJson(gs_file)
  wkt <- get_wkt_of_greenspace(geojson_data)
  lists <- dbGetQuery(con, paste0(
    "SELECT * from ebird_all_data",
    "WHERE SAMPLING_EVENT_IDENTIFIER FROM spatial_table WHERE MBRContains( GeomFromText(\'", wkt, "\'), pt);"))
  lists <- as.data.frame(lists)
  meta <- parse_gs_file(gs_file)
  if(nrow(lists) == 0)
   lists
  else {
    cat(paste(meta$name, nrow(lists), 'lists \n'))
    cbind(meta, lists)
  } 
}

all_greenspace_checklists  <- function (greenspace_folder = 'geojson_greenspace_folders/'){
  greenspaces <- paste0(greenspace_folder, dir(greenspace_folder))
  con <- get_con()
  lists <- plyr::ldply(greenspaces, function (gs) checklists_from_file(con, gs))
  dbDisconnect(con)
  lists
}

open_leaflet <- function (checklists) {
  require(leaflet)
  require(dplyr)
  markers <- checklists %>% select(lat =LATITUDE, lng = LONGITUDE) %>% 
      group_by(lat, lng) %>% 
      summarise(count = n())
  leaflet() %>% addTiles() %>% 
    addMarkers(markers$lng, markers$lat, label = paste('checklists', markers$count),
    labelOptions = labelOptions(noHide = T))
}


# saveRDS(all_greenspace_checklists(), 'greenspace_checklists.RDS')
# all_greenspace_checklists()  %>% open_leaflet  %>% print
