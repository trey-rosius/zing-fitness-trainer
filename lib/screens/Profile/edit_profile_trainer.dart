import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:zing_fitnes_trainer/components/button.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/modules/certificate_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/modules/pFootbg.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';
import 'package:zing_fitnes_trainer/screens/Profile/modules/profileInputField.dart';
import 'package:zing_fitnes_trainer/screens/Profile/modules/row_text_input.dart';

import 'package:zing_fitnes_trainer/screens/Profile/modules/user_certificate_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';

import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:zing_fitnes_trainer/utils/validator.dart';

class EditProfileTrainer extends StatelessWidget {
  EditProfileTrainer({this.userId,this.trainerProfileModel});
  final String userId;
  final TrainerProfileModel trainerProfileModel;

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: IconThemeData(color: MyColors().deepBlue, size: 40),
              backgroundColor: MyColors().skyBlue,
              title: Text(
                  "Edit Profile",

                  style: TextStyle(
                      color: MyColors().deepBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.w900),

              ),
              centerTitle: true,
            ),
            body: Container(
              color: MyColors().skyBlue,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FormSection(userId,trainerProfileModel),
                  ],
                ),
              ),
            ));
  }
}

class FormSection extends StatefulWidget {
  FormSection(this.userId,this.profileModel);
  final String userId;
  final TrainerProfileModel profileModel;


  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final Geolocator _geolocator = Geolocator();

  String longitude;
  String latitude;
  _saveLongitude(String longitude) async {
    final prefs =  await StreamingSharedPreferences.instance;


    prefs.setString(Config.longitude, longitude);
  }
  _saveLatitude(String latitude) async {
    final prefs =  await StreamingSharedPreferences.instance;


    prefs.setString(Config.latitude, latitude);
  }


  final GlobalKey<FormState> _regularFormKey = GlobalKey<FormState>();
  String phoneNumber;
  String serviceArea;
  String experience;
  String sessionRate;

  String _path;
  Map<String, String> _paths;
  String _extension='pdf';
  bool _loadingPath = false;

  //FileType _pickingType = FileType.CUSTOM;
  File file;
  var targetPath;
  Future<File> _imageFile;
  String profilePic;
  String _fileName;
  bool loading = false;
  String sessionType = 'Single';

  final  userNameController = TextEditingController();
  final  locationController = TextEditingController();
  final  phoneController = TextEditingController();
  final  experienceController = TextEditingController();
  final  sessionTypeController = TextEditingController();

  final  sessionRateController = TextEditingController();



  void _openFileExplorer() async {
    /*
   // if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {

          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);

      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {

        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';

        print("file name is"+ _fileName);
        print("file path is"+ _path);

        ProfileProvider.instance()
            .uploadImage(File(_path))
            .then((value) {
          Map userData = Map<String, dynamic>();

          userData[Config.certName] = _fileName;
          userData[Config.certUrl] = value;
          userData[Config.userId] = widget.userId;
          userData[Config.createdOn] = FieldValue.serverTimestamp();


          ProfileProvider.instance()
              .saveCertificate(widget.userId, userData)
              .then((_) {
                setState(() {
                  _loadingPath = false;
                });
            print("successfull");
          });
        });
      });
  //  }
  */
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      profilePic = widget.profileModel.profilePicUrl;
      userNameController.text = widget.profileModel.name;
      phoneController.text = widget.profileModel.phoneNumber;

      sessionType = widget.profileModel.sessionType == ""? sessionType : widget.profileModel.sessionType;
      experienceController.text = widget.profileModel.experience;
      locationController.text = widget.profileModel.location;

      sessionRateController.text = widget.profileModel.sessionRate;



    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();


    userNameController.dispose();
    locationController.dispose();
    phoneController.dispose();

    sessionTypeController.dispose();
    experienceController.dispose();

    sessionRateController.dispose();

  }

  void _onImageButtonPressed(ImageSource source) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
    );

    print(file.path);
    print(result.path);

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            file = snapshot.data;
            print("image file " + snapshot.data.toString());
            return InkWell(
              onTap: () => _onImageButtonPressed(ImageSource.gallery),
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: 100,
                  height: 100,
                  child: ClipOval(
                      child: Image.file(
                    snapshot.data,
                    fit: BoxFit.cover,
                  ))),
            );
          } else if (snapshot.error != null) {
            //  showInSnackBar("Error Picking Image");

            return InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.account_circle,
                  size: 100,
                ),
              ),
            );
          } else {
            //  showInSnackBar("You have not yet picked an image.");
            return InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.account_circle,
                  size: 100,
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    var userCertModel = Provider.of<List<UserCertificateModel>>(context);
    var colors = new MyColors();
    return SingleChildScrollView(
        child: Form(
          key: _regularFormKey,
          child:  Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    profilePic != null?

                   Center(
                     child:  ClipRRect(
                         borderRadius:
                         BorderRadius.circular(60),
                         child: CachedNetworkImage(
                           width: 100.0,
                           height: 100.0,
                           fit: BoxFit.cover,
                           imageUrl: profilePic??"",
                           placeholder: (context, url) =>
                               CircularProgressIndicator(),
                           errorWidget: (context, url, ex) =>
                               Icon(Icons.error),
                         )),
                   ) :

                    Center(
                      child: _previewImage(),
                    ),

                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),

                    ProfileInputField(
                      hintText: 'Trainer Name',
                      icon: Icons.account_circle,
                      controller: userNameController,
                      validator: (value) {
                        return Validator().textValidator(value);
                      },
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),
                    ProfileInputField(
                      hintText: 'Mobile number',
                      icon: Icons.phone_iphone,
                      controller: phoneController,

                      validator: (value) {
                        return Validator().textValidator(value);
                      },
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                    ),

                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),

                    Container(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 30,
                        5,
                        MediaQuery.of(context).size.width / 32,
                        0,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: colors.inputBlue,
                      ),




                      child: TextFormField(


                          validator: (value){return Validator().textValidator(value);},

                          controller: locationController,
                          maxLines: 3,


                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  0,
                                  MediaQuery.of(context).size.height / 40,
                                  0,
                                  MediaQuery.of(context).size.height / 40),
                              alignLabelWithHint: true,
                              icon: Icon(
                                Icons.location_on,
                                size: MediaQuery.of(context).size.width / 15,
                                color: colors.deepBlue,
                              ),
                              labelText: 'Session Area(Full Address)',
                              labelStyle: TextStyle(color: colors.deepBlue),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: colors.inputBlue),
                              ))),
                    ),



                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),


                    Container(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 30,
                        5,
                        MediaQuery.of(context).size.width / 32,
                        0,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: colors.inputBlue,
                      ),

                      child: TextFormField(
                          onChanged: ((value){

                          }),
                          validator: (value){return Validator().textValidator(value);},
                          //   initialValue: initialValue,
                          controller: sessionRateController,
                          keyboardType: TextInputType.number,

                          decoration: InputDecoration(

                              labelText: "Hourly Rates(\$)",
                            labelStyle: TextStyle(color: colors.deepBlue),
                              border: InputBorder.none,
                              )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 30,
                        5,
                        MediaQuery.of(context).size.width / 32,
                        0,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: colors.inputBlue,
                      ),

                      child: TextFormField(
                          onChanged: ((value){

                          }),
                          validator: (value){return Validator().textValidator(value);},
                          //   initialValue: initialValue,
                          controller: experienceController,
                          keyboardType: TextInputType.number,


                          decoration: InputDecoration(

                            labelText: "Years of Experience",
                            labelStyle: TextStyle(color: colors.deepBlue),
                            border: InputBorder.none,
                          )),
                    ),

                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Text("Session Type",style: TextStyle(fontSize: 20,color: Colors.white),),

                      DropdownButton<String>(
                        hint: Text(sessionType,style: TextStyle(color: colors.deepBlue),),


                        items: <String>['Single','Groups','Classes'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child:  Text(value,),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            sessionType = value;
                          });
                        },
                      ),
                    ],),

                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                         Text("Certificates",style: TextStyle(fontSize: 20,color: Colors.white),),
                         _loadingPath ? CircularProgressIndicator() : IconButton(icon: Icon(Icons.add_circle,size: 40,), onPressed: (){
                         _openFileExplorer();

                         })
                       ],
                     ),


                 userCertModel != null ?   ListView.builder(
                   shrinkWrap: true,
                   physics: ClampingScrollPhysics(),
                   itemBuilder: (context,index){
                      return StreamProvider.value(value: ProfileProvider.instance().streamCertificateDocument(userCertModel[index].certId),
                      catchError: (context,error){
                        print(error);
                      }, child: Consumer<CertificateModel>(
builder: (_,value,child){
  return value !=null ? ListTile(
    title: Text(value.certName),
    trailing: IconButton(icon: Icon(Icons.cancel,color: Colors.red,), onPressed: (){
      ProfileProvider.instance().deleteCertificateDocument(value.certId, widget.userId);
    }),
  ) : Container();
},
                        ),);
                    },
                    itemCount: userCertModel.length,) : Container(),

                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),


                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),


                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),


                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),

                    //Notes(hintText:'Notes'),

                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 50)),

                loading ?Center(
                  child: CircularProgressIndicator(),
                ) :   Button(
                        text: 'Update',
                        onClick: () async {
    if (_regularFormKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      final List<Placemark> placemarks = await Future(
              () => _geolocator.placemarkFromAddress(locationController.text))
          .catchError((onError) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(onError.toString()),
        ));
        return Future.value(List<Placemark>());
      });

      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];



        setState(() {
          longitude = pos.position?.longitude.toString();
          latitude = pos.position?.latitude.toString();

          _saveLatitude(latitude);
          _saveLongitude(longitude);
        });

      }
      if (file != null && profilePic == null) {
        var dir = await path_provider.getTemporaryDirectory();
        var targetPath = dir.absolute.path + "/temp.png";

        print("file image is" + file.path);
        compressAndGetFile(file, targetPath)
              .then((File result) {
            print("result is" + result.path);

            ProfileProvider.instance()
                .uploadImage(result)
                .then((value) {
              Map userData = Map<String, dynamic>();


              userData[Config.profilePicUrl] = value;
              userData[Config.fullNames] = userNameController.text;
              userData[Config.location] = locationController.text;
              userData[Config.experience] =experienceController.text;
              userData[Config.sessionType] =sessionType;
              userData[Config.longitude] =longitude;
              userData[Config.latitude] =latitude;

              userData[Config.phone] = phoneController.text;
              userData[Config.sessionRate] = sessionRateController.text;



              ProfileProvider.instance()
                  .saveUserData(widget.userId, userData)
                  .then((_) {
                print("successfull");

                setState(() {
                  loading = false;
                });

                Navigator.of(context).pop();
              });
            });
        });
      } else if(file == null && profilePic != null){

              Map userData = Map<String, dynamic>();


              userData[Config.profilePicUrl] = profilePic;
              userData[Config.fullNames] = userNameController.text;
              userData[Config.location] = locationController.text;
              userData[Config.experience] =experienceController.text;
              userData[Config.sessionType] =sessionType;
              userData[Config.longitude] =longitude;
              userData[Config.latitude] =latitude;

              userData[Config.phone] = phoneController.text;
              userData[Config.sessionRate] = sessionRateController.text;



              ProfileProvider.instance()
                  .saveUserData(widget.userId, userData)
                  .then((_) {
                print("successfull");

                setState(() {
                  loading = false;
                });
                Navigator.of(context).pop();
              });



      } else if(file == null && profilePic != null){

        var dir = await path_provider.getTemporaryDirectory();
        var targetPath = dir.absolute.path + "/temp.png";

        print("file image is" + file.path);
        compressAndGetFile(file, targetPath)
              .then((File result) {
            print("result is" + result.path);

            ProfileProvider.instance()
                .uploadImage(result)
                .then((value) {
              Map userData = Map<String, dynamic>();


              userData[Config.profilePicUrl] = value;
              userData[Config.fullNames] = userNameController.text;
              userData[Config.location] = locationController.text;
              userData[Config.sessionType] =sessionType;
              userData[Config.experience] = experienceController.text;
              userData[Config.longitude] =longitude;
              userData[Config.latitude] =latitude;
              userData[Config.phone] = phoneController.text;
              userData[Config.sessionRate] = sessionRateController.text;


              ProfileProvider.instance()
                  .saveUserData(widget.userId, userData)
                  .then((_) {
                print("successfull");

                setState(() {
                  loading = false;
                });
                Navigator.of(context).pop();
              });
            });
        });

      }else
        {
            setState(() {
              loading = false;
            });

            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              content: Text(
                  'Please add a profile picture'),
              duration: Duration(seconds: 3),
            ));
        }

    }
                        })
                        ,

                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 15),
                    ),

                    FootBgr()
                  ]),
          ),

        ),
      );

  }
}
