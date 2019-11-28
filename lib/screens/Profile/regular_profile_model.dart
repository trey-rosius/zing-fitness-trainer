import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class RegularProfileModel{
  String userId;
  String name;
  String phoneNumber;
  String profilePicUrl;

  String height,age,weight;
  String location;
  String email;
  String latitude;
  String longitude;


  RegularProfileModel({this.userId, this.name,this.weight, this.phoneNumber, this.height, this.age,
      this.location,this.profilePicUrl,this.email,this.latitude,this.longitude});

  factory RegularProfileModel.fromFirestore(DocumentSnapshot docSnapShot){

    return RegularProfileModel(
      userId: docSnapShot.data[Config.userId],
      name: docSnapShot.data[Config.fullNames],
      phoneNumber: docSnapShot.data[Config.phone],
      profilePicUrl: docSnapShot.data[Config.profilePicUrl],
      height: docSnapShot.data[Config.height]??"",
      age: docSnapShot.data[Config.age]??"",
      latitude: docSnapShot.data[Config.latitude]??"",
      longitude: docSnapShot.data[Config.longitude]??"",
      email: docSnapShot.data[Config.email]??"",
      weight: docSnapShot.data[Config.weight]??"",
      location: docSnapShot.data[Config.location]??"",


    );
  }


}