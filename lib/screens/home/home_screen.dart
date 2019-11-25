import 'package:flutter/material.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_screen.dart';
import 'package:zing_fitnes_trainer/screens/bookings_active/bookings_page.dart';
import 'package:zing_fitnes_trainer/screens/home/zoom_scaffold.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({this.userId,this.admin,this.menuController,this.isUserAnonymous});
  final MenuController menuController;
  final String userId;
  final bool admin;
  final bool isUserAnonymous;



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

    _pageController = PageController(initialPage: _selectedIndex);
  }

  void pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
/*
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  NotificationScreen(userId: widget.userId,admin: widget.admin),
                      ));
*/
                },

                child: Container(
                    margin: EdgeInsets.only(right: 10,left: 10),
                    child: Icon(FontAwesomeIcons.search)),
              )

            ],
          ),

          body: BookingsPage(widget.userId),
          floatingActionButton: FloatingActionButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewBookingScreen(widget.userId),

              ),
            );
          },child: Icon(Icons.add),),



          // This trailing comma makes auto-formatting nicer for build methods.
        );

  }
}