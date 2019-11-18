import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class BookingsCard extends StatelessWidget {
  BookingsCard(this.userId,this.trainerInfo,this.bookingModel);
  final String userId;
  final TrainerProfileModel trainerInfo;
  final NewBookingModel bookingModel;

  @override
  Widget build(BuildContext context) {
    var colors = MyColors();
    var size = MediaQuery.of(context).size;
    return
        Transform.translate(
          offset: Offset(0, 35),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            decoration: BoxDecoration(
                color: colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: size.width-50,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(60),
                          child: CachedNetworkImage(
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                            imageUrl: trainerInfo.profilePicUrl??"",
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, ex) =>
                                Icon(Icons.error),
                          )),
                    ),
                    Expanded(child: Text(trainerInfo.name,style: TextStyle(fontSize: 20,),))
                  ],
                ),
                Divider(),

                Container(
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: colors.deepBlue,
                      size: 30,
                    ),
                    title: Text(trainerInfo.location),
                  ),
                ),
                Divider(),
                Container(
                  child: ListTile(
                    leading: Icon(
                      Icons.calendar_today,
                      color: colors.deepBlue,
                      size: 30,
                    ),
                    title: Text(bookingModel.date),
                  ),
                ),

                Divider(),
                otherInfo("Session type", bookingModel.sessionType),
                otherInfo("Speciality", trainerInfo.speciality),
                Container(
                  decoration: BoxDecoration(
                      color: colors.gray,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: RichText(
                    text: TextSpan(
                        text: "Session Cost :",
                        style: TextStyle(fontSize: 20, color: colors.textBlack),
                        children: [
                          TextSpan(
                              text: '\$'+trainerInfo.sessionRate,
                              style: TextStyle(
                                  color: colors.deepBlue,
                                  fontWeight: FontWeight.w900))
                        ]),
                  ),
                ),
              ],
            ),
          ),
        );

  }
}

Widget _cardListItem(
    {Widget leading, String title = "", String subtitle = ""}) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          leading,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  title,
                  style: TextStyle(
                      color: MyColors().textBlack,
                      fontSize: 17,
                      fontWeight: FontWeight.w900),
                ),
              ),
              RichText(
                  text: TextSpan(
                text: subtitle,
                style: TextStyle(color: MyColors().textBlack, fontSize: 13),
              ))
            ],
          ),
        ],
      ));
}

Widget otherInfo(title, content) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 61),
    padding: EdgeInsets.symmetric(vertical: 3),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title,
            style: TextStyle(fontSize: 12, color: MyColors().textBlack)),
        Text(content,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: MyColors().textBlack))
      ],
    ),
  );
}
