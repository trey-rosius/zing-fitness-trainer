import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/user_bookings_model.dart';
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



  ///Stream Single Bookings
  Stream<BookingsModel>streamSingleBooking(String bookingId){
    return _firestore.collection(Config.bookings).document(bookingId).snapshots()
        .map((snap){
      print(snap.data.toString());
      return BookingsModel.fromFirestore(snap);
    });
  }

  /// Stream list of user bookings
  Stream<List<UserBookingsModel>>streamListOfUserBookings(String userId){

    return _firestore.collection(Config.users).document(userId).collection(Config.userBookings)
        .snapshots()
        .map((list)=>
    list.documents.map((doc)=>UserBookingsModel.fromFirestore(doc)).toList());
  }

  //Stream single booking



}