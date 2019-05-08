# Measuring biodiversity metrics in urban greenspaces using existing citizen science data

#### [Demo site](https://coreytcallaghan.github.io/urban_greenspaces/)

A repository to begin building a website which allows council managers to fully use biodiversity metrics from a specific urban greenspace. The theory behind the tool is largely developed, and can be read [here](http://www.ace-eco.org/vol12/iss2/art12/) and [here](http://www.publish.csiro.au/wr/Fulltext/WR17141).

### Adding Greenspaces
To add a greenspace use a tool like [geojson.io](http://geojson.io/) to extract a `.geojson` file of your greenspace.

We use the naming convention `<three letter country code>-<state or province>-<name_of_park>.geojson`, for example Hyde Park in New South Wales Australia has the file name `aus-nsw-hyde_park.geojson`. All spaces must be replaced by underscores: `_` and the filename must be in all lowercase. 

There then two options to contribute the delineated greenspace to us. The easiest way is to email the file to callaghan.corey.t@gmail.com and the more technical way is to make a `github.com` account and fork the greenspace repository, add your `.geojson` file to the folder `/geojson_greenspace_files`, commit your changes and then submit a pull request. You can submit mulitple greenspaces at a time.

:leaves: :bird:

### Overall workflow:

![Workflow](https://github.com/coreytcallaghan/urban_greenspaces/blob/master/urban_greenspace_workflow.jpg)

This repository is mainly going to be used to get a proof-of-concept up-and-running. It will eventually be split out into better and more distinct repos for project management.

The main steps include:

1.) Delineate urban greenspaces as test locations

2.) Convert eBird data to sql db

3.) Spatially query the sql db based on the urban greenspace .geojson files

4.) Run analyses on the data for each greenspace and save results/plots

5.) Export results/plots for each greenspace which can be used for website development
