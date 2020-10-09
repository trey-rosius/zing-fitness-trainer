import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/modules/certificate_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/modules/user_certificate_model.dart';
import 'package:zing_fitnes_trainer/screens/Profile/pdf_viewer.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class CertificateScreen extends StatefulWidget {
  CertificateScreen(this.userId);
  final String userId;

  @override
  _CertificateScreenState createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  bool _isLoading = true;


  String _extension='pdf';
  bool _loadingPath = false;
  bool _multiPick = false;

  String _directoryPath;
  var targetPath;

  String profilePic;
  String _fileName;
  FileType _pickingType = FileType.custom;


  File _path;

  bool loading = false;
  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _path = (await FilePicker.getFile(
        type: _pickingType,

        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ));

    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {

      _loadingPath = true;
      _fileName = _path != null ? _path.path.split('/').last :"certificate";


      if(_path != null) {

         showDialog(context: context,
             builder: (context)=> SimpleDialog(

               children: [
                 Text("Uploading ... please wait",style: TextStyle(fontSize: 20),)
               ],
               contentPadding: EdgeInsets.all(20),
             ));

        print("file name is" + _fileName);
        print("_path is" + _path.path.toString());

        ProfileProvider.instance()
            .uploadPdf(_path)
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
              Navigator.of(context).pop();
            });
            print("successfull");
          });
        });
      }else
      {
        _loadingPath = false;

      }
    });

  }
  @override
  Widget build(BuildContext context) {
    var userCertModel = Provider.of<List<UserCertificateModel>>(context);
    return Scaffold(
      appBar: AppBar(



        title: Text(
          "Certificates",

          style: TextStyle(

              fontSize: 17,
              fontWeight: FontWeight.w900),

        ),
        centerTitle: true,
      ),
      body: userCertModel != null ?SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index){
              return StreamProvider.value(value: ProfileProvider.instance().streamCertificateDocument(userCertModel[index].certId),
                catchError: (context,error){
                  print(error);
                }, child: Consumer<CertificateModel>(
                  builder: (_,value,child){
                    return value !=null ? Column(children: <Widget>[

                      ListTile(
onTap: (){
  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return PdfViewer(value.certUrl);
                                    //  child: ProfileRegularUser();
                                  }),
                                );
},
                        leading: Icon(Icons.picture_as_pdf,size: 40,),
                      title: Text(value.certName),
                      trailing: IconButton(icon: Icon(Icons.cancel,color: Colors.red,), onPressed: (){


                        showDialog(context: context,
                            builder: (context)=> SimpleDialog(
                              backgroundColor: MyColors().skyBlue,
                              title: Text("Delete Certificate"),

                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FlatButton(onPressed: (){
                                       ProfileProvider.instance().deleteCertificateDocument(value.certId, widget.userId);
                                       Navigator.of(context).pop();
                                    }, child: Text("Yes",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),)),
                                    FlatButton(onPressed: (){
                                   Navigator.of(context).pop();
                                    }, child: Text("No",style: TextStyle(fontWeight: FontWeight.bold),)),
                                  ],
                                ),

                              ],
                              contentPadding: EdgeInsets.all(20),

                            ));

                      }),
                    ),
Divider(),

                    ],) : Container();
                  },
                ),);
            },
            itemCount: userCertModel.length,),
        ),
      ) : Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>  _openFileExplorer(),
      ),
    );
  }
}
