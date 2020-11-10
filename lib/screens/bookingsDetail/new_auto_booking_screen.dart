import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/book_now_screen.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/trainers_screen.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';


class NewAutoBookingScreen extends StatefulWidget {
  NewAutoBookingScreen(this.userId);
  final String userId;
  @override
  _NewAutoBookingScreenState createState() => _NewAutoBookingScreenState();
}

class _NewAutoBookingScreenState extends State<NewAutoBookingScreen> {

  DateTime selectedDate = DateTime.now();
  int day,month,year;
  int startHr=0,startMin=0;
  int endHr,endMin;
  TimeOfDay endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now());
  TimeOfDay initialTime = TimeOfDay.fromDateTime(DateTime.now());
  String sessionType="Single";
  var selectDateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  var numberOfPeopleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String longitude,latitude;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  getLongitudeAndLatitude() async{
    final prefs =  await StreamingSharedPreferences.instance;
    setState(() {
      longitude = prefs.getString(Config.longitude, defaultValue: Config.longitude).getValue();
      latitude = prefs.getString(Config.latitude, defaultValue: Config.latitude).getValue();

      print("longitude "+longitude);
      print("latitude" +latitude);
    });


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLongitudeAndLatitude();
    selectDateController.text = "Select Date";
    print("user Id"+widget.userId);

    setState(() {
      day = selectedDate.day;
      month = selectedDate.month;
      year = selectedDate.year;
      selectedDate = selectedDate;
      print(selectedDate.day.toString());
      print(selectedDate.month.toString());
      print(selectedDate.year.toString());
      selectDateController.text = '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}';

    });
  }

  Future<Null> selected15MinIncrements(BuildContext context) async{

    final TimeOfDay picked = await  showIntervalTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      interval: 15,

      visibleStep: VisibleStep.Fifteenths,

    );
    if(picked != null && picked != initialTime){
      print(picked.hour);
      print(picked.minute);
      print( picked.period);

      setState(() {

        if(picked.period ==DayPeriod.am)
          {
            if(picked.hourOfPeriod == 0 && picked.minute == 0)
            {
              endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
              startTimeController.text = '12:00AM';
              endTimeController.text = '1:00'+(endHrTimeOfDay.period ==DayPeriod.am ?"AM":"PM");
              startHr = 12;
              startMin =00;
              endHr = 1;
              endMin=00;

            }else if(picked.hourOfPeriod == 0 && picked.minute != 0){
              endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
              startTimeController.text = '12:${picked.minute}'+"AM";
              endTimeController.text = '1:${picked.minute}'+(endHrTimeOfDay.period  ==DayPeriod.am ?"AM":"PM");
              startHr = 12;
              startMin =picked.minute;
              endHr = 1;
              endMin=picked.minute;

            }else if(picked.hourOfPeriod != 0 && picked.minute == 0){
              endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
              startTimeController.text = '${picked.hourOfPeriod}:00' +'AM';
              endTimeController.text = '${(picked.hourOfPeriod+1)}:00' +"AM";
              startHr = picked.hourOfPeriod;
              startMin =00;
              endHr = picked.hourOfPeriod+1;
              endMin=00;

            }else{
              endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
              print("this once ahdhsahd a hsdad");
              startTimeController.text = '${picked.hourOfPeriod}:${picked.minute} AM';
              endTimeController.text = '${(picked.hourOfPeriod+1)}:${picked.minute} '+ "AM";

              startHr = picked.hourOfPeriod;
              startMin =picked.minute;

              endHr = picked.hourOfPeriod+1;
              endMin=picked.minute;
            }

          }else
            {

              if(picked.hourOfPeriod == 12 && picked.minute == 0)
              {
                print("hour"+picked.hourOfPeriod.toString());
                endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
                startTimeController.text = '12:00'+"PM";
                endTimeController.text = '1:00'+(endHrTimeOfDay.period ==DayPeriod.am ?"AM":"PM");
                startHr = 12;
                startMin =00;
                endHr = 1;
                endMin=00;

              }else if(picked.hourOfPeriod == 12 && picked.minute != 0){
                print("hour"+picked.hourOfPeriod.toString());
                endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
                startTimeController.text = '12:${picked.minute}'+"PM";
                endTimeController.text = '1:${picked.minute}'+(endHrTimeOfDay.period  ==DayPeriod.am ?"AM":"PM");
                startHr = 12;
                startMin =picked.minute;
                endHr = 1;
                endMin=picked.minute;

              }else if(picked.hourOfPeriod != 12 && picked.minute == 0){
                print("hour"+picked.hourOfPeriod.toString());
                endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
                startTimeController.text = '${picked.hourOfPeriod}:00'+"PM";
                endTimeController.text = '${(picked.hourOfPeriod+1)}:00'+"PM";
                startHr = picked.hourOfPeriod;
                startMin =00;
                endHr = picked.hourOfPeriod+1;
                endMin=00;

              }else{
                print("hour"+picked.hourOfPeriod.toString());
                endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
                startTimeController.text = '${picked.hourOfPeriod}:${picked.minute}'+"PM";
                endTimeController.text = '${(picked.hourOfPeriod+1)}:${picked.minute}'+"PM";

                startHr = picked.hourOfPeriod;
                startMin =picked.minute;

                endHr = picked.hourOfPeriod+1;
                endMin=picked.minute;
              }


            }


      });
    }


  }

  Future<Null> selectedEndTimeOfDay(BuildContext context) async{

    final TimeOfDay picked = await  showIntervalTimePicker(
      context: context,
      initialTime:startHr==0 ? endHrTimeOfDay : TimeOfDay(hour: startHr+1, minute:startMin),
      interval: 15,
      visibleStep: VisibleStep.Fifteenths,

    );
    if(picked != null && picked != initialTime){

     setState(() {
       print(picked);
       if(picked.period ==DayPeriod.am)
         {

           if(picked.hour == 0 && picked.minute == 0)
           {
             endTimeController.text = '12:00'+(picked.period ==DayPeriod.am ?"AM":"PM");
             endHr = 12;
             endMin =00;
           }else if(picked.hour == 0 && picked.minute != 0){

             endTimeController.text = '12:${picked.minute}'+(picked.period ==DayPeriod.am ?"AM":"PM");
             endHr = 12;
             endMin =picked.minute;

           }else if(picked.hour != 0 && picked.minute == 0){

             endTimeController.text = '${(picked.hourOfPeriod)}:00'+(picked.period ==DayPeriod.am ?"AM":"PM");
             endHr = picked.hourOfPeriod;
             endMin =00;

           }else{

             endTimeController.text = '${(picked.hourOfPeriod)}:${picked.minute}'+(picked.period ==DayPeriod.am ?"AM":"PM");

             endHr = picked.hourOfPeriod;
             endMin =picked.minute;
           }

         }else{
         if(picked.hour == 12 && picked.minute == 0)
         {
           endTimeController.text = '12:00'+(picked.period ==DayPeriod.am ?"AM":"PM");
           endHr = 12;
           endMin =00;
         }else if(picked.hour == 12 && picked.minute != 0){

           endTimeController.text = '12:${picked.minute}'+(picked.period ==DayPeriod.am ?"AM":"PM");
           endHr = 12;
           endMin =picked.minute;

         }else if(picked.hour != 12 && picked.minute == 0){

           endTimeController.text = '${(picked.hourOfPeriod)}:00'+(picked.period ==DayPeriod.am ?"AM":"PM");
           endHr = picked.hourOfPeriod;
           endMin =00;

         }else{

           endTimeController.text = '${(picked.hourOfPeriod)}:${picked.minute}'+(picked.period ==DayPeriod.am ?"AM":"PM");

           endHr = picked.hourOfPeriod;
           endMin =picked.minute;
         }

       }


     });

      /*
      setState(() {
        endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
      });
      */
    }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Booking',style: TextStyle(fontSize: 20),),
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
                    //  onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 2)
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(selectDateController.text ,style: TextStyle(fontSize: 20),),
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

                        onTap: ()  => selected15MinIncrements(context),

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
                      onTap: () => selectedEndTimeOfDay(context),
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
             sessionType =="Groups"? Container(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Flexible(child:  Container(
                       padding: EdgeInsets.symmetric(vertical: 10),
                       child: Text("Number of People",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),),),),
                      Flexible(child: Form(
                        key: _formKey,
                        child: Column(
                          children: [

                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: TextFormField(
                                controller: numberOfPeopleController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },

                              ),
                            )

                          ],
                        ),
                      ))
                    ],
                  )
              ) : Container(),
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
                sessionType :sessionType,
                longitude:longitude,
                latitude:latitude,
                numberOfPeople: numberOfPeopleController.text.isEmpty  ? 0 : int.parse(numberOfPeopleController.text)
              );


              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return StreamProvider.value(
                      value: ProfileProvider.instance()
                          .streamTrainersListSessionType(sessionType),
                      catchError: (context, error) {
                        print(error);
                      },
                      child: BookNowScreen(widget.userId,bookingModel));
                      //child: TrainersScreen(widget.userId,bookingModel));
                  //  child: ProfileRegularUser();
                }),
              );
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
