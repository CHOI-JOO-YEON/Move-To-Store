import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu_add_page.dart';
import 'menu_update_page.dart';

class MenuManagementPage extends StatelessWidget {
  int num;
  var id;

  MenuManagementPage(this.num, this.id);

  Color getColor(DocumentSnapshot doc) {
    if (doc['able'] == false) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Store')
            .document(id)
            .collection('메뉴')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MenuAddPage(num, id)));
                  // Add your onPressed code here!
                },
                label: const Text(
                  '메뉴 생성',
                  style: TextStyle(fontFamily: 'beat'),
                ),
                icon: const Icon(Icons.add),
                backgroundColor: Colors.blueGrey,
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 5, left: 5),
                child: Column(children: [
                  Expanded(
                    child: ListView(
                      children: snapshot.data.documents.map((doc) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: getColor(doc),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            doc['menuName'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontFamily: "beat"),
                                          ),
                                          trailing: Text(
                                            '${doc['cost']}원',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontFamily: "beat"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                          onPressed: () {

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => MenuUpdatePage(id, doc)));
                                            // Add your onPressed code here!

                                          },
                                          icon: Icon(
                                            Icons.create,
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
              ),
            );
          }
        });

  }


}
