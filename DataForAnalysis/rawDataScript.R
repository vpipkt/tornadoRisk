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
#confusing number of states field
#confusing state number field
#confusing tornado segment field --  for touchdowns, get only records = 1; 2 are dupes with state detail. -9 are dupes with additional counties
#county FIPS 1
#county FIPS 2
#county FIPS 3
#county FIPS 4



