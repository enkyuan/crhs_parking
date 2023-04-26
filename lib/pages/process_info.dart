import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'change_info.dart';

DateTime birth;
DateTime licenseExpiration;
DateTime insuranceExpiration;
bool payCash = true;

String firstSave;
String lastSave;
String gradeSave;
String idSave;
String addressSave;
String zipSave;
String phoneSave;
String modelSave;
String colorSave;
String yearSave;
String plateSave;
String driverSave;

class Process extends StatefulWidget {
  @override
  _ProcessState createState() => _ProcessState();
}

class _ProcessState extends State<Process> {

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
    if(currentStudent!=null) {
      return FutureBuilder(
        future: FirebaseFirestore.instance.collection('spots').doc(currentStudent.spotuid).get(),
        builder: (context, snapshots) {
          if(snapshots.data!=null) {
            birth = snapshots.data['birth'].toDate();
            licenseExpiration = snapshots.data['licenseExpiration'].toDate();
            insuranceExpiration = snapshots.data['insuranceExpiration'].toDate();
            payCash = snapshots.data['isCash'];
            firstSave = snapshots.data['first'];
            lastSave = snapshots.data['last'];
            gradeSave = snapshots.data['grade'].toString();
            idSave = snapshots.data['schoolID'];
            addressSave = snapshots.data['address'];
            zipSave = snapshots.data['zipCode'];
            phoneSave = snapshots.data['phone'];
            modelSave = snapshots.data['model'];
            colorSave = snapshots.data['color'];
            yearSave = snapshots.data['year'].toString();
            plateSave = snapshots.data['licensePlate'];
            driverSave = snapshots.data['driverLicenseNumber'];
            return InfoChange();
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
  }
}
