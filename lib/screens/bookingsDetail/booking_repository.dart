import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class BookingRepository{

  Firestore _firestore ;


  BookingRepository.instance() : _firestore = Firestore.instance;

  Future<void>saveBookingDetails(String userId,Map bookingsMap){

    return _firestore.collection(Config.bookings).add(bookingsMap)
         .then((DocumentReference docRef){

           _firestore.collection(Config.users).document(userId).collection(Config.userBookings)
               .document(docRef.documentID).setData({
             Config.bookingsId:docRef.documentID,
             Config.createdOn:FieldValue.serverTimestamp(),

           });
    });
  }



  Future<void> makeBookingPayment(String customerId,double amount,String userId,Map bookingsMap){
    return _firestore.collection(Config.users).document(userId).collection(Config.charges).document(customerId).setData({
      Config.currencyDes:'usd',
      Config.amount: (amount*100).round(),

      Config.customerId:customerId
    }).then((val){



   print("done");

    });

  }


}