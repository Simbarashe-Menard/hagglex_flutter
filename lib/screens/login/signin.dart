import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hagglex_flutter/constants.dart';
import 'package:hagglex_flutter/screens/home/home_screen.dart';
import 'package:hagglex_flutter/screens/login/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hagglex_flutter/screens/login/verify.dart';

class SigninScreen extends StatefulWidget {

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  String email = '';
  String password = '';
  String emailErrorMessage;
  String passwordErrorMessage;
  bool errorPassword = false;
  bool errorEmail = false;
  bool _passwordVisible = false;
  bool _loading = false;

  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        checkVerification();
      }
    });
    super.initState();
  }

  Future<void> checkVerification() async {
    user = auth.currentUser;
    await user.reload;
    if (user.emailVerified) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Verifyaccount()));
    }
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 2), () {
      Navigator.pop(context);
      _login();
    });
  }

  Future _login() async{
    setState((){
      _loading = false;
    });
  }

  void signInMethod(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      ).then((authResult){
        if(authResult.user != null){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not found.'),
            ),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user found for that email.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password provided for that user.'),
          ),
        );
      }
    }
  }

  Future<bool> checkInternet(String email, String password) async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 4));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _onLoading();
        signInMethod(email, password);
        return true;
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red,
          content: Text('Not connected.',style: TextStyle(
              color: Colors.white
          ),),
        ),
      );
      return false;
    }
  }

  void checkFields(String email, String password) {

    bool cancel = false;

    if(password.isEmpty){
      errorPassword = true;
      passwordErrorMessage = "Please Enter your password";
      cancel = true;
    }

    if (email.isEmpty) {
      setState(() {
        errorEmail = true;
        emailErrorMessage = "Please Enter your email";
        cancel = true;
      });
    } else if (!emailValidatorRegExp.hasMatch(email)){
      setState(() {
        errorEmail = true;
        emailErrorMessage = "Please Enter Valid Email";
        cancel = true;
      });
    }

    if (cancel) {
    } else {
      checkInternet(email, password);
    }

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF2b2350),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.15,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Welcome!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05,),
                TextFormField(
                  onTap: () => emailErrorMessage = '',
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, ),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                      color : Colors.white
                    ),
                      errorText: errorEmail ?  emailErrorMessage : null,
                      errorStyle: TextStyle(
                          color: Colors.red.withOpacity(0.8),
                          fontWeight: FontWeight.bold
                      )
                  ),
                  onChanged: (value) => email = value,
                ),
                SizedBox(height: 15.0,),
                TextFormField(
                  obscureText: !_passwordVisible,
                  onTap: () => passwordErrorMessage = '',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white,),
                      ),
                    labelText: "Password (Min 8 characters)",
                      labelStyle: TextStyle(
                          color : Colors.white,
                      ),
                      suffixIcon:
                      IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      errorText: errorPassword ?  passwordErrorMessage : null,
                      errorStyle: TextStyle(
                          color: Colors.red.withOpacity(0.8),
                          fontWeight: FontWeight.bold
                      )
                  ),
                  onChanged: (value) => password = value,
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: ()  {

                      },
                      child: Text("Forgot Password?",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                            color: Color(0xFFE8C839),
                            onPressed: ()  {
                              checkFields(email, password);
                            },
                            child: Text(
                              "LOG IN",
                              style: TextStyle(color: Colors.black,
                              fontSize: 16),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(submitted: false,)));
                      },
                      child: Text("New User? Create a new account?",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
