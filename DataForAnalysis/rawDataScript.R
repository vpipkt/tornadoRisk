#Read in raw data and produce a useful data frame for later analysis

## Fields
#observation within year
#year
#Month
#day
#date text
#time HH:mm:SS
#time zone ? is coded unknown; 9=GMT. Should all be 3=CST
#state post
#state fips
#storm number within state, deprecated
#f scale, -9 is unknown
#injuries (count)
#fatalities (count)
#loss info. prior to 1996, categorized 1<$50, 2=$50-$500, 3=$500-$5,000, 4=$5,000-$50,000, 5=$50,000-$500,000, 6=$500,000-$5,000,000, 7=$5,000,000-$50,000,000, 8=$50,000,000- $500,000,000, 9=$5000,000,000.)
#	after 1996, millions of dollars
#	0 indicates NA not zero
# crop loss in $M
#start lat
#start lon
#end lat
# end lon
#track length miles
#track width in yards (presume maximum ?)
#confusing number of states field
#confusing state number field
#confusing tornado segment field --  for touchdowns, get only records = 1; 2 are dupes with state detail. -9 are dupes with additional counties
#county FIPS 1
#county FIPS 2
#county FIPS 3
#county FIPS 4


#URL working & correct as of October 2014
url<-"http://www.spc.noaa.gov/wcm/data/1950-2013_torn.csv"
url<-"c:/users/jason/source/repos/tornado/tornadoRisk/RawData/1950-2013_torn.csv"
#cheat for developing these functions

torn<- read.csv(url,header=FALSE,
             col.names=c("obsInYear","year","month","day","date","time",
                         "time.zone","state.post","state.fips","state.storm",
                         "f.scale","injury.count","fatality.count","loss",
                         "crop.loss","start.lat","start.lon","end.lat","end.lon",
                         "track.len.mi","track.wid.yd","state.confusing","state.confusing.2","segment",
                         "county.fips.1","county.fips.2","county.fips.3","county.fips.4"),
             colClasses=c(rep("numeric",4),"character","character",
                          rep("factor",3),"numeric",
                          "factor",rep("numeric",10),
                          rep("factor",3),rep("character",4)))
                     
#need to seriously clean for nulls 
# several instances -9 is used for this
#lat lon if 0, must be na
summary(torn)

#date & time to R date format
# do

#fscale
torn$f.scale[torn$f.scale==-9] <- NA
