import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crhs_parking_app/animations/FadeAnimationLeft.dart';
import 'package:crhs_parking_app/animations/FadeAnimationStatic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Revoke extends StatefulWidget {
  @override
  _RevokeState createState() => _RevokeState();
}

class _RevokeState extends State<Revoke> {

  TextEditingController searchController = new TextEditingController(text: '');
  String query = '';

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('spots').snapshots(),
          builder: (context, snapshots) {
            if(!snapshots.hasData) {
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
              return Scaffold(
                body: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 40,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width-20,
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
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                onChanged: (String input) async {
                                  query = input;
                                  setState(() {

                                  });
                                  print('search $query');
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
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshots.data.docs.length,
                          itemBuilder: (context, i) {
                            if(snapshots.data.docs[i]['spot']!=0&&snapshots.data.docs[i]['completed']&&snapshots.data.docs[i]['confirmed']&&'${snapshots.data.docs[i]['first'].toLowerCase()} ${snapshots.data.docs[i]['last'].toLowerCase()}'.contains(query.toLowerCase())) {
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    FadeAnimationLeft(
                                      1+i*0.2,
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    '${snapshots.data.docs[i]['first']} ${snapshots.data.docs[i]['last']}',
                                                    style: TextStyle(
                                                      fontSize: 26,
                                                    ),
                                                  ),
                                                  Spacer(
                                                    flex: 1,
                                                  ),
                                                  Text(
                                                    '${snapshots.data.docs[i]['spot']}',
                                                    style: TextStyle(
                                                      fontSize: 26,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 48,
                                              child: Row(
                                                children: <Widget>[
                                                  Spacer(
                                                    flex: 1,
                                                  ),
                                                  Container(
                                                    width: (MediaQuery.of(context).size.width-50)/2,
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(10),
                                                        child: Center(
                                                          child: Text(
                                                            'Revoke',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Row(
                                                                  children: <Widget>[
                                                                    Icon(
                                                                      Icons.warning,
                                                                      color: Colors.red,
                                                                    ),
                                                                    Text(
                                                                      ' Alert',
                                                                      style: TextStyle(
                                                                        color: Colors.red,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                content: Text('Are You Sure You Want to Revoke This Person From the Database'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: Text('No'),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text('Yes'),
                                                                    onPressed: () async {
                                                                      bool gotError = false;
                                                                      User currentUser = await FirebaseAuth.instance.currentUser;
                                                                      FirebaseFirestore.instance.collection('admin').doc(currentUser.uid).collection('history').doc('${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}${DateTime.now().millisecond}').set({
                                                                        'time': DateTime.now(),
                                                                        'docID': snapshots.data.docs[i].docID,
                                                                        'action': 'revoke',
                                                                      }, SetOptions(merge: true)).catchError((onError) {
                                                                        gotError = true;
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (context) {
                                                                            return AlertDialog(
                                                                              title: Text('Error'),
                                                                              content: Text('Access Denied'),
                                                                            );
                                                                          }
                                                                        );
                                                                      });
                                                                      FirebaseFirestore.instance.collection('spots').doc(snapshots.data.docs[i].docID).set({
                                                                        'confirmed': false,
                                                                      }, SetOptions(merge: true)).catchError((onError) {
                                                                        if(!gotError) {
                                                                          gotError = true;
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  title: Text('Error'),
                                                                                  content: Text('Access Denied'),
                                                                                );
                                                                              }
                                                                          );
                                                                        }
                                                                      });
                                                                      if(!gotError) {
                                                                        Navigator.pop(context);
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            }
                                                        );
                                                      },
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Color.fromRGBO(255, 183, 77, 1),
                                                    ),
                                                  ),
                                                  Spacer(
                                                    flex: 1,
                                                  ),
                                                  Container(
                                                    width: (MediaQuery.of(context).size.width-50)/2,
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(10),
                                                        child: Center(
                                                          child: Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Row(
                                                                  children: <Widget>[
                                                                    Icon(
                                                                      Icons.warning,
                                                                      color: Colors.red,
                                                                    ),
                                                                    Text(
                                                                      ' Alert',
                                                                      style: TextStyle(
                                                                        color: Colors.red,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                content: Text('Are You Sure You Want to Delete This Person\'s Spot From the Database'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: Text('No'),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text('Yes'),
                                                                    onPressed: () async {
                                                                      bool gotError = false;
                                                                      User currentUser = await FirebaseAuth.instance.currentUser;
                                                                      FirebaseFirestore.instance.collection('admin').doc(currentUser.uid).collection('history').doc('${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().second}${DateTime.now().millisecond}').set({
                                                                        'time': DateTime.now(),
                                                                        'docID': snapshots.data.docs[i].docID,
                                                                        'action': 'delete',
                                                                      }, SetOptions(merge: true)).catchError((onError) {
                                                                        gotError = true;
                                                                        showDialog(
                                                                            context: context,
                                                                            builder: (context) {
                                                                              return AlertDialog(
                                                                                title: Text('Error'),
                                                                                content: Text('Access Denied'),
                                                                              );
                                                                            }
                                                                        );
                                                                      });
                                                                      FirebaseFirestore.instance.collection('spots').doc(snapshots.data.docs[i].docID).delete().catchError((onError) {
                                                                        if(!gotError) {
                                                                          gotError = true;
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  title: Text('Error'),
                                                                                  content: Text('Access Denied'),
                                                                                );
                                                                              }
                                                                          );
                                                                        }
                                                                      });
                                                                      FirebaseFirestore.instance.collection('users').doc(snapshots.data.docs[i]['userid']).set({
                                                                        'spotuid': 'none',
                                                                      }, SetOptions(merge: true)).catchError((onError) {
                                                                        if(!gotError) {
                                                                          gotError = true;
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  title: Text('Error'),
                                                                                  content: Text('Access Denied'),
                                                                                );
                                                                              }
                                                                          );
                                                                        }
                                                                      });
                                                                      if(!gotError) {
                                                                        Navigator.pop(context);
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            }
                                                        );
                                                      },
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Color.fromRGBO(255, 23, 68, 1),
                                                    ),
                                                  ),
                                                  Spacer(
                                                    flex: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    FadeAnimationStatic(
                                      1+i*0.2+0.1,
                                      Divider(
                                        indent: 15,
                                        endIndent: 15,
                                        thickness: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            else {
                              return Container();
                            }
                          },
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
    );
  }
}
