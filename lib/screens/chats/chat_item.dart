

import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:timeago/timeago.dart' as timeago;
import 'package:zing_fitnes_trainer/screens/chats/chat_item_model.dart';
import 'package:zing_fitnes_trainer/screens/chats/chats_repository.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/view_image.dart';

class ChatItem extends StatefulWidget {
  ChatItem(
      {Key key,
      // @required this.document,

      @required this.userId,
      @required this.senderId,
      @required this.receiverId,
      this.listMessage,
        this.chatId,
      this.index})
      : super(key: key);
  // final DocumentSnapshot document;
  final String userId;
  List<ChatItemModel> listMessage;
  final String chatId;
  final int index;
  final String senderId;
  final String receiverId;

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool _isLoading;
  bool _permissisonReady;
  String _localPath;
  var status, progress;
  String downId;

  void initState() {
    super.initState();
      print("senderId =" +widget.senderId);
      print("receiverId = "+widget.receiverId);
    _isLoading = true;
  }


  Future<Null> chatOptions(BuildContext context, String messageId, bool left) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

          content: SingleChildScrollView(


              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Delete message?",style: TextStyle(
                      fontSize: 18.0
                  ),),
                ),
              )
          ),
          actions: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Theme.of(context).accentColor,
                child: new Text(
                  "No",
                  style: TextStyle(fontSize: 14.0,color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();


                  // checkUserType();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Theme.of(context).accentColor,
                child: new Text(
                  "Yes",
                  style: TextStyle(fontSize: 14.0,color: Colors.white),
                ),
                onPressed: () {

                  Map map = Map<String,bool>();
                  map[widget.senderId] = false;
                  map[widget.receiverId] = true;

                  Navigator.of(context).pop();
                  left?
                      ChatsRepository.instance().deleteLeftMessage(map, widget.chatId, messageId)
                   :
                  ChatsRepository.instance().deleteRightMessage(map, widget.chatId, messageId);



                  // checkUserType();
                },
              ),
            ),

          ],
        );
      },
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            widget.listMessage != null &&
            widget.listMessage[index - 1].receiverId ==
                widget.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            widget.listMessage != null &&
            widget.listMessage[index - 1].receiverId !=
                widget.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildItem(BuildContext context) {


    if (widget.listMessage[widget.index].receiverId !=
        widget.senderId) {
      return widget.listMessage[widget.index].visible[widget.senderId]?
      // Right (my message)
       Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          widget.listMessage[widget.index].messageType == Config.text
              // Text
              ? InkWell(
                  onLongPress: () {
                    chatOptions(context,widget.listMessage[widget.index].messageId, false);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 200.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.listMessage[widget.index].messageText,
                              style: TextStyle(color: Colors.white,fontFamily: 'GothamRnd',fontSize: 16),
                            ),

                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),

                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,

                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                        margin: EdgeInsets.only(bottom: 5.0, right: 10.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom:10.0,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.listMessage[widget.index].createdOn ==
                                  null
                                  ? ""
                                  : timeago.format(
                                  DateTime.fromMillisecondsSinceEpoch(widget
                                      .listMessage[widget.index].
                                  createdOn
                                      .millisecondsSinceEpoch)),
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 15.0,fontFamily: 'GothamRnd'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : widget.listMessage[widget.index].messageType ==
                      Config.image
                  ?
                  // Image
                  InkWell(
                      onLongPress: () {
                        chatOptions(context,widget.listMessage[widget.index].messageId, false);
                      },

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewImageScreen(
                                    tag: widget.listMessage[widget.index].messageId,
                                    imageUrl: widget.listMessage[widget.index].imageUrl,
                                  )),
                        );
                      },
                      child: Container(
                        width: 200.0,
                        child:
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Material(
            child: Hero(
              tag: widget.listMessage[widget.index].messageId,
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<
                        Color>(
                        Theme.of(context).accentColor),
                  ),
                  width: 200.0,
                  height: 200.0,
                  padding: EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Material(
                      child: Image.asset(
                        'images/img_not_available.jpeg',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                imageUrl: widget.listMessage[widget.index].imageUrl,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
            borderRadius:
            BorderRadius.all(Radius.circular(8.0)),
            clipBehavior: Clip.hardEdge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                widget.listMessage[widget.index].createdOn ==
                    null
                    ? ""
                    : timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        widget
                            .listMessage[widget.index].createdOn
                            .millisecondsSinceEpoch)),
                style: TextStyle(
                    color: Colors.grey, fontSize: 15.0,fontFamily: 'GothamRnd'),
              ),
              /*
                                    Text(
                                      widget.listMessage[widget.index][Config.createdOn] ==
                                              null
                                          ? ""
                                          : DateFormat('kk:mm - yyyy-MM-dd').format(
                                              widget.listMessage[widget.index][
                                                  Config.createdOn]),
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 12.0),
                                    ),
                                    */
            ],
          ),
        ],
      ),




                        margin: EdgeInsets.only(
                            bottom:
                                isLastMessageRight(widget.index) ? 20.0 : 10.0,
                            right: 10.0),
                      ))
                  : Container(),

        ],
      ) : Container();
    } else {
      // Left (peer message)
      return widget.listMessage[widget.index].visible[widget.senderId] ?

        InkWell(
        onLongPress: (){
          chatOptions(context,widget.listMessage[widget.index].messageId, true);
        },
        child: Container(

          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection(Config.users)
                          .document(
                              widget.listMessage[widget.index].senderId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return InkWell(

                            onTap: () {



                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context).accentColor),
                                        ),
                                        width: 50.0,
                                        height: 50.0,
                                        padding: EdgeInsets.all(10.0),
                                      ),
                                  imageUrl: snapshot.data[Config.profilePicUrl],
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                  widget.listMessage[widget.index].messageType ==
                          Config.text
                      ? InkWell(
                          onTap: () {
                            /*
                            chatOptions(context,
                              widget.listMessage[widget.index][Config.FIREBASE_IMAGE], true),
                             */
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 200.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.listMessage[widget.index].messageText,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,fontSize: 16,fontFamily: 'GothamRnd'),
                                    ),

                                  ],
                                ),
                                padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),

                                decoration: BoxDecoration(
                                    color: Color(0xFFdeeffc),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15))),
                                margin: EdgeInsets.only(left: 10.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    widget.listMessage[widget.index].createdOn ==
                                        null
                                        ? ""
                                        : timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            widget
                                                .listMessage[widget.index].createdOn
                                                .millisecondsSinceEpoch)),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,fontFamily: 'GothamRnd'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : widget.listMessage[widget.index].messageType ==
                              Config.image
                          ? Container(
                              width: 200.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onLongPress: () {
                                      chatOptions(context,widget.listMessage[widget.index].messageId, true);
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewImageScreen(
                                                  tag: widget.listMessage[widget
                                                      .index].messageId,
                                                  imageUrl: widget.listMessage[
                                                          widget.index].imageUrl,
                                                )),
                                      );
                                    },
                                    child: Material(
                                      child: Hero(
                                        tag: widget.listMessage[widget.index].messageId,
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                                child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .accentColor),
                                                ),
                                                width: 200.0,
                                                height: 200.0,
                                                padding: EdgeInsets.all(70.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0),
                                                  ),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Material(
                                                child: Image.asset(
                                                  'images/img_not_available.jpeg',
                                                  width: 200.0,
                                                  height: 200.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                              ),
                                          imageUrl:
                                              widget.listMessage[widget.index].imageUrl,
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        widget.listMessage[widget.index].createdOn ==
                                                null
                                            ? ""
                                            : timeago.format(DateTime
                                                .fromMillisecondsSinceEpoch(widget
                                                    .listMessage[widget.index].createdOn
                                                    .millisecondsSinceEpoch)),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(left: 10.0),
                            )
                          : Container()
                ],
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        ),
      ) :Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildItem(context);
  }
}
