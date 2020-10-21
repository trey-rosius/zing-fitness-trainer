class NewBookingModel{
  String date;
  String sessionType;
  String startTime;
  String endTime;
  int day,month,year;
  int startHr,startMin;
  int endHr,endMin;
  int numberOfPeople;
  String longitude;
  String latitude;

  NewBookingModel({this.date,this.sessionType,this.longitude,this.latitude, this.startTime, this.endTime, this.day, this.month,
      this.year, this.startHr, this.startMin, this.endHr, this.endMin,this.numberOfPeople});


}