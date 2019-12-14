import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class NotificationsRepository extends ChangeNotifier{

  Firestore _firestore ;


  NotificationsRepository.instance() : _firestore = Firestore.instance;


  Future<void>saveNotification(Map notificationMap){
    return _firestore.collection(Config.notifications).add(notificationMap).then((DocumentReference documentReference)=>{
      _firestore.collection(Config.notifications).document(documentReference.documentID).updateData({
        Config.notificationId:documentReference.documentID
      })
    });
  }


}