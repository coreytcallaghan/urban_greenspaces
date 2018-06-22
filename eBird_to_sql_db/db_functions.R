## An R script to convert a flat text file that is almost 5 GB
## into a MySQL database hosted on a remote MySQL server
## This is for Australia only, but will eventually want to
## convert the entire eBird dataset into a MySQL database
## Started work on a function to read the text file in
## in chunks and append those chunks to a MySQL database
## Need to work on this more though, and for now moving forward with
## the simple version below


library(RMariaDB)
library(readr)
library(dplyr, quietly = TRUE, warn.conflicts = FALSE)
library(magrittr)
options(readr.show_progress = FALSE)

con <- dbConnect(RMariaDB::MariaDB(), user="ebird", password="magpie2311", host="WEDGETAIL", dbname="ebird")
main <- function (chunk_size = 1e3) {
  #path = "C:/Users/CTC/Desktop/urban_greenspaces/Raw_eBird_data/ebd_AU_relFeb-2018/ebd_AU_relFeb-2018.txt"
  path = "Raw_eBird_data/ebird_1e4_text.txt"
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
    #print(nrow(dbReadTable(con, 'spatial_table')))
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
}
main()
print(dbGetQuery(con, "SELECT COUNT(*) FROM ebird_all_data"))
#print(warnings())
dbDisconnect(con)

