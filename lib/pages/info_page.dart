import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crhs_parking_app/animations/FadeAnimationDown.dart';
import 'package:crhs_parking_app/animations/FadeAnimationStatic.dart';
import 'package:crhs_parking_app/animations/FadeAnimationUp.dart';
import 'package:crhs_parking_app/pages/information_submission.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map.dart';

class InfoPage extends StatefulWidget {

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  String _uid;
  User currentStudent;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    User getUser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(getUser.uid).get();
    _uid = getUser.uid;
    currentStudent = User.fromSnapshot(userData);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    List<Color> completedGradient = [Color.fromRGBO(100, 181, 246, 1),Color.fromRGBO(159, 168, 218, 1)];
    List<Color> unconfirmedGradient = [Color.fromRGBO(139, 195, 74, 1),Color.fromRGBO(102, 187, 106, 1)];
    List<Color> incompleteGradient = [Color.fromRGBO(229, 115, 115, 1),Color.fromRGBO(255, 171, 145, 1)];

    if(currentStudent==null){
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
    else{
      return Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(_uid).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
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
              if(snapshot.data['spotuid']=='none') {
                return Scaffold(
                  body: Container(
                    child: Column(
                      children: [
                        Container(
                          height: 240,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 60,
                                ),
                                FadeAnimationStatic(
                                  3.8,
                                  Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          width: 105,
                                          height: 105,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  spreadRadius: 3,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3), // changes position of shadow
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: 95,
                                              height: 95,
                                              child: ClipRRect(
                                                child: Image.network(currentStudent.uid),
                                                borderRadius: BorderRadius.circular(45),
                                              ),
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 25,
                                ),
                                FadeAnimationDown(
                                  3.9,
                                  Text(
                                    'Welcome ${currentStudent.name}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: FadeAnimationUp(
                            1,
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                  ),
                                  Container(
                                    height: 170,
                                    child: AspectRatio(
                                      aspectRatio: 1000/560,
                                      child: FlareActor(
                                        "assets/add.flr",
                                        alignment:Alignment.center,
                                        fit: BoxFit.fill,
                                        animation: 'active',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Container(
                                        height: 30,
                                        child: AspectRatio(
                                          aspectRatio: 8.5,
                                          child: FlareActor(
                                            "assets/parktext.flr",
                                            alignment:Alignment.center,
                                            fit: BoxFit.fill,
                                            animation: 'reserve',
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height-296,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Map()),
                            );
                          },
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: incompleteGradient
                      ),
                    ),
                  ),
                );
              }
              else{
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('spots').doc(snapshot.data['spotuid']).get(),
                  builder: (context, spotData) {
                    if(spotData.hasData) {
                      if(!spotData.data['completed']) {
                        return Scaffold(
                          body: Container(
                            child: ListView(
                              children: [
                                Container(
                                  height: 240,
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 60,
                                        ),
                                        FadeAnimationStatic(
                                          3.8,
                                          Stack(
                                            children: <Widget>[
                                              Center(
                                                child: Container(
                                                  width: 105,
                                                  height: 105,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(50),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.3),
                                                          spreadRadius: 3,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 3), // changes position of shadow
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 95,
                                                      height: 95,
                                                      child: ClipRRect(
                                                        child: Image.network(currentStudent.uid),
                                                        borderRadius: BorderRadius.circular(45),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                        ),
                                        FadeAnimationDown(
                                          3.9,
                                          Text(
                                            'Welcome ${currentStudent.name}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: FadeAnimationUp(
                                    1,
                                    Container(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: 20,
                                                ),
                                                Container(
                                                  height: 200,
                                                  child: AspectRatio(
                                                    aspectRatio: 1000/560,
                                                    child: FlareActor(
                                                      "assets/add.flr",
                                                      alignment:Alignment.center,
                                                      fit: BoxFit.fill,
                                                      animation: 'parking',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      child: AspectRatio(
                                                        aspectRatio: 8.5,
                                                        child: FlareActor(
                                                          "assets/parktext.flr",
                                                          alignment:Alignment.center,
                                                          fit: BoxFit.fill,
                                                          animation: 'continue',
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              DocumentReference spotRef = FirebaseFirestore.instance.collection('spots').doc(snapshot.data['spotuid']);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => InfoSubmit(spotRef))
                                              );
                                            },
                                          ),
                                          Container(
                                            height: 50,
                                          ),
                                          ElevatedButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.transparent,  // Button color
                                              foregroundColor: Colors.transparent,   // Splash color
                                            ),
                                            child: Container(
                                              height: 60,
                                              child: FadeAnimationStatic(
                                                6,
                                                Container(
                                                  height: 60,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        height: 5,
                                                        width: 1,
                                                      ),
                                                      FadeAnimationUp(
                                                        6,
                                                        Text(
                                                          'or',
                                                          style: TextStyle(
                                                              fontSize: 20
                                                          ),
                                                        ),
                                                      ),
                                                      FadeAnimationUp(
                                                        6.5,
                                                        Text(
                                                          'Change Your Selection',
                                                          style: TextStyle(
                                                              fontSize: 20
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              DocumentReference spotRef = FirebaseFirestore.instance.collection('spots').doc(snapshot.data['spotuid']);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => Map())
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height-296,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black54.withOpacity(.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: incompleteGradient
                              ),
                            ),
                          ),
                        );
                      }
                      else if(!spotData.data['confirmed']) {
                        return Scaffold(
                          body: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 240,
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 60,
                                        ),
                                        FadeAnimationStatic(
                                          1.8,
                                          Stack(
                                            children: <Widget>[
                                              Center(
                                                child: Container(
                                                  width: 105,
                                                  height: 105,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(50),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.3),
                                                          spreadRadius: 3,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 3), // changes position of shadow
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 95,
                                                      height: 95,
                                                      child: ClipRRect(
                                                        child: Image.network(currentStudent.uid),
                                                        borderRadius: BorderRadius.circular(45),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                        ),
                                        FadeAnimationDown(
                                          1.9,
                                          Text(
                                            'Welcome ${currentStudent.name}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: FadeAnimationUp(
                                    1,
                                    Container(
                                      child: PageView(
                                        scrollDirection: Axis.vertical,
                                        physics: ScrollPhysics(),
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height-296,
                                            child: Column(
                                              children: <Widget>[
                                                Spacer(
                                                  flex: 1,
                                                ),
                                                (spotData.data['submitDate'] as Timestamp).toDate().add(Duration(days: 30+(7-(spotData.data['submitDate'] as Timestamp).toDate().add(Duration(days: 30)).weekday))).difference(DateTime.now()).inDays>0 ? Column(
                                                  children: <Widget>[
                                                    RichText(
                                                      text: TextSpan(
                                                          style: DefaultTextStyle.of(context).style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: '${(spotData.data['submitDate'] as Timestamp).toDate().add(Duration(days: 30+(7-(spotData.data['submitDate'] as Timestamp).toDate().add(Duration(days: 30)).weekday))).difference(DateTime.now()).inDays}',
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.width/7,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' Days',
                                                              style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                    Text(
                                                      'Until Spot Deletion',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ) :
                                                Column(
                                                  children: <Widget>[
                                                    Text(
                                                      'Your Spot Will Be',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Deleted This Midnight',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                ),
                                                (spotData.data['submitDate'] as Timestamp).toDate().add(Duration(days: 30+(7-(spotData.data['submitDate'] as Timestamp).toDate().add(Duration(days: 30)).weekday))).difference(DateTime.now()).inDays>0 ? Container(
                                                  width: 200,
                                                  child: Text(
                                                    'Show your valid License, Insurance, and your School ID to your Counselor to Confirm your Parking Spot',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                ) :
                                                Container(
                                                  width: 200,
                                                  child: Text(
                                                    'It\'s Sunday. Sooooooo...... um... Isn\'t the school closed today?',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                ),
                                                Spacer(
                                                  flex: 1,
                                                ),
                                                Text(
                                                  'Spot Information',
                                                  style: TextStyle(
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black38,
                                                  size: 35,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                width: 20,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width-20,
                                                height: MediaQuery.of(context).size.height-326,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Your spot is',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 20,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      spotData.data['spot'].toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 60,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Payment Method: ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          spotData.data['isCash'] ? 'Cash' : 'Check',
                                                          style: TextStyle(
                                                            color: spotData.data['isCash'] ? Colors.green : Colors.blue,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height-296,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black54.withOpacity(.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: unconfirmedGradient
                              ),
                            ),
                          ),
                        );
                      }
                      else {
                        return Scaffold(
                          body: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 240,
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 60,
                                        ),
                                        FadeAnimationStatic(
                                          1.8,
                                          Stack(
                                            children: <Widget>[
                                              Center(
                                                child: Container(
                                                  width: 105,
                                                  height: 105,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(50),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.3),
                                                          spreadRadius: 3,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 3), // changes position of shadow
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 95,
                                                      height: 95,
                                                      child: ClipRRect(
                                                        child: Image.network(currentStudent.uid),
                                                        borderRadius: BorderRadius.circular(45),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                        ),
                                        FadeAnimationDown(
                                          1.9,
                                          Text(
                                            'Welcome ${currentStudent.name}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: FadeAnimationUp(
                                    1,
                                    Container(
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 20,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width-20,
                                              height: MediaQuery.of(context).size.height-326,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Your spot is',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 20,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    spotData.data['spot'].toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 60,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${spotData.data['year']} ${spotData.data['model']}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    spotData.data['licensePlate'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height-296,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black54.withOpacity(.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: completedGradient
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    else {
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
                  },
                );
              }
            }
          },
        ),
      );
    }
  }
}
