import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/regular_profile_model.dart';

import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';

import 'package:zing_fitnes_trainer/screens/trainers/user_details_screen.dart';


import 'package:zing_fitnes_trainer/utils/Config.dart';


class TrainerRequestedBookingsItem extends StatelessWidget {
  TrainerRequestedBookingsItem(

      this.bookingsModel,
      this.userId);

  final BookingsModel bookingsModel;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return bookingsModel.bookingStatus == Config.requested ?

     StreamProvider.value(
        value: ProfileProvider.instance().streamRegularUserProfile(bookingsModel.userId),
        catchError: (context,error){
          print(error);

        },
        child: Consumer<RegularProfileModel>(
          builder: (key,value,child){
            return value== null ? Container():

                InkWell(
                  onTap: (){
                    print(bookingsModel.userId);
                    print(bookingsModel.trainerUserId);

                    print("pressed");


                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(userId,bookingsModel)








                        ));




                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
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


                                    Row(
                                      children: <Widget>[

                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 3),
                                          child: Text(
                                            "Requested",
                                            style: TextStyle(fontSize: 15,color:Theme.of(context).primaryColorDark,fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.navigate_next,
                                color: Colors.grey,
                                size: 30,
                              ),
                              onPressed: () {
                                print("pressed");
                              },
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );


          },
        ),
      ) : Container(color: Colors.red,);




  }


}
