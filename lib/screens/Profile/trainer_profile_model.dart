import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class TrainerProfileModel{
  String userId;
  String name;
  String phoneNumber;
  String serviceArea;
  String experience;
  String sessionRate;
  String profilePicUrl;
  String speciality;
  String sessionType,email,location;
  String longitude,latitude;
  bool userPresence;


  TrainerProfileModel({this.userId, this.name, this.phoneNumber,
      this.serviceArea, this.experience, this.sessionRate, this.profilePicUrl,
      this.speciality, this.sessionType,this.userPresence,this.email,this.location,this.latitude,this.longitude});

  factory TrainerProfileModel.fromFirestore(DocumentSnapshot docSnapShot){

    return TrainerProfileModel(
      userId: docSnapShot.data[Config.userId],
      name: docSnapShot.data[Config.fullNames],
      email: docSnapShot.data[Config.email],
      userPresence: docSnapShot.data[Config.presence]??true,
      phoneNumber: docSnapShot.data[Config.phone]??"",
      profilePicUrl: docSnapShot.data[Config.profilePicUrl]??null,
      latitude: docSnapShot.data[Config.latitude],
      longitude: docSnapShot.data[Config.longitude],

      sessionType: docSnapShot.data[Config.sessionType]??"",

      speciality: docSnapShot.data[Config.speciality]??"",
      sessionRate: docSnapShot.data[Config.sessionRate]??"",
      experience: docSnapShot.data[Config.experience]??"",
      serviceArea: docSnapShot.data[Config.serviceArea]??"",
      location: docSnapShot.data[Config.location]??"",




    );
  }


}