import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/active_booking_session.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/cancelled_booking_session.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/past_booking_session.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/pending_booking_session.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/requested_booking_session.dart';

import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/user_bookings_model.dart';


import 'package:zing_fitnes_trainer/utils/myColors.dart';


class RegularUsersBookingsPage extends StatefulWidget {
  RegularUsersBookingsPage(this.userId,this.userType);
  final String userId;
  final String userType;

  @override
  _RegularUsersBookingsPageState createState() => _RegularUsersBookingsPageState();
}

class _RegularUsersBookingsPageState extends State<RegularUsersBookingsPage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 5, vsync: this);
    super.initState();

    print("user id"+widget.userId);

  }
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
  //  var myColor = Colors.green;
  //  var hex = '#${myColor.value.toRadixString(16)}';

   // print(hex);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            // iconTheme: IconThemeData(color: MyColors().deepBlue, size: 40),
            backgroundColor: MyColors().white,

            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 20),
              child: TabBar(

                controller: _tabController,
                // indicatorColor: Colors.transparent,
                isScrollable: true,
                 unselectedLabelColor: Colors.grey,
                 labelColor: Theme.of(context).accentColor,
                labelStyle: TextStyle(),


                tabs: [


                  new Tab(text:"Active",),

                  new Tab(text:"Pending",),
                  new Tab(text:"Requested",),
                  new Tab(text:"Past",),
                  new Tab(text:"Cancelled",),


                ],

              ),
            ),

          ),
          body: StreamProvider.value(value: BookingRepository.instance().streamListOfUserBookings(widget.userId),
            catchError: (context,error){
              print(error);
            },
            child: BookingsBody(widget.userId,_tabController,widget.userType),)
      ),

    );
  }
}

class BookingsBody extends StatelessWidget {
  BookingsBody(this.userId,this.tabController,this.userType);
  final TabController tabController;
  final String userType;
  final String userId;
  //this will be modified later to make the list dynamic
  @override
  Widget build(BuildContext context) {
    var userBookingsModel = Provider.of<List<UserBookingsModel>>(context);
    return TabBarView(

      children: <Widget>[ActiveBookingSession(userId,userBookingsModel,userType),
      PendingBookingSession(userId,userBookingsModel,userType),
      RequestedBookingSession(userId,userBookingsModel,userType),
      PastBookingSession(userId,userBookingsModel),
      CancelledBookingSession(userId,userBookingsModel),],
      controller: tabController,
    );
  }
}
