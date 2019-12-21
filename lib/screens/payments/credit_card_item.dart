import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_card_model.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_cart_repository.dart';

import 'package:zing_fitnes_trainer/utils/Config.dart';

class CreditCardItem extends StatelessWidget {
  CreditCardItem({this.userId, this.listCreditCards});

  final String userId;

  final List<CreditCardModel> listCreditCards;

  void saveCardNumber(String value) async {
    final preferences = await StreamingSharedPreferences.instance;
    preferences.setString(Config.cardNumber, value);

    print("saved card Number");
  }
  void saveCardExpiry(String value) async {
    final preferences = await StreamingSharedPreferences.instance;
    preferences.setString(Config.cardExpiry, value);

    print("saved card Expiry");
  }
  void saveCardType(String value) async {
    final preferences = await StreamingSharedPreferences.instance;
    preferences.setString(Config.cardType, value);

    print("saved card Typer");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context,index){
      print("last 4 "+listCreditCards[index].cardNumber);
      if(index == 0){
        Map defaultMap = Map<String,dynamic>();
        defaultMap[Config.customerId] = listCreditCards[index].customer;
        defaultMap[Config.cardNumber] = listCreditCards[index].cardNumber;
        defaultMap[Config.cardMonth] = listCreditCards[index].month;
        defaultMap[Config.cardYear] = listCreditCards[index].year;
        defaultMap[Config.cardType] = listCreditCards[index].cardType;

       CreditCardRepository.instance().setCardAsDefault(userId, defaultMap);
      }
      return index == 0 ?
      InkWell(
        onTap: () {
          print(listCreditCards[index].customer);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Material(
            color:Theme.of(context).primaryColor ,
            elevation: 10.0,
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: Color(0x802196F3),
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 10.0, bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        listCreditCards[index].cardType == Config.visa
                            ? Image.asset('assets/images/visa.png',color: Colors.white,)
                            : Image.asset('assets/images/mastercard.png'),
                        StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection(Config.users)
                                .document(userId)
                                .collection(Config.cardDefault)

                                .document(userId)

                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> docSnap) {
                              if (docSnap.hasData &&
                                  docSnap.data.exists) {
                                return docSnap.data[Config.customerId] == listCreditCards[index].customer ? InkWell(
                                    onTap: () {

                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,),
                                        child: Padding(
                                            padding: const EdgeInsets.all(
                                                10.0),
                                            child: Icon(
                                              Icons.check,
                                              size: 15.0,
                                              color: Theme.of(context).primaryColor,
                                            )))) :
                                InkWell(
                                    onTap: () {

                                      print(listCreditCards[index].cardId);
                                      Map defaultMap = Map<String,dynamic>();
                                      defaultMap[Config.customerId] = listCreditCards[index].customer;
                                      defaultMap[Config.cardNumber] = listCreditCards[index].cardNumber;
                                      defaultMap[Config.cardMonth] = listCreditCards[index].month;
                                      defaultMap[Config.cardYear] = listCreditCards[index].year;
                                      defaultMap[Config.cardType] = listCreditCards[index].cardType;

                                      CreditCardRepository.instance().setCardAsDefault(userId, defaultMap);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2.0)),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(15.0),
                                        )));
                              } else {
                                return InkWell(
                                    onTap: () {
                                      print(listCreditCards[index].cardId);
                                      Map defaultMap = Map<String,dynamic>();
                                      defaultMap[Config.customerId] = listCreditCards[index].customer;
                                      defaultMap[Config.cardNumber] = listCreditCards[index].cardNumber;
                                      defaultMap[Config.cardMonth] = listCreditCards[index].month;
                                      defaultMap[Config.cardYear] = listCreditCards[index].year;
                                      defaultMap[Config.cardType] = listCreditCards[index].cardType;

                                      CreditCardRepository.instance().setCardAsDefault(userId, defaultMap);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2.0)),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(15.0),
                                        )));
                              }
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text("####,####,"+listCreditCards[index].cardNumber,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("CARD HOLDER",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0)),
                        Text("EXPIRES",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text("Owner",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
                        ),
                        Text(
                            listCreditCards[index].month.toString() +
                                "/" +
                                listCreditCards[index].year.toString(),
                            style: TextStyle(

                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )

          :InkWell(
        onTap: () {
          print(listCreditCards[index].customer);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: Color(0x802196F3),
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 10.0, bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        listCreditCards[index].cardType == Config.visa
                            ? Image.asset('assets/images/visa.png')
                            : Image.asset('assets/images/mastercard.png'),
                        StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection(Config.users)
                                .document(userId)
                                .collection(Config.cardDefault)
                                .document(userId)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> docSnap) {
                              if (docSnap.hasData &&
                                  docSnap.data.exists) {
                                return docSnap.data[Config.customerId] == listCreditCards[index].customer ? InkWell(
                                    onTap: () {

                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).primaryColor),
                                        child: Padding(
                                            padding: const EdgeInsets.all(
                                                10.0),
                                            child: Icon(
                                              Icons.check,
                                              size: 15.0,
                                              color: Colors.white,
                                            )))) :
                                InkWell(
                                    onTap: () {

                                      print(listCreditCards[index].customer);
                                      Map defaultMap = Map<String,dynamic>();
                                      defaultMap[Config.customerId] = listCreditCards[index].customer;
                                      defaultMap[Config.cardNumber] = listCreditCards[index].cardNumber;
                                      defaultMap[Config.cardMonth] = listCreditCards[index].month;
                                      defaultMap[Config.cardYear] = listCreditCards[index].year;
                                      defaultMap[Config.cardType] = listCreditCards[index].cardType;

                                      CreditCardRepository.instance().setCardAsDefault(userId, defaultMap);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Theme.of(context).primaryColor,
                                                width: 2.0)),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(15.0),
                                        )));
                              } else {
                                return InkWell(
                                    onTap: () {
                                      print(listCreditCards[index].cardId);
                                      Map defaultMap = Map<String,dynamic>();
                                      defaultMap[Config.customerId] = listCreditCards[index].customer;
                                      defaultMap[Config.cardNumber] = listCreditCards[index].cardNumber;
                                      defaultMap[Config.cardMonth] = listCreditCards[index].month;
                                      defaultMap[Config.cardYear] = listCreditCards[index].year;
                                      defaultMap[Config.cardType] = listCreditCards[index].cardType;

                                      CreditCardRepository.instance().setCardAsDefault(userId, defaultMap);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Theme.of(context).primaryColor,
                                                width: 2.0)),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(15.0),
                                        )));
                              }
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text("####,####,"+listCreditCards[index].cardNumber,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("CARD HOLDER",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0)),
                        Text("EXPIRES",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text("Owner",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
                        ),
                        Text(
                            listCreditCards[index].month.toString() +
                                "/" +
                                listCreditCards[index].year.toString(),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

    },
    itemCount: listCreditCards.length);



  }
}
