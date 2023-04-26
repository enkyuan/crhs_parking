import 'package:crhs_parking_app/pages/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crhs_parking_app/admin/login/google_sign_in.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  VideoPlayerController videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    setState(() {
      videoPlayerController = VideoPlayerController.asset('assets/above.mp4');
    });
    _initializeVideoPlayerFuture = videoPlayerController.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 250, 1),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  videoPlayerController.play();
                  videoPlayerController.setLooping(true);
                  return Container(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: videoPlayerController.value.size.width,
                        height: videoPlayerController.value.size.height,
                        child: VideoPlayer(
                          videoPlayerController,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.black,
                  );
                }
              },
            ),
          ),
          Container(
            color: Color.fromRGBO(83, 148, 255, 0.25),
          ),
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  Image.asset(
                    'assets/crhs.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  Container(
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height /
                                    MediaQuery.of(context).size.width >=
                                16 / 9
                            ? MediaQuery.of(context).size.width / 8
                            : 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  Container(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height /
                                    MediaQuery.of(context).size.width >=
                                16 / 9
                            ? MediaQuery.of(context).size.width / 12
                            : 35,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  Container(
                    child: Text(
                      'with your KatyISD Account',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height /
                                    MediaQuery.of(context).size.width >=
                                16 / 9
                            ? MediaQuery.of(context).size.width / 20
                            : 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 135,
              ),
              Container(
                height: 60,
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  child: Image.asset('assets/google_signin.png'),
                  onPressed: () async {
                    await authService.googleSignIn().catchError((onError) {
                      print(onError.toString());
                      if (onError.toString() ==
                          'PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 12500: , null)') {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('Cannot Sign in with Google'),
                              );
                            });
                      }
                    });
                    String uid;
                    String email;
                    await FirebaseAuth.instance.currentUser;
                    // uid = currentUser.uid;
                    // email = currentUser.email;
                    DocumentSnapshot userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get();
                    if (email.endsWith('@students.katyisd.org')) {
                      Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                              builder: (context) => Navigation()),
                          ModalRoute.withName('/login'));
                    } else {
                      print('invalid account');
                      FirebaseAuth.instance.signOut();
                      authService.signOut();
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Use your KatyISD Google Account'),
                            );
                          });
                    }
                  },
                ),
              ),
              Container(
                height: 10,
              ),
              Container(
                width: 240,
                height: 50,
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/adminlogo.png',
                        height: 30,
                      ),
                      Container(
                        width: 30,
                      ),
                      Text(
                        'Admin Access',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  color: Colors.black54,
                  splashColor: Colors.transparent,
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AdminSignin()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(_profile.toString()),
    );
  }
}
