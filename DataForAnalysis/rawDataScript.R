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
url<-"c:/users/jason/source/repos/tornado/tornadorisk/RawData/1950-2013_torn.csv"
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

#loss needs significant work as it was re-coded by the data custodian

loss.point<- data.frame(loss=1:9,lb=c(0,50,500,5000,50000,500000, 5000000, 50000000,500000000),
                        ub=c(50,500,5000,50000,500000, 5000000, 50000000,500000000,NA))
#compute geometric mean of bucket
loss.point$loss.point = sqrt(loss.point$lb * loss.point$ub)
#last one is unbounded, so make point estimate its lower bound
loss.point$loss.point[9]=500000000

#merge loss.point with torn to set pre '96 point estimates
torn<-merge(torn,loss.point,all.x=TRUE,by="loss")
plot(loss.point~jitter(loss),torn,xlim=c(0,12),log="y")
summary(torn$loss.point)
sub <- !is.na(torn$loss) & torn$year>=1996
torn[sub,"loss.point"] <- 1000000*torn[sub,"loss"]

#compute factor
torn$loss.cat <- cut(torn$loss.point,breaks=c(0,50,500,5000,50000,500000, 5000000, 50000000,500000000))
plot(loss ~ loss.cat, subset(torn,year<1996))

par(mfrow=c(1,2))
plot(loss.point~jitter(loss),subset(torn,year<1996),xlim=c(0,12),log="y")
plot(loss.point/1000000~loss,subset(torn,year>=1996))
abline(0,1)

#check that NA's have been transposed okay.
nrow(torn) - sum(is.na(torn$loss) == is.na(torn$loss.point))

#drop now extraneous variables 
torn$lb<-NULL
torn$ub<-NULL


### lats and lons ... safe to assume since data coverage is explicitly 
## united states that 0,0 is interpreted as NA, NA

sum(torn$start.lat==0)
summary(torn$start.lon[torn$start.lat==0])
torn$star

torn$start.lat[torn$start.lat==0] <- NA
torn$start.lon[torn$start.lon==0] <- NA
summary(torn)

# missing end coordinate is much more common
sum(torn$end.lat==0)
summary(torn$end.lon[torn$end.lat==0])

torn$end.lat[torn$end.lat==0] <- NA
torn$end.lon[torn$end.lon==0] <- NA
summary(torn)


par(mfrow=c(1,1))

plot(start.lat~start.lon,torn,col=f.scale)

#no AK or HI events by start location
subset(torn,state.post=="AK" |  state.post=="HI")

sum(is.na(torn$start.lat))  #118

summary(torn$track.len.mi)
summary(torn$track.wid.yd)
#zeros here likely mean missing data
torn$track.len.mi[torn$track.len.mi==0] <- NA
torn$track.wid.yd[torn$track.wid.yd==0]<- NA

#identifier to be able to go back to the original
torn$storm.id<- paste(torn$year, torn$obsInYear, sep="-")

tornado <- torn[torn$segment==1,c("storm.id","state.post","date2","f.scale",
              "injury.count","fatality.count","loss.cat","start.lat","start.lon",
              "end.lat","end.lon","track.len.mi","track.wid.yd")]

nrow(tornado)
summary(torn$segment)

names(tornado)[3] <- "date"
