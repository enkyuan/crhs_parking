import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crhs_parking_app/login/google_sign_in.dart';
import 'package:crhs_parking_app/pages/process_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crhs_parking_app/login/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'map.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  User currentStudent;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    User getUser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(getUser.uid).get();
    currentStudent = User.fromSnapshot(userData);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if(currentStudent==null) {
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
        body: Column(
          children: [
            Container(
              height: 50,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                ),
                Container(
                  child: Text('Settings',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 25,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                ),
                Container(
                  child: TextButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width-50,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.feedback,
                            color: Colors.lightBlueAccent,
                          ),
                          Container(
                            width: 10,
                          ),
                          Text(
                            'Feedback',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      if (await canLaunchUrl('https://forms.gle/NcPZGGcLJKaFFEEh7' as Uri)) {
                      await launchUrl('https://forms.gle/NcPZGGcLJKaFFEEh7' as Uri);
                      }
                      else {

                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(129, 212, 250, 1),  // Button color
                      foregroundColor: Color.fromRGBO(79, 195, 247, 1),   // Splash color
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(currentStudent.uid).snapshots(),
                  builder: (context, snapshots) {
                    if(!snapshots.hasData) {
                      return Container();
                    }
                    else {
                      if(snapshots.data['spotuid']=='none') {
                        return Container();
                      }
                      else {
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('spots').doc(snapshots.data['spotuid']).snapshots(),
                          builder: (context, snap) {
                            if(!snap.hasData) {
                              return Container();
                            }
                            else {
                              if(snap.data['confirmed']) {
                                return Container();
                              }
                              else {
                                return Column(
                                  children: <Widget>[
                                    snap.data['completed'] ? Container(
                                      child: TextButton(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width-50,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.info_outline,
                                                color: Colors.lightBlue,
                                              ),
                                              Container(
                                                width: 10,
                                              ),
                                              Text(
                                                'Change Info',
                                                style: TextStyle(
                                                  color: Colors.lightBlue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Process()));
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(129, 212, 250, 1),  // Button color
                                          foregroundColor: Color.fromRGBO(79, 195, 247, 1),   // Splash color
                                        ),
                                      ),
                                    ) : Container(),
                                    Container(
                                      child: TextButton(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width-50,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.local_parking,
                                                color: Colors.black54,
                                              ),
                                              Container(
                                                width: 10,
                                              ),
                                              Text(
                                                'Change Spot',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Map()));
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.black12,  // Button color
                                          foregroundColor: Colors.black38,   // Splash color
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width-50,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.redAccent,
                                              ),
                                              Container(
                                                width: 10,
                                              ),
                                              Text(
                                                'Remove Spot',
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {
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
                                                content: Text('Are You Sure You Want to Remove Your Reservation'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance.collection('spots').doc(snapshots.data['spotuid']).delete();
                                                      FirebaseFirestore.instance.collection('users').doc(currentStudent.uid).set({
                                                        'spotuid': 'none'
                                                      }, SetOptions(merge: true));
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            }
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(239, 154, 154, 1),  // Button color
                                          foregroundColor: Color.fromRGBO(255, 205, 210, 1),   // Splash color
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                ),
                Container(
                  child: TextButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width-50,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                          ),
                          Container(
                            width: 10,
                          ),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      authService.signOut();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Signin()),ModalRoute.withName('/pages'));
                    },

                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 205, 210, 1),  // Button color
                      foregroundColor: Color.fromRGBO(239, 154, 154, 1),   // Splash color
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
