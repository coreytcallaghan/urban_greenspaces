LOAD DATA CONCURRENT INFILE '/home/corey/ebd_relDec-2018.txt' 
  IGNORE INTO TABLE species 
  IGNORE 1 LINES
    (
    @GLOBAL_UNIQUE_IDENTIFIER,
    @LAST_EDITED_DATE,
    @TAXONOMIC_ORDER,
    @CATEGORY,
    @COMMON_NAME,
    @SCIENTIFIC_NAME,
    @SUBSPECIES_COMMON_NAME,
    @SUBSPECIES_SCIENTIFIC_NAME,
    @OBSERVATION_COUNT,
    @BREEDING_BIRD_ATLAS_CODE,
    @BREEDING_BIRD_ATLAS_CATEGORY,
    @AGE_SEX,
    @COUNTRY,
    @COUNTRY_CODE,
    @STATE_PROVINCE,
    @SUBNATIONAL1_CODE,
    @COUNTY,
    @SUBNATIONAL2_CODE,
    @IBA_CODE,
    @BCR_CODE,
    @USFWS_CODE,
    @ATLAS_BLOCK,
    @LOCALITY,
    @LOCALITY_ID,
    @LOCALITY_TYPE,
    @LATITUDE,
    @LONGITUDE,
    @OBSERVATION_DATE,
    @TIME_OBSERVATIONS_STARTED,
    @OBSERVER_ID,
    @SAMPLING_EVENT_IDENTIFIER,
    @PROTOCOL_TYPE,
    @PROTOCOL_CODE,
    @PROJECT_CODE,
    @DURATION_MINUTES,
    @EFFORT_DISTANCE_KM,
    @EFFORT_AREA_HA,
    @NUMBER_OBSERVERS,
    @ALL_SPECIES_REPORTED,
    @GROUP_IDENTIFIER,
    @HAS_MEDIA,
    @APPROVED,
    @REVIEWED,
    @REASON,
    @TRIP_COMMENTS,
    @SPECIES_COMMENTS) 
  SET 
     TAXONOMIC_ORDER = @TAXONOMIC_ORDER,
     CATEGORY = @CATEGORY,
     COMMON_NAME = @COMMON_NAME,
     SCIENTIFIC_NAME = @SCIENTIFIC_NAME,
     SUBSPECIES_COMMON_NAME = @SUBSPECIES_COMMON_NAME,
     SUBSPECIES_SCIENTIFIC_NAME = @SUBSPECIES_SCIENTIFIC_NAME
;
