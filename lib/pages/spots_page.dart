import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crhs_parking_app/animations/FadeAnimationUp.dart';
import 'package:crhs_parking_app/pages/information_submission.dart';
import 'package:crhs_parking_app/pages/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Spots extends StatefulWidget {
  String position;
  Spots(this.position);
  @override
  _SpotsState createState() => _SpotsState();
}

class _SpotsState extends State<Spots> {

  List<int> spotSearch = new List<int>();

  TextEditingController searchController = new TextEditingController(text: '');
  String query = '';

  Search(List<int> spots) {
    spotSearch = new List<int>();
    print(spotSearch);
    int i=0;
    print(spots.length);
    while(i<spots.length) {
      print('max is this $i');
      if(query=='') {
        spotSearch.add(spots[i]);
        print('added 0 ${spots[i]}');
      }
      else if(spots[i].toString().startsWith(query)) {
        spotSearch.add(spots[i]);
        print('added 1 ${spots[i]}');
      }
      else if(spots[i].toString().endsWith(query)) {
        spotSearch.add(spots[i]);
        print('added 2 ${spots[i]}');
      }
      else if(spots[i].toString().substring(1, 3)==query) {
        spotSearch.add(spots[i]);
        print('added 3 ${spots[i]}');
      }
      i++;
    }
    i = 0;
    print(spotSearch);
  }

  @override
  Widget build(BuildContext context) {
    List<int> spots = new List<int>();
    int min;
    int max;

    if(widget.position=='a'){
      //Back Lot
      for(int i=1420;i<=1593;i++){
        spots.add(i);
      }
      min = 1420;
      max = 1593;
      print('min is $min');
      print('max is $max');
    }
    if(widget.position=='b'){
      //9th Grade Center
      for(int i=1305;i<=1419;i++){
        spots.add(i);
      }
      min = 1305;
      max = 1419;
      print('min is $min');
      print('max is $max');
    }
    if(widget.position=='c'){
      //PAC Lot
      for(int i=1192;i<=1304;i++){
        spots.add(i);
      }
      min = 1192;
      max = 1304;
      print('min is $min');
      print('max is $max');
    }
    if(widget.position=='d'){
      //1200 Lot
      for(int i=736;i<=1191;i++){
        spots.add(i);
      }
      min = 736;
      max = 1191;
      print('min is $min');
      print('max is $max');
    }
    if(widget.position=='e'){
      //1600 Lot
      for(int i=356;i<=735;i++){
        spots.add(i);
      }
      min = 356;
      max = 735;
      print('min is $min');
      print('max is $max');
    }
    if(widget.position=='f'){
      //Athletic Lot
      for(int i=1;i<=355;i++){
        spots.add(i);
      }
      min = 1;
      max = 355;
      print('min is $min');
      print('max is $max');
    }

    Search(spots);

    return Scaffold(
      body: ListView(
        children: [
          FadeAnimationUp(
            1,
            Container(
              child: Column(
                children: [
                  Container(
                    height: 30,
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          'Lot Selection',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                  ),
                  Container(
                    height: 5,
                  ),
                  Container(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      child: PhotoView.customChild(
                        initialScale: 0.9,
                        minScale: 0.9,
                        maxScale: 8.0,
                        child: Image.asset("assets/parking${widget.position}.png"),
                        backgroundDecoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height-280,
            child: Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('spots').snapshots(),
                builder: (context, snap) {
                  if(!snap.hasData) {
                    return Scaffold(
                      body: Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  else {
                    List<int> occupied = new List<int>();
                    for(int i=0;i<snap.data.documents.length;i++) {
                      if(snap.data.documents[i]['spot']>=min&&snap.data.documents[i]['spot']<=max){
                        occupied.add(snap.data.documents[i]['spot']);
                      }
                    }

                    return Scaffold(
                      body: Container(
                        height: MediaQuery.of(context).size.height-280,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 20,
                                  ),
                                  Icon(Icons.search),
                                  Container(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: 22,
                                      ),
                                      onChanged: (String input) async {
                                        print(spots);
                                        query = input;
                                        setState(() {
                                          Search(spots);
                                          print(spots);
                                        });
                                        print('search $query');
                                        print('array is ${spotSearch.toString()}');
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height-340,
                              child: ListView(
                                children: List.generate(spotSearch.length, (i) {
                                  bool isOccupied = false;
                                  String occupyDir = 'assets/itis.png';
                                  Color statColor = Colors.greenAccent;
                                  String stats = 'Available';
                                  for(int e=0;e<occupied.length;e++) {
                                    if(occupied[e]==spotSearch[i]) {
                                      occupyDir = 'assets/itsnot.png';
                                      isOccupied = true;
                                      statColor = Colors.red;
                                      stats  ='Unavailable';
                                    }
                                  }
                                  return Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 10,
                                              ),
                                              Image.asset(
                                                occupyDir,
                                                width: 40,
                                              ),
                                              Container(
                                                width: 10,
                                              ),
                                              Text(
                                                spotSearch[i].toString(),
                                                style: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(
                                                flex: 1,
                                              ),
                                              Text(
                                                stats,
                                                style: TextStyle(
                                                  color: statColor,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              Container(
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                          color: Colors.transparent,
                                        ),
                                        onTap: () async {
                                          if(!isOccupied) {
                                            FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
                                            DocumentSnapshot userDoc = await Firestore.instance.collection('users').document(currentUser.uid).get();
                                            if(userDoc.data['spotuid']!='none') {
                                              DocumentReference currentSpotDoc = await Firestore.instance.collection('spots').document(userDoc.data['spotuid']);
                                              currentSpotDoc.setData({
                                                'spot': spotSearch[i],
                                                'confirmed': false,
                                              }, merge: true);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) => Navigation()),
                                              );
                                            }
                                            else {
                                              DocumentReference spotDoc = await Firestore.instance.collection('spots').document();
                                              spotDoc.setData({
                                                'spot': spotSearch[i],
                                                'completed': false,
                                                'confirmed': false,
                                              }, merge: true);
                                              await Firestore.instance.collection('users').document(currentUser.uid).setData({
                                                'spotuid': spotDoc.documentID,
                                              }, merge: true);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) => InfoSubmit(spotDoc)),
                                              );
                                            }
                                          }
                                          else {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        'Sorry, the space is not available'
                                                    ),
                                                  );
                                                }
                                            );
                                          }
                                        },
                                      ),
                                      Divider(
                                        indent: 15,
                                        endIndent: 15,
                                        thickness: 3,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
