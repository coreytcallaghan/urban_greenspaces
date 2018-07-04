# A SQL SCript used to make a spatial dataset of eBird_aus_data
# change this to site instead of spatial tables

ALTER TABLE sites DROP COLUMN pt;
ALTER TABLE sites ADD COLUMN pt POINT;
SET SQL_SAFE_UPDATES = 0;
UPDATE sites SET pt=POINT(LONGITUDE, LATITUDE);
ALTER TABLE sites 
CHANGE COLUMN pt pt GEOMETRY NOT NULL;
CREATE SPATIAL INDEX ix_sites_pt ON sites(pt);

CREATE INDEX ix_SAMPLING_EVENT_IDENTIFIER on samples(SAMPLING_EVENT_IDENTIFIER);
CREATE INDEX ix_LOCALITY_ID on checklists (LOCALITY_ID);
# might not be able to create an index on primary key
# CREATE INDEX ix_TAXONOMIC_ORDER on species (TAXONOMIC_ORDER);
