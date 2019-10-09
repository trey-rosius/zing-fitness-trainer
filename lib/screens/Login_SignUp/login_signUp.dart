import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/login_SignUpProvider.dart';
import '../../components/footBg.dart';
import '../../utils/myColors.dart';

class Login_SignUP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLoginSignUp(),
    );
  }
}

class MyLoginSignUp extends StatelessWidget {
  final col = MyColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
           
          color: col.skyBlue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 15,
                      MediaQuery.of(context).size.height / 40,
                      MediaQuery.of(context).size.width / 15,
                      0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset('./assets/images/logo.png',
                                height:
                                    MediaQuery.of(context).size.height / 9.4,
                                width: MediaQuery.of(context).size.width / 2.2),

                            //
                            //this is the area where we are going to do out conditional rendering
                            //
                            //The logic used here is that there is a provider class having a variable 
                            //that controls which widget is to be displayed here
                            //
                            //initially the variable holds the Login() class and a Padding class to 
                            // provide some space before the FootBg() element
                            //
                            //the Login() and SignUp() Widget(class) both Contains a flatButton with 
                            //the Label Login, and Another  Flatbutton with the label SignUp
                            //
                            //if you click on the flatbutton with the label Login then the Login widget 
                            //is what is displayed together with a Padding widget
                            //
                            //if you click on the flatbutton with the label SignUp, then then the SignUp 
                            //widget is displayed together with a Padding widget
                            //
                            MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  builder: (_) => Login_SignUp_Provider(),
                                ),
                              ],
                              child: Consumer<Login_SignUp_Provider>(
                                  builder: (context, data, child) =>
                                      data.showCode),
                            )
                          ],
                        ),
                      )
                    ],
                  )),

              //this is for the footer element
              FootBg(),
            ],
          )),
        ],
      )
    );
  }
}
