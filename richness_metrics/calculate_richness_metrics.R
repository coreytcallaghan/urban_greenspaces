# An R Script used to calculate species richness values for each greenspace
# the steps involve piping in data from the rd_greenspace_files folder
# and then cleaning and limiting the data to run the species richness estimates

## packages
library(dplyr)
library(ggplot2)
library(vegan)
library(tidyr)
library(reshape2)
library(data.table)
library(lubridate)
library(tibble)




richness_metric_calculation <- function(greenspace) {

# source functions
source("richness_metrics/global_functions.R")
  
# first for an example greenspace
data <- readRDS(paste0("rds_greenspace_files/", greenspace))

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
  # get rid of any checklists prior to 2010 - rather arbitrary cutoff, but gets rid of older stuff a bit
  filter(OBSERVATION_DATE >= "2010-01-01") %>%
  dplyr::filter(DURATION_MINUTES >= 5) %>%
  dplyr::filter(DURATION_MINUTES <= 240) %>%
  replace_na(list(EFFORT_DISTANCE_KM = 0)) %>%
  dplyr::filter(EFFORT_DISTANCE_KM <= 5) %>%
  replace_na(list(EFFORT_AREA_HA = 0)) %>%
  dplyr::filter(as.numeric(as.character(EFFORT_AREA_HA)) <= 500) %>%
  # add season for each checklist
  mutate(season = getSeason_southern(OBSERVATION_DATE)) %>%
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

## applying the 5% rule - getting rid of 5% of observations 
## Exluding the species that rarely occur
checklists_hotspots <- analysis_data.all%>%
  group_by(LOCALITY_ID)%>%
  summarise(total_checklists=length(unique(SAMPLING_EVENT_IDENTIFIER)))

## creating a dataframe which removes the species that are on <=5% of checklists in a hotspot
analysis_data.95 <- analysis_data.all%>%
  group_by(LOCALITY_ID, COMMON_NAME)%>%
  summarise(species_count=length(COMMON_NAME))%>%
  inner_join(checklists_hotspots, ., by="LOCALITY_ID")%>%
  mutate(percentage_of_checklists=(species_count/total_checklists)*100)%>%
  inner_join(analysis_data.all, ., by=c("LOCALITY_ID", "COMMON_NAME"))%>%
  filter(percentage_of_checklists >=5.00) ## removing species that are on < 5% of checklists in a hotspot

## now remove everything from environment besides analysis_data.all and analysis_data.95
rm(list=setdiff(ls(), c("analysis_data.all", "analysis_data.95", "greenspace", "richness_summary")))

## now run the functions to look at species richness in each site
rich_all <- richness_summary(analysis_data.all) %>%
  mutate(level="all")
rich_95 <- richness_summary(analysis_data.95) %>%
  mutate(level="95")

results <- bind_rows(rich_all, rich_95)

N <- nrow(rich_all)

greenspace <- gsub(".RDS", "", greenspace)

saveRDS(results, file=paste0("richness_metrics/results/", greenspace, ".RDS"))

ggplot(results, aes(x=Checklists, y=Richness, color=level))+
  geom_point()+
  geom_line()+
  geom_ribbon(aes(x=Checklists, ymin=(Richness-2*SD), ymax=(Richness+2*SD)), alpha=0.1)+
  xlab("Number of checklists")+
  ylab("Species richness")+
  theme_classic()+
  theme(axis.text=element_text(color="black", size=10))+
  theme(axis.title=element_text(color="black", size=12))+
  theme(panel.grid.major=element_line(color="gray90"))+
  theme(panel.border=element_rect(color="black", fill=NA, size=1.2))+
  theme(legend.position=c(0.9, 0.2))+
  theme(legend.background=element_blank())+
  theme(legend.box.background=element_rect(color="black"))+
  ggtitle(paste0("N = ", N, " checklists"))+
  scale_color_manual(values=c("goldenrod3", "steelblue3"))
  
  ggsave(paste0("richness_metrics/plots/", greenspace, ".png"), width=4, height=3.6, units="in", dpi=400)
  
  rm(greenspace)
}

## get list of filenames and then filter based on a set number of checklists
## this way we are only analyzing greenspaces which are likely to have enough data
greenspace_metadata <- read_csv("richness_metrics/greenspace_metadata.csv")

## let's only look at files with >40 checklists though
## and only for Australia for now
## will adapt to include other parts of the world 
## in due time

greenspaces_to_assess <- greenspace_metadata %>%
  dplyr::filter(., grepl("aus", .$filename)) %>%
  dplyr::filter(number_lists > 40) %>%
  .$filename

for (i in greenspaces_to_assess) {
  
  tryCatch(
    richness_metric_calculation(i), error=function(e){cat("ERROR:", conditionMessage(e), "\n")}
    
    )

  
}







