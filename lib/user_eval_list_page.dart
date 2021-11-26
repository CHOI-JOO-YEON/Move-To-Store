import 'package:flutter/material.dart';
import 'package:flutter_mts_1/user_eval_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEvalListPage extends StatefulWidget {
  DocumentSnapshot document;
  int j;

  UserEvalListPage(this.document, this.j);

  @override
  _UserEvalListPageState createState() => _UserEvalListPageState();
}

class _UserEvalListPageState extends State<UserEvalListPage> {
  String _avgEval = '0.0';

  Future<void> startDash() async {
    QuerySnapshot doc = await Firestore.instance
        .collection('Store')
        .document(widget.document.documentID)
        .collection('리뷰')
        .getDocuments();

    double j = 0;
    for (int i = 0; i < doc.documents.length; i++) {
      j = (j + doc.documents[i]['starNum']).toDouble();
    }

    j = j / doc.documents.length;
    if (doc.documents.length == 0) {
      j = 0;
    }

    await Firestore.instance
        .collection('Store')
        .document(widget.document.documentID)
        .updateData({'starNum': j});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDash();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Store')
//            .document(widget.document.documentID)
//            .collection('리뷰')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserEvalPage(widget.document)));

                },
                label: const Text('리뷰 작성'),
                icon: const Icon(Icons.thumb_up),
                backgroundColor: Colors.blueGrey,
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 20, right: 5, bottom: 5),
                child: Column(
                  children: [
                    Text(
                      '평균 평점   ${snapshot.data.documents[widget.j]['starNum'].toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 30,fontFamily: 'beat'),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Store')
                              .document(widget.document.documentID)
                              .collection('리뷰')
                              .snapshots(),
                          builder: (context, s) {
                            if (!s.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return ListView(
                              children: s.data.documents.map((doc) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    child: ListTile(
                                      title: getComment(doc),
                                      trailing: Text(
                                        doc['starNum'].toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: "beat"),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                    )
                  ],
                ),
              ),
            );
          }
        });

  }
  Widget getComment(DocumentSnapshot doc) {

    if(doc['comment']=='')
      {
        return Text('코멘트 없음',

          style: TextStyle(
              fontSize: 20,
              color: Colors.grey[400],
              fontFamily: "beat"),
        );
      }
      else{
        return Text(
          doc['comment'],
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: "beat"),
        );
    }


  }

}
