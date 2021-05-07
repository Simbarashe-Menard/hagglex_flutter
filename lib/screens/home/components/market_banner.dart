import 'package:flutter/material.dart';

class MarketBanner extends StatelessWidget {
  const MarketBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 145,
      width: width * 0.95,
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
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
        borderRadius: BorderRadius.circular(5),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(
                text: "HaggleX\nMarketplace\n",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: "Input sample text here."),
            ],
          ),
        ),
      ),
    );
  }
}