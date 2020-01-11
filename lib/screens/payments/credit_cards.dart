import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
//import 'package:stripe_payment/stripe_payment.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_card_item.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_card_model.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_cart_repository.dart';

class CreditCardScreen extends StatefulWidget {
  CreditCardScreen({this.userId});
  final String userId;
  @override
  _CreditCardScreenState createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {

  void addCard(){



    StripeSource.addSource().then((String token) {
      print("here is the token"+token);
    CreditCardRepository.instance().addCard(widget.userId, token);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Payment",
          style: TextStyle(


              fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed:()=>addCard(),
      child: Icon(Icons.credit_card),),
      body:StreamProvider.value(
        value: CreditCardRepository.instance().streamUserCreditCards(widget.userId),
        catchError: (context,error){
          print(error.toString());
        },
        child: Consumer<List<CreditCardModel>>(
          builder: (key,value,child){

            return value== null ? Container() : CreditCardItem(
              listCreditCards: value,
              userId: widget.userId,

            );
          },
        ),

      ),
    );
  }
}
