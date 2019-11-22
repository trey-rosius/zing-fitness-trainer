import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/payments/credit_cart_repository.dart';
import 'package:zing_fitnes_trainer/screens/payments/default_credit_card_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/bookingCard.dart';
import 'package:zing_fitnes_trainer/screens/trainers/make_payment_screen.dart';

class TrainerDetailsScreen extends StatefulWidget {
  TrainerDetailsScreen(this.userId,this.trainerInfo,this.bookingModel);
  final String userId;
  final TrainerProfileModel trainerInfo;
  final NewBookingModel bookingModel;
  @override
  _TrainerDetailsScreenState createState() => _TrainerDetailsScreenState();
}

class _TrainerDetailsScreenState extends State<TrainerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Trainer Booking Details',style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(bottom: 20),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Text('Start time',style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark),),
                       Row(
                         children: <Widget>[
                           Text(widget.bookingModel.startTime,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),),
                           Text(widget.bookingModel.startHr > 12 ? "PM":"AM",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                         ],
                       ),

                     ],
                   ),
                 ),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Text('End time',style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark),),
                     Row(
                       children: <Widget>[
                         Text(widget.bookingModel.endTime,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                         Text(widget.bookingModel.endHr > 12 ? "PM":"AM",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                       ],
                     ),

                   ],
                 )
                    ],
                  ),
                   Image.asset('assets/images/mng.png',fit: BoxFit.cover,width: size.width/2,)
                ],
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: BookingsCard(widget.userId,widget.trainerInfo,widget.bookingModel),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: size.width/2,
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
        height:size.height/12 ,


        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Theme.of(context).primaryColorDark,
          
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context)
                {
                  return StreamProvider<DefaultCreditCardModel>.value(
                    value:CreditCardRepository.instance().streamDefaultCreditCard(widget.userId) ,
                    catchError: (context,error){
                      print(error);
                      return null;
                    },
                    child: MakePaymentScreen(widget.userId,  widget.bookingModel,widget.trainerInfo),
                  );
                  // return UserDetailsScreen(userId, trainerInfo, bookingModel);
                })
              //  child: ProfileRegularUser();

            );

        },
        child: Text("Request",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),),
      ),
    );
  }
}
