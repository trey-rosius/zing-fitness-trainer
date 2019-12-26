import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_card_transaction_item.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_cart_repository.dart';

class CreditCardTransactionScreen extends StatelessWidget {
  CreditCardTransactionScreen(this.cardId,this.userId);
  final String cardId;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Transactions",
          style: TextStyle(


              fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),
      ),

      body:StreamProvider.value(
        value: CreditCardRepository.instance().streamCreditCardTransactions(cardId),
        catchError: (context,error){
          print(error.toString());
        },
        child: Consumer<List<BookingsModel>>(
          builder: (key,value,child){

            return value== null ? Container() : ListView.builder(itemBuilder: (context,index){
              print("this is the result"+value[index].trainerUserId);
              return CreditCardTransactionItem(


                value[index],
                userId,

              );
            },itemCount: value.length,);
          },
        ),

      ),
    );
  }
}
