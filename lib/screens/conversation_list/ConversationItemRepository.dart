
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/screens/conversation_list/conversation_item_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class ConversationItemRepository extends ChangeNotifier {

  Firestore _firestore;

  FirebaseStorage storage;

  ConversationItemRepository.instance()
      : _firestore = Firestore.instance,
        storage = FirebaseStorage.instance;




  Stream<List<ConversationItemModel>> streamUserConversationList(String userId){
    return  _firestore
        .collection(Config.users).document(userId)
        .collection(Config.chatList)
        .orderBy(Config.createdOn,descending: true)
        .snapshots()

        .map((list){
           print("this list is "+list.toString());
          return list.documents.map((doc) => ConversationItemModel.fromFirestore(doc)).toList();
    }
      );



  }


}