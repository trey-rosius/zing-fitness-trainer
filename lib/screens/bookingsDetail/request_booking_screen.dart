import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/trainers_screen.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';



class RequestBookingScreen extends StatefulWidget {
  RequestBookingScreen(this.userId,this.trainerProfileModel);
  final String userId;
  final TrainerProfileModel trainerProfileModel;
  @override
  _RequestBookingScreenState createState() => _RequestBookingScreenState();
}
const String MIN_DATETIME = '2010-05-12 00:00:00';
const String MAX_DATETIME = '2030-11-25 23:59:10';
const String INIT_DATETIME = '2019-05-17 18:13:15';
class _RequestBookingScreenState extends State<RequestBookingScreen> {
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  bool _showTitle = true;
  String _format = 'dd-MMMM-yyyy';
  String _timeFormat = 'HH:m';
  String departureDay = "departureDay";
  String departureMonth = "departureMonth";
  String departureYear = "departureYear";
  String arrivalDateTime = "";
  String departureDateTime ="";
  bool loading = false;

  String departureHour = "departureHour";
  String departureMinute = "departureMinute";

  String arrivalHour = "arrivalHour";
  String arrivalMinute = "arrivalMinute";
  String sessionType = "Single";


  String arrivalDay = "arrivalDay";
  String arrivalMonth = "arrivalMonth";
  String arrivalYear = "arrivalYear";
  DateTime _dateTime;
  int day,month,year;
  int startHr,startMin;
  int endHr,endMin;
  var selectDateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("user Id"+widget.userId);
    print("trainer user Id"+widget.trainerProfileModel.userId);
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle( fontSize: 20.0),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Theme.of(context).accentColor,
    ));
  }
  void _showArrivalDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: _showTitle,
        confirm: Text('DONE', style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
        cancel: Text('CANCEL', style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w600)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;

          arrivalDay = dateTime.day.toString();
          arrivalMonth = _dateTime.month.toString();
          arrivalYear  = _dateTime.year.toString();
          day = dateTime.day;
          month = dateTime.month;
          year = dateTime.year;
          selectDateController.text = arrivalDay+"/"+arrivalMonth+"/"+arrivalYear;
          print(_dateTime.toString());
          print(_dateTime.day.toString() +" / "+_dateTime.month.toString() +" / "+ _dateTime.year.toString());
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;

          arrivalDay = _dateTime.day.toString();
          arrivalMonth = _dateTime.month.toString();
          arrivalYear  = _dateTime.year.toString();

          day = dateTime.day;
          month = dateTime.month;
          year = dateTime.year;
          selectDateController.text = arrivalDay+"/"+arrivalMonth+"/"+arrivalYear;
          _dateTime = dateTime;
          print(_dateTime.day.toString() +" / "+_dateTime.month.toString() +" / "+ _dateTime.year.toString());
        });
      },
    );
  }


  /// Display time picker.
  void _showEndTimePicker() {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: DateTime.parse(INIT_DATETIME),
      dateFormat: _timeFormat,
      pickerMode: DateTimePickerMode.time, // show TimePicker
      pickerTheme: DateTimePickerTheme(
        /*
        title: Container(
          decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
          width: double.infinity,
          height: 56.0,
          alignment: Alignment.center,
          child: Text(
            'Pick Departure Time',
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0,fontFamily: 'GothamRnd'),
          ),
        ),
        titleHeight: 56.0,
        */
        // showTitle: _showTitle,
        confirm: Text('DONE', style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
        cancel: Text('CANCEL', style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w600)),
      ),
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;


          departureDateTime = dateTime.toString();
          departureHour = dateTime.hour.toString();
          departureMinute = dateTime.minute.toString();
          endHr = dateTime.hour;
          endMin = dateTime.minute;

          endTimeController.text = departureHour+":"+departureMinute;

        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;

          departureDateTime = dateTime.toString();
          departureHour = dateTime.hour.toString();
          departureMinute = dateTime.minute.toString();
          endHr = dateTime.hour;
          endMin = dateTime.minute;
          endTimeController.text = departureHour+":"+departureMinute;
        });
      },
    );
  }

  void _showStartTimePicker() {
    DatePicker.showDatePicker(
      context,

      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: DateTime.parse(INIT_DATETIME),
      dateFormat: _timeFormat,
      pickerMode: DateTimePickerMode.time, //
      pickerTheme: DateTimePickerTheme(
        /*
        title: Container(
          decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
          width: double.infinity,
          height: 56.0,
          alignment: Alignment.center,
          child: Text(
            'Pick Arrival Time',
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0,fontFamily: 'GothamRnd'),
          ),
        ),
        titleHeight: 56.0,
        showTitle: _showTitle,
        */
        confirm: Text('DONE', style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
        cancel: Text('CANCEL', style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w600)),
      ),// show TimePicker

      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;

          arrivalDateTime = dateTime.toString();
          print(_dateTime.toString());
          arrivalHour = dateTime.hour.toString();
          arrivalMinute = dateTime.minute.toString();
          startHr = dateTime.hour;
          startMin = dateTime.minute;
          startTimeController.text = arrivalHour+":"+arrivalMinute;

        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          print(_dateTime.toString());

          arrivalDateTime = dateTime.toString();
          arrivalHour = dateTime.hour.toString();
          arrivalMinute = dateTime.minute.toString();
          startHr = dateTime.hour;
          startMin = dateTime.minute;
          startTimeController.text = arrivalHour+":"+arrivalMinute;
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Request Booking',style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Select Date",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),),),

                    InkWell(
                      onTap: (){
                        _showArrivalDatePicker();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 2)
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(selectDateController.text==""?"Select Date" :selectDateController.text ,style: TextStyle(fontSize: 20),),
                            Icon(Icons.calendar_today)
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Start Time",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),),),

                    InkWell(
                      onTap: _showStartTimePicker,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 2)
                        ),
                        child: Text(startTimeController.text==""?"Select Start Time" :startTimeController.text ,style: TextStyle(fontSize: 20),),

                      ),
                    )


                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("End Time",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),),),

                    InkWell(
                      onTap: _showEndTimePicker,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 2)
                        ),
                        child: Text(endTimeController.text==""?"Select End Time" :endTimeController.text ,style: TextStyle(fontSize: 20),),

                      ),
                    )


                  ],
                ),
              ),



              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Session Type",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),),),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButton<String>(
                        hint: Text(sessionType,style: TextStyle(fontSize: 17,color: Theme.of(context).primaryColor),),


                        items: <String>['Single','Groups','Classes'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child:  Text(value,style: TextStyle(color: Theme.of(context).primaryColor),),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            sessionType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child:   Container(
                  height: 70,
                  width: 200,
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    onPressed: (){
                      if(selectDateController.text== "" || startTimeController.text == "" || endTimeController.text ==""){
                        showInSnackBar("Please Select Date, start and end time");
                      }else
                      {
                        setState(() {
                          loading = true;
                        });
                        NewBookingModel bookingModel = NewBookingModel(
                            date: selectDateController.text,
                            startTime: startTimeController.text,
                            endTime: endTimeController.text,
                            day: day,
                            month: month,
                            year: year,
                            startHr: startHr,
                            startMin: startMin,
                            endHr: endHr,
                            endMin: endMin,
                            sessionType :sessionType
                        );

                        Map bookingMap = Map<String,dynamic>();
                        bookingMap[Config.bookingDate] = bookingModel.date;
                        bookingMap[Config.bookingDay] = bookingModel.day;
                        bookingMap[Config.bookingMonth] = bookingModel.month;
                        bookingMap[Config.bookingsYear] = bookingModel.year;
                        bookingMap[Config.bookingStartHr] = bookingModel.startHr;
                        bookingMap[Config.bookingStartTime] = bookingModel.startTime;
                        bookingMap[Config.bookingStartMin] = bookingModel.startMin;
                        bookingMap[Config.bookingEndHr] = bookingModel.endHr;
                        bookingMap[Config.bookingEndTime] = bookingModel.endTime;
                        bookingMap[Config.bookingEndMin] = bookingModel.endMin;
                        bookingMap[Config.bookingStartMin] = bookingModel.startMin;
                        bookingMap[Config.bookingStatus] = Config.requested;
                        bookingMap[Config.trainerUserId] = widget.trainerProfileModel.userId;
                        bookingMap[Config.userId] = widget.userId;
                        bookingMap[Config.sessionType] = bookingModel.sessionType;
                        bookingMap[Config.createdOn] = FieldValue.serverTimestamp();


                        bookingMap[Config.sessionRate] = widget.trainerProfileModel.sessionRate;
                       BookingRepository.instance().saveRequestedBookingDetails(widget.userId,widget.trainerProfileModel.userId, bookingMap).then((_){
                         setState(() {
                           loading = false;
                           Navigator.of(context).pop();
                         });
                       });
                      }

                    },
                    child: Text("Submit",style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }
}
