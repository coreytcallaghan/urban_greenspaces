library(RMariaDB)
library(dplyr)
library(dbplyr)
#source('eBird_to_sql_db/db_functions.R')
con <- get_con()
dbGetQuery(con, 'SHOW TABLE STATUS')  %>% select(Name, Rows)  %>% mutate(million_rows = Rows/1e6)

dbDisconnect(con)

