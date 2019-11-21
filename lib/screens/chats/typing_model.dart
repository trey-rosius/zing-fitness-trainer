
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class TypingModel{
  bool typing;

  TypingModel(this.typing);

  factory TypingModel.fromFirestore(DocumentSnapshot snapshot){
    return snapshot.data != null && snapshot.exists ? TypingModel(snapshot[Config.typing]) : TypingModel(false);
  }


}