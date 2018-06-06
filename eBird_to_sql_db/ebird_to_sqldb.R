## An R script to convert a flat text file that is almost 5 GB
## into a MySQL database hosted on a remote MySQL server
## This is for Australia only, but will eventually want to
## convert the entire eBird dataset into a MySQL database
## Started work on a function to read the text file in
## in chunks and append those chunks to a MySQL database
## Need to work on this more though, and for now moving forward with
## the simple version below


library(RMySQL)
library(readr)
library(dplyr)

con <- dbConnect(RMySQL::MySQL(), user="ebird", password="magpie2311", host="WEDGETAIL", dbname="ebird")


df <- read_delim("C:/Users/CTC/Desktop/urban_greenspaces/Raw_eBird_data/ebd_AU_relFeb-2018/ebd_AU_relFeb-2018.txt", 
                 delim="\t", quote="", col_names=TRUE, trim_ws=TRUE)

colnames(df) <- gsub(" ", "_", colnames(df))
colnames(df) <- gsub("/", "_", colnames(df))

spatial_table <- df %>%
  select(SAMPLING_EVENT_IDENTIFIER, LATITUDE, LONGITUDE) %>%
  distinct(., .keep_all=TRUE)

dbWriteTable(conn=con, name="spatial_table", value=as.data.frame(spatial_table), overwrite=TRUE)


  
ebird_all <- df %>%
  select(-TRIP_COMMENTS, -SPECIES_COMMENTS, -X49, -FIRST_NAME, 
          -LAST_NAME, -REASON, -APPROVED, -HAS_MEDIA, -REVIEWED, -LOCALITY)
  
dbWriteTable(conn=con, name="ebird_all_data", value=as.data.frame(ebird_all), overwrite=TRUE)



## Trying to generalize it, but keep getting errors
## this will be necessary for when we want to convert the
## entire eBird database into a sql file
txt_to_mysql <- function(txt_file, table_name, 
                         pre_process_size = 1000, chunk_size = 50000) {
  
  con <- dbConnect(RMySQL::MySQL(), user="ebird", password="magpie2311", host="WEDGETAIL", dbname="ebird")
  
  # read an extract of the data to extract the colnames and types
  # to figure out the date and datetime columns
  df <- read_delim(txt_file, delim="\t", quote="", col_names=TRUE, trim_ws=TRUE, n_max = pre_process_size,
                   col_types= list(`TRIP COMMENTS` = col_skip(),
                                   `SPECIES COMMENTS` = col_skip(),
                                   X49 = col_skip(),
                                   `FIRST NAME` = col_skip(),
                                   `LAST NAME` = col_skip(),
                                   REASON = col_skip(),
                                   APPROVED = col_skip(),
                                   `HAS MEDIA` = col_skip(),
                                   REVIEWED = col_skip(),
                                   LOCALITY = col_skip()))
  
  # make column names neater
  colnames(df) <- gsub(" ", "_", colnames(df))
  colnames(df) <- gsub("/", "_", colnames(df))
  
  # write this first batch of lines to SQL table
  dbWriteTable(conn=con, name=table_name, as.data.frame(df), overwrite=TRUE)
  
  print("omg")
  
  # subfunction that appends new sections to the table
  append_to_sql <- function(x, pos) {
   
    # make column names neater
    colnames(x) <- gsub(" ", "_", colnames(x))
    colnames(x) <- gsub("/", "_", colnames(x))

    dbWriteTable(conn=con, name=table_name, as.data.frame(x), append = TRUE)
  }
  
  # readr chunk functionality
  read_delim_chunked(txt_file, append_to_sql, delim="\t", quote="", trim_ws=TRUE,
                     skip = pre_process_size+1, col_names = colnames(df),
                     col_types = list(`TRIP COMMENTS` = col_skip(),
                                      `SPECIES COMMENTS` = col_skip(),
                                      X49 = col_skip(),
                                      `FIRST NAME` = col_skip(),
                                      `LAST NAME` = col_skip(),
                                      REASON = col_skip(),
                                      APPROVED = col_skip(),
                                      `HAS MEDIA` = col_skip(),
                                      REVIEWED = col_skip(),
                                      LOCALITY = col_skip()), chunk_size = chunk_size,
                     progress = TRUE)
  dbDisconnect(con)
}


table_name <- "ebird_all_data"

txt_to_mysql(paste("C:/Users/CTC/Desktop/urban_greenspaces/Raw_eBird_data/ebd_AU_relFeb-2018/ebd_AU_relFeb-2018.txt"), 
             table_name, pre_process_size = 1000, 
             chunk_size = 50000)








