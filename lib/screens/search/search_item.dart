
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class SearchItem extends StatelessWidget {
  SearchItem(this.userId,this.trainerProfileModel);
  final String userId;
  final TrainerProfileModel trainerProfileModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){

          print("pressed");


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
                      imageUrl: trainerProfileModel.profilePicUrl??"",
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
                            trainerProfileModel.name,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                              text: trainerProfileModel.experience + "+ ",
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
    );
  }
}
