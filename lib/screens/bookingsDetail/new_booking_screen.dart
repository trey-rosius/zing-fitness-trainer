import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/trainers_screen.dart';
import 'package:interval_time_picker/interval_time_picker.dart';


class NewBookingScreen extends StatefulWidget {
  NewBookingScreen(this.userId);
  final String userId;
  @override
  _NewBookingScreenState createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectDateController.text = "Select Date";
    print("user Id"+widget.userId);
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

      setState(() {
        if(picked.hour == 0 && picked.minute == 0)
          {
            endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
            startTimeController.text = '12:00';
            endTimeController.text = '1:00';
            startHr = 12;
            startMin =00;
            endHr = 1;
            endMin=00;

          }else if(picked.hourOfPeriod == 0 && picked.minute != 0){
          endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
          startTimeController.text = '12:${picked.minute}';
          endTimeController.text = '1:${picked.minute}';
          startHr = 12;
          startMin =picked.minute;
          endHr = 1;
          endMin=picked.minute;

        }else if(picked.hourOfPeriod != 0 && picked.minute == 0){
          endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
          startTimeController.text = '${picked.hourOfPeriod}:00';
          endTimeController.text = '${(picked.hourOfPeriod+1)}:00';
          startHr = picked.hourOfPeriod;
          startMin =00;
          endHr = picked.hourOfPeriod+1;
          endMin=00;

        }else{
          endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 2)));
          startTimeController.text = '${picked.hourOfPeriod}:${picked.minute}';
          endTimeController.text = '${(picked.hourOfPeriod+1)}:${picked.minute}';

          startHr = picked.hourOfPeriod;
          startMin =picked.minute;

          endHr = picked.hourOfPeriod+1;
          endMin=picked.minute;
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
       if(picked.hour == 0 && picked.minute == 0)
       {
         endTimeController.text = '1:00';
         endHr = 1;
         endMin =00;
       }else if(picked.hour == 0 && picked.minute != 0){

         endTimeController.text = '1:${picked.minute}';
         endHr = 1;
         endMin =picked.minute;

       }else if(picked.hour != 0 && picked.minute == 0){

         endTimeController.text = '${(picked.hourOfPeriod)}:00';
         endHr = picked.hourOfPeriod;
         endMin =00;

       }else{

         endTimeController.text = '${(picked.hourOfPeriod)}:${picked.minute}';

         endHr = picked.hourOfPeriod;
         endMin =picked.minute;
       }


     });

      /*
      setState(() {
        endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
      });
      */
    }


  }
/*
  Future<TimeOfDay> selectedTime12Hour(BuildContext context) async {
    final TimeOfDay picked =  await showTimePicker(

      context: context,

      initialTime: TimeOfDay.now(),

      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if(picked != null && picked != initialTime){

      setState(() {
        print(picked.hourOfPeriod);
        endTimeController.text = '${picked.hourOfPeriod}-${picked.minute}';
      });

      /*
      setState(() {
        endHrTimeOfDay = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
      });
      */
    }
  }
*/
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        day = picked.day;
        month = picked.month;
        year = picked.year;
        selectedDate = picked;
        print(picked.day.toString());
        print(picked.month.toString());
        print(picked.year.toString());
        selectDateController.text = '${picked.day} / ${picked.month} / ${picked.year}';

      });
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
                      onTap: () => _selectDate(context),
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
                      child: TrainersScreen(widget.userId,bookingModel));
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
