import 'package:flutter/material.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zing_fitnes_trainer/screens/bookings/regular_users/regular_users_bookings_page.dart';
import 'package:zing_fitnes_trainer/screens/bookings/trainer_bookings_page.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_auto_booking_screen.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_screen.dart';

import 'package:zing_fitnes_trainer/screens/home/zoom_scaffold.dart';
import 'package:zing_fitnes_trainer/screens/notifications/notifications_screen.dart';
import 'package:zing_fitnes_trainer/screens/search/search_screen.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen(this.userId,this.admin,this.menuController,this.longitude,this.latitude,this.userType);
  final MenuController menuController;
  final String userId;
  final bool admin;
  final String longitude;
  final String latitude;
  final String userType;



  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  int _selectedIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("user type is "+ widget.userType);

    _pageController = PageController(initialPage: _selectedIndex);
  }

  void pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<Null> bookType(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),

            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewAutoBookingScreen(widget.userId),

                        ),
                      );
                    },
                    title: Text("Book Now",style: TextStyle(fontSize: 20),),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewBookingScreen(widget.userId),

                        ),
                      );
                    },
                    title: Text("Book Later",style: TextStyle(fontSize: 20),),
                  ),



                ],
              ),
            )

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {



        return Scaffold(
          backgroundColor:  Color(0xFF2f00ad),

          appBar: AppBar(
            leading: InkWell(
                    onTap: ()=>widget.menuController.toggle(),
                    child: Icon(Icons.menu)),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Bookings",
              style: TextStyle(fontSize: 20),),
            centerTitle: true,
            elevation: 0.0,
            actions: <Widget>[


              InkWell(
                onTap: (){


                  Navigator.push(
                    context,
                    MaterialPageRoute(

                        builder: (context) {
                          return  SearchScreen(widget.userId,widget.longitude,widget.latitude);


                        }



                    ),
                  );
                },

                child: Container(
                    margin: EdgeInsets.only(right: 10,left: 10),
                    child: Icon(Icons.search)),
              ),
              InkWell(
                onTap: (){


                  Navigator.push(
                    context,
                    MaterialPageRoute(

                        builder: (context) {
                          return  NotificationsScreen(widget.userId);


                        }



                    ),
                  );
                },

                child: Container(
                    margin: EdgeInsets.only(right: 10,left: 10),
                    child: Icon(Icons.notifications)),
              )

            ],
          ),

          body:


          widget.userType== Config.trainer ? TrainerBookingsPage(widget.userId,widget.userType) :RegularUsersBookingsPage(widget.userId,widget.userType) ,
          floatingActionButton: FloatingActionButton(onPressed: (){

            bookType(context);

          },child: Icon(Icons.add),),



          // This trailing comma makes auto-formatting nicer for build methods.
        );

  }
}
