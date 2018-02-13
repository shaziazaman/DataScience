db.HotelReviews.aggregate([
//{$match:{"HotelInfo.country-name":{$exists:1}}}
{$match:{"HotelInfo.region":{$exists:1}}}
,{$project:{_id:0, Reviews:"$Reviews", Region: "$HotelInfo.region", HotelId: "$HotelInfo.HotelID"}}
, {$unwind:"$Reviews"}
, {$project: {_id:0, Region:1, HotelId: 1, ReviewDate: "$Reviews.Date", TravelType:"$Reviews.TravelType"
  , Overall:"$Reviews.Ratings.Overall", Service:"$Reviews.Ratings.Service", Cleanliness: "$Reviews.Ratings.Cleanliness"
  , Value: "$Reviews.Ratings.Value", SleepQuality: "$Reviews.Ratings.SleepQuality", Rooms: "$Reviews.Ratings.Rooms"
  , Location: "$Reviews.Ratings.Location", BizSvc: "$Reviews.Ratings.Business service", FrontDesk: "$Reviews.Ratings.CheckI in / front desk"}}
//, {$match: {Region:'WA'}}
, {$match: {ReviewDate:{$gte: new Date("2010-01-01T00:00:00.000Z"), $lte: new Date("2010-12-31T00:00:00.000Z")}}}
, {$out: "HotelReviews2010"}
])

db.HotelReviews.aggregate([
{$match:{}}
,{$project:{_id:0, HotelInfo:"$HotelInfo"}}
,{$match: {"HotelInfo.country-name":"The Netherlands"}}
])

db.HotelReviews.aggregate([
{$match:{"HotelInfo.region":{$exists:1}}}
,{$project:{_id:0, Reviews:"$Reviews", Region: "$HotelInfo.region", HotelId: "$HotelInfo.HotelID"}}
, {$unwind:"$Reviews"}
, {$project: {_id:0, Region:1, HotelId: 1, ReviewDate: "$Reviews.Date", TravelType:"$Reviews.TravelType", Content: "$Reviews.Content"}}
, {$match: {TravelType:'Other', Region: 'WA', ReviewDate:{$gte: new Date("2012-01-01T00:00:00.000Z"), $lt: new Date("2012-01-31T00:00:00.000Z")}}}
//, {$match: {ReviewDate:{$gte: new Date("2012-01-01T00:00:00.000Z"), $lt: new Date("2012-01-31T00:00:00.000Z")}}}
])

db.HotelReviews.aggregate([
{$match:{}}
,{$project:{_id:0, Reviews:"$Reviews"}}
, {$unwind:"$Reviews"}
, {$project: {_id:0, TravelType:"$Reviews.TravelType", Content: "$Reviews.Content"}}
, {$out: "OtherContent"}
])