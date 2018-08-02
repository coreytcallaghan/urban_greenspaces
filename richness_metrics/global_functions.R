# some global functions

## function for seasons in southern hemisphere
getSeason_southern <- function(DATES) {
  WS <- as.Date("2012-12-15", format = "%Y-%m-%d") # Winter Solstice
  SE <- as.Date("2012-3-15",  format = "%Y-%m-%d") # Spring Equinox
  SS <- as.Date("2012-6-15",  format = "%Y-%m-%d") # Summer Solstice
  FE <- as.Date("2012-9-15",  format = "%Y-%m-%d") # Fall Equinox
  
  # Convert dates from any year to 2012 dates
  d <- as.Date(strftime(DATES, format="2012-%m-%d"))
  
  ifelse (d >= WS | d < SE, "Summer",
          ifelse (d >= SE & d < SS, "Autumn",
                  ifelse (d >= SS & d < FE, "Winter", "Spring")))
}

# function for seasons in northern hemisphere
getSeason_northern <- function(DATES) {
  WS <- as.Date("2012-12-15", format = "%Y-%m-%d") # Winter Solstice
  SE <- as.Date("2012-3-15",  format = "%Y-%m-%d") # Spring Equinox
  SS <- as.Date("2012-6-15",  format = "%Y-%m-%d") # Summer Solstice
  FE <- as.Date("2012-9-15",  format = "%Y-%m-%d") # Fall Equinox
  
  # Convert dates from any year to 2012 dates
  d <- as.Date(strftime(DATES, format="2012-%m-%d"))
  
  ifelse (d >= WS | d < SE, "Winter",
          ifelse (d >= SE & d < SS, "Spring",
                  ifelse (d >= SS & d < FE, "Summer", "Autumn")))
}



## This function works for the entire checklists (2010-2016) at a hotspot
richness_summary <- function(data) {
  
  # spreading the columns to a matrix form
  hotspot_species <- dcast(data, SAMPLING_EVENT_IDENTIFIER~COMMON_NAME, fun.aggregate=mean, value.var="OBSERVATION_COUNT") 
  
  # removing NaN and replacing with 0 
  hotspot_species[is.na(hotspot_species)] <- 0
  
  # subsetting the checklists to make row names
  hotspot_species <- hotspot_species %>%
    column_to_rownames("SAMPLING_EVENT_IDENTIFIER")
  
  # Making the entire data frame numeric for analysis sake
  asNumeric <- function(x) as.numeric(as.character(x))
  factorsNumeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], asNumeric))
  hotspot_species <- factorsNumeric(hotspot_species)
  
  # performing the species accumulation, using a 'randon' approach
  hotspot_acc <- specaccum(hotspot_species, method="random", permutations=1000)
  
  # turning the specaccum object into a dataframe
  hotspot_acc.data <- data.frame(Checklists=hotspot_acc$sites, Richness=hotspot_acc$richness, SD=hotspot_acc$sd)
  
  # gives the cumpercent of richness for checklists
  # this will be used later when i ask the question how many checklists required
  # to say the community is well sampled
  hotspot_acc.data$total <- tail(hotspot_acc.data$Richness, n=1)
  hotspot_acc.data$cumpercent.observed <- (hotspot_acc.data$Richness/hotspot_acc.data$total)*100
  
  # this estimates the total number of species present
  # I use the chao estimator in this instance 
  # (references: https://cran.r-project.org/web/packages/vegan/vignettes/diversity-vegan.pdf)
  hotspot_acc.data$specpool <- specpool(hotspot_species)[,2]
  hotspot_acc.data$cumpercent.estimated <- (hotspot_acc.data$Richness/hotspot_acc.data$specpool)*100
  
  # returns the data if you want to assign it
  invisible(hotspot_acc.data)  
  # save(hotspot_acc.data, file = paste0(hotspot,".Rdata"))
}










