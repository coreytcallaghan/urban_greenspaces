# An R script to calculate the species list for each greenspace
# based on reporting rate
# reporting rate is defined as the percentage of eBird checklists that a species is seen on
# for a given greenspace
# this is then saved out as a .json file
# and this is done for each 'level'

## packages
library(dplyr)
library(ggplot2)
library(vegan)
library(tidyr)
library(reshape2)
library(data.table)
library(lubridate)
library(tibble)
library(jsonlite)

# list of files to do it for
files <- list.files("rds_greenspace_files")

for (i in files) {
  
  data <- readRDS(paste0("rds_greenspace_files/", i))
  
  ## First step is to clean the data and limit the checklists used in the analysis
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
    summarise(Species_Richness=length(unique(COMMON_NAME)), 
              Species_Diversity=diversity(OBSERVATION_COUNT), 
              Species_Abundance=sum(OBSERVATION_COUNT, na.rm=TRUE), 
              Minutes=mean(DURATION_MINUTES, na.rm=TRUE), 
              Distance_km=mean(EFFORT_DISTANCE_KM, na.rm=TRUE), 
              Area_ha=mean(EFFORT_AREA_HA, na.rm=TRUE)) %>%
    inner_join(clean_data, ., by="SAMPLING_EVENT_IDENTIFIER") %>%
    # get rid of any checklists prior to 2000 - rather arbitrary cutoff, but gets rid of older stuff a bit
    filter(OBSERVATION_DATE >= "2000-01-01") %>%
    dplyr::filter(DURATION_MINUTES >= 5) %>%
    dplyr::filter(DURATION_MINUTES <= 240) %>%
    replace_na(list(EFFORT_DISTANCE_KM = 0)) %>%
    dplyr::filter(EFFORT_DISTANCE_KM <= 5) %>%
    replace_na(list(EFFORT_AREA_HA = 0)) %>%
    dplyr::filter(as.numeric(as.character(EFFORT_AREA_HA)) <= 500) %>%
    ungroup()
  
  # first select the group_identifiers and associated checklists
  duplicated <- analysis_data %>%
    mutate(GROUP_IDENTIFIER = gsub("", NA, .$GROUP_IDENTIFIER)) %>%
    drop_na(GROUP_IDENTIFIER) %>%
    select(GROUP_IDENTIFIER, SAMPLING_EVENT_IDENTIFIER) %>%
    distinct(.keep_all=TRUE) %>%
    group_by(GROUP_IDENTIFIER) %>%
    # randomly sample one checklist for each group_identifier
    sample_n(., 1) %>%
    .$SAMPLING_EVENT_IDENTIFIER
  
  duplicated_data <- analysis_data %>%
    filter(SAMPLING_EVENT_IDENTIFIER %in% duplicated)
  
  ## now, append the selected checklists for each group_identifier
  ## with the non group_identifier checklists from the data
  
  # create analysis_data.all for all data
  analysis_data.all <- analysis_data %>%
    filter(!grepl("G", GROUP_IDENTIFIER)) %>%
    bind_rows(., duplicated_data)

  ## create species list for all data
  all_species_list <- analysis_data.all %>%
    group_by(COMMON_NAME) %>%
    summarise(N_species=n()) %>%
    mutate(N_lists=length(unique(analysis_data.all$SAMPLING_EVENT_IDENTIFIER))) %>%
    mutate(reporting_rate=(N_species/N_lists)*100) %>%
    dplyr::select(COMMON_NAME, reporting_rate) %>%
    rename(Species = COMMON_NAME) %>%
    rename(`Reporting rate (%)` = reporting_rate) %>%
    arrange(desc(`Reporting rate (%)`)) %>%
    mutate(`Reporting rate (%)` = round(.$`Reporting rate (%)`, digits=1))
  
  write_json(all_species_list, path=paste0("greenspaces/", gsub(".RDS", "", i), "/", gsub(".RDS", "", i), ".json"))
  
}
  
  
  
  
  
  
  
  