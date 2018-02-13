db.HotelReviews.find().forEach(function (doc) {
 	for(var i in doc.Reviews)
 	{
 	  var dateString = doc.Reviews[i].Date;
 	  DateTimeFormatter dtf = new DateTimeFormatterBuilder().appendMonthOfYearShortText().appendLiteral(" ").appendDayOfMonth(1).appendLiteral(", ").appendYear(4, 4).toFormatter();
 	  DateTime jodaDate = dft.parseDateTime(dateString);
 	  print( dateString );
 	  //doc.Reviews[i].Date = new ISODate({dateToSave); 
 	} 
 	//db.HotelReviews.save(doc);
})