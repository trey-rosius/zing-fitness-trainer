
import 'package:flutter/material.dart';
import 'package:zing_fitnes_trainer/utils/authentication.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool autovalidate = false;
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

  UserAuth userAuth = new UserAuth();



  bool loading = false;



  void reset() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar("Please Fix Errors");
    } else {
      form.save();
      setState(() {
        loading = true;
      });

      userAuth.resetUserPassword(emailController.text).then((value) {
        if (value) {
          setState(() {
            loading = false;
          });
          showInSnackBar(
              "A Reset Link Has been forwarded to your Email Address");
        }
      }).catchError((onError) {
        showInSnackBar(onError.toString());
      });
    }
  }
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(

      key: _scaffoldKey,
      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Forgot Password",style: TextStyle(fontSize: 20.0),),


      ),
      body: SingleChildScrollView(
        child:  new Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0),
          child: new Column(

            children: <Widget>[
              new Form(
                key: formKey,
                autovalidate: autovalidate,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: new TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20.0),
                        validator: (value) {
                          if(value != null){
                            return value;
                          }

                        },
                        controller: emailController,


                        // enabled: false,
                        // keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                            fillColor: Colors.white,
                            labelText: "Email",
                            contentPadding: new EdgeInsets.all(18.0),
                            filled: true,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                      ),
                    ),


                  ],
                ),
              ),

               Column(
                 children: <Widget>[
                   loading == true ? CircularProgressIndicator() :
                   Container(
                    padding: EdgeInsets.only(top: 30.0),
                    width: screenSize.width / 1.3,
                    //  color: Theme.of(context).primaryColor,

                    child: RaisedButton(

                      onPressed: () {
                        reset();
                      },
                      color: Theme.of(context).primaryColor,
                      child: new Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: new Text(
                            "Request Password Reset",
                            style: new TextStyle(

                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
              ),
                 ],
               ),
            ],
          ),
        ),
      ),

    );
  }
}
