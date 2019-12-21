import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/general_user_model.dart';
import 'package:zing_fitnes_trainer/screens/notifications/notification_model.dart';

class NotificationItem extends StatelessWidget {
  NotificationItem(this.notificationModel);
  final NotificationModel notificationModel;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<GeneralUserModel>.value(value:ProfileProvider.instance().streamGeneralUserModel(notificationModel.senderId),
       child: Consumer<GeneralUserModel>(
       builder: (_,value,child){
         return value == null ? Container():
             Container(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Row(
                     children: <Widget>[
                       ClipRRect(
                           borderRadius:
                           BorderRadius.circular(60),
                           child: CachedNetworkImage(
                             width: 60.0,
                             height: 60.0,
                             fit: BoxFit.cover,
                             imageUrl: value.profilePicUrl??"",
                             placeholder: (context, url) =>
                                 CircularProgressIndicator(),
                             errorWidget: (context, url, ex) =>
                                 Icon(Icons.error),
                           )),
                       Expanded(
                         child: Padding(
                           padding: EdgeInsets.all(10.0),
                           child: Wrap(

                             children: <Widget>[
                               Text(value.name,style: TextStyle(fontSize: 20),),


                               Text(notificationModel.notificationText,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.red),)


                             ],
                           ),
                         ),
                       )
                     ],
                   ),
                   Divider()
                 ],
               ),
             );
       },),
    );
  }
}
