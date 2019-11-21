
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class ChatItemModel{
String messageId;
String senderId;
String receiverId;
String messageType;
String imageUrl;
Map<String,bool> visible;

Timestamp createdOn;
String messageText;


ChatItemModel({this.messageId, this.senderId, this.receiverId, this.messageType,
    this.imageUrl, this.visible,
    this.createdOn, this.messageText});

factory ChatItemModel.fromFirestore(DocumentSnapshot doc){

  return ChatItemModel(
    messageId: doc[Config.messageId],
    senderId: doc[Config.senderId],
    receiverId: doc[Config.receiverId],
    messageText: doc[Config.message],
    messageType: doc[Config.messageType],
    createdOn: doc[Config.createdOn],
    imageUrl: doc[Config.imageUrl],

    visible:Map<String, bool>.from(doc[Config.visible])

  );
}


}