import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/regular_user_approved_bookings_item.dart';
import 'package:zing_fitnes_trainer/screens/bookings/modules/trainers_approved_bookings_item.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/user_bookings_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';


class ActiveBookingSession extends StatelessWidget {
  ActiveBookingSession(this.userId,this.userBookingsModel,this.userType);
  final String userId;
  final String userType;
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
               userType == Config.trainer? TrainersApprovedBookingsItem(value,userId) : RegularUserApprovedBookingsItem(value,userId);
              },
            ),

          );
        },
        itemCount: userBookingsModel.length,);

  }
}
