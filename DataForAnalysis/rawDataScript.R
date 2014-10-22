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
url<-"c:/users/jbrown/source/repos/tornado/RawData/1950-2013_torn.csv"
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
torn$date2 <- as.Date(torn$date, "%Y-%m-%d")
s<-sample(1:nrow(torn),100)
cbind(torn$date[s],format(torn$date2[s]))
rm(s)

#states look fine.
summary(torn$state.post)

#fscale
torn$f.scale[torn$f.scale==-9] <- NA

#loss needs significant work as it was re-coded multiple times
summary(torn$loss)
torn$loss[torn$loss == 0] <- NA
#easy way to do this is to code all as a factor,including newer ones with $M estimates
torn$loss.cat <- ordered(NA,levels=1:9,
                         labels= c("<50","50-500","500-5,000","5k-50k","50k-500k","500k-5M",
                                   "5M-50M","50M-500M",">500M"))
              
sub<- torn$year<1996 & !is.na(torn$loss)
torn$loss.cat[sub] <-torn$loss[sub]

#may be easier to do this by assigning midpoints as a point est for pre-'96, then set loss.cat with "cut"

loss.point<- data.frame(loss=1:9,lb=c(0,50,500,5000,50000,500000, 5000000, 50000000,500000000),
                        ub=c(50,500,5000,50000,500000, 5000000, 50000000,500000000,NA))
#compute geometric mean of bucket
loss.point$point.est = sqrt(loss.point$lb * loss.point$ub)
loss.point$point.est[9]=500000000

#merge loss.point with torn to set pre '96 point estimates
