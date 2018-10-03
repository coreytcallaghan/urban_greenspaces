# An R script to make a plot which shows the number of eBird checklists through time
# for each greenspace

## packages
library(dplyr)
library(ggplot2)
library(vegan)
library(tidyr)
library(reshape2)
library(data.table)
library(lubridate)
library(tibble)

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
  
  ## make a figure which shows the number of eBird checklists through time
  analysis_data.all %>% 
    dplyr::select(SAMPLING_EVENT_IDENTIFIER, OBSERVATION_DATE) %>%
    distinct(SAMPLING_EVENT_IDENTIFIER, .keep_all = TRUE) %>%
    mutate(year=year(OBSERVATION_DATE)) %>%
    group_by(year) %>%
    filter(year < 2018) %>%
    filter(year > 2000) %>%
    summarise(N=n()) %>%
    mutate(year=as.character(as.numeric(.$year))) %>%
    ggplot(., aes(x=year, y=N))+
    geom_bar(stat="identity")+
    xlab("Year")+
    ylab("Number of checklists")+
    theme_classic()+
    theme(axis.text.y=element_text(color="black", size=10))+
    theme(axis.text.x=element_text(angle = 45, size=8, color="black", hjust=0.7))+
    theme(axis.title=element_text(color="black", size=12))+
    theme(panel.grid.major=element_line(color="gray90"))+
    theme(panel.border=element_rect(color="black", fill=NA, size=1.2))
  
  ggsave(paste0("greenspaces/", gsub(".RDS", "", i), "/lists_time-", gsub(".RDS", "", i), ".png"), width=4, height=3.6, units="in", dpi=400)
  
}