import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class DefaultCreditCardModel{
  String cardType;
  String cardNumber;

  int cardMonth;
  int  cardYear;
  String customerId;


  DefaultCreditCardModel({this.cardType, this.cardNumber, this.cardMonth,
      this.cardYear, this.customerId});

  factory DefaultCreditCardModel.fromFirestore(DocumentSnapshot docSnap){
    return DefaultCreditCardModel(
        cardType: docSnap[Config.cardType],
        cardNumber: docSnap[Config.cardNumber],


        cardMonth: docSnap[Config.cardMonth],
        cardYear: docSnap[Config.cardYear],

        customerId: docSnap[Config.customerId]


    );
  }


}