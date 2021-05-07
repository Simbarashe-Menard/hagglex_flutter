import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hagglex_flutter/screens/home/components/market_banner.dart';
import 'package:hagglex_flutter/screens/home/components/notification_bell.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2350),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 175,
                color: Color(0xFF2b2350),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconBtnWithCounter(
                            svgSrc: "",
                            press: () {},
                          ),
                          Text("HaggleX", style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),),
                          IconBtnWithCounter(
                            svgSrc: "assets/icons/Bell.svg",
                            numOfitem: 3,
                            press: () {},
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Your balance',style: TextStyle(
                                color: Colors.white
                              )),
                              SizedBox(height: 3,),
                              Text("\$****", style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                          ToggleButtons(
                            disabledColor: Colors.white,
                            selectedColor: Colors.orange.withOpacity(0.45),
                            fillColor: Colors.orange,

                            borderRadius: BorderRadius.circular(25.0),
                            children: <Widget>[
                              // first toggle button
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'USD',
                                  style: TextStyle(

                                    color: Colors.white,
                                  )
                                ),
                              ),
                              // second toggle button
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'NAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                              });
                            },
                            isSelected: isSelected,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
               Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            MarketBanner(),
                            MarketBanner(),
                            MarketBanner(),
                            MarketBanner(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Do more with HaggleX',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          )),
                        ),
                      ),
                      _buildCard(),
                      _buildCard(),
                      _buildCard(),
                      _buildCard(),
                      _buildCard(),
                      _buildCard(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF2b2350),
        unselectedItemColor: Colors.black26,
        items: [
          BottomNavigationBarItem(
            label: "Dashboard",
              icon: Icon(Icons.dashboard_rounded)),
          BottomNavigationBarItem(
              label: "Dashboard",
              icon: Icon(Icons.confirmation_number)),
          BottomNavigationBarItem(
              label: "Dashboard",
              icon: Icon(Icons.dashboard_rounded)),
          BottomNavigationBarItem(
              label: "Dashboard",
              icon: Icon(Icons.save_alt_rounded)),
        ],
      ),
    );
  }


  Widget _buildCard() => SizedBox(
//    height: 230,
    child: Container(
//      margin: const EdgeInsets.all(15.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            title: Text('Receive money from anyone',
                style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 17,
                )),
            subtitle: Text('Receive money with ease'),
            leading: Icon(
              Icons.credit_card,
              size: 30,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ),
    ),
  );
}




