import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_details_screen.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/pending_booking_details_screen.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class CreditCardTransactionItem extends StatelessWidget {
  CreditCardTransactionItem(

      this.bookingsModel,
      this.userId);

  final BookingsModel bookingsModel;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return

    StreamProvider.value(
      value: ProfileProvider.instance().streamTrainerUserProfile(bookingsModel.trainerUserId),
      catchError: (context,error){
        print(error);

      },
      child: Consumer<TrainerProfileModel>(
        builder: (key,value,child){
          return value== null ? Container():

          InkWell(
            onTap: (){
              print("pressed");

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingDetailsScreen(

                          bookingsModel,
                          value,
                          userId)






                  ));

            },
            child: Container(
              padding: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius:
                          BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                            imageUrl: value.profilePicUrl??"",
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, ex) =>
                                Icon(Icons.error),
                          )),

                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  value.name,
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: value.experience + "+ ",
                                    style: TextStyle(color: MyColors().deepBlue, fontSize: 15),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "yrs experience",
                                          style: TextStyle(color: Colors.black,fontSize: 15))
                                    ]),
                              ),

                              Container(
                                padding: EdgeInsets.only(top: 5,bottom: 5),
                                child: Row(
                                  children: <Widget>[

                                    Text(bookingsModel.bookingDate+", ",style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.bold),),
                                    Text(bookingsModel.bookingStartTime+" ",style: TextStyle(fontSize: 16,),),
                                    Text("to ",style: TextStyle(fontSize: 16,),),
                                    Text(bookingsModel.bookingEndTime,style: TextStyle(fontSize: 16,),),
                                  ],
                                ),
                              ),



                            ],
                          ),
                        ),
                      ),
                      Container(
                         padding: EdgeInsets.all(5),
                          child: Text('\$'+bookingsModel.sessionRate,style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.bold),)),

                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          );


        },
      ),
    );




  }


}
