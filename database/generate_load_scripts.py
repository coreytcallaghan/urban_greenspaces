#!/usr/bin/python3

import argparse
import os.path
import MySQLdb
import re
import sys
from datetime import datetime
from pprint import pprint as pp
parser = argparse.ArgumentParser()
parser.add_argument('-p', '--path', help='the path to the text file on the local db instance',
  default='/home/bird_100k_test.txt', type=str)
parser.add_argument('-s', '--schema_path', help='the path to the schema file, local',
  default='schema.txt', type=str)
parser.add_argument('-', '--dir', help='the path to write the sql files',
  default='init/', type=str)
args = parser.parse_args()
def main():
  path = args.path
  schema_path = args.schema_path

  schema_file = open(schema_path)
  schema_file  = [ line.strip() for line in schema_file.readlines()
    if not re.match('^\*|^#|^$', line) ]
  schemas = {}
  for line in schema_file:
    table, index, name = line.split(' ')[:3]
    if not table in schemas:
      schemas[table] = [name]
    else: 
      schemas[table].append(name)
  files = [os.path.join(args.dir, 'init_mariadb.sql')]
  for schema_name in schemas.keys():
    write_path = os.path.join(args.dir, 'init_%s.sql' % schema_name)
    print(write_path)
    files.append(write_path)
    cols = ''
    for col in schemas[schema_name]:
      cols += '     %s = @%s,\n' % (col,col)
    cols = cols[:-2]
    out = get_sql(path, cols,schema_name)
    f = open(write_path, 'w+')
    f.write(out)
    f.close()

  files.append(os.path.join(args.dir, 'add_spatial_index.sql'))
  f = open(os.path.join(args.dir, 'init.sql' ), 'w+')

  f.write('\n'.join(['source %s' %f for f in files]))
  f.close()
def get_sql(path, cols, table):
    return """LOAD DATA CONCURRENT INFILE '%s' 
  IGNORE INTO TABLE %s 
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
    @FIRST_NAME,
    @LAST_NAME,
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
%s
;
""" % (path, table,cols)

if __name__ == '__main__':
  main()
