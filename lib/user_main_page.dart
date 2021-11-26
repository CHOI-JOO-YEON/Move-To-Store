import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mts_1/user_detail_page.dart';
import 'package:flutter_mts_1/user_tab_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class UserMainPage extends StatefulWidget {
  @override
  _UserMainPageState createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  num latitude=36.76549777631354;
  num longitude=127.28042932109757;
  var geoPoint = GeoPoint(36.81952629198124, 127.15649652948832);
  final Distance _distance = Distance();
  num _realDistance;
  bool short = true;
  bool star = false;
  List<DocumentSnapshot> _document = [];
  List<int> nim = [];

  int soltNum = 1;

  void fetch() {
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
  }

  void getDocument(List<DocumentSnapshot> documents, int num) {
//    List<DocumentSnapshot> dot = [];
//
//    for (int i = 0; i < documents.length; i++) {
//      dot.add(documents[i]);
//      //_document[i]=documents[i];
//    }
//    _document = dot;
    soltDocument(documents, num);
  }

  int getNum(List<DocumentSnapshot> documents) {
    int k = 0;
    for (int i = 0; i < documents.length; i++) {
      if (documents[i]['open'] == true) {
        k++;
      }
    }

    return k;
  }

  void soltDocument(List<DocumentSnapshot> documents, int num) {
    nim=[];

    List<DocumentSnapshot> dot = [];
    List<DocumentSnapshot> openCheck = [];
    List<double> rank = [];
    double max;
    int target;
    for (int i = 0; i < documents.length; i++) {
      if (documents[i]['open'] == true) {
        openCheck.add(documents[i]);
      }
    }
    if (num == 1)
    //가까운순 정렬
    {
      for (int i = 0; i < openCheck.length; i++) {
        rank.add(double.parse(getDistance(openCheck[i])));
      }
      while (true) {
        max = 25000;

        for (int i = 0; i < rank.length; i++) {
          if (rank[i] <= max) {
            max = rank[i];
            target = i;
          }
        }
        dot.add(openCheck[target]);
        rank[target] = 25000;
        nim.add(target);

        if (max == 25000) {
          break;
        }
      }
      _document = dot;


    } else if (num == 2)
    //별점순 정렬
    {
      for (int i = 0; i < openCheck.length; i++) {
        if (openCheck[i]['starNum'] is int) {
          rank.add(openCheck[i]['starNum'].toDouble());
        } else {
          rank.add(openCheck[i]['starNum']);
        }
      }
      while (true) {
        max = -1;

        for (int i = 0; i < rank.length; i++) {
          if (rank[i] >= max) {
            max = rank[i];
            target = i;
          }
        }
        dot.add(openCheck[target]);
        nim.add(target);
        rank[target] = -1;
        if (max == -1) {
          break;
        }
      }
      _document = dot;


    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListPage(),
    );
  }

  String getDistance(DocumentSnapshot document) {
    _realDistance = _distance.as(LengthUnit.Meter, LatLng(latitude, longitude),
        LatLng(document['geopoint'].latitude, document['geopoint'].longitude));
    return _realDistance.toString();
  }

  String getDetailDistacne(DocumentSnapshot document) {
    int distance = (_distance.as(
            LengthUnit.Meter,
            LatLng(latitude, longitude),
            LatLng(
                document['geopoint'].latitude, document['geopoint'].longitude)))
        .toInt();
    return '${distance.toString()} m';
  }

  Widget ListPage() {
    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Store').snapshots(),
          builder: (context, snapshot) {
            getDocument(snapshot.data.documents, soltNum);
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, right: 10, left: 10, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 3, color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        )),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '새로고침',
                              style: TextStyle(fontFamily: "beat"),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    fetch();
                                    getDocument(
                                        snapshot.data.documents, soltNum);
                                  });
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.white70,
                                )),
                            SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    '가까운순 정렬',
                                    style: TextStyle(fontFamily: "beat"),
                                  ),
                                  Switch(
                                      activeColor: Colors.white,
                                      value: short,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          star = short;
                                          short = newValue;

                                          if (newValue == true) {
                                            soltNum = 1;
                                          }
                                          if (newValue == false) {
                                            soltNum = 2;
                                          }
                                        });
                                      })
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Row(
                                children: [
                                  Text(
                                    '별점순 정렬',
                                    style: TextStyle(fontFamily: "beat"),
                                  ),
                                  Switch(
                                      activeColor: Colors.white,
                                      value: star,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          short = star;
                                          star = newValue;
                                          if (newValue == true) {
                                            soltNum = 2;
                                          }
                                          if (newValue == false) {
                                            soltNum = 1;
                                          }
                                        });
                                      })
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: getNum(snapshot.data.documents),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserTabPage(_document[index],nim[index])));
                              },
//                              leading: Text(
//                                (index + 1).toString(),
//                                style: TextStyle(fontSize: 30),
//                              ),
                              title: Text(
//                                            snapshot.data.documents[index]
                                _document[index]['storeName'],
                                style: TextStyle(
                                    fontSize: 27,
                                    color: Colors.white,
                                    fontFamily: "beat"),
                              ),
                              subtitle: Text(
                                _document[index]['starNum'].toString().length ==
                                        1
                                    ? _document[index]['starNum'].toString() +
                                        '.0'
                                    : _document[index]['starNum'].toStringAsFixed(1),
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 20,
                                    fontFamily: "beat"),
                              ),
                              trailing: Text(
//                                '${getDistance(_document[index])}km',
                                getDetailDistacne(_document[index]),

                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: "beat"),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }
}
