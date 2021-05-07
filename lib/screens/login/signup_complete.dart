import 'package:flutter/material.dart';
import 'package:hagglex_flutter/screens/home/home_screen.dart';


class SetUpComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF2b2350),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 1,),
              Image.asset("assets/images/tick.png",
                width: 100,
                fit: BoxFit.fitWidth,),
              SizedBox(height: 10,),
              Text("Setup Complete",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10,),
              Text("Thank you for setting up your HaggleX account",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Spacer(flex: 2,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5.0),
                width: width * 0.75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                    color: Color(0xFFE8C839),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));},
                    child: Text(
                      "START EXPLORING",
                      style: TextStyle(color: Colors.black),),
                  ),
                ),
              ),

              Spacer(flex: 1,),
            ],
          ),
        ),
      ),
    );
  }
}
