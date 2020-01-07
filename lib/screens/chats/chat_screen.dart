import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_item_model.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_list.dart';
import 'package:zing_fitnes_trainer/screens/chats/chats_repository.dart';
import 'package:zing_fitnes_trainer/screens/chats/typing_model.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String receiverFirstName;

  ChatScreen({Key key, @required this.senderId, @required this.receiverId,@required this.receiverFirstName})
      : super(key: key);

  @override
  State createState() =>
       ChatScreenState(senderId: senderId, receiverId: receiverId,receiverFirstName:receiverFirstName);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {Key key, @required this.senderId, @required this.receiverId,@required this.receiverFirstName});

  String senderId;
  String receiverId;
  String userId;
  String receiverFirstName;
  String _filePath;
  final greyColor = Color(0xffaeaeae);
  bool update = false;
  String chatId="";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  SharedPreferences prefs;
 // var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  File imageFile;
  File audioFile;
  bool isLoading;
  String audioFilePath;
  String imageUrl;

  final TextEditingController textEditingController =
      new TextEditingController();
  ScrollController listScrollController;
  final FocusNode focusNode = new FocusNode();

  String fileExtension;


  @override
  void initState() {
    super.initState();

    if (senderId.hashCode <= receiverId.hashCode) {
      chatId = '$senderId-$receiverId';
    } else {
      chatId = '$receiverId-$senderId';
    }
    listScrollController = new ScrollController();
    isLoading = false;

    imageUrl = '';

    readLocal();



    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage 1: $message");
        print("onMessage 2: "+message['notification']['title']);
        print("onMessage 3: "+message['data']['username']);



        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

  }




  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(Config.userId) ?? '';


  }

  Future getImageFromCamera() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });

      var dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path + "/temp.png";

      compressAndGetFile(imageFile, targetPath).then((File result) {
        print("result is" + result.path);

        ChatsRepository.instance().uploadImage(result).then((String downloadUrl){
          print(downloadUrl);
          setState(() {
            isLoading = false;
            onSendImage(downloadUrl, Config.image);
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });

        });
      });

    } else
    {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });

      var dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path + "/temp.png";

      compressAndGetFile(imageFile, targetPath).then((File result) {
        print("result is" + result.path);

        ChatsRepository.instance().uploadImage(result).then((String downloadUrl){
          print(downloadUrl);
          setState(() {
            isLoading = false;
            onSendImage(downloadUrl, Config.image);
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });

        });
      });

    } else
      {
        setState(() {
          isLoading = false;
        });
      }
  }

  // 2. compress file and get file.
  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,

    );

    print(file.path);
    print(result.path);

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }



  void onSendImage(String downloadUrl, String type) {
    Map mapVisible = Map<String,bool>();
    mapVisible[senderId] = true;
    mapVisible[receiverId] = true;

    Map map = Map<String,dynamic>();

    map[Config.senderId] = senderId;
    map[Config.receiverId]= receiverId;
    map[Config.imageUrl] =  downloadUrl;
    map[Config.message]=type;
    map[Config.visible] = mapVisible;
    map[Config.createdOn]= FieldValue.serverTimestamp();
    map[Config.messageType] = type;

    ChatsRepository.instance().sendChat(map, chatId, senderId, receiverId, type).then((_){
      print("saved info");
    });
  }

  Future<Null> confirmBlock(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),


          child: AlertDialog(

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

            content: SingleChildScrollView(


                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Block this flyer?",style: TextStyle(
                          color: Theme.of(context).splashColor,fontSize: 30.0,fontFamily: 'GothamRnd',
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Now you would not be able to contact the flyer",style: TextStyle(
                          color: Colors.grey,fontSize: 16.0,fontFamily: 'GothamRnd',
                        ),),
                      ),

                      Image.asset('assets/images/block.png'),
                      Padding(
                        padding: const EdgeInsets.only(top:40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 200,
                              height: 50,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                color: Theme.of(context).splashColor,
                                child: new Text(
                                  "Confirm",
                                  style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: 'GothamRnd',),
                                ),
                                onPressed: () {
                                  /*
                                  Navigator.of(context).pop();
                                  Map map = Map<String,dynamic>();
                                  map[Config.userId] = widget.receiverId;
                                  map[Config.createdOn] = FieldValue.serverTimestamp();
                                  BlockedRepository.instance().blockUser(map, userId, widget.receiverId);
*/
                                  // checkUserType();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),

          ),
        );
      },
    );
  }


  void senderReceiver(String content, String type) {

    Map mapVisible = Map<String,bool>();
    mapVisible[senderId] = true;
    mapVisible[receiverId] = true;

    Map map = Map<String,dynamic>();

    map[Config.senderId] = senderId;
    map[Config.receiverId]= receiverId;
    map[Config.imageUrl] =  imageUrl;
    map[Config.message]=content;
    map[Config.visible] = mapVisible;
    map[Config.createdOn]= FieldValue.serverTimestamp();
    map[Config.messageType] = type;

    ChatsRepository.instance().sendChat(map, chatId, senderId, receiverId, content).then((_){
      print("saved info");
    });


  }

  void onSendMessage(String content, String type) {
    //type = audio,text,image
    if (content.trim() != '') {
      textEditingController.clear();
      ChatsRepository.instance().sendTyping(false, senderId, receiverId);

      senderReceiver(content.trim(), type);
      setState(() {
        update = true;
      });

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var typingIndicator = Provider.of<TypingModel>(context);
   // var blockedUser = Provider.of<BlockedUserModel>(context);
   // var blockedMe = Provider.of<BlockedMeModel>(context);
    /*
     if(blockedMe != null)
       {
         print("blocked userId: "+blockedUser.userId);
         print("blocked me userId: "+blockedMe.userId);
      }
      */
    final platform = Theme.of(context).platform;
  //  return blockedUser == null && blockedMe==null ? Scaffold(
    return  Scaffold(

      appBar:  AppBar(

        elevation: 0.0,
        backgroundColor: Colors.transparent,

        title: Text(receiverFirstName,style: TextStyle(fontSize: 20.0,fontFamily: 'GothamRnd')),
        actions: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: Icon(Icons.block,color: Theme.of(context).accentColor,), onPressed:()=>confirmBlock(context)),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: Icon(Icons.image,color: Theme.of(context).primaryColor,), onPressed: getImage),
          ),
        ],







      ),
      body:  Column(
        children: <Widget>[
          // List of messages
          // Container(),

          StreamProvider<List<ChatItemModel>>.value(value: ChatsRepository.instance().streamChats(userId,chatId),catchError: (context,error){
            print("error is "+error.toString());
            return null;
          },child:  ChatList(listScrollController: listScrollController,
            userId: userId,
            senderId: senderId,
            receiverId: receiverId,
            platform: platform,
            update: update,
            chatId: chatId,),),



          // Sticker

          // Input content
           buildInput(typingIndicator),
        ],
      ),
    );
    /*

        : (blockedUser !=null && blockedMe== null) ?
    Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,

        title: Text(receiverFirstName,style: TextStyle(fontSize: 20.0,fontFamily: 'GothamRnd')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: Icon(Icons.block,color: Theme.of(context).accentColor,), onPressed:()=>confirmBlock(context)),
          ),

        ],







      ),
      body:  Column(
        children: <Widget>[
          // List of messages
          // Container(),

          StreamProvider<List<ChatItemModel>>.value(value: ChatsRepository.instance().streamChats(userId,chatId),catchError: (context,error){
            print("error is "+error.toString());
            return null;
          },child:  ChatList(listScrollController: listScrollController,
            userId: userId,
            senderId: senderId,
            receiverId: receiverId,
            platform: platform,
            update: update,
            chatId: chatId,),),



          // Sticker


        ],
      ),
    )
        :  (blockedUser ==null && blockedMe != null) ?
    Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,

        title: Text(receiverFirstName,style: TextStyle(fontSize: 20.0,fontFamily: 'GothamRnd')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: Icon(Icons.block,color: Theme.of(context).accentColor,), onPressed:()=>confirmBlock(context)),
          ),

        ],







      ),
      body:  Column(
        children: <Widget>[
          // List of messages
          // Container(),

          StreamProvider<List<ChatItemModel>>.value(value: ChatsRepository.instance().streamChats(userId,chatId),catchError: (context,error){
            print("error is "+error.toString());
            return null;
          },child:  ChatList(listScrollController: listScrollController,
            userId: userId,
            senderId: senderId,
            receiverId: receiverId,
            platform: platform,
            update: update,
            chatId: chatId,),),




        ],
      ),
    )
        :
         Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,

        title: Text(receiverFirstName,style: TextStyle(fontSize: 20.0,fontFamily: 'GothamRnd')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: Icon(Icons.block,color: Theme.of(context).accentColor,), onPressed:()=>confirmBlock(context)),
          ),

        ],







      ),
     body:  Column(
       children: <Widget>[
         // List of messages
         // Container(),

         StreamProvider<List<ChatItemModel>>.value(value: ChatsRepository.instance().streamChats(userId,chatId),catchError: (context,error){
           print("error is "+error.toString());
           return null;
         },child:  ChatList(listScrollController: listScrollController,
             userId: userId,
             senderId: senderId,
             receiverId: receiverId,
             platform: platform,
             update: update,
         chatId: chatId,),),




       ],
     ),
    );
    */
  }



  Widget buildInput(TypingModel typingModel) {
    return
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

               typingModel ==null ? Container() :  typingModel.typing ?
          Container(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
    child:  Text("typing......",style: TextStyle(fontSize: 14.0,color: Theme.of(context).accentColor,fontStyle: FontStyle.italic),)



    ) : Container(),
                  /*
                  StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection(Config.typing)
                          .document(receiverId)
                          .collection(senderId)
                          .document(Config.typing)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {

                        if (snapshot.data != null && snapshot.data.exists) {
                          return
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                                  child: snapshot.data[Config.typing] ? Text("typing......",style: TextStyle(fontSize: 14.0,color: Colors.white,fontStyle: FontStyle.italic),) : Container()



                          );
                        }
                        else
                        {
                          return Container();
                        }


                      }),
                      */
                  isLoading ?
                  Container(
                      height: 20.0,
                      width: 20.0,
                      margin:EdgeInsets.only(right: 20.0),
                      child: CircularProgressIndicator())
                      : Container()
                ],
              ),
              Row(
                  children: <Widget>[
                    // Button send image
                     Container(
                       margin: EdgeInsets.only(left: 10.0),
                       decoration: BoxDecoration(
                           color: Theme.of(context).primaryColor,
                           shape: BoxShape.circle),
                       child: IconButton(
                            icon: new Icon(Icons.camera_alt),
                            onPressed: getImageFromCamera,
                            color: Colors.white,
                          ),
                     ),





                    // Edit text
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0),


                        child: Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: TextField(
                                maxLines: null,
                                onChanged: (String text) {
                                  if (text.trim().length > 0) {

                                    ChatsRepository.instance().sendTyping(true, senderId, receiverId);
                                  } else {

                                    ChatsRepository.instance().sendTyping(false, senderId, receiverId);

                                  }
                                },

                                style: TextStyle(color: Colors.black, fontSize: 15.0),
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  hintText: 'At 10:00pm in...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Button send message
                    Container(
                        margin: new EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: Center(
                          child: new IconButton(
                            icon: new Icon(Icons.arrow_forward),
                            onPressed: () => onSendMessage(
                                textEditingController.text, Config.text),
                            color: Colors.white,
                          ),
                        ),
                      ),

                  ],


    ),
            ],
          );
  }
}
