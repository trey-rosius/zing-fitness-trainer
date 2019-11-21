import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class UserBookingsModel{
  String bookingsId;
  Timestamp createdOn;

  UserBookingsModel({this.bookingsId, this.createdOn});

  factory UserBookingsModel.fromFirestore(DocumentSnapshot docSnap){

    return UserBookingsModel(
      bookingsId: docSnap[Config.bookingsId],
      createdOn: docSnap[Config.createdOn]
    );
  }


}