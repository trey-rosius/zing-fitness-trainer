import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_card_model.dart';
import 'package:zing_fitnes_trainer/screens/payments/default_credit_card_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class CreditCardRepository  extends ChangeNotifier{

  Firestore _firestore ;


  CreditCardRepository.instance() : _firestore = Firestore.instance;


    Future<void>addCard(String userId,String token){

     return _firestore.collection(Config.users).document(userId).collection(Config.tokens).add({
        Config.tokenId:token
      }).then((val){
        print("User Card Token Saved");

      });
    }

  /// Get a Stream of credit cards for a user
  Stream<List<CreditCardModel>> streamUserCreditCards(String userId){
    return _firestore
        .collection(Config.users)
        .document(userId)
        .collection(Config.sources)
        .orderBy(Config.created,descending: true)
        .snapshots()
        .map((list) =>
        list.documents.map((doc) => CreditCardModel.fromFirestore(doc)).toList());



  }

  Future<void>setCardAsDefault(String userId,Map defaultMap){
      return _firestore
          .collection(Config.users)
          .document(userId)
          .collection(Config.cardDefault)
          .document(userId)
          .setData(defaultMap).then((_) {

      });
  }

  ///Stream single credit card transactions
  ///
  /// Stream list of user bookings
  Stream<List<BookingsModel>>streamCreditCardTransactions(String cardId){

    return _firestore.collection(Config.bookings).where(Config.customer,isEqualTo: cardId)

        .snapshots()
        .map((list)=>
        list.documents.map((doc)=>BookingsModel.fromFirestore(doc)).toList());
  }

  /// stream single credit card document
  Stream<DefaultCreditCardModel> streamDefaultCreditCard(String userId) {
    return _firestore
        .collection(Config.users)
        .document(userId)
        .collection(Config.cardDefault)

        .document(userId)

        .snapshots()

        .map((snap) {
      print(snap.data.toString());
      return DefaultCreditCardModel.fromFirestore(snap);
    });
  }



}