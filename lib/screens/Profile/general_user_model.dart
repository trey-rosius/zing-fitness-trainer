import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class GeneralUserModel{
  String userId;
  String name;
  String profilePicUrl;
  String userType,email;
  String latitude;
  String longitude;
  Timestamp createdOn;

  GeneralUserModel({this.userId, this.name, this.profilePicUrl, this.userType,this.email,this.createdOn,this.longitude,this.latitude});



  factory GeneralUserModel.fromFirestore(DocumentSnapshot docSnapShot){
    return GeneralUserModel(
      userId: docSnapShot.data[Config.userId],
      name: docSnapShot.data[Config.fullNames],
      email: docSnapShot.data[Config.email],
      profilePicUrl: docSnapShot.data[Config.profilePicUrl],
      userType: docSnapShot.data[Config.userType],
        latitude: docSnapShot.data[Config.latitude],
        longitude: docSnapShot.data[Config.longitude],
      createdOn: docSnapShot.data[Config.createdOn]

    );
  }
}