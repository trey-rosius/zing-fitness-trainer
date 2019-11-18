import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class CreditCardModel{
  String cardType;
  String cardNumber;

  String holderName;
  int month;
  int  year;

  String cardId;
  String customer;

  CreditCardModel({this.cardType, this.cardNumber, this.holderName,
      this.month, this.year, this.cardId,this.customer});

  factory CreditCardModel.fromFirestore(DocumentSnapshot docSnap){
    return CreditCardModel(
       cardType: docSnap[Config.card][Config.brand],
       cardNumber: docSnap[Config.card][Config.last4],

       holderName: docSnap[Config.cardHolderName],
      month: docSnap[Config.card][Config.exp_month],
      year: docSnap[Config.card][Config.exp_year],

      cardId:docSnap[Config.cardId],
      customer: docSnap[Config.customer]


    );
  }


}