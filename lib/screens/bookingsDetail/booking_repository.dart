import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/user_bookings_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class BookingRepository{

  Firestore _firestore ;


  BookingRepository.instance() : _firestore = Firestore.instance;



  Future<void>saveRequestedBookingDetails(String userId,String trainerUserId,Map bookingsMap){

    return _firestore.collection(Config.bookings).add(bookingsMap)
        .then((DocumentReference docRef){

          _firestore.collection(Config.bookings).document(docRef.documentID)
              .updateData({
            Config.bookingsId :docRef.documentID
          }
          ).then((_) {

            _firestore.collection(Config.users).document(userId).collection(Config.userBookings)
                .document(docRef.documentID).setData({
              Config.bookingsId:docRef.documentID,
              Config.createdOn:FieldValue.serverTimestamp(),
          });


      }).then((_){
        _firestore.collection(Config.users).document(trainerUserId).collection(Config.userBookings)
            .document(docRef.documentID).setData({
          Config.bookingsId: docRef.documentID,
          Config.createdOn: FieldValue.serverTimestamp(),
        });
      });
    });
  }

  Future<void>changeBookingStatus(String bookingId,Map bookingMap){
    return _firestore.collection(Config.bookings).document(bookingId)
           .updateData(bookingMap).then((_){
      print("updates status");
    });
  }



  Future<void> makeBookingPayment(String customerId,double amount,String userId,Map bookingsMap){
    return _firestore.collection(Config.users).document(userId).collection(Config.charges).document(customerId).setData({
      Config.currencyDes:'usd',
      Config.amount: (amount*100).round(),
      Config.userId: userId,
      Config.customerId:customerId
    }).then((val){



   print("done");

    });

  }



  ///Stream Single Bookings
  Stream<BookingsModel>streamSingleBooking(String bookingId){
    return _firestore.collection(Config.bookings)
         
        .document(bookingId).snapshots()
        .map((snap){
      print(snap.data.toString());
      return BookingsModel.fromFirestore(snap);
    });
  }

  /// Stream list of user bookings
  Stream<List<UserBookingsModel>>streamListOfUserBookings(String userId){

    return _firestore.collection(Config.users).document(userId).collection(Config.userBookings)
        .orderBy(Config.createdOn,descending: true)

        .snapshots()
        .map((list)=>
    list.documents.map((doc)=>UserBookingsModel.fromFirestore(doc)).toList());
  }



//Stream single booking



}