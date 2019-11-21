
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_item_model.dart';
import 'package:zing_fitnes_trainer/screens/chats/typing_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class ChatsRepository extends ChangeNotifier {

  Firestore _firestore;

  FirebaseStorage storage;

  ChatsRepository.instance()
      : _firestore = Firestore.instance,
        storage = FirebaseStorage.instance;


  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    StorageReference ref = storage.ref().child(Config.users).child("$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }

  Future<void> sendChat(Map<String, dynamic> messageContent, String chatId,
      String senderId, String receiverId, String lastMessage) {
    return _firestore
        .collection(Config.chats)
        .document(chatId)
        .collection(Config.chatThread).add(messageContent).then((
        DocumentReference doc) {
      String docId = doc.documentID;
      _firestore
          .collection(Config.chats)
          .document(chatId)
          .collection(Config.chatThread)
          .document(docId)
          .updateData({Config.messageId: docId});

      _firestore.collection(Config.users).document(senderId).collection(
          Config.chatList).document(receiverId).setData({
        Config.userId: receiverId,
        Config.lastMessage: lastMessage,
        Config.createdOn: FieldValue.serverTimestamp()
      }, merge: true);
      _firestore.collection(Config.users).document(receiverId).collection(
          Config.chatList).document(senderId).setData({
        Config.userId: senderId,
        Config.lastMessage: lastMessage,
        Config.createdOn: FieldValue.serverTimestamp()
      }, merge: true);
    },);
  }


  Future<void> sendTyping(bool typing, String senderId, String receiverId) {
    return _firestore
        .collection(Config.typing)
        .document(senderId)
        .collection(receiverId)
        .document(Config.typing)
        .setData({Config.typing: typing});
  }

  Future<void>deleteLeftMessage(Map<String,bool> messageVisible,String chatId,String messageId){

    return _firestore.collection(Config.chats).document(chatId).collection(Config.chatThread).document(messageId)
        .updateData({
      Config.visible:messageVisible
    }).then((_){
      print("done");
      notifyListeners();
    });


  }




  Future<void>deleteRightMessage(Map<String,bool> messageVisible,String chatId,String messageId){


    return _firestore.collection(Config.chats).document(chatId).collection(Config.chatThread).document(messageId)
        .updateData({

      Config.visible:messageVisible
    }).then((_){
      print("done");
      notifyListeners();
    });


  }



  /// Get a stream of a single document
  Stream<TypingModel> streamTyping(String senderId, String receiverId) {
    return _firestore
        .collection(Config.typing)
        .document(receiverId)
        .collection(senderId)
        .document(Config.typing)
        .snapshots()
        .map((snap) {
      print(snap.data.toString());
      return TypingModel.fromFirestore(snap);
    });
  }


  Stream<List<ChatItemModel>> streamChats(String userId,String chatId){
    return  _firestore
        .collection(Config.chats)
        .document(chatId)
        .collection(Config.chatThread)
        .orderBy(Config.messageId, descending: true)

        .limit(10000)
        .snapshots()

        .map((list){
      print("this list is "+list.toString());
      return list.documents.map((doc) => ChatItemModel.fromFirestore(doc)).toList();
    }
    );



  }

}