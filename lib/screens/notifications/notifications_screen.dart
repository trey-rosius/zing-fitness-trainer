import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/notifications/notification_item.dart';
import 'package:zing_fitnes_trainer/screens/notifications/notification_model.dart';
import 'package:zing_fitnes_trainer/screens/notifications/notifications_repository.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen(this.userId);
  final String userId;
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Notifications",
          style: TextStyle(fontSize: 20),),
        centerTitle: true,

      ),
      body: StreamProvider<List<NotificationModel>>.value(value: NotificationsRepository.instance().streamAllNotifications(widget.userId),
      child: Consumer<List<NotificationModel>>(
        builder: (_,value,child){
          return value !=null ? ListView.builder(itemBuilder: (context,index){
             return NotificationItem(value[index]);
          },itemCount:value.length ,): Container();
        },
      )),
    );

  }
}
