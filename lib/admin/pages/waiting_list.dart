import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crhs_parking_app/animations/FadeAnimationLeft.dart';
import 'package:crhs_parking_app/animations/FadeAnimationStatic.dart';
import 'package:crhs_parking_app/admin/pages/info_page.dart';
import 'package:flutter/material.dart';

class WaitingList extends StatefulWidget {
  @override
  _WaitingListState createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {

  List<int> spotSearch = new List<int>();

  TextEditingController searchController = new TextEditingController(text: '');
  String query = '';

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
                                keyboardType: TextInputType.number,
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
                                  hintText: 'Search by Spot Number',
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
                          itemCount: snapshots.data.documents.length,
                          itemBuilder: (context, i) {
                            if(snapshots.data.documents[i]['spot']!=0&&snapshots.data.documents[i]['completed']&&!snapshots.data.documents[i]['confirmed']&&snapshots.data.documents[i]['spot'].toString().contains(query)) {
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    FadeAnimationLeft(
                                      1+i*0.2,
                                      TextButton(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 10,
                                              ),
                                              Text(
                                                '${snapshots.data.documents[i]['first']} ${snapshots.data.documents[i]['last']}',
                                                style: TextStyle(
                                                  fontSize: 23,
                                                ),
                                              ),
                                              Container(
                                                width: 10,
                                              ),
                                              Text(
                                                '${snapshots.data.documents[i]['spot']}',
                                                style: TextStyle(
                                                  fontSize: 23,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SpotInfo(snapshots.data.documents[i])));
                                        },
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
