
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_item.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_item_model.dart';


class ChatList extends StatefulWidget {
  ChatList(
      {this.senderId, this.receiverId, this.listScrollController, this.userId,this.platform,this.update,this.chatId});
  final String senderId;
  final userId;
  final String receiverId;
  ScrollController listScrollController;
  final bool update;
  final platform;
  final String chatId;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  var listMessage;

  SharedPreferences prefs;
  String userId;
  String receiverId;




  _scrollListener() {
    if (widget.listScrollController.offset >= widget.listScrollController.position.maxScrollExtent &&
        !widget.listScrollController.position.outOfRange) {



      print("reached bottom");





    }
    if (widget.listScrollController.offset <= widget.listScrollController.position.minScrollExtent &&
        !widget.listScrollController.position.outOfRange) {
      setState(() {
        print("reached top");

        //
      });
    }
  }



  void initState() {
    super.initState();

    widget.listScrollController.addListener(_scrollListener);




  }






  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var chatList = Provider.of<List<ChatItemModel>>(context);
    return chatList== null ?Container(
      
      child: Flexible(
        child: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor))),
      ),
    ) :Container(
      child: Flexible(
        child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {


                 return ChatItem(
                  index: index,
                 // onDelete: ()=>deleteMessage(index),
                  //  document: snapshot.data.documents[index],
                  listMessage: chatList,
                  userId: widget.userId,
                  senderId: widget.senderId,
                  receiverId: widget.receiverId,
                   chatId:widget.chatId
                );

                },
                itemCount: chatList.length,
                reverse: true,
                controller: widget.listScrollController,
              )


      ),
    );
  }
}

