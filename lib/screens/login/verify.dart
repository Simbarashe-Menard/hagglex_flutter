import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hagglex_flutter/screens/home/home_screen.dart';
import 'package:hagglex_flutter/screens/login/signup_complete.dart';

class Verifyaccount extends StatefulWidget {
  @override
  _VerifyaccountState createState() => _VerifyaccountState();
}

class _VerifyaccountState extends State<Verifyaccount> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String opt = '' ;
  final TextEditingController _otpController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    if (!user.emailVerified) {
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    super.initState();
  }

  Future<void> sendVerify() async {
    await user.sendEmailVerification();
  }

  Future<void> checkVerification() async {
    user = auth.currentUser;
    await user.reload;
    if (user.emailVerified) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SetUpComplete()));
    } else {

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2350),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Verify your account",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Image.asset("assets/images/tick2.png",
                          width: 100,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("We just sent a verification link to your email."),
                      Text("Please enter this code"),
                      SizedBox(height: 15),
//                      Padding(
//                        padding: const EdgeInsets.symmetric(vertical: 15),
//                        child: TextField(
//                          controller: _otpController,
//                          onChanged: (value) => opt = value,
//                          keyboardType: TextInputType.number,
//                          decoration: InputDecoration(
//                            labelText: 'Verification code',
//                          ),
//                        ),
//                      ),
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
                                  onPressed: () =>  checkVerification(),
                                  child: Text(
                                    "CHECK VERIFICATION",
                                    style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0,),
                      Text("This link will expire in 10 minutes",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      GestureDetector(
                        onTap: () => {
                          sendVerify()
                        },
                        child: Text("Resend Code",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),),
                      ),
                      SizedBox(height: 20.0,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
