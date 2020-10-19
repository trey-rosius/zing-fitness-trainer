
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/external_profile_trainer_screen.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class SearchItem extends StatefulWidget {
  SearchItem(this.userId,this.trainerProfileModel,this.longitude,this.latitude);
  final String userId;
  final TrainerProfileModel trainerProfileModel;
  final String longitude;
  final String latitude;

  @override
  _SearchItemState createState() => _SearchItemState();
}


class _SearchItemState extends State<SearchItem> {

 // var distance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

/*
    print("longitude is"+widget.longitude);
    print("latitude is"+widget.latitude);
    ProfileProvider.instance().calculateDistance(widget.trainerProfileModel, widget.longitude, widget.latitude).then((distanceInMeters){
setState(() {
  distance = distanceInMeters;
  print("distance is "+distance.toString());
});

    });
    */

  }
  @override
  Widget build(BuildContext context) {

/*
distance != null && distance <=5000000 ?
 */
    return

    Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){

          print("pressed");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return StreamProvider.value(
                  value: ProfileProvider.instance()
                      .streamTrainerUserProfile(widget.trainerProfileModel.userId),
                  catchError: (context, error) {
                    print(error);
                  },
                  child: ExternalProfileTrainerUser(userId: widget.userId,));
              //  child: ProfileRegularUser();
            }),
          );


        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                    borderRadius:
                    BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                      imageUrl: widget.trainerProfileModel.profilePicUrl??"",
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
                            widget.trainerProfileModel.name,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                              text: widget.trainerProfileModel.experience + "+ ",
                              style: TextStyle(color: MyColors().deepBlue, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "yrs experience",
                                    style: TextStyle(color: Colors.black,fontSize: 15))
                              ]),
                        ),



                      ],
                    ),
                  ),
                ),

              ],
            ),
            Divider()
          ],
        ),
      )
    ) ;
  }
}
