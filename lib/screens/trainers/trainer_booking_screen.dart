import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/request_booking_screen.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_cart_repository.dart';
import 'package:zing_fitnes_trainer/screens/payments/default_credit_card_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/booking_card.dart';
import 'package:zing_fitnes_trainer/screens/trainers/trainer_details_booking_card.dart';
import 'package:zing_fitnes_trainer/screens/trainers/make_payment_screen.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class TrainerBookingsScreen extends StatefulWidget {
  TrainerBookingsScreen(this.userId,this.trainerInfo,this.bookingModel);
  final String userId;
  final TrainerProfileModel trainerInfo;
  final NewBookingModel bookingModel;
  @override
  _TrainerBookingsScreenState createState() => _TrainerBookingsScreenState();
}

class _TrainerBookingsScreenState extends State<TrainerBookingsScreen> {
  Future<Null> alertText(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            //    title:  Text("Chicago Time",textAlign: TextAlign.center,style: TextStyle(fontSize: 22),),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Text(
                      "Your Request Has been sent. All Requests are displayed on the Requested tab in the booking screen."
                          "If the trainer accepts your request, you'll find it in the pending tab. "
                          "If he declines, you will find it in the cancelled tab",
                      style: TextStyle(fontSize: 20.0,),
                    ),
                  ),
                  Divider(),
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok", style: TextStyle(fontSize: 20.0,fontFamily: 'Montserrat',color: Theme.of(context).accentColor),),
                  )

                ],
              ),
            )

        );
      },
    );
  }
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Trainer Booking Details',style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(bottom: 20),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Text('Start time',style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark),),
                       Row(
                         children: <Widget>[
                           Text(widget.bookingModel.startTime,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),),
                           Text(widget.bookingModel.startHr > 12 ? "PM":"AM",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                         ],
                       ),

                     ],
                   ),
                 ),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Text('End time',style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark),),
                     Row(
                       children: <Widget>[
                         Text(widget.bookingModel.endTime,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                         Text(widget.bookingModel.endHr > 12 ? "PM":"AM",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                       ],
                     ),

                   ],
                 )
                    ],
                  ),
                   Image.asset('assets/images/mng.png',fit: BoxFit.cover,width: size.width/2,)
                ],
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: BookingsCard(widget.userId,widget.trainerInfo,widget.bookingModel),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _loading  ? Container(
        width: size.width/4,
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ):

      Container(
        width: size.width/2,
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
        height:size.height/12 ,


        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Theme.of(context).primaryColorDark,
          
          onPressed: (){
           setState(() {
             _loading =true;
           });

            Map bookingMap = Map<String,dynamic>();
            bookingMap[Config.bookingDate] = widget.bookingModel.date;
            bookingMap[Config.bookingDay] = widget.bookingModel.day;
            bookingMap[Config.bookingMonth] = widget.bookingModel.month;
            bookingMap[Config.bookingsYear] = widget.bookingModel.year;
            bookingMap[Config.bookingStartHr] = widget.bookingModel.startHr;
            bookingMap[Config.bookingStartTime] = widget.bookingModel.startTime;
            bookingMap[Config.bookingStartMin] = widget.bookingModel.startMin;
            bookingMap[Config.bookingEndHr] = widget.bookingModel.endHr;
            bookingMap[Config.bookingEndTime] = widget.bookingModel.endTime;
            bookingMap[Config.bookingEndMin] = widget.bookingModel.endMin;
            bookingMap[Config.bookingStartMin] = widget.bookingModel.startMin;
            bookingMap[Config.bookingStatus] = Config.requested;
            bookingMap[Config.trainerUserId] = widget.trainerInfo.userId;
            bookingMap[Config.userId] = widget.userId;
            bookingMap[Config.bookingSessionStarted] = false;
            bookingMap[Config.bookingSessionCompleted] = false;

            bookingMap[Config.paid] = false;

            bookingMap[Config.sessionType] = widget.bookingModel.sessionType;
            bookingMap[Config.createdOn] = FieldValue.serverTimestamp();


            bookingMap[Config.sessionRate] = widget.trainerInfo.sessionRate;
            BookingRepository.instance().saveRequestedBookingDetails(widget.userId,widget.trainerInfo.userId, bookingMap).then((_){
              setState(() {
                _loading = false;
                alertText(context);
              });
            });

        },
        child: Text("Request",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),),
      ),
    );
  }
}
