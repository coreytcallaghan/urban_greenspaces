## An R script to convert a flat text file 
## into a MySQL database hosted on a remote MySQL server

options(readr.show_progress = FALSE)

get_con <- function () dbConnect(RMariaDB::MariaDB(), user="ebird", password="magpie2311", host="WEDGETAIL", dbname="ebird")
import_data <- function (path = 'D:/All eBird data/ebd_AU_relFeb-2018.txt', chunk_size = 1e4) {
  library(RMariaDB)
  library(readr)
  library(dplyr, quietly = TRUE, warn.conflicts = FALSE)
  library(magrittr)
  con <- get_con()

  col_types_list = cols(
      .default = col_character(),
    `LAST EDITED DATE` = col_datetime(format = ""),
    `TAXONOMIC ORDER` = col_double(),
    LATITUDE = col_double(),
    LONGITUDE = col_double(),
    `OBSERVATION DATE` = col_date(format = ""),
    `TIME OBSERVATIONS STARTED` = col_time(format = ""),
    `DURATION MINUTES` = col_integer(),
    `EFFORT DISTANCE KM` = col_double(),
    `EFFORT AREA HA` = col_double(),
    `NUMBER OBSERVERS` = col_integer(),
    `ALL SPECIES REPORTED` = col_integer(),
    `TRIP COMMENTS` = col_skip(),
    `SPECIES COMMENTS` = col_skip(),
    `FIRST NAME` = col_skip(),
    `LAST NAME` = col_skip(),
    REASON = col_skip(),
    APPROVED = col_skip(),
    `HAS MEDIA` = col_skip(),
    REVIEWED = col_skip(),
    LOCALITY = col_skip(),
    X49 = col_skip()
  )
db_
  doWrite <- function (what, df) {
    # make column names neater
    colnames(df) <- gsub(" |/", "_", colnames(df))
    if(what == 'append') {
        append <- T
        overwrite <- F
    } else if (what == 'create') {
        append <- F
        overwrite <- T
    } else {
      stop(paste('what', what, 'not properly specified, should be one of "create" or "append"'))
    }
    ebird_all <- dbWriteTable(con, 'ebird_all_data', as.data.frame(df), 
      overwrite = overwrite,  append = append)
    if(!ebird_all) {
      print(paste('writes failed ebird_all', ebird_all))
    }
  }


  ## entire eBird database into the database
  process_data_raw <- function(df, pos) {
      # make column names neater
      print(paste('processing', pos, paste(dim(df), collapse = ',')))
      doWrite(ifelse(pos == 1, 'create', 'append'), df)
  }
  process_data_callback <- SideEffectChunkCallback$new(process_data_raw)
  print("db's created")
  # start the sequential read
  read_delim_chunked(path, process_data_callback, 
            delim="\t", quote="", trim_ws=TRUE,
            col_names = TRUE,
            col_types = col_types_list, chunk_size = chunk_size)
  dbDisconnect(con)
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


#
# saveRDS(all_greenspace_checklists(), 'greenspace_checklists.RDS')
# all_greenspace_checklists()  %>% open_leaflet  %>% print
