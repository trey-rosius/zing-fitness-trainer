import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_screen.dart';
import 'package:zing_fitnes_trainer/screens/trainers/trainer_details_screen.dart';
import 'package:zing_fitnes_trainer/screens/trainers/user_details_screen.dart';

class TrainerUserItem extends StatelessWidget {
  TrainerUserItem({this.userId,this.trainerInfo,this.bookingModel});
  final String userId;
  final TrainerProfileModel trainerInfo;
  final NewBookingModel bookingModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)
          {
           return TrainerDetailsScreen(userId, trainerInfo, bookingModel);
           // return UserDetailsScreen(userId, trainerInfo, bookingModel);
          })
              //  child: ProfileRegularUser();

          );

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
            ClipRRect(
            borderRadius:
            BorderRadius.circular(60),
            child: CachedNetworkImage(
              width: 70.0,
              height: 70.0,
              fit: BoxFit.cover,
              imageUrl: trainerInfo.profilePicUrl??"",
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              errorWidget: (context, url, ex) =>
                  Icon(Icons.error),
            )),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(trainerInfo.name,style: TextStyle(fontSize: 20),),

                          Padding(
                            padding:  EdgeInsets.only(top:10.0,bottom: 10),
                            child: Text(trainerInfo.experience+" years",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ),
                        Text('\$ '+trainerInfo.sessionRate,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.red),)


                      ],
                    ),
                  ),
                )
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
