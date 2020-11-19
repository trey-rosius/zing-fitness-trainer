import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:zing_fitnes_trainer/utils/Config.dart';

class CreditCardModel {
  String cardType;
  String cardNumber;
  Timestamp createdOn;

  String holderName;
  String paymentMethodId;
  int month;
  int year;

  String cardId;
  String customer;

  CreditCardModel(
      {this.cardType,
        this.cardNumber,
        this.month,
        this.year,
        this.createdOn,
        this.cardId,
        this.paymentMethodId,
        this.holderName,
        this.customer});

  factory CreditCardModel.fromFirestore(DocumentSnapshot docSnap) {
    return CreditCardModel(
        cardType: docSnap[Config.brand],
        cardNumber: docSnap[Config.last4],
        createdOn: docSnap[Config.createdOn],
        holderName: docSnap[Config.cardHolderName] ?? "",
        month: docSnap[Config.expMonth],
        year: docSnap[Config.expYear],
        paymentMethodId: docSnap[Config.paymentMethodId],
        cardId: docSnap[Config.cardId],
        customer: docSnap[Config.customerId] ?? "");
  }
}
