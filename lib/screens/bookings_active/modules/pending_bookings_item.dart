import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_screen.dart';
import 'package:zing_fitnes_trainer/screens/chats/chats_repository.dart';
import 'package:zing_fitnes_trainer/screens/chats/typing_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class PendingBookingsItem extends StatelessWidget {
  PendingBookingsItem(

      this.bookingsModel,
      this.userId);

  final BookingsModel bookingsModel;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return bookingsModel.bookingStatus == Config.pendingApproval ?

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
                            builder: (context) =>
                                MultiProvider(providers: [
                                  StreamProvider<TypingModel>.value(value: ChatsRepository.instance().streamTyping(userId, value.userId),catchError: (context,error){
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
                                      receiverId: value.userId,
                                      receiverFirstName :value.name

                                  ),)



                        ));
                  },
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

                                  Row(
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
                );


          },
        ),
      ) : Container();




  }


}
