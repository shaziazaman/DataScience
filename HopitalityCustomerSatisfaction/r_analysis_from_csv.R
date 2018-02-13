library(nnet)
library(ggplot2)
library(reshape2)
rm(list=ls())
data2012=read.csv("<working directory>/data/csv/HotelReview2012.csv",head=TRUE)

# Analyze Travel Type data
with(data2012, table(Overall,TravelType))
data2012$TravelTypeL<-relevel(data2012$TravelType, ref="Other")
testTravelType<-multinom(Overall~TravelTypeL, data=data2012)
summary(testTravelType)
zTravelType<-summary(testTravelType)$coefficients/summary(testTravelType)$standard.errors
zTravelType
pTravelType<-(1-pnorm(abs(zTravelType),1))*2
pTravelType
exp(coef(testTravelType))
head(pp<- fitted(testTravelType))
dTravelType<-data.frame(TravelTypeL=c("Other", "Business", "Leisure"))
predict(testTravelType, newdata=dTravelType,"probs")

# Analyze Ratings for Room, Service, Cleanliness and Location with Overall Ratings data
with(data2012, table(Overall,Rooms))
with(data2012, table(Overall,Service))
with(data2012, table(Overall,Cleanliness))
with(data2012, table(Overall,Location))
testRatings<-multinom(Overall~Rooms+Service+Cleanliness+Location, data=data2012)
summary(testRatings)
exp(coef(testRatings))
head(pp<- fitted(testRatings))

# Analyze Rooms ratings
data2012$RoomsF<-factor(data2012$Rooms)
data2012$RoomsFL<-relevel(data2012$RoomsF,ref="1")
testRoomsRatings<-multinom(Overall~RoomsFL, data=data2012)
summary(testRoomsRatings)
dRooms<-data.frame(RoomsFL=c("1", "2", "3","4","5"))
predict(testRoomsRatings, newdata=dRooms,"probs")

# Analyze Service ratings
data2012$ServiceF<-factor(data2012$Service)
data2012$ServiceFL<-relevel(data2012$ServiceF,ref="1")
testServiceRatings<-multinom(Overall~ServiceFL, data=data2012)
summary(testServiceRatings)
dService<-data.frame(ServiceFL=c("1", "2", "3","4","5"))
predict(testServiceRatings, newdata=dService,"probs")

# Analyze Cleanliness ratings
data2012$CleanlinessF<-factor(data2012$Cleanliness)
data2012$CleanlinessFL<-relevel(data2012$CleanlinessF,ref="1")
testCleanlinessRatings<-multinom(Overall~CleanlinessFL, data=data2012)
summary(testCleanlinessRatings)
dCleanliness<-data.frame(CleanlinessFL=c("1", "2", "3","4","5"))
predict(testCleanlinessRatings, newdata=dCleanliness,"probs")

# Analyze Cleanliness ratings
data2012$LocationF<-factor(data2012$Location)
data2012$LocationFL<-relevel(data2012$LocationF,ref="1")
testLocationRatings<-multinom(Overall~LocationFL, data=data2012)
summary(testLocationRatings)
dLocation<-data.frame(LocationFL=c("1", "2", "3","4","5"))
predict(testLocationRatings, newdata=dLocation,"probs")