## An R script to convert a flat text file 
## into a MySQL database hosted on a remote MySQL server
## To run these commands you need to connect to a ebird database, setup like in the database folder:
## and have an .Renviron file with your database credentials 
## follow the steps outlined here: https://db.rstudio.com/best-practices/managing-credentials/#use-environment-variables
options(readr.show_progress = FALSE)
library(dbplyr)
library(dplyr, quietly = T, warn.conflicts = F)
library(RMariaDB)
get_con  <- function () {
  dbConnect(RMariaDB::MariaDB(), host = 'KESTREL', dbname='ebird',user = Sys.getenv('userid'), password = Sys.getenv('pwd'))
} 
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
  gs_id <- x
  x <- unlist(strsplit(x, '-'))
  data.frame(filename = filename, file_country = x[1], file_state = x[2], file_gs_name = x[3], gs_id = gs_id)
}

checklists_from_file <- function (con, gs_file) {
  stop("function not yet useable")
  geojson_data <- geojsonR::FROM_GeoJson(gs_file)
  wkt <- get_wkt_of_greenspace(geojson_data)
  lists <- dbGetQuery(con, paste0("SELECT SAMPLING_EVENT_IDENTIFIER FROM sites WHERE MBRContains( GeomFromText(\'", wkt, "\'), pt);"))
  lists <- as.data.frame(lists)
  meta <- parse_gs_file(gs_file)
  if(nrow(lists) == 0)
   lists
  else {
    cat(paste(meta$name, nrow(lists), 'lists \n'))
    cbind(meta, lists)
  } 
}
samples_from_file <- function (con, gs_file) {
  geojson_data <- geojsonR::FROM_GeoJson(gs_file)
  wkt <- get_wkt_of_greenspace(geojson_data)
  query_ <- paste0(
    "
    SELECT
      *
    FROM checklists as lists, sites as sites, samples as samples, species as species
      WHERE
          samples.TAXONOMIC_ORDER = species.TAXONOMIC_ORDER
        AND
          samples.SAMPLING_EVENT_IDENTIFIER = lists.SAMPLING_EVENT_IDENTIFIER
        AND
          lists.LOCALITY_ID = sites.LOCALITY_ID 
        AND
          MBRContains( GeomFromText(
            \'", wkt,"\'
          ), sites.pt);")
  lists <- dbGetQuery(con, query_)
  lists <- as.data.frame(lists)
  meta <- parse_gs_file(gs_file)
  if(nrow(lists) == 0) {
    cat(paste(meta$file_country, meta$gs_id, 0, 'observations \n'))
    lists
  } else {
    cat(paste(meta$file_country, meta$gs_id, nrow(lists), 'observations \n'))
    cbind(meta, lists)
  }
}

write_all_samples  <- function (greenspace_folder = 'geojson_greenspace_files/'){
  greenspaces <- dir(greenspace_folder)
  write_samples(greenspaces)
}
write_new_samples <- function (
    greenspace_folder = 'geojson_greenspace_files/',
    rds_folder = 'rds_greenspace_files/') {
    geojsons <- dir(greenspace_folder) %>% gsub('.geojson$', '', .)
    rdss <- dir(rds_folder) %>% gsub('.RDS$', '', .)
    
    greenspaces <- setdiff(geojsons, rdss)
    if (length(greenspaces) > 0) {
      greenspaces <- paste0(greenspaces, '.geojson')
      write_samples(greenspaces)
    } else {
      print('no new greenspaces')
    }
}
write_samples <- function (files, greenspace_folder = 'geojson_greenspace_files/', out_folder = 'rds_greenspace_files/') {
  require(purrr)
  con <- get_con()
  print(paste('processing', length(files), 'greenspaces'))
  files %>% walk(function(gs){
    infile <- paste0(greenspace_folder, gs)
    outfile <- paste0(out_folder, gsub('.geojson$','', gs) ,'.RDS')
    #print(paste(gs, infile, outfile))
    saveRDS(samples_from_file(con, infile), outfile)
  })
  dbDisconnect(con)
}
open_leaflet <- function (checklists) {
  require(leaflet)
  require(dplyr)
  markers <- checklists %>% select(lat =LATITUDE, lng = LONGITUDE) %>% 
      group_by(lat, lng) %>% 
      summarise(count = n())
  leaflet() %>% addTiles() %>% 
    addMarkers(markers$lng, markers$lat, label = paste('samples', markers$count),
    labelOptions = labelOptions(noHide = T))
}

# write_new_samples()
# write_greenspace_checklists()
#saveRDS(all_greenspace_checklists(), 'greenspace_checklists.RDS')
#samples_from_file(get_con(), 'geojson_greenspace_files/aus-nsw-randwick_environment_park.geojson')  %>% open_leaflet
