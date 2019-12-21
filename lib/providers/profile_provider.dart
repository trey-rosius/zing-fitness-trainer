import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:zing_fitnes_trainer/screens/Profile/general_user_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/modules/certificate_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/modules/user_certificate_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/regular_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
class ProfileProvider extends ChangeNotifier{

  Firestore _firestore ;
  FirebaseStorage storage;

  ProfileProvider.instance() : _firestore = Firestore.instance,
        storage = FirebaseStorage.instance;




  Future<String> uploadImage(var imageFile) async {


    var uuid = Uuid().v1();
    StorageReference ref = storage.ref().child(Config.users).child("profile_$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;


  }

  Future<void> saveCertificate(String userId,Map certDataMap){

    return  _firestore.collection(Config.certificates).add(certDataMap).then((DocumentReference docRef){

      _firestore.collection(Config.certificates).document(docRef.documentID).updateData({
        Config.certId:docRef.documentID
      }).then((_){
        _firestore.collection(Config.users).document(userId).collection(Config.userCertificates).document(docRef.documentID).setData({
          Config.certId:docRef.documentID
        });
      });

    });


  }

  Future<void> updateAdminPresence(String userId,bool value){

    return  _firestore.collection(Config.users).document(userId).updateData({
      Config.presence:value
    });


  }


  Future<void> saveUserData(String userId,Map userDataMap){

    return _firestore.collection(Config.users).document(userId).setData(userDataMap,merge: true).then((_){
      print("successful");
    });
  }

  /// Stream trainers profiles
  ///
  Stream<List<TrainerProfileModel>> streamTrainersListSessionType(String sessionType){
    return _firestore.collection(Config.users)
       .where(Config.sessionType,isEqualTo:sessionType )
        .snapshots()
        .map((list) =>
    list.documents.map((doc) => TrainerProfileModel.fromFirestore(doc)).toList());



  }

  /// Stream online trainers profiles
  ///
  Stream<List<TrainerProfileModel>> streamOnlineTrainersListSessionType(String sessionType){
    return _firestore.collection(Config.users)
        .where(Config.sessionType,isEqualTo:sessionType)
        .where(Config.presence,isEqualTo: true)
        .snapshots()
        .map((list) =>
        list.documents.map((doc) => TrainerProfileModel.fromFirestore(doc)).toList());



  }

  /// Stream trainers profiles
  ///
  Stream<List<TrainerProfileModel>> streamTrainersList(){
    return _firestore.collection(Config.users)
          .where(Config.userType,isEqualTo: Config.trainer)

        .snapshots()
        .map((list) =>
        list.documents.map((doc) => TrainerProfileModel.fromFirestore(doc)).toList());



  }

  Future<double> calculateDistance(TrainerProfileModel trainerUserModel,String longitude,String latitude) async{
    final double startLatitude = double.parse(latitude);
    final double startLongitude = double.parse(longitude);
    final double endLatitude = double.parse(trainerUserModel.latitude);
    final double endLongitude = double.parse(trainerUserModel.longitude);

    final double distance = await Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    return distance;

  }

  /// Get a stream of a single trainer profile document
  Stream<TrainerProfileModel> streamTrainerUserProfile(String userId) {
    return _firestore
        .collection(Config.users).document(userId)

        .snapshots()

        .map((snap) {
      print(snap.data.toString());
      return TrainerProfileModel.fromFirestore(snap);
    });
  }

  /// Get a stream of a regular user profile document
  Stream<RegularProfileModel> streamRegularUserProfile(String userId) {
    return _firestore
        .collection(Config.users).document(userId)

        .snapshots()

        .map((snap) {
      print(snap.data.toString());
      return RegularProfileModel.fromFirestore(snap);
    });
  }

  /// Get a stream of a general user profile document
  Stream<GeneralUserModel> streamGeneralUserModel(String userId) {
    return _firestore
        .collection(Config.users).document(userId)

        .snapshots()

        .map((snap) {
      print(snap.data.toString());
      return GeneralUserModel.fromFirestore(snap);
    });
  }

  /// Get a stream of all user certificates
  Stream<List<UserCertificateModel>> streamUserCerts(String userId){
    return  _firestore
        .collection(Config.users)
        .document(userId)
        .collection(Config.userCertificates)
        .snapshots()
        .map((list) =>
        list.documents.map((doc) => UserCertificateModel.fromFirestore(doc)).toList());



  }

  /// stream single certificate document
  Stream<CertificateModel> streamCertificateDocument(String certId) {
    return _firestore
        .collection(Config.certificates).document(certId)

        .snapshots()

        .map((snap) {
      print(snap.data.toString());
      return CertificateModel.fromFirestore(snap);
    });
  }

  /// delete single certificate document
  Future<void> deleteCertificateDocument(String certId,String userId) {
    return _firestore
        .collection(Config.certificates).document(certId).delete().then((_){
          _firestore.collection(Config.users).document(userId).collection(Config.userCertificates)
              .document(certId).delete();
    });


  }


}