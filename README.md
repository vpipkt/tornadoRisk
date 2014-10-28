## U.S. Tornado Hazard Exposure and Population Risk

Here I replicate work I performed in GIS to develop a spatially consistent tornado hazard measure. The ultimate goal of this effort was to create a comparative measure of population exposure to the tornado hazard (risk of tornado exposure). The intent of the measure was to provide spatial resolution at about the county level. This could then be used to compute risk for states and metropolitan statistical areas (MSA).

The original implementation has been lost to time and was anyways trapped in ArcGIS. There were significant challenges with reproducibility of the analysis within ArcGIS.  This effort will hopefully provide some appreciation of the tornado hazard and provide the risk measures to a broad audience.

### General analysis approach

Consider the history of tornado touchdown points as observations drawn from a stationary (not changing over time) spatial distribution. Estimate the density surface using kernel smoothing or similar techniques. This surface is the tornado hazard measure. The product of exposure and population density is the population risk measure.

In a broad sense, the work here updates and extends the work of [Concannon](http://www.nssl.noaa.gov/users/brooks/public_html/concannon/).  

Some general thoughts about this approach. (under construction)

Why touchdown points? Why not tracks?
How to parameterize the smoothing?
Should one weight stronger tornadoes?
Why assume a stationary process? 


### Data source
[US NOAA Storm Prediction Center](http://www.spc.noaa.gov/wcm/) provides severe weather database files datting from 1950. As of this writing, the tornado files are available through the end of calendar 2013.

### Files in this repo


