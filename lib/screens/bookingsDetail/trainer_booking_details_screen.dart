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
import 'package:zing_fitnes_trainer/screens/trainers/user_booking_card.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class TrainerBookingDetailsScreen extends StatefulWidget {
  TrainerBookingDetailsScreen(this.userId,this.bookingModel);
  final String userId;
  final BookingsModel bookingModel;
  @override
  _TrainerBookingDetailsScreenState createState() => _TrainerBookingDetailsScreenState();
}

class _TrainerBookingDetailsScreenState extends State<TrainerBookingDetailsScreen> {

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
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      height:size.height/12 ,


                      child: Row(
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

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MultiProvider(providers: [
                                              StreamProvider<TypingModel>.value(value: ChatsRepository.instance().streamTyping(widget.userId, widget.bookingModel.userId),catchError: (context,error){
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
                                                  senderId: widget.userId,
                                                  receiverId: widget.bookingModel.userId,
                                                  receiverFirstName :value.name

                                              ),)



                                    ));

                              },
                              child: Text("chat",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),),

    );
  }
}
