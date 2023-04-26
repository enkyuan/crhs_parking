import 'package:crhs_parking_app/animations/FadeAnimationUp.dart';
import 'package:crhs_parking_app/pages/spots_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 239, 241, 1),
      body: Column(
        children: [
          FadeAnimationUp(
            1,
            Container(
              child: Column(
                children: [
                  Container(
                    height: 50,
                  ),
                  Container(
                    height: 5,
                  ),
                  Container(
                    child: Image.asset(
                      'assets/schoolparking.png',
                    ),
                  ),
                  Container(
                    height: 35,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(236, 239, 241, 1),
                      Color.fromRGBO(224, 242, 241, 1),
                    ]
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height-90-((2094/4241)*MediaQuery.of(context).size.width),
            child: ListView(
              children: [
                Container(
                  height: 510,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      FadeAnimationUp(
                        1.5,
                        SpotButton('Back Lot', 'a')
                      ),
                      FadeAnimationUp(
                        2,
                        SpotButton('9th Grade Center', 'b')
                      ),
                      FadeAnimationUp(
                        2.5,
                        SpotButton('PAC Lot', 'c')
                      ),
                      FadeAnimationUp(
                        3,
                          SpotButton('1200 Lot', 'd')
                      ),
                      FadeAnimationUp(
                        3.5,
                        SpotButton('1600 Lot', 'e')
                      ),
                      FadeAnimationUp(
                        4,
                        SpotButton('Athletic Lot', 'f')
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget SpotButton(String name, String spot) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width-10,
          child: ButtonTheme(
            height: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    ' $name',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(236, 239, 241, 1),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => Spots(spot)));
              },
            ),
          ),
        ),
        spot=='f' ? Container() :
        Divider(
          thickness: 2,
          indent: 20,
          endIndent: 20,
          color: Colors.grey,
        ),
      ],
    );
  }
}
