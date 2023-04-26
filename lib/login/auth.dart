import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User> user;
  Stream<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = _auth.authStateChanges();
    profile = user.switchMap((User u) {
      if (u != null) {
        return _db
            .collection('users')
            .doc(u.uid)
            .snapshots()
            .map((snap) => snap.data());
      } else {
        return Stream.value({});
      }
    });
  }
  Future<User> googleSignIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final User user = (await _auth.signInWithCredential(credential)).user;
    if (user.email.endsWith('@students.katyisd.org')) {
      updateUserData(user);
    }
    print(user.displayName + ' has been signed in');
    loading.add(false);
    return user;
  }

  void updateUserData(User user) async {
    DocumentReference ref = _db.collection('users').doc(user.uid);
    DocumentSnapshot snap = await _db.collection('users').doc(user.uid).get();
    String spotid;
    if (snap.data != null) {
      spotid = (snap.data as DocumentSnapshot)['spotuid'];
    } else {
      spotid = 'none';
    }
    return ref.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'spotuid': spotid,
      'url': user.photoURL,
    }, SetOptions(merge: true));
  }

  void signOut() {
    print('signed out');
    _auth.signOut();
    _googleSignIn.signOut();
  }
}

final AuthService authService = AuthService();
