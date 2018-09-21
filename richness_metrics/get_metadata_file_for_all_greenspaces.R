## create a metadata file for the list of greenspaces
## useful for deciding which greenspaces are able to 
## be analyzed

# packages
library(dplyr)
library(tibble)
library(readr)
library(tidyr)

# get list of files
files <- list.files("rds_greenspace_files")

# see how many observations for each greenspace before limiting checklists used
df <- list()

for (i in files) {
  
  data <- readRDS(paste0("rds_greenspace_files/", i))
  
  number_obs <- print(nrow(data))
  
  df[[i]] <- number_obs

}

number_obs <- t(bind_cols(df)) %>% 
  as.data.frame() %>%
  rename(number_obs = V1) %>%
  rownames_to_column("filename")

# now see how many checklists meet criteria for inclusion
df2 <- list() 

for (i in files) {
  
  data <- readRDS(paste0("rds_greenspace_files/", i))
  
  # here is where you add all the columns needed for the analysis (that don't vary within checklist)
  sampling_event_info <- data %>%
    select(SAMPLING_EVENT_IDENTIFIER, LOCALITY_ID, OBSERVATION_DATE,
           PROTOCOL_TYPE, ALL_SPECIES_REPORTED, EFFORT_DISTANCE_KM, EFFORT_AREA_HA, 
           DURATION_MINUTES, GROUP_IDENTIFIER, LATITUDE, LONGITUDE, OBSERVER_ID) %>%
    distinct()
  
  # Counts how many 'x's per checklist
  X_missing <- data %>%
    group_by(SAMPLING_EVENT_IDENTIFIER) %>%
    summarise(number_X = sum(OBSERVATION_COUNT=="X"))
  
  # accounts for the instance in which people submit 
  # the same species both at the species and subspecies level
  # also makes it so only 'species' and 'issf' category are included in analysis
  clean_data <- data %>%
    filter(CATEGORY %in% c("species", "issf", "domestic")) %>% 
    group_by(SAMPLING_EVENT_IDENTIFIER, COMMON_NAME) %>%
    summarise(COUNT_SPP = sum(as.numeric(as.character(OBSERVATION_COUNT)))) %>%
    rename(OBSERVATION_COUNT = COUNT_SPP) %>% 
    inner_join(., sampling_event_info, by="SAMPLING_EVENT_IDENTIFIER")%>%
    inner_join(., X_missing, by="SAMPLING_EVENT_IDENTIFIER")
  
  # applying some filtering criteria
  analysis_data <- clean_data %>%
    dplyr::filter(ALL_SPECIES_REPORTED == 1, # only complete checklists
                  PROTOCOL_TYPE !="Incidental", # get rid of 'incidental' lists
                  PROTOCOL_TYPE !="Historical", # get rid of 'historical' lists
                  number_X==0) %>% ## Get rid of any checklists that had a single X (Could alter this)
    group_by(SAMPLING_EVENT_IDENTIFIER) %>%
    summarise(Minutes=mean(DURATION_MINUTES, na.rm=TRUE), 
              Distance_km=mean(EFFORT_DISTANCE_KM, na.rm=TRUE), 
              Area_ha=mean(EFFORT_AREA_HA, na.rm=TRUE)) %>%
    inner_join(clean_data, ., by="SAMPLING_EVENT_IDENTIFIER") %>%
    # get rid of any checklists prior to 2010 - rather arbitrary cutoff, but gets rid of older stuff a bit
    filter(OBSERVATION_DATE >= "2010-01-01") %>%
    dplyr::filter(DURATION_MINUTES >= 5) %>%
    dplyr::filter(DURATION_MINUTES <= 240) %>%
    replace_na(list(EFFORT_DISTANCE_KM = 0)) %>%
    dplyr::filter(EFFORT_DISTANCE_KM <= 5) %>%
    replace_na(list(EFFORT_AREA_HA = 0)) %>%
    dplyr::filter(as.numeric(as.character(EFFORT_AREA_HA)) <= 500)

  number_lists <- print(length(unique(analysis_data$SAMPLING_EVENT_IDENTIFIER)))
  
  df2[[i]] <- number_lists
  
}

number_lists <- t(bind_cols(df2)) %>% 
  as.data.frame() %>%
  rename(number_lists = V1) %>%
  rownames_to_column("filename")

greenspace_metadata <- number_lists %>%
  inner_join(., number_obs, by="filename")

write_csv(greenspace_metadata, "richness_metrics/greenspace_metadata.csv")
