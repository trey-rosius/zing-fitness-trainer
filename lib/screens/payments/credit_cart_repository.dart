import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_card_model.dart';
import 'package:zing_fitnes_trainer/screens/payments/default_credit_card_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class CreditCardRepository  extends ChangeNotifier{

  Firestore _firestore ;


  CreditCardRepository.instance() : _firestore = Firestore.instance;


    Future<void>addCard(String userId,String token){

      return _firestore
          .collection(Config.users)
          .document(userId)
          .collection(Config.paymentMethodId)
          .add({Config.paymentMethodId: token}).then((val) {
        print("User Card Token Saved");
      });
    }

  void paymentRequestWithCardForm(String userId) {
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      print("payment method id " + paymentMethod.id);
      print("last 4 digits " + paymentMethod.card.last4);
      print("exp month " + paymentMethod.card.expMonth.toString());
      print("exp year " + paymentMethod.card.expYear.toString());
      print("received " + paymentMethod.card.brand);

      Map map = Map<String, Object>();
      map[Config.last4] = paymentMethod.card.last4;
      map[Config.expMonth] = paymentMethod.card.expMonth;
      map[Config.expYear] = paymentMethod.card.expYear;
      map[Config.brand] = paymentMethod.card.brand;
      map[Config.createdOn] = FieldValue.serverTimestamp();
      map[Config.paymentMethodId] = paymentMethod.id;

      print("received " + paymentMethod.card.last4);
      saveCardDetails(userId, map, paymentMethod.id);
      addCard(userId, paymentMethod.id);
    });
  }
  /// Get a Stream of credit cards for a user
  Stream<List<CreditCardModel>> streamUserCreditCards(String userId) {
    return _firestore
        .collection(Config.users)
        .document(userId)
        .collection(Config.cards)
        .orderBy(Config.createdOn, descending: true)
        .snapshots()
        .map((list) => list.documents
        .map((doc) => CreditCardModel.fromFirestore(doc))
        .toList());
  }
  /*
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
  */

  Future<void> saveCardDetails(String userId, Map cardMap, String paymentId) {
    return _firestore
        .collection(Config.users)
        .document(userId)
        .collection(Config.cards)
        .document(paymentId)
        .setData(cardMap, merge: true)
        .then((_) {
      print("User Card Token Saved");
    });
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