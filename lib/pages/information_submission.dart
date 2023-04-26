import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crhs_parking_app/animations/FadeAnimationUp.dart';
import 'package:crhs_parking_app/pages/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/sanitizers.dart';

bool _isAgreed = false;
bool _isRead = false;
bool _isGood = false;
DateTime _birth;
DateTime _licenseExpiration;
DateTime _insuranceExpiration;
bool _payCash = true;

String firstSave = '';
String lastSave = '';
String gradeSave = '';
String idSave = '';
String addressSave = '';
String zipSave = '';
String phoneSave = '';
String modelSave = '';
String colorSave = '';
String yearSave = '';
String plateSave = '';
String driverSave = '';

class InfoSubmit extends StatefulWidget {
  DocumentReference reference;
  InfoSubmit(this.reference);
  @override
  _InfoSubmitState createState() => _InfoSubmitState();
}

class _InfoSubmitState extends State<InfoSubmit> {
  TextEditingController first = new TextEditingController(text: firstSave);
  TextEditingController last = new TextEditingController(text: lastSave);
  TextEditingController grade = new TextEditingController(text: gradeSave);
  TextEditingController id = new TextEditingController(text: idSave);
  TextEditingController address = new TextEditingController(text: addressSave);
  TextEditingController zip = new TextEditingController(text: zipSave);
  TextEditingController phone = new TextEditingController(text: phoneSave);
  TextEditingController model = new TextEditingController(text: modelSave);
  TextEditingController color = new TextEditingController(text: colorSave);
  TextEditingController year = new TextEditingController(text: yearSave);
  TextEditingController plate = new TextEditingController(text: plateSave);
  TextEditingController driver = new TextEditingController(text: driverSave);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                ),
                Text(
                  "Parking Information",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                ),
                Text(
                  "and Agreement",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Icons.person,
                      size: 50,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'Personal Info',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FieldGen("First Name", TextInputType.text, first),
                    FieldGen("Last Name", TextInputType.text, last)
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FieldGenMax("Grade Level", TextInputType.number, grade, 2),
                    FieldGen("Student Id", TextInputType.text, id)
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FieldGen('Street Address', TextInputType.text, address),
                    FieldGenMax("Zip Code", TextInputType.number, zip, 5),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FieldGenMax(
                        "Phone Number", TextInputType.number, phone, 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      width: (MediaQuery.of(context).size.width - 20) / 2,
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            Text(
                              _birth == null
                                  ? 'Date of Birth'
                                  : '${_birth.month}/${_birth.day}/${_birth.year}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                        onPressed: () {
                          firstSave = first.text;
                          lastSave = last.text;
                          gradeSave = grade.text;
                          idSave = id.text;
                          addressSave = address.text;
                          zipSave = zip.text;
                          phoneSave = phone.text;
                          modelSave = model.text;
                          colorSave = color.text;
                          yearSave = year.text;
                          plateSave = plate.text;
                          driverSave = driver.text;

                          showDatePicker(
                            context: context,
                            initialDate: _birth != null
                                ? _birth
                                : DateTime(DateTime.now().year),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(DateTime.now().year),
                          ).then((date) {
                            setState(() {
                              _birth = date;
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Icons.directions_car,
                      size: 50,
                    ),
                    Container(
                      width: 5,
                    ),
                    Text(
                      'Car Info',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FieldGen("Make/Model", TextInputType.text, model),
                    FieldGen("Color", TextInputType.text, color),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FieldGenMax("Year", TextInputType.number, year, 4),
                    FieldGenSmall(
                        "License Plate Number", TextInputType.text, plate)
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FieldGenMaxSmall("Driver's License Number",
                        TextInputType.number, driver, 8),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      width: (MediaQuery.of(context).size.width - 20) / 2,
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            Text(
                              _licenseExpiration == null
                                  ? 'License Exp.'
                                  : '${_licenseExpiration.month}/${_licenseExpiration.day}/${_licenseExpiration.year}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                        onPressed: () {
                          firstSave = first.text;
                          lastSave = last.text;
                          gradeSave = grade.text;
                          idSave = id.text;
                          addressSave = address.text;
                          zipSave = zip.text;
                          phoneSave = phone.text;
                          modelSave = model.text;
                          colorSave = color.text;
                          yearSave = year.text;
                          plateSave = plate.text;
                          driverSave = driver.text;

                          showDatePicker(
                            context: context,
                            initialDate: _licenseExpiration != null
                                ? _licenseExpiration
                                : DateTime(DateTime.now().year),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(2070),
                          ).then((licensedate) {
                            setState(() {
                              _licenseExpiration = licensedate;
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      width: (MediaQuery.of(context).size.width - 20) / 2,
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            Text(
                              _insuranceExpiration == null
                                  ? 'Insurance Exp.'
                                  : '${_insuranceExpiration.month}/${_insuranceExpiration.day}/${_insuranceExpiration.year}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                        onPressed: () {
                          firstSave = first.text;
                          lastSave = last.text;
                          gradeSave = grade.text;
                          idSave = id.text;
                          addressSave = address.text;
                          zipSave = zip.text;
                          phoneSave = phone.text;
                          modelSave = model.text;
                          colorSave = color.text;
                          yearSave = year.text;
                          plateSave = plate.text;
                          driverSave = driver.text;

                          showDatePicker(
                            context: context,
                            initialDate: _insuranceExpiration != null
                                ? _insuranceExpiration
                                : DateTime(DateTime.now().year),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(2050),
                          ).then((insurancedate) {
                            setState(() {
                              _insuranceExpiration = insurancedate;
                            });
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 45,
                      child: ToggleSwitch(
                          minWidth:
                              (MediaQuery.of(context).size.width - 20) / 4,
                          cornerRadius: 5,
                          // theme: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          labels: ['Cash', 'Check'],
                          activeBgColors: [Colors.green, Colors.blue],
                          onToggle: (index) {
                            if (index == 0) {
                              _payCash = true;
                            } else {
                              _payCash = false;
                            }
                            print('Cash is ' + _payCash.toString());
                          }),
                    )
                  ],
                ),
                SizedBox(height: 20),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isAgreed,
                  onChanged: (agree) {
                    firstSave = first.text;
                    lastSave = last.text;
                    gradeSave = grade.text;
                    idSave = id.text;
                    addressSave = address.text;
                    zipSave = zip.text;
                    phoneSave = phone.text;
                    modelSave = model.text;
                    colorSave = color.text;
                    yearSave = year.text;
                    plateSave = plate.text;
                    driverSave = driver.text;

                    setState(() {
                      _isAgreed = agree;
                    });
                    print(_isAgreed);
                  },
                  title: Text(
                    'I understand that KISD assumes no liability for student parking. Students park at their own risk with regard to accidental damage to vehicles.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isRead,
                  onChanged: (read) async {
                    firstSave = first.text;
                    lastSave = last.text;
                    gradeSave = grade.text;
                    idSave = id.text;
                    addressSave = address.text;
                    zipSave = zip.text;
                    phoneSave = phone.text;
                    modelSave = model.text;
                    colorSave = color.text;
                    yearSave = year.text;
                    plateSave = plate.text;
                    driverSave = driver.text;

                    if (await canLaunchUrl(
                            'http://www.katyisd.org/campus/CRHS/Documents/PARKING%20PACKET%20%202020-21.pdf'
                                as Uri) &&
                        read) {
                      await launchUrl(
                          'http://www.katyisd.org/campus/CRHS/Documents/PARKING%20PACKET%20%202020-21.pdf'
                              as Uri);
                    } else {}
                    setState(() {
                      _isRead = read;
                    });
                    print(_isRead);
                  },
                  title: Text(
                    'I acknowledge that I have received and read the KISD & CRHS Parking Rules and Regulations information.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isGood,
                  onChanged: (good) {
                    firstSave = first.text;
                    lastSave = last.text;
                    gradeSave = grade.text;
                    idSave = id.text;
                    addressSave = address.text;
                    zipSave = zip.text;
                    phoneSave = phone.text;
                    modelSave = model.text;
                    colorSave = color.text;
                    yearSave = year.text;
                    plateSave = plate.text;
                    driverSave = driver.text;

                    setState(() {
                      _isGood = good;
                    });
                    print(_isGood);
                  },
                  title: Text(
                    'I have paid all school related fines and have a valid Driver\'s License, Insurance and School ID.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Container(
                    child: Container(
                      height: 48,
                      width: (MediaQuery.of(context).size.width - 10) / 2,
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (first != null &&
                        last != null &&
                        grade != null &&
                        id != null &&
                        address != null &&
                        zip != null &&
                        phone != null &&
                        _birth != null &&
                        model != null &&
                        color != null &&
                        year != null &&
                        plate != null &&
                        driver != null &&
                        _licenseExpiration != null &&
                        _insuranceExpiration != null &&
                        _isAgreed &&
                        _isRead &&
                        _isGood &&
                        first.text != '' &&
                        last.text != '' &&
                        grade.text != '' &&
                        id.text != '' &&
                        address.text != '' &&
                        zip.text != '' &&
                        phone.text.length == 10 &&
                        model.text != '' &&
                        color.text != '' &&
                        year.text != '' &&
                        plate.text != '' &&
                        driver.text != '') {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Wait'),
                              content: Text(
                                  'Please double check your information. Information regarding the reserved spot can be changed before the reserved spot is confirmed.'),
                              actions: [
                                ElevatedButton(
                                  child: Text(
                                    'Double Check',
                                    style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ),
                                  onPressed: () async {
                                    _isRead = false;
                                    _isAgreed = false;
                                    _isGood = false;

                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return WillPopScope(
                                            onWillPop: () async => false,
                                            child: AlertDialog(
                                              content: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 70,
                                                    ),
                                                    AspectRatio(
                                                      aspectRatio: 1,
                                                      child: FlareActor(
                                                        "assets/confirm.flr",
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.contain,
                                                        animation: 'Complete',
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 10,
                                                    ),
                                                    FadeAnimationUp(
                                                      3,
                                                      Text(
                                                        'Confirmed!',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .greenAccent,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 20,
                                                    ),
                                                    FadeAnimationUp(
                                                      3.5,
                                                      Text(
                                                        'Show your License and Insurance to your Counselor to Confirm your Parking Spot',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                    ),
                                                    ElevatedButton(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            50,
                                                        height: 50,
                                                        child: Center(
                                                          child: Text(
                                                            'Continue',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    Navigation()),
                                                            ModalRoute.withName(
                                                                '/'));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                    User currentUser =
                                        await FirebaseAuth.instance.currentUser;
                                    widget.reference.set({
                                      'first': first.text
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          first.text.substring(1),
                                      'last': last.text
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          last.text.substring(1),
                                      'grade': toInt(grade.text),
                                      'schoolID': id.text
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          id.text.substring(1),
                                      'address': address.text,
                                      'zipCode': zip.text,
                                      'phone': phone.text,
                                      'birth': _birth,
                                      'model': model.text,
                                      'color': color.text,
                                      'year': toInt(year.text),
                                      'licensePlate': plate.text,
                                      'driverLicenseNumber': driver.text,
                                      'licenseExpiration': _licenseExpiration,
                                      'insuranceExpiration':
                                          _insuranceExpiration,
                                      'isCash': _payCash,
                                      'confirmed': false,
                                      'completed': true,
                                    }, SetOptions(merge: true));

                                    _payCash = true;
                                  },
                                ),
                              ],
                            );
                          });
                    } else if (_isAgreed && _isRead && _isGood) {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                                  Text('Please submit all info to continue'),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                  'Please agree to the Terms and Conditions'),
                            );
                          });
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget FieldGen(
      String hint, TextInputType type, TextEditingController controller) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: (MediaQuery.of(context).size.width - 20) / 2,
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          keyboardType: type,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
            hintText: " " + hint,
            hintStyle: TextStyle(fontSize: 18, color: Colors.black),
            border: InputBorder.none,
          ),
        ));
  }

  Widget FieldGenMax(String hint, TextInputType type,
      TextEditingController controller, int max) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: (MediaQuery.of(context).size.width - 20) / 2,
        child: TextField(
          maxLength: max,
          controller: controller,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          keyboardType: type,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
            hintText: " " + hint,
            hintStyle: TextStyle(fontSize: 18, color: Colors.black),
            border: InputBorder.none,
          ),
        ));
  }

  Widget FieldGenSmall(
      String hint, TextInputType type, TextEditingController controller) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: (MediaQuery.of(context).size.width - 20) / 2,
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          keyboardType: type,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
            hintText: " " + hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.black),
            border: InputBorder.none,
          ),
        ));
  }

  Widget FieldGenMaxSmall(String hint, TextInputType type,
      TextEditingController controller, int max) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: (MediaQuery.of(context).size.width - 20) / 2,
        child: TextField(
          maxLength: max,
          controller: controller,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          keyboardType: type,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
            hintText: " " + hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.black),
            border: InputBorder.none,
          ),
        ));
  }
}
