import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/user_bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/bookings_active/modules/bookings_item.dart';

class ActiveBookingSession extends StatelessWidget {
  ActiveBookingSession(this.userId,this.userBookingsModel);
  final String userId;
  final List<UserBookingsModel> userBookingsModel;
  @override
  Widget build(BuildContext context) {
    return userBookingsModel ==null ? Container() :
        ListView.builder(itemBuilder: (context,index){
          return  Container(
            padding: EdgeInsets.only(top: 20,left: 20,right: 10),
            child: StreamProvider.value(value: BookingRepository.instance().streamSingleBooking(userBookingsModel[index].bookingsId),
              catchError: (context,error){
                print(error);
              },
            child: Consumer<BookingsModel>(
              builder: (key,value,child){
               return value == null ? Container() :
                 BookingsItem(value,userId);
              },
            ),
            ),
          );
        },
        itemCount: userBookingsModel.length,);

  }
}
