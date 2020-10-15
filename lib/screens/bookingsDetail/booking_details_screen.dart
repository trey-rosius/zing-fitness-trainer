import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_screen.dart';
import 'package:zing_fitnes_trainer/screens/chats/chats_repository.dart';
import 'package:zing_fitnes_trainer/screens/chats/typing_model.dart';
import 'package:zing_fitnes_trainer/screens/notifications/notifications_repository.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_cart_repository.dart';
import 'package:zing_fitnes_trainer/screens/payments/default_credit_card_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/make_payment_screen.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class BookingDetailsScreen extends StatelessWidget {
  BookingDetailsScreen(

      this.bookingsModel,
      this.trainerProfileModel,
      this.userId);
  final BookingsModel bookingsModel;
  final TrainerProfileModel trainerProfileModel;
  final String userId;
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
                      "Your trainer would have to turn on the timer, which would last for the duration of "
                          "your paid session",
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details',style: TextStyle(fontSize: 20),),
        centerTitle: true,

        actions: <Widget>[
          bookingsModel.bookingStatus == Config.paid ?  IconButton(

              color: Theme.of(context).primaryColorDark,
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MultiProvider(providers: [
                              StreamProvider<TypingModel>.value(value: ChatsRepository.instance().streamTyping(userId, trainerProfileModel.userId),catchError: (context,error){
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
                                  senderId: userId,
                                  receiverId: trainerProfileModel.userId,
                                  receiverFirstName :trainerProfileModel.name

                              ),)



                    ));
              },
              icon: Icon(Icons.chat_bubble_outline,color: Colors.white,))
           : Container(),
        ],
      ),

      body: SingleChildScrollView(
        child:Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Column(
            children: <Widget>[
              Center(
                child:
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),

                  child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(
                                Theme.of(context).accentColor),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(10.0),
                        ),
                        imageUrl: trainerProfileModel.profilePicUrl??"",
                        width: 120.0,
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                ),

                ),
              bookingsModel.bookingStatus != Config.paid ?  Padding(
                padding:  EdgeInsets.only(right:10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.check_box_outline_blank,
                      color: MyColors().deepBlue,
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        "UnPaid",
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ) :  Padding(
                padding:  EdgeInsets.only(right:10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.check_box,
                      color: MyColors().deepBlue,
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        "Paid",
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(trainerProfileModel.name,style: TextStyle(fontSize: 20),),
              ),



              Padding(
                padding:  EdgeInsets.only(right:10.0),
                child:ListTile(
                  title:  Text(
                    "Experience",
                    style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),
                  ),
                  trailing: Text(
                    trainerProfileModel.experience,
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ),

      Padding(
          padding:  EdgeInsets.only(right:10.0),
          child:ListTile(
            title:  Text(
              "Date",
              style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),
            ),
            trailing: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width: 2)
              ),
              child: Text(
                bookingsModel.bookingDate,
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
      ),
              Padding(
                  padding:  EdgeInsets.only(right:10.0),
                  child:ListTile(
                    title:  Text(
                      "Session Cost",
                      style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),
                    ),
                    trailing: Container(

                      child: Text(
                       '\$'+ bookingsModel.sessionRate,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
              ),

              Padding(
                  padding:  EdgeInsets.only(right:10.0),
                  child:ListTile(
                    title:  Text(
                      "Session Type",
                      style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),
                    ),
                    trailing: Container(

                      child: Text(
                         bookingsModel.sessionType,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
              ),
              Padding(
                  padding:  EdgeInsets.only(right:10.0),
                  child:ListTile(
                    title:  Text(
                      "Start Time",
                      style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),
                    ),
                    trailing: Container(

                      child: Text(
                        bookingsModel.bookingStartTime,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
              ),
              Padding(
                  padding:  EdgeInsets.only(right:10.0),
                  child:ListTile(
                    title:  Text(
                      "End Time",
                      style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),
                    ),
                    trailing: Container(

                      child: Text(
                        bookingsModel.bookingEndTime,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
              ),

              Row(


                children: <Widget>[

                bookingsModel.bookingStatus == Config.approved ?  Container(
                    height:size.height/10,
                    width: size.width/2.5,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)
                            {
                              return StreamProvider<DefaultCreditCardModel>.value(
                                value:CreditCardRepository.instance().streamDefaultCreditCard(userId) ,
                                catchError: (context,error){
                                  print(error);
                                  return null;
                                },
                                child: MakePaymentScreen(userId, bookingsModel,trainerProfileModel),
                              );
                              // return UserDetailsScreen(userId, trainerInfo, bookingModel);
                            })
                          //  child: ProfileRegularUser();

                        );
                      },
                      child: Text("Pay",style: TextStyle(fontSize: 20,color: Colors.white),),),
                  ) : Container(),






                ],
              ),

              bookingsModel.currentlyInSession ?  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height:size.height/12,
                    width: size.width/1.5,

                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Theme.of(context).primaryColorDark,
                      onPressed: (){




/*
                       Map startBooking = Map<String,dynamic>();
                       startBooking[Config.bookingSessionRequestToStart] =true;


                       BookingRepository.instance().changeBookingStatus(bookingsModel.bookingId, startBooking).then((_){

                         Map notMap = Map<String,dynamic>();
                         notMap[Config.bookingsId] = bookingsModel.bookingId;

                         notMap[Config.bookingStatus] = "paid";
                         notMap[Config.notificationType] = Config.booking;

                         notMap[Config.userId] = bookingsModel.userId;
                         notMap[Config.senderId] = bookingsModel.userId;
                         notMap[Config.receiverId] = bookingsModel.trainerUserId;
                         notMap[Config.trainerUserId] = bookingsModel.trainerUserId;
                         notMap[Config.notificationText] = Config.requestedToStartSession;



                         NotificationsRepository.instance().saveNotification(notMap).then((_){
                           alertText(context);
                         });

                       });
*/
                      },
                      child: Text("Session Running",style: TextStyle(fontSize: 20,color: Colors.white),),),
                  )
                ],
              ) : Container(

              ) ,


              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  bookingsModel.bookingStatus == Config.paid ? Container(
                    height:size.height/14,
                    width: size.width/2.5,
                    padding: EdgeInsets.only(left: 10),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Theme.of(context).primaryColorDark,
                      onPressed: (){
                        Map cancelBooking = Map<String,dynamic>();
                        cancelBooking[Config.bookingStatus] = Config.cancel;
                        cancelBooking[Config.cancelledBy] = Config.cancelledBy;

                        BookingRepository.instance().changeBookingStatus(bookingsModel.bookingId, cancelBooking).then((_){

                          Map notMap = Map<String,dynamic>();
                          notMap[Config.bookingsId] = bookingsModel.bookingId;
                          notMap[Config.bookingStatus] = Config.cancel;
                          notMap[Config.userId] = bookingsModel.userId;
                          notMap[Config.senderId] = bookingsModel.userId;
                          notMap[Config.receiverId] = bookingsModel.trainerUserId;

                          notMap[Config.trainerUserId] = bookingsModel.trainerUserId;
                          notMap[Config.notificationText] = Config.sessionCancelled;



                          NotificationsRepository.instance().saveNotification(notMap).then((_){
                            Navigator.of(context).pop();
                          });
                        });
                      },
                      child: Text("Cancel",style: TextStyle(fontSize: 20,color: Colors.white),),),
                  ) : Container(),
                ],
              )


*/


            ],
          ),
        ),
      ),
    );
  }
}
