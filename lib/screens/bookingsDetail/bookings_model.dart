import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class BookingsModel{
  String bookingId;
  String bookingDate;
  int bookingDay,bookingEndHr,bookingEndMin,bookingStartHr,bookingStartMin,bookingYear,bookingMonth;
  String bookingEndTime,bookingStartTime;
  String bookingStatus,sessionRate,sessionType;
  String trainerUserId,userId;
  Timestamp createdOn;

  BookingsModel({this.bookingId,this.bookingDate, this.bookingDay, this.bookingEndHr,
      this.bookingEndMin, this.bookingStartHr, this.bookingStartMin,
      this.bookingYear, this.bookingMonth, this.bookingEndTime,
      this.bookingStartTime, this.bookingStatus, this.sessionRate,
      this.sessionType, this.trainerUserId,this.createdOn,this.userId});


  factory BookingsModel.fromFirestore(DocumentSnapshot docSnap){
    return BookingsModel(
        bookingId: docSnap[Config.bookingsId],
        bookingDate : docSnap[Config.bookingDate],
        bookingDay: docSnap[Config.bookingDay],
        bookingEndHr: docSnap[Config.bookingEndHr],
      bookingEndMin: docSnap[Config.bookingEndMin],
      bookingEndTime: docSnap[Config.bookingEndTime],
      bookingMonth: docSnap[Config.bookingMonth],
      bookingStartHr: docSnap[Config.bookingStartHr],
      bookingStartMin: docSnap[Config.bookingStartMin],
      bookingStartTime: docSnap[Config.bookingStartTime],
      bookingStatus: docSnap[Config.bookingStatus],
      bookingYear: docSnap[Config.bookingsYear],
      sessionRate: docSnap[Config.sessionRate],
      sessionType: docSnap[Config.sessionType],
      userId: docSnap[Config.userId],
      trainerUserId: docSnap[Config.trainerUserId],
      createdOn : docSnap[Config.createdOn]

    );
  }


}