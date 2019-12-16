import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/components/tabBar.dart';
import 'package:zing_fitnes_trainer/components/tabBar_trainer.dart';
import 'package:zing_fitnes_trainer/providers/provider.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/active_booking_session.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/pending_booking_session.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/requested_booking_session.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/user_bookings_model.dart';



import 'package:zing_fitnes_trainer/utils/myColors.dart';


class TrainerBookingsPage extends StatelessWidget {
  TrainerBookingsPage (this.userId);
  final String userId;
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
  //  var myColor = Colors.green;
  //  var hex = '#${myColor.value.toRadixString(16)}';

   // print(hex);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => AppBarData(),
        )
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
             // iconTheme: IconThemeData(color: MyColors().deepBlue, size: 40),
              backgroundColor: MyColors().white,

              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 20),
                child: TrainerTabBar(),
              ),

            ),
            body: StreamProvider.value(value: BookingRepository.instance().streamListOfUserBookings(userId),
            catchError: (context,error){
              print(error);
            },
            child: BookingsBody(userId),)
          ),

      ),
    );
  }
}

class BookingsBody extends StatelessWidget {
  BookingsBody(this.userId);
  final String userId;
  //this will be modified later to make the list dynamic
  @override
  Widget build(BuildContext context) {
    var userBookingsModel = Provider.of<List<UserBookingsModel>>(context);
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[ActiveBookingSession(userId,userBookingsModel),PendingBookingSession(userId,userBookingsModel),RequestedBookingSession(userId,userBookingsModel,"hf")],
    );
  }
}