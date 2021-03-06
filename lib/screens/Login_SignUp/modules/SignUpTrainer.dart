import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zing_fitnes_trainer/components/passwordInput.dart';
import 'package:zing_fitnes_trainer/screens/Login_SignUp/modules/LoginTrainer.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/authentication.dart';
import 'package:zing_fitnes_trainer/utils/validator.dart';
import '../../../providers/login_SignUpProvider.dart';
import '../../../components/button.dart';
import '../../../components/input.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class SignUpTrainer extends StatefulWidget {
  @override
  _SignUpTrainerState createState() => _SignUpTrainerState();
}

class _SignUpTrainerState extends State<SignUpTrainer> {
  final _formKey = GlobalKey<FormState>();
  final color = MyColors();
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var userAuth =  UserAuth();
  String userType;

  String notificationToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //  _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //  _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        notificationToken = token;
      });

      print(notificationToken);


    });


  }
  _launchURL() async {
    const url = 'https://www.websitepolicies.com/policies/view/RpRamNWi';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var formdata = Provider.of<LoginSignUpProvider>(context);
    return Form(
      autovalidate: formdata.readAutovalidate,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //
          //this row contains two flatbuttons and a text widget
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ButtonTheme(
                  minWidth: 5,
                  child: Consumer<LoginSignUpProvider>(
                    builder: (context, data, child) => FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text('Login',
                          style: TextStyle(
                              color: color.deepBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.w500)),
                      onPressed: () {
                        data.changeCodeTrainer = Column(
                          children: <Widget>[
                            LoginTrainer(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 40),
                            )
                          ],
                        );
                      },
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 15,
                    0,
                    MediaQuery.of(context).size.width / 15,
                    0),
                child: Text('or', style: TextStyle(color: color.white)),
              ),
              ButtonTheme(
                minWidth: 5,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {},
                  child: Text('Sign Up',
                      style: TextStyle(
                        color: color.deepBlue,
                        fontSize: 22,
                        decoration: TextDecoration.underline,
                      )),
                ),
              )
            ],
          ),

          Padding(
            padding: EdgeInsets.all(10),
          ),
/////////
          Consumer<LoginSignUpProvider>(
            builder: (context, data, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Input_field(
                    icon: Icons.perm_identity,
                    hintText: 'Trainer name',
                    validator: (value) {
                      return Validator().textValidator(value);
                    },
                    onChanged: (value) {
                      data.setTrainerName = value;
                    },
                    hide: false),
                Padding(
                  padding: EdgeInsets.all(7),
                ),
                Input_field(
                    icon: Icons.lock_outline,
                    hintText: 'Email id',
                    validator: (value) {
                      return Validator().emailValidator(value);
                    },
                    onChanged: (value) {
                      data.setsignUpEmail = value;
                    },
                    hide: false),
                Padding(
                  padding: EdgeInsets.all(7),
                ),
                Input_field(
                    icon: Icons.phone_iphone,
                    hintText: 'Mobile number',
                    validator: (value) {
                      return Validator().textValidator(value);
                    },
                    onChanged: (value) {
                      data.setsignUpNumber = value;
                    },
                    hide: false),
                Padding(
                  padding: EdgeInsets.all(7),
                ),
                PasswordInputfield(
                    icon: Icons.lock_outline,
                    hintText: 'Password',
                    validator: (value) {
                      return Validator().passwordValidator(value);
                    },
                    onChanged: (value) {
                      data.setsignUppasssword = value;
                    },
                )
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
          ),



         _loading?
             Center(
               child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.white),),
             ) :
         Consumer<LoginSignUpProvider>(
            builder: (context, data, _) => Button(
                text: 'NEXT',
                onClick: () {
                  validateForm(data,formdata);

                  

                }),
          ),
          FlatButton(
            onPressed: (){
              _launchURL();
            },
            child: Text('Terms and Conditions',style: TextStyle(fontSize: 20,color: Colors.white),),
          )
        ],
      ),

    );
  }

  Future<Null> alertText(BuildContext context,String text) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            //    title:  Text("Chicago Time",textAlign: TextAlign.center,style: TextStyle(fontSize: 22),),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 20.0,),
                    ),
                  ),
                  Divider(),
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok", style: TextStyle(fontSize: 20.0,fontFamily: 'Montserrat',color: Theme.of(context).accentColor),),
                  )

                ],
              ),
            )

        );
      },
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle( fontSize: 20.0),
      ),
      backgroundColor: Theme.of(context).accentColor,
    ));
  }

  validateForm(LoginSignUpProvider data,LoginSignUpProvider formData) {
    if (_formKey.currentState.validate()) {

      setState(() {
         _loading = true;
      });
      UserData userData = UserData(displayName: data.readTrainerName,
      email: data.readsignUpEmail,password: data.readSignUpPassword);

      userAuth.createUser(userData).then((value){
        print("value is "+value);
        formData.saveUserData(data.readSignUpNumber, data.readTrainerName,Config.trainer,notificationToken).then((_){
          print("successfully saved to DB");
          setState(() {
            _loading = false;
          });

          alertText(context, 'A link has been sent to your email address please confirm');




          
        });


      }).catchError((Object onError) {
        //    showInSnackBar(AppLocalizations.of(context).emailExist);
      //  showInSnackBar(onError.toString());
        print(onError.toString());
        setState(() {
          _loading = false;
        });
      });


      /*
      showDialog(
          context: context,
          builder: (context) => InfoDialogue(
                title: "SignUp Info",
                values: {
                  "Trainer Name": data.readTrainerName,
                  "Email Id": data.readsignUpEmail,
                  "Mobile Number": data.readSignUpNumber,
                  "Password": data.readSignUpPassword
                },
              ));

      */
    } else {
      data.setAutovalidate = true;
    }
  }
}
