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
import 'package:zing_fitnes_trainer/screens/bookingsDetail/distance_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
class ProfileProvider extends ChangeNotifier{

  Firestore _firestore ;
  FirebaseStorage storage;

  ProfileProvider.instance() : _firestore = Firestore.instance,
        storage = FirebaseStorage.instance;

  DistanceModel _distanceModel;

  DistanceModel get distanceModel => _distanceModel;
  List<DistanceModel> _listDistanceModel = [];

  List<DistanceModel> get listDistanceModel =>_listDistanceModel;

  set listDistanceModel(val){
    _listDistanceModel.add(val);
    notifyListeners();
  }

  set distanceModel (val){
    _distanceModel = val;
    notifyListeners();
  }





  Future<String> uploadImage(var imageFile) async {


    var uuid = Uuid().v1();
    StorageReference ref = storage.ref().child(Config.users).child("profile_$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;


  }
  Future<String> uploadPdf(var imageFile) async {


    var uuid = Uuid().v1();
    StorageReference ref = storage.ref().child(Config.users).child("profile_$uuid.pdf");
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

  //update trainers session status
  Future<void> updateTrainerSession(String userId,bool value){

    return  _firestore.collection(Config.users).document(userId).updateData({
      Config.currentlyInSession:value
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
       .where(Config.sessionType,arrayContains:sessionType)
        .where(Config.presence,isEqualTo: true)
        .where(Config.currentlyInSession,isEqualTo: false)
        .snapshots()
        .map((list) =>
    list.documents.map((doc) => TrainerProfileModel.fromFirestore(doc)).toList());



  }

  /// Stream online trainers profiles
  ///
  Stream<List<TrainerProfileModel>> streamOnlineTrainersListSessionType(String sessionType){
    return _firestore.collection(Config.users)
        .where(Config.sessionType,arrayContains:sessionType)
        .where(Config.presence,isEqualTo: true)
        .snapshots()
        .map((list) =>
        list.documents.map((doc) => TrainerProfileModel.fromFirestore(doc)).toList());



  }

  Future<List<DistanceModel>> listDistance(List<TrainerProfileModel> trainerList,String longitude,String latitude) {

    for (int i = 0; i <= trainerList.length - 1; i++) {
      calculateDistance(trainerList[i], longitude, latitude).then((value) {
        print("this is the value" + value.toStringAsFixed(2));
        distanceModel =
            DistanceModel(distance: value, trainerId: trainerList[0].userId);

        listDistanceModel = distanceModel;
      });


      print("distance list" + listDistanceModel.toString());
      if(i == trainerList.length){
        break;
      }
    }
  }

  Future<double> calculateDistance(TrainerProfileModel trainerUserModel,String longitude,String latitude) async{
    final double startLatitude = double.parse(latitude);
    final double startLongitude = double.parse(longitude);
    final double endLatitude = double.parse(trainerUserModel.latitude);
    final double endLongitude = double.parse(trainerUserModel.longitude);

    final double distance = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    return distance;

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