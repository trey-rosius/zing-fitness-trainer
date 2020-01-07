import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/regular_user_approved_bookings_item.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/past_bookings_item.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/user_bookings_model.dart';


class PastBookingSession extends StatelessWidget {
  PastBookingSession(this.userId,this.userBookingsModel);
  final String userId;
  final List<UserBookingsModel> userBookingsModel;
  @override
  Widget build(BuildContext context) {
    return userBookingsModel ==null ? Container() :
        ListView.builder(itemBuilder: (context,index){
          return StreamProvider.value(value: BookingRepository.instance().streamSingleBooking(userBookingsModel[index].bookingsId),
              catchError: (context,error){
                print(error);
              },
            child: Consumer<BookingsModel>(
              builder: (key,value,child){
               return value == null ? Container() :
                 PastBookingsItem(value,userId);
              },
            ),

          );
        },
        itemCount: userBookingsModel.length,);

  }
}
