import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zing_fitnes_trainer/components/passwordInput.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Login_SignUp/forgot_password.dart';
import 'package:zing_fitnes_trainer/screens/Profile/edit_profile_trainer.dart';
import 'package:zing_fitnes_trainer/screens/Profile/profile_trainer_user.dart';
import 'package:zing_fitnes_trainer/screens/Profile/profile_regular_user.dart';
import 'package:zing_fitnes_trainer/screens/home/home_container.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
import 'package:zing_fitnes_trainer/utils/authentication.dart';
import 'package:zing_fitnes_trainer/utils/showdialogue.dart';
import '../../../components/button.dart';
import '../../../components/input.dart';
import '../../../utils/myColors.dart';
import '../../../providers/login_SignUpProvider.dart';
import './SignUpTrainer.dart';
import 'package:zing_fitnes_trainer/utils/validator.dart';

class LoginTrainer extends StatefulWidget {
  @override
  _LoginTrainerState createState() => _LoginTrainerState();
}

class _LoginTrainerState extends State<LoginTrainer> {
  final _formKey = GlobalKey<FormState>();
  final color = MyColors();
  var userAuth = UserAuth();
  bool _loading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {},
                  child: Text('Login',
                      style: TextStyle(
                          color: color.deepBlue,
                          decoration: TextDecoration.underline,
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 15,
                    0,
                    MediaQuery.of(context).size.width / 15,
                    0),
                child: Text('or', style: TextStyle(color: color.white)),
              ),

//here we are using provider to switch to Signup upon clicking signUp
              Consumer<LoginSignUpProvider>(
                  builder: (context, data, child) => ButtonTheme(
                        minWidth: 5,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('Sign Up',
                              style: TextStyle(
                                  color: color.deepBlue, fontSize: 22)),
                          onPressed: () {
                            data.changeCodeTrainer = Column(
                              children: <Widget>[
                                SignUpTrainer(),
                                Padding(padding: EdgeInsets.all(2)
                                    // padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/500),
                                    )
                              ],
                            );
                          },
                        ),
                      ))
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //
              //this is the first child of the inner column and it holds the white texts
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0,
                        MediaQuery.of(context).size.height / 90,
                        0,
                        MediaQuery.of(context).size.height / 150),
                    child: Text(
                      "Make",
                      style: TextStyle(
                          color: color.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    "Your self fit",
                    style: TextStyle(
                        color: color.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(8),
              ),

              Consumer<LoginSignUpProvider>(
                builder: (context, mydata, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Input_field(
                      onChanged: (value) {
                        mydata.setEmail = value;
                      },
                      hide: false,
                      validator: (value) {
                        return Validator().emailValidator(value.trim());
                      },
                      icon: Icons.email,
                      hintText: 'Email id',
                    ),
                    Padding(
                      padding: EdgeInsets.all(7),
                    ),
                    PasswordInputfield(
                      onChanged: (value) {
                        mydata.setpasssword = value;
                      },
                      icon: Icons.lock_outline,
                      hintText: 'Password',
                      validator: (value) {
                        return Validator().passwordValidator(value);
                      },
                    ),

                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(3),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>ForgotPasswordScreen(),

                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: color.white),
                      ))
                ],
              ),

              Padding(
                padding: EdgeInsets.all(3),
              ),

              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Consumer<LoginSignUpProvider>(
                      builder: (context, data, child) => Button(
                          text: 'LOGIN',
                          onClick: () {
                            validateForm(data);

                          }),
                    ),
              FlatButton(
                onPressed: (){
                  _launchURL();
                },
                child: Text('Terms and Conditions',style: TextStyle(fontSize: 20,color: Colors.white),),
              )
              //
              //this is the second child of the inner column and it contains two inputfields
              //
            ],
          )
        ],
      ),
    );
  }

  _saveUserId(String userId) async {
    final prefs =  await StreamingSharedPreferences.instance;


    prefs.setString(Config.userId, userId);
  }

  validateForm(LoginSignUpProvider data) async{
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });




   try {
     await firebaseAuth.signInWithEmailAndPassword(
         email: data.readEmail.trim(), password: data.readloginPass).then((value) {
       data.login().then((firebaseUserId) {
         _saveUserId(firebaseUserId);
         print(firebaseUserId);

         data.updateNotificationToken(notificationToken, firebaseUserId)
             .then((_) {
           setState(() {
             _loading = false;
           });
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => HomeContainer(),

             ),
           );
         });


         print("login was successfull");
       });
     });

   } on PlatformException catch(error){
     setState(() {
       _loading = false;
     });

       showDialog(
           context: context,
           builder: (context) => InfoDialogue(
             title: "Login Info",
             values: {
               "Error": error.code,
               "Password": error.message
             },
           ));

   }








    } else {
      data.setAutovalidate = true;
    }
  }
}
