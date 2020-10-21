import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';
import 'package:zing_fitnes_trainer/utils/validator.dart';

class SearchFilterScreen extends StatefulWidget {
  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String sessionType = "Single";
  final  locationController = TextEditingController();
  final Geolocator _geolocator = Geolocator();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var colors =  MyColors();
  String longitude,latitude;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.close), onPressed: (){
          Navigator.of(context).pop();
        }),
        title: Text('Filter',style: TextStyle(fontSize: 20),),
        centerTitle: true,

      ),

      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[

              Container(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 30,
                  5,
                  MediaQuery.of(context).size.width / 32,
                  0,
                ),





                child: TextFormField(


                    validator: (value){return Validator().textValidator(value);},

                    controller: locationController,
                    maxLines: 3,


                    decoration: InputDecoration(

                        alignLabelWithHint: true,

                        labelText: 'Session Area(Full Address)',
                        labelStyle: TextStyle(color: colors.deepBlue),
                       // border: InputBorder.none,
                       )),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Session Type",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColorDark),),),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButton<String>(
                        hint: Text(sessionType,style: TextStyle(fontSize: 17,color: Theme.of(context).primaryColor),),


                        items: <String>['Single','Groups','Classes'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child:  Text(value,style: TextStyle(color: Theme.of(context).primaryColor),),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            sessionType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

             loading ? Container(
               padding: EdgeInsets.all(10),
               child: CircularProgressIndicator(),
             ): Container(
                width: size.width/2,
                height: size.height/10,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).primaryColorDark,
                  onPressed: () async{
                    if(locationController.text.trim().length > 0)
                      {


                        setState(() {
                          loading = true;
                        });
                      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                      if(position == null){

                          setState(() {
                            loading = false;
                            longitude = position?.longitude.toString();
                            latitude = position?.latitude.toString();



                            Navigator.pop(context,{
                              Config.longitude:longitude,
                              Config.latitude:latitude,
                              Config.sessionType:sessionType,
                              Config.hasGeo:true
                            }

                            );
                          });



                        }

                      }else
                        {
                          Navigator.pop(context,{
                          Config.longitude:longitude,
                          Config.latitude:latitude,
                          Config.sessionType:sessionType,
                          Config.hasGeo:false
                          });
                        }


                },child: Text("Apply",style: TextStyle(fontSize: 20,color: Colors.white),),),
              )
            ],
          ),
        ),
      )
    );
  }
}
