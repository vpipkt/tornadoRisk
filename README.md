## U.S. Tornado Hazard Exposure and Population Risk

Here I replicate work I performed in GIS to develop a spatially consistent tornado hazard measure. The ultimate goal of this effort was to create a comparative measure of population exposure to the tornado hazard (risk of tornado exposure). The intent of the measure was to provide spatial resolution at about the county level. This could then be used to compute risk for states and metropolitan statistical areas (MSA).

The original implementation has been lost to time and was anyways trapped in ArcGIS. There were significant challenges with replication of the analysis.  This effort will hopefully provide a way for others to use the risk measures.

### General analysis approach

Consider the history of tornado touchdown points as observations drawn from a static, spatial distribution. Estimate the density surface using kernel smoothing or similar techniques. This surface is the tornado hazard measure. The product of exposure and population density is the population risk measure.

Some general thoughts about this approach. (under construction)

Why touchdown points? Why not tracks?
How to parameterize the smoothing?

### Data source

### Files in this repo


