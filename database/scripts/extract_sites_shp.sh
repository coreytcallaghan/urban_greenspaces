set -e
source .Renviron
docker exec -it $GDAL_IMAGE ogr2ogr -f "ESRI Shapefile" ebird_sites.shp \
  MYSQL:"host=$host user=$userid dbname=$dbname password=$pwd" \
  "select LOCALITY_ID, COUNTRY_CODE, pt from sites"
