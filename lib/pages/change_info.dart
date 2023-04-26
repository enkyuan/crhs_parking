import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:validators/sanitizers.dart';
import 'navigation.dart';
import 'process_info.dart';

class InfoChange extends StatefulWidget {
  InfoChange();
  @override
  _InfoChangeState createState() => _InfoChangeState();
}

class _InfoChangeState extends State<InfoChange> {
  @override
  Widget build(BuildContext context) {

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

    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 239, 241, 1),
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
                Container(
                  child: Text('Change Your Info',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 10,),
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
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
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
                    FieldGenMax("Phone Number", TextInputType.number, phone, 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      width: (MediaQuery.of(context).size.width-20)/2,
                      child: TextButton(
                        child: Row(
                          children: [
                            Text(
                              birth == null ? 'Date of Birth' : '${birth.month}/${birth.day}/${birth.year}',
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
                            initialDate: birth != null ? birth : DateTime(DateTime.now().year),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(DateTime.now().year),
                          ).then((date) {
                            setState(() {
                              birth = date;
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
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                      ),
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
                    FieldGenSmall("License Plate Number", TextInputType.text, plate)
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FieldGenMaxSmall("Driver's License Number", TextInputType.number, driver, 8),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      width: (MediaQuery.of(context).size.width-20)/2,
                      child: TextButton(
                        child: Row(
                          children: [
                            Text(
                              licenseExpiration == null ? 'License Exp.' : '${licenseExpiration.month}/${licenseExpiration.day}/${licenseExpiration.year}',
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
                            initialDate: licenseExpiration != null ? licenseExpiration : DateTime(DateTime.now().year),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(2070),
                          ).then((licensedate) {
                            setState(() {
                              licenseExpiration = licensedate;
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
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      width: (MediaQuery.of(context).size.width-20)/2,
                      child: TextButton(
                        child: Row(
                          children: [
                            Text(
                              insuranceExpiration == null ? 'Insurance Exp.' : '${insuranceExpiration.month}/${insuranceExpiration.day}/${insuranceExpiration.year}',
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
                            initialDate: insuranceExpiration != null ? insuranceExpiration : DateTime(DateTime.now().year),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(2050),
                          ).then((insurancedate) {
                            setState(() {
                              insuranceExpiration = insurancedate;
                            });
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      child: ToggleSwitch(
                        initialLabelIndex: payCash ? 0 : 1,
                        minWidth: (MediaQuery.of(context).size.width-20)/4.0,
                        cornerRadius: 5,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        labels: ['Cash', 'Check'],
                        activeBgColors: [Colors.green, Colors.blue],
                        onToggle: (index) {
                          if (index == 0) {
                            payCash = true;
                          }
                          else {
                            payCash = false;
                          }
                          print('Cash is ' + payCash.toString());
                        }
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                InkWell(
                  child: Container(
                    child: Container(
                      height: 48,
                      width: (MediaQuery.of(context).size.width-10)/2,
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
                  onTap: () async {
                    if(first!=null&&
                        last!=null&&
                        grade!=null&&
                        id!=null&&
                        address!=null&&
                        zip!=null&&
                        phone!=null&&
                        birth!=null&&
                        model!=null&&
                        color!=null&&
                        year!=null&&
                        plate!=null&&
                        driver!=null&&
                        licenseExpiration!=null&&
                        insuranceExpiration!=null&&
                        first.text!=''&&
                        last.text!=''&&
                        grade.text!=''&&
                        id.text!=''&&
                        address.text!=''&&
                        zip.text!=''&&
                        phone.text!=''&&
                        model.text!=''&&
                        color.text!=''&&
                        year.text!=''&&
                        plate.text!=''&&
                        driver.text!='') {
                      User currentUser = await FirebaseAuth.instance.currentUser;
                      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
                      DocumentReference reference = FirebaseFirestore.instance.collection('spots').doc((userDoc.data as DocumentSnapshot)['spotuid']);
                      await reference.set({
                        'first': first.text.substring(0, 1).toUpperCase()+first.text.substring(1),
                        'last': last.text.substring(0, 1).toUpperCase()+last.text.substring(1),
                        'grade': toInt(grade.text),
                        'schoolID': id.text.substring(0, 1).toUpperCase()+id.text.substring(1),
                        'address': address.text,
                        'zipCode': zip.text,
                        'phone': phone.text,
                        'birth': birth,
                        'model': model.text,
                        'color': color.text,
                        'year': toInt(year.text),
                        'licensePlate': plate.text,
                        'driverLicenseNumber': driver.text,
                        'licenseExpiration': licenseExpiration,
                        'insuranceExpiration': insuranceExpiration,
                        'isCash': payCash,
                        'confirmed': false,
                        'completed': true,
                        'userid': currentUser.uid,
                      }, SetOptions(merge: true));
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Navigation()));
                    }
                    else {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('Please submit all info to continue'),
                            );
                          }
                      );
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

  Widget FieldGen (String hint, TextInputType type, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))

      ),
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
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.black
            ),
            border: InputBorder.none,

        ),
      )
    );
  }

  Widget FieldGenMax (String hint, TextInputType type, TextEditingController controller, int max) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
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
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.black
            ),
            border: InputBorder.none,

        ),
      )
    );
  }

  Widget FieldGenSmall (String hint, TextInputType type, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),

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
            hintStyle: TextStyle(
              fontSize: 13,
              color: Colors.black
          ),

          border: InputBorder.none,
        ),
      )
    );
  }

  Widget FieldGenMaxSmall(String hint, TextInputType type, TextEditingController controller, int max) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))

      ),
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
            top: 8.0, bottom: 8.0, left: 10.0, right: 10.0
          ),
          hintText: " " + hint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.black
          ),

          border: InputBorder.none,
          ),
      )
    );
  }
}