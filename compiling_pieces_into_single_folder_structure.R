# an R script to put all the pieces of the different folders into a single place
# It moves the geojsons from each individual file to a folder for each greenspace
# then pulls in the rds greenspace files into that same folder


my.file.copy <- function(from, to) {
  todir <- dirname(to)
  if (!isTRUE(file.info(todir)$isdir)) dir.create(todir, recursive=TRUE)
  file.copy(from = from,  to = to)
}

# First does this for geojson files
files <- list.files("geojson_greenspace_files")

for (i in files) {
  

  my.file.copy(from = paste0("geojson_greenspace_files/", i), to = paste0("greenspaces/", gsub(".geojson", "", i), "/", i, ""))

  
 }



# Now repeat the same thing and copy over the png for each greenspace which has enough data to be analyzed
files <- list.files("greenspace_metrics/plots/accum_curves")

for (i in files) {
  
  
  my.file.copy(from = paste0("greenspace_metrics/plots/accum_curves", i), to = paste0("greenspaces/", gsub(".png", "", i), "/", i, ""))
  
  
}






