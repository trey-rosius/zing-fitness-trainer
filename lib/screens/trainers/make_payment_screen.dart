import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/booking_repository.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/bookings_model.dart';
import 'package:zing_fitnes_trainer/screens/home/home_container.dart';
import 'package:zing_fitnes_trainer/screens/payments/default_credit_card_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class MakePaymentScreen extends StatefulWidget {
  MakePaymentScreen(this.userId, this.bookingModel, this.trainerInfo);
  final String userId;
  final TrainerProfileModel trainerInfo;
  final BookingsModel bookingModel;
  @override
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {

  bool loading = false;
  Widget otherInfo(title, content) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style: TextStyle(fontSize: 20, color: MyColors().textBlack)),
          Text(content,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: MyColors().textBlack))
        ],
      ),
    );
  }

  saveBookingAfterDuration(String customerId,double amount,Map bookingsMap) async {

    return  approveBookings(customerId,amount,widget.userId, bookingsMap);
  }

   approveBookings(String customerId,double amount,String userId,Map bookingMap){
    BookingRepository.instance().makeBookingPayment(customerId,amount,widget.userId, bookingMap).then((_){

      BookingRepository.instance().changeBookingStatus(widget.bookingModel.bookingId,bookingMap).then((_){
        setState(() {
          loading = false;
        });



        Navigator.of(context).pushReplacement(MaterialPageRoute(settings:  RouteSettings(name: '/HomeContainer'),
            builder: (context) =>  HomeContainer()));
      });


    });

  }

  @override
  Widget build(BuildContext context) {
    var colors = MyColors();
    Size size = MediaQuery.of(context).size;
    var defaultCard = Provider.of<DefaultCreditCardModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Payment',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          defaultCard == null
              ? SliverToBoxAdapter(
                  child: Container(),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: Color(0x802196F3),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 10.0,
                                  bottom: 30.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  defaultCard.cardType == Config.visa
                                      ? Image.asset('assets/images/visa.png')
                                      : Image.asset(
                                          'assets/images/mastercard.png'),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text("####,####," + defaultCard.cardNumber,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text("Owner",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)),
                                  ),
                                  Text(
                                      defaultCard.cardMonth.toString() +
                                          "/" +
                                          defaultCard.cardYear.toString(),
                                      style: TextStyle(
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
                ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.trainerInfo.name,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Container(
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: colors.deepBlue,
                        size: 30,
                      ),
                      title: Text(widget.trainerInfo.location),
                    ),
                  ),
                  Divider(),
                  Container(
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: colors.deepBlue,
                        size: 30,
                      ),
                      title: Text(widget.bookingModel.bookingDate),
                    ),
                  ),
                  Divider(),
                  otherInfo("Session type", widget.bookingModel.sessionType),
                  Divider(),
                  otherInfo("Speciality", widget.trainerInfo.speciality),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Session Cost",
                            style: TextStyle(
                                fontSize: 20, color: MyColors().textBlack)),
                        Text('\$' + widget.trainerInfo.sessionRate,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.red))
                      ],
                    ),
                  ),
             loading?   Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ) : Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: size.width / 2.5,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {


                              print("default card is"+defaultCard.customerId);

                              Map bookingMap = Map<String,dynamic>();


                              bookingMap[Config.bookingStatus] = Config.paid;
                              bookingMap[Config.paid] = true;
                              bookingMap[Config.customer] = defaultCard.customerId;
                              bookingMap[Config.updatedOn] = FieldValue.serverTimestamp();


                              print(' amount is '+widget.trainerInfo.sessionRate);
                              setState(() {
                                loading = true;
                              });
                              saveBookingAfterDuration(defaultCard.customerId,double.parse(widget.trainerInfo.sessionRate), bookingMap);




                            },
                            child: Text(
                              "Pay Now",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          width: size.width / 2.5,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {

                            Navigator.of(context).pop();



                            },
                            child: Text(
                              "Pay Later",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
