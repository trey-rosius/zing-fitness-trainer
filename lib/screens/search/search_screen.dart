import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/search/search_filter_screen.dart';
import 'package:zing_fitnes_trainer/screens/search/search_item.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen(this.userId,this.longitude,this.latitude);
  final String userId;
  final String longitude;
  final String latitude;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  bool isLargeScreen = false;
  String filter;
  bool applyFilter = false;
  String longitude,latitude;
  String sessionType = "Single";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("longitude is"+widget.longitude);
    print("latitude is"+widget.latitude);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Search',style: TextStyle(fontSize: 20),),
        centerTitle: true,

        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:IconButton(icon: Icon(Icons.filter_list), onPressed: ()async{
             final result = await Navigator.push(
                context,
                MaterialPageRoute(

                  builder: (context) => SearchFilterScreen(),
                ),
              );
            if(result != null) {
              setState(() {
                applyFilter = true;
                if (result[Config.hasGeo]) {
                  sessionType = result[Config.sessionType];
                  longitude = result[Config.longitude];
                  latitude = result[Config.latitude];
                  print(result);
                  print(result[Config.longitude]);
                  print(result[Config.latitude]);
                  print(result[Config.sessionType]);
                } else {
                  print(result);
                  sessionType = result[Config.sessionType];
                  longitude = widget.longitude;
                  latitude = widget.latitude;
                  print(result[Config.sessionType]);
                }
              });
            } else
              {
                print("nothing returned");
              }





            })


          )
        ],
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


         applyFilter ?Expanded(
           child: StreamProvider.value(value: ProfileProvider.instance().streamTrainersListSessionType(sessionType),
             catchError: (context,error){
               print(error);
             },
             child: Consumer<List<TrainerProfileModel>>(
               builder: (_,value,child){
                 return Container(
                     padding: EdgeInsets.symmetric(vertical: 10.0),
                     child: value==null ? Container() : ListView.builder(itemBuilder: (context,index){
                       return SearchItem(widget.userId,value[index],longitude,latitude);
                     },
                       itemCount: value.length,)
                 );
               },
             ),),
         ) :
         Expanded(
            child: StreamProvider.value(value: ProfileProvider.instance().streamTrainersList(),
            catchError: (context,error){
              print(error);
            },
            child: Consumer<List<TrainerProfileModel>>(
              builder: (_,value,child){
                return Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: value==null ? Container() : ListView.builder(itemBuilder: (context,index){
                      return SearchItem(widget.userId,value[index],widget.longitude,widget.latitude);
                    },
                      itemCount: value.length,)
                );
              },
            ),),
          )
        ]),
      ]),
    );
  }
}
