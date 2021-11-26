import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuUpdatePage extends StatefulWidget {
  var docid;
  var doc;

  MenuUpdatePage(this.docid, this.doc);

  @override
  _MenuUpdatePageState createState() => _MenuUpdatePageState();
}

class _MenuUpdatePageState extends State<MenuUpdatePage> {
  final textEditingControllerName = TextEditingController();
  final textEditingControllerCost = TextEditingController();
  bool updateAble;

  @override
  void dispose() {
    textEditingControllerName.dispose();
    textEditingControllerCost.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      updateAble = widget.doc['able'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Store')
            .document(widget.docid)
            .collection('메뉴')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5, right: 5, left: 5),
                          child: TextField(
                            controller: textEditingControllerName,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.doc['menuName'],
                              hintStyle: TextStyle(fontFamily: 'beat'),
                            ),
                            cursorColor: Colors.white10,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5, right: 5, left: 5),
                          child: TextField(
                            controller: textEditingControllerCost,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.doc['cost'],
                              hintStyle: TextStyle(fontFamily: 'beat'),
                            ),
                            cursorColor: Colors.white10,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 60,),
                        Text('판매 가능 여부'),
                        Switch(
                          activeColor: Colors.blueGrey,
                            value: updateAble,
                            onChanged: (bool newValue) {
                            setState(() {
                              updateAble = newValue;
                            });

                            }),
                      ],
                    ),
                    SizedBox(height: 10,),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          child: SizedBox(
                            width: 200,
                            child: RaisedButton(
                              color: Colors.green,
                              onPressed: () {
                                updateDoc(widget.doc);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  '메뉴 업데이트',
                                  style: TextStyle(
                                      fontFamily: 'beat', color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(height: 20,),

                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          child: SizedBox(
                            width: 200,
                            child: RaisedButton(
                              color: Colors.red,
                              onPressed: () {
                                deleteDoc(widget.doc);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  '메뉴 삭제',
                                  style: TextStyle(
                                      fontFamily: 'beat', color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            );
          }
        });
  }

  Future<void> updateDoc(DocumentSnapshot doc) {
    Firestore.instance
        .collection('Store')
        .document(widget.docid)
        .collection('메뉴')
        .document(doc.documentID)
        .updateData({
          'menuName': textEditingControllerName.text==''?doc['menuName']:textEditingControllerName.text,
          'cost': textEditingControllerCost.text==''?doc['cost']:textEditingControllerCost.text,
          'able' : updateAble,
        })
        .then((value) => print("문서 업데이트"))
        .catchError((error) => print("Failed to delete user: $error"));
    Navigator.pop(context);
  }

  Future<void> deleteDoc(DocumentSnapshot doc) {
    Firestore.instance
        .collection('Store')
        .document(widget.docid)
        .collection('메뉴')
        .document(doc.documentID)
        .delete()
        .then((value) => print("문서 삭제"))
        .catchError((error) => print("Failed to delete user: $error"));
    Navigator.pop(context);
  }
}
