import 'dart:io';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:hagglex_flutter/constants.dart';
import 'package:hagglex_flutter/screens/login/search_country.dart';
import 'package:hagglex_flutter/screens/login/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  final String flagCountry, code ;
  final bool submitted;

  const SignUpScreen({Key key,
    this.flagCountry,
    this.code,
    this.submitted}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState(flagCountry,code,submitted);
}

class _SignUpScreenState extends State<SignUpScreen> {
  final String flagCountry, code ;
  bool submitted = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String emailErrorMessage;
  String passwordErrorMessage;
  bool errorPassword = false;
  bool errorEmail = false;
  bool _passwordVisible = false;
  bool _loading = false;

  _SignUpScreenState(this.flagCountry, this.code, this.submitted);


  void verifyOTp() async {
    EmailAuth.sessionName = "Test haggleX App";
    var result = await EmailAuth.sendOtp(receiverMail: email);
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
      Navigator.pop(context); //pop dialog
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
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential.user != null){
        userCredential.user.sendEmailVerification();
        Navigator.push(context, MaterialPageRoute(builder: (context) => Verifyaccount()));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong on our end.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    try {
       await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      ).then((authResult){
        if(authResult.user != null){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Verifyaccount()));
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
    return Scaffold(
      backgroundColor: Color(0xFF2b2350),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.only( top: 20.0, left: 25.0, bottom: 15.0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      width: 55,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                        child: Icon(Icons.arrow_back_ios, color: Colors.white,),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("Create a new account",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextField(
                        onTap: () => emailErrorMessage = '',
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
                            errorText: errorEmail ?  emailErrorMessage : null,
                            errorStyle: TextStyle(
                                color: Colors.red.withOpacity(0.8),
                                fontWeight: FontWeight.bold
                            )
                        ),
                        onChanged: (value) => email = value,
                      ),
                      SizedBox(height: 5),
                      TextField(
                        obscureText: !_passwordVisible,
                        onTap: () => passwordErrorMessage = '',
                        decoration: InputDecoration(
                            labelText: "Password (Min 8 characters)",
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
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Create a username',
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.black12,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => StartHere1()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  (submitted)
                                      ? Text(flagCountry)
                                      : Image.asset("assets/images/nigeria.png"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    child: Container(
                                      width: 1,
                                      height: 30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  (submitted)
                                   ? Text('+'+code)
                                    :Text("+234"),
                                ],
                              ),),
                          ),
                          SizedBox(width: 2,),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter your phone number',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Referral code |optional|',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("By signing, you agree to HaggleX terms and privacy policy.", style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12
                      ),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomRight ,
                                      end: Alignment.bottomLeft,
                                      stops: [0.1, 0.4, 0.8, 0.9],
                                      colors: [
                                        Color(0xFF8b7ade),
                                        Color(0xFF6353ad),
                                        Color(0xFF3f366b),
                                        Color(0xFF3f366b),
                                      ]
                                  ),
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5.0),
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                  onPressed: ()  {
                                    checkFields(email, password);
                                    },
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
