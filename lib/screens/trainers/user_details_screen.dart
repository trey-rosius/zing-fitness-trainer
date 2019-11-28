import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/regular_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/user_booking_card.dart';

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen(this.userId,this.trainerInfo,this.bookingModel);
  final String userId;
  final TrainerProfileModel trainerInfo;
  final NewBookingModel bookingModel;
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('User Details',style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body:StreamProvider.value(value:ProfileProvider.instance().streamRegularUserProfile(widget.userId),
      catchError: (context,error){
        print(error.toString());
      },
      child: Consumer<RegularProfileModel>(
        builder: (_,value,child){
          return value==null ? Container() :  SingleChildScrollView(
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
                                Text('Height',style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark),),
                                Row(
                                  children: <Widget>[
                                    Text(value.height,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),),
                                    Text("CM",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Weight',style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColorDark),),
                              Row(
                                children: <Widget>[
                                  Text(value.weight,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                                  Text("KG",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
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
                    child: UserBookingsCard(widget.userId,value,widget.bookingModel),
                  )
                ],
              ),
            ),
          );
        },
      ),),
      bottomNavigationBar: Container(
        width: size.width/2,
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
        height:size.height/12 ,


        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Theme.of(context).primaryColorDark,
          
          onPressed: (){

        },
        child: Text("Accept",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),),
      ),
    );
  }
}
