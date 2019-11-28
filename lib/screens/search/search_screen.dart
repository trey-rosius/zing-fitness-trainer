import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/search/search_item.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen(this.userId);
  final String userId;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  bool isLargeScreen = false;
  String filter;

  @override
  Widget build(BuildContext context) {
    var trainerUserList = Provider.of<List<TrainerProfileModel>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Search',style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),

      body: Stack(children: <Widget>[
        Flex(direction: Axis.vertical, children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 34.0, 16.0, 10.0),
            color: Theme
                .of(context)
                .accentColor,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white)
              ),
              autofocus: true,
              cursorColor: Colors.white,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,

                decoration: TextDecoration.none,
              ),
              onChanged: (String value) {
                setState(() {
                  filter = value;
                });
              },
            ),
          ),


          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: trainerUserList==null ? Container() : ListView.builder(itemBuilder: (context,index){
                return SearchItem(widget.userId,trainerUserList[index]);
              },
              itemCount: trainerUserList.length,)
            ),
          )
        ]),
      ]),
    );
  }
}
