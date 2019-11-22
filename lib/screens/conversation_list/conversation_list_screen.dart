
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/general_user_model.dart';
import 'package:zing_fitnes_trainer/screens/conversation_list/conversation_item_model.dart';
import 'package:zing_fitnes_trainer/screens/conversation_list/conversation_list_item.dart';
class ConversationListScreen extends StatelessWidget {
ConversationListScreen(this.userId);
final String userId;


  @override
  Widget build(BuildContext context) {
    var convoList = Provider.of<List<ConversationItemModel>>(context);
    print("this is it"+convoList.toString());
    return convoList == null ? Scaffold(
      appBar: AppBar(
        title: Text('Conversation List',style: TextStyle(fontSize: 20),),
        centerTitle: true,

      ),
    ) : Scaffold(
        appBar: AppBar(
          title: Text('Conversation List',style: TextStyle(fontSize: 20),),
          centerTitle: true,

        ),

      body:  ListView.builder(

                  itemCount: convoList.length,
                  itemBuilder: (_, int index)
                  {
                    final convoItem = convoList[index];
                    return  StreamProvider<GeneralUserModel>.value(value: ProfileProvider.instance().streamGeneralUserModel(convoItem.userId),catchError: (context,error){
                      print("error is "+error.toString());
                      return null;
                    },child:ConversationListItem(userId:userId,convoItem:convoItem));
                  })


    );
  }
}
