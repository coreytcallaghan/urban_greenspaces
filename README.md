# Measuring biodiversity metrics in urban greenspaces using existing citizen science data

A repository to begin building a website which allows council managers to fully use biodiversity metrics from a specific urban greenspace. The theory behind the tool is largely developed, and can be read [here](http://www.ace-eco.org/vol12/iss2/art12/) and [here](http://www.publish.csiro.au/wr/Fulltext/WR17141).


### Overall workflow:

![Workflow](https://github.com/coreytcallaghan/urban_greenspaces/blob/master/urban_greenspace_workflow.jpg)

This repository is mainly going to be used to get a proof-of-concept up-and-running. It will eventually be split out into better and more distinct repos for project management.

The main steps include:

1.) Delineate urban greenspaces as test locations

2.) Convert eBird data to sql db

3.) Spatially query the sql db based on the urban greenspace .geojson files

4.) Run analyses on the data for each greenspace and save results/plots

5.) Export results/plots for each greenspace which can be used for website development
