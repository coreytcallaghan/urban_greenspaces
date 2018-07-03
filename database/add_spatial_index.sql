# A SQL SCript used to make a spatial dataset of eBird_aus_data
# change this to site instead of spatial tables

ALTER TABLE spatial_table ADD COLUMN pt POINT;
SET SQL_SAFE_UPDATES = 0;
UPDATE spatial_table SET pt=POINT(LONGITUDE, LATITUDE);
ALTER TABLE spatial_table 
CHANGE COLUMN pt pt GEOMETRY NOT NULL;
CREATE SPATIAL INDEX ix_spatial_table_pt ON spatial_table(pt);
