import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class BookingDetailsScreen extends StatelessWidget {
  BookingDetailsScreen(

      this.bookingsModel,
      this.trainerProfileModel,
      this.userId);
  final BookingsModel bookingsModel;
  final TrainerProfileModel trainerProfileModel;
  final String userId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details',style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child:Column(
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                    border:
                    Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(30)),
                child: Material(
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
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
              ),
            ),

            Padding(
              padding:  EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.check_box_outline_blank,
                    color: MyColors().deepBlue,
                    size: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 3),
                    child: Text(
                      "UnPaid",
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                ],
              ),
            ),

            Container(
              child: Text(trainerProfileModel.name),
            )
          ],
        ),
      ),
    );
  }
}
