import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/regular_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_screen.dart';
import 'package:zing_fitnes_trainer/screens/chats/chats_repository.dart';
import 'package:zing_fitnes_trainer/screens/chats/typing_model.dart';
import 'package:zing_fitnes_trainer/screens/notifications/notifications_repository.dart';
import 'package:zing_fitnes_trainer/screens/trainers/user_booking_card.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class ApprovedUserDetailsScreen extends StatefulWidget {
  ApprovedUserDetailsScreen(this.userId,this.bookingModel,this.regularProfileModel);
  final String userId;
  final BookingsModel bookingModel;
  final RegularProfileModel regularProfileModel;

  @override
  _ApprovedUserDetailsScreenState createState() => _ApprovedUserDetailsScreenState();
}

class _ApprovedUserDetailsScreenState extends State<ApprovedUserDetailsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle( fontSize: 20.0),
      ),
      backgroundColor: Theme.of(context).accentColor,
    ));

    Navigator.of(context).pop();
  }

  Future<Null> sessionAlert(BuildContext context) async {
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
                      "You can't end this session Now. Please wait for session duration to elapse",
                      style: TextStyle(fontSize: 20.0,),
                    ),
                  ),
                  Divider(),
                  FlatButton(
                    onPressed: (){
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

  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('User Details',style: TextStyle(fontSize: 20),),
        centerTitle: true,
        actions: <Widget>[
          widget.bookingModel.bookingStatus == Config.paid ?  IconButton(

              color: Theme.of(context).primaryColorDark,
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MultiProvider(providers: [
                              StreamProvider<TypingModel>.value(value: ChatsRepository.instance().streamTyping(widget.bookingModel.trainerUserId, widget.bookingModel.userId),catchError: (context,error){
                                print("error is "+error.toString());
                                return null;
                              },),
                              /*
                         StreamProvider<BlockedUserModel>.value(value: BlockedRepository.instance().haveIblockedFlyer(userId, userProfile.userId),catchError: (context,error){
                           print("error is "+error.toString());
                           return null;
                         },),
                         StreamProvider<BlockedMeModel>.value(value: BlockedRepository.instance().hasFlyerblockedMe(userId, userProfile.userId),catchError: (context,error){
                           print("error is "+error.toString());
                           return null;
                         },),
                         */
                            ],
                              child: ChatScreen(
                                  senderId: widget.bookingModel.trainerUserId,
                                  receiverId: widget.bookingModel.userId,
                                  receiverFirstName :widget.regularProfileModel.name

                              ),)



                    ));
              },
              icon: Icon(Icons.chat_bubble_outline,color: Colors.white,))
              : Container(),
        ],
      ),
      body:StreamProvider.value(value:ProfileProvider.instance().streamRegularUserProfile(widget.userId),
      catchError: (context,error){
        print(error.toString());
      },
      child: Consumer<RegularProfileModel>(
        builder: (_,value,child){
          return value==null ? Container() :  SingleChildScrollView(
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
                                Text('Height',style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark),),
                                Row(
                                  children: <Widget>[
                                    Text(value.height,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),),
                                    Text("CM",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Weight',style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark),),
                              Row(
                                children: <Widget>[
                                  Text(value.weight,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                                  Text("KG",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
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
                    child: UserBookingsCard(widget.userId,value,widget.bookingModel),
                  )
                ],
              ),
            ),
          );
        },
      ),),
      bottomNavigationBar:
      widget.bookingModel.currentlyInSession ?
      Container(
          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          height:size.height/12 ,
          width: size.width/1.4,

          child:

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(

                child:IconButton(icon: Icon(Icons.timelapse,size: 40,), onPressed: (){

                })
              ),
              Container(
                height: size.height/12,
                width: size.width/1.5,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).primaryColorDark,

                  onPressed: (){


                    TimeOfDay nowTime = TimeOfDay.fromDateTime(DateTime.now());

                    double _doubleYourTime = widget.bookingModel.bookingEndHr.toDouble() +
                        (widget.bookingModel.bookingEndMin.toDouble() / 60);
                    double _doubleNowTime = nowTime.hour.toDouble() +
                        (nowTime.minute.toDouble() / 60);
                    if(_doubleNowTime  > _doubleYourTime){
                      print("start time"+widget.bookingModel.bookingStartTime);
                      print("Time passed");



                    }else if(_doubleNowTime  < _doubleYourTime){
                      print("start time"+widget.bookingModel.bookingStartTime);

                      print("time hasn't reached");

                      sessionAlert(context);


                    }else{
                      print("activate");
                      print("start time"+widget.bookingModel.bookingStartTime);


                    }

/*
                    Map bookingMap = Map<String,dynamic>();

                    bookingMap[Config.bookingSessionCompleted] = true;
                    bookingMap[Config.bookingStatus] = Config.completed;

                    bookingMap[Config.updatedOn] = FieldValue.serverTimestamp();
                    bookingMap[Config.currentlyInSession] = false;

                    BookingRepository.instance().changeBookingStatus(widget.bookingModel.bookingId, bookingMap).then((_){
                      showInSnackBar("Booking Approved");

                      Map notMap = Map<String,dynamic>();
                      notMap  [Config.bookingsId] = widget.bookingModel.bookingId;

                      //  notMap[Config.bookingSessionStarted] = true;
                      notMap[Config.bookingStatus] = Config.completed;
                      notMap[Config.notificationType] = Config.booking;
                      notMap[Config.currentlyInSession] = false;

                      notMap[Config.userId] = widget.bookingModel.userId;
                      notMap[Config.senderId] = widget.bookingModel.userId;
                      notMap[Config.receiverId] = widget.bookingModel.trainerUserId;
                      notMap[Config.trainerUserId] = widget.bookingModel.trainerUserId;
                      notMap[Config.notificationText] = Config.sessionStarted;

                      //update trainer current session status
                      ProfileProvider.instance().updateTrainerSession(widget.userId, false);

                      NotificationsRepository.instance().saveNotification(notMap).then((_){
                        setState(() {

                        });
                      });

                    });
*/
                  },
                  child: Text("Complete",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),),
              ),


            ],
          )
      ) :

      Container(
       margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        height:size.height/12 ,


        child:

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: size.height/12,
              width: size.width/2.5,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).primaryColorDark,

                onPressed: (){
              DateTime bookingDateTime = DateTime(widget.bookingModel.bookingYear,widget.bookingModel.bookingMonth,widget.bookingModel.bookingDay);
                  DateTime selectedDate = DateTime.now();

    if(selectedDate.compareTo(bookingDateTime) ==0 ){
      print("dates are equal. D-day");
    } else if(selectedDate.compareTo(bookingDateTime) >=1 ){

      print("selected date is after booking date");
      print("Can't start this session anymore.Booking date has past.");

    } else{
      print("Booking date hasn't reached");
      print("selected date is before book date");
      TimeOfDay nowTime = TimeOfDay.fromDateTime(DateTime.now());

      double _doubleYourTime = widget.bookingModel.bookingStartHr.toDouble() +
          (widget.bookingModel.bookingStartMin.toDouble() / 60);
      double _doubleNowTime = nowTime.hour.toDouble() +
          (nowTime.minute.toDouble() / 60);
      if(_doubleNowTime  > _doubleYourTime){
        print("start time"+widget.bookingModel.bookingStartTime);
        print("Time passed");

        Map bookingMap = Map<String,dynamic>();

        bookingMap[Config.bookingSessionStarted] = true;
        bookingMap[Config.updatedOn] = FieldValue.serverTimestamp();
        bookingMap[Config.currentlyInSession] = true;

        BookingRepository.instance().changeBookingStatus(widget.bookingModel.bookingId, bookingMap).then((_){
          showInSnackBar("Booking Approved");

          Map notMap = Map<String,dynamic>();
          notMap  [Config.bookingsId] = widget.bookingModel.bookingId;

          //  notMap[Config.bookingSessionStarted] = true;
          notMap[Config.bookingStatus] = Config.start;
          notMap[Config.notificationType] = Config.booking;
          notMap[Config.currentlyInSession] = true;

          notMap[Config.userId] = widget.bookingModel.userId;
          notMap[Config.senderId] = widget.bookingModel.userId;
          notMap[Config.receiverId] = widget.bookingModel.trainerUserId;
          notMap[Config.trainerUserId] = widget.bookingModel.trainerUserId;
          notMap[Config.notificationText] = Config.sessionStarted;

          //update trainer current session status
          ProfileProvider.instance().updateTrainerSession(widget.userId, true);

          NotificationsRepository.instance().saveNotification(notMap).then((_){
            setState(() {

            });
          });

        });

      }else if(_doubleNowTime  < _doubleYourTime){
        print("start time"+widget.bookingModel.bookingStartTime);

        print("time hasn't reached");









      }else{
        print("activate");
        print("start time"+widget.bookingModel.bookingStartTime);


      }


    }




              },
              child: Text("Start",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),),
            ),

          ],
        )
      )

    );
  }
}
