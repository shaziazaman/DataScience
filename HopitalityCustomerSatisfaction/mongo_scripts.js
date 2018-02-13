/* Give distinct ratings value */
db.reviews.distinct('Reviews.Ratings');

// Give distinct keys used in ratings - this is not working
db.runCommand(
{
  "mapReduce": "Reviews.Ratings",
  "map": function() {
    for (var in this) {
      emit(key,null);
	},
	"reduce": function(key, stuff)
	{
	  return null;
	},
	"out": "ratings_key"
  }
}
)

//script to update date string to date type
db.reviews.find({},{Reviews:1}).forEach(function(doc)
{
  doc.Date = new Date(doc.Date);
  db.reviews.update({_id:doc._id},{$set: {"doc.Reviews.$.Date": new ISO(doc.Reviews.$.Date)}});
}
);

db.reviews.find().forEach(function(doc){db.reviews.update({_id:doc._id},{Reviews:{$each:{$set:{Date:new ISO(Date)}}}})});
db.reviews.update({$set:{"Reviews.$$.Date":ISODate("Reviews.$$.Date")});
  
  db.shutdownServer();
