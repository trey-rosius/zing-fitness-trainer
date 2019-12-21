import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class NotificationModel{

  String notificationId;
  String bookingId;
  String bookingStatus;
  String notificationText;
  String trainerUserId;
  String userId;
  String senderId,receiverId;

  NotificationModel({this.notificationId, this.bookingId, this.bookingStatus,
      this.notificationText, this.trainerUserId, this.userId,this.senderId,this.receiverId});

  factory NotificationModel.fromFirestore(DocumentSnapshot docSnap){

    return NotificationModel(
      notificationId: docSnap[Config.notificationId],
      bookingStatus: docSnap[Config.bookingStatus],
      bookingId: docSnap[Config.bookingsId],
      trainerUserId: docSnap[Config.trainerUserId],
      notificationText: docSnap[Config.notificationText],
      userId: docSnap[Config.userId],
      senderId: docSnap[Config.senderId],
      receiverId: docSnap[Config.receiverId]
    );
  }


}