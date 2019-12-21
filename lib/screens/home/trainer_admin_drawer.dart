import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/general_user_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/profile_regular_user.dart';
import 'package:zing_fitnes_trainer/screens/Profile/profile_trainer_user.dart';
import 'package:zing_fitnes_trainer/screens/Profile/regular_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/conversation_list/ConversationItemRepository.dart';
import 'package:zing_fitnes_trainer/screens/conversation_list/conversation_item_model.dart';
import 'package:zing_fitnes_trainer/screens/conversation_list/conversation_list_screen.dart';
import 'package:zing_fitnes_trainer/screens/home/zoom_scaffold.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_cards.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class TrainerAdminDrawer extends StatefulWidget {
  TrainerAdminDrawer(this.userId, this.admin, this.menuController,this.userType);
  final String userId;
  final bool admin;
  final String userType;

  final MenuController menuController;

  @override
  _TrainerAdminDrawerState createState() => _TrainerAdminDrawerState();
}

class _TrainerAdminDrawerState extends State<TrainerAdminDrawer> {
  bool isSwitched = true;
  _deletePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Config.userId);
  }

  _saveAdmin(bool admin) async {
    final prefs = await StreamingSharedPreferences.instance;

    prefs.setBool(Config.admin, admin);
  }

  Future<Null> _confirmSignOut(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Sign Out"),
          content: Container(
            child: Text(
              "Are you sure you wish to sign out ?",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          actions: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: new Text(
                      "no",
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: new Text(
                      "yes",
                    ),
                    onPressed: () {
                      _deletePreferences();
                      //  LoginRepository.instance().signOut();
                      Navigator.of(context).pop();

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                      // checkUserType();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 1.6,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      child: StreamProvider.value(value: ProfileProvider.instance()
              .streamTrainerUserProfile(widget.userId),catchError: (context,error){
                        print(error.toString());
      },
      child: Consumer<TrainerProfileModel>(
        builder: (_,profileMod,child){
          return profileMod == null ? Container(): Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      // margin:EdgeInsets.only(top: 10,right: 20,left: 20) ,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.cover,
                              imageUrl: profileMod.profilePicUrl ?? "",
                              placeholder: (context, url) =>
                                  SpinKitHourGlass(
                                      color: Theme.of(context)
                                          .accentColor),
                              errorWidget: (context, url, ex) =>
                                  CircleAvatar(
                                    backgroundColor:
                                    Theme.of(context).accentColor,
                                    radius: 50.0,
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ))),
                    ),
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () {
                          widget.menuController.close();
                          /*
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              //  builder: (context) => HomeScreen(userId: widget.userId,admin: false,),
                                              builder: (context) => EditProfileScreen(userId),
                                            ),
                                          );
                                          */
                        },
                        child: Text(
                          profileMod.name,
                          style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 60),
                      child: Text(profileMod.userPresence?"Online":"Offline",style: TextStyle(fontSize: 20,color: Colors.white),),
                    ),
                    Switch(
                      value: profileMod.userPresence,
                      onChanged: (value) {
                        setState(() {

                          ProfileProvider.instance().updateAdminPresence(widget.userId, value);
                       //  isSwitched = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),)),


                  InkWell(
                      onTap: () {
                        widget.menuController.close();
                        if(widget.userType == Config.regularUser){

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return StreamProvider.value(
                                value: ProfileProvider.instance()
                                    .streamRegularUserProfile(widget.userId),
                                catchError: (context, error) {
                                  print(error);
                                },
                                child: ProfileRegularUser(

                                ),
                              );
                            }),
                          );
                        }else
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return StreamProvider.value(
                                    value: ProfileProvider.instance()
                                        .streamTrainerUserProfile(widget.userId),
                                    catchError: (context, error) {
                                      print(error);
                                    },
                                    child: ProfileTrainerUser(userId: widget.userId,));
                                //  child: ProfileRegularUser();
                              }),
                            );
                          }
                      },
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.userAlt,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        /*
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(

                                          builder: (context) => OrdersScreen(admin: admin,userId:userId),
                                        ),
                                      );
                                      */
                      },
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.book,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Bookings",
                          style: TextStyle(
                              color: Colors.white,),
                        ),
                      )),
                  InkWell(
                      onTap: () {

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(

                                          builder: (context) => CreditCardScreen(userId:widget.userId),
                                        ),
                                      );

                      },
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.creditCard,
                            color: Colors.white),
                        title: Text(
                          "Payments",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17
                          ),
                        ),
                      )),
                  InkWell(
                      onTap: () {

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(

                                          builder: (context) {
                                            return StreamProvider<List<ConversationItemModel>>.value(value: ConversationItemRepository.instance().streamUserConversationList(widget.userId),
                                            catchError: (context,error){
                                             print(error);
                                             return null;
                                            },child: ConversationListScreen(widget.userId),);


                                          }



                                        ),
                                      );

                      },
                      child: ListTile(
                        leading:
                        Icon(FontAwesomeIcons.comment, color: Colors.white),
                        title: Text(
                          "Conversation",
                          style: TextStyle(color: Colors.white,  fontSize: 17),
                        ),
                      )),




                ],
              ),
              Spacer(),
              ListTile(
                onTap: () {
                  _confirmSignOut(context);
                },
                leading: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Icon(
                    FontAwesomeIcons.signOutAlt,
                    color: Colors.white,
                  ),
                ),
                title: Text('Logout',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ],
          ),
        ),

    );
  }
}
