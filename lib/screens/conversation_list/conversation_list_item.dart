
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:zing_fitnes_trainer/screens/Profile/general_user_model.dart';
import 'package:zing_fitnes_trainer/screens/chats/chat_screen.dart';
import 'package:zing_fitnes_trainer/screens/chats/chats_repository.dart';
import 'package:zing_fitnes_trainer/screens/chats/typing_model.dart';
import 'package:zing_fitnes_trainer/screens/conversation_list/conversation_item_model.dart';
class ConversationListItem extends StatelessWidget {
  ConversationListItem({this.userId,this.convoItem});
  final String userId;
  final ConversationItemModel convoItem;

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<GeneralUserModel>(context);



            return userProfile == null ? Container() : InkWell(
              onTap: (){
                print("pressed");

                  Navigator.push(
                      context,
                       MaterialPageRoute(
                        builder: (context) =>
                       MultiProvider(providers: [
                         StreamProvider<TypingModel>.value(value: ChatsRepository.instance().streamTyping(userId, userProfile.userId),catchError: (context,error){
                           print("error is "+error.toString());
                           return null;
                         },),
                         /*
                         StreamProvider<BlockedUserModel>.value(value: BlockedRepository.instance().haveIblockedFlyer(userId, userProfile.userId),catchError: (context,error){
                           print("error is "+error.toString());
                           return null;
                         },),
                         StreamProvider<BlockedMeModel>.value(value: BlockedRepository.instance().hasFlyerblockedMe(userId, userProfile.userId),catchError: (context,error){
                           print("error is "+error.toString());
                           return null;
                         },),
                         */
                       ],
                       child: ChatScreen(
                           senderId: userId,
                           receiverId: userProfile.userId,
                           receiverFirstName :userProfile.name

                       ),)



                      ));

              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),

                child:

                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            width: 60.0,
                            height: 60.0,
                            fit: BoxFit.cover,
                            imageUrl: userProfile.profilePicUrl ?? "",
                            placeholder: (context, url) =>
                           CircularProgressIndicator(),
                            errorWidget: (context, url, ex) => new Icon(Icons.error),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right:3.0),
                              child:
                                  Text(userProfile.name,style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold,color: Colors.black54,
                                  ),),
                                 // Text(userProfile.lastName,style: TextStyle(fontSize: 17.0,fontWeight:FontWeight.bold,color: Theme.of(context).primaryColor),),





                            ),

                            Text(convoItem.lastMessage,maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 18.0,
                                color: Colors.grey),),





                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top:2.0),
                          child: Text(convoItem.createdOn == null
                              ? ""
                              :
                          timeago.format(
                              convoItem.createdOn.toDate()),style: TextStyle(),
                          ),
                        ),
                      )






                    ],
                  ),

              ),
            );
          }






}
