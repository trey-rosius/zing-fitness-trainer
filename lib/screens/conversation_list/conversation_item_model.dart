
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class ConversationItemModel {
  String userId;
  String lastMessage;

  Timestamp createdOn;


  ConversationItemModel({this.userId, this.createdOn,this.lastMessage});

  factory ConversationItemModel.fromFirestore(DocumentSnapshot doc){

    print("this doc is "+doc[Config.userId]);

    return ConversationItemModel(
      userId: doc[Config.userId],
      lastMessage: doc[Config.lastMessage],

      createdOn: doc[Config.createdOn]

    );
        }


}