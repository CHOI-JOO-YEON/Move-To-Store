import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'menu_management_page.dart';

class MasterDetailPage extends StatelessWidget {
  int _num = 0;

  DocumentSnapshot _document;

  MasterDetailPage(this._document, this._num);

  Future<void> _updateOpenState(DocumentSnapshot doc, bool currentState) {
    return Firestore.instance
        .collection('Store')
        .document(doc.documentID)
        .updateData({'open': !currentState}).then((value) => print('업데이트 완료'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Store').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    snapshot.data.documents[_num]['storeName'],
                    style: TextStyle(fontFamily: 'beat', fontSize: 50),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: SizedBox(
                          width: 250,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 5, right: 5, left: 5),
                              child: Center(
                                  child:
                                      getOpen(snapshot.data.documents[_num]))),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _updateOpenState(snapshot.data.documents[_num],
                                snapshot.data.documents[_num]['open']);
                          },
                          icon:
                              getOpenStateIcon(snapshot.data.documents[_num])),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                        width: 300,

                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuManagementPage(_num,snapshot.data.documents[_num].documentID)));

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('메뉴 관리',style: TextStyle(fontFamily: 'beat',fontSize: 30),),
                          ),
                        )),
                  ),
                  SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                        width: 300,

                        child: RaisedButton(
                          onPressed: () {
                            getCurrentLocation(snapshot.data.documents[_num]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('위치 갱신',style: TextStyle(fontFamily: 'beat',fontSize: 30),),
                          ),
                        )),
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget getOpenStateIcon(DocumentSnapshot doc) {
    if (doc['open'] == true) {
      return Icon(Icons.stop);
    } else {
      return Icon(Icons.play_arrow);
    }
  }
  Future<void> getCurrentLocation(DocumentSnapshot doc) async {

    Position position =await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print(position.longitude);
    return Firestore.instance
        .collection('Store')
        .document(doc.documentID)
        .updateData({'geopoint':  GeoPoint(position.latitude,position.longitude, )


        }).then((value) => print('업데이트 완료'));

  }

  Widget getOpen(DocumentSnapshot document) {
    if (document['open'] == true) {
      return Text(
        '영업 중',
        style: TextStyle(fontFamily: 'beat', fontSize: 30, color: Colors.green),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        '쉬는 중',
        style: TextStyle(
            fontFamily: 'beat', fontSize: 30, color: Colors.redAccent),
        textAlign: TextAlign.center,
      );
    }
  }
}
