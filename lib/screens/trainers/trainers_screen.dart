import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/trainer_user_item.dart';

class TrainersScreen extends StatefulWidget {
  TrainersScreen(this.userId);
  final String userId;
  @override
  _TrainersScreenState createState() => _TrainersScreenState();
}

class _TrainersScreenState extends State<TrainersScreen> {
  @override
  Widget build(BuildContext context) {
    var trainerList = Provider.of<List<TrainerProfileModel>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainers',style: TextStyle(fontSize: 20),),
        centerTitle: true,

      ),
      body: trainerList == null ? Container() : ListView.builder(itemBuilder: (context,index){
        return TrainerUserItem(trainerInfo: trainerList[index],);
      },
      itemCount: trainerList.length,),

    );
  }
}
