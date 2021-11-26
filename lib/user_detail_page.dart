import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  DocumentSnapshot document;
  UserDetailPage(this.document);

  @override


  Widget build(BuildContext context) {
    return
//      document==null?Center(child: CircularProgressIndicator(),):
      Scaffold(


        body:

          document == null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
              Text('데이터를 불러오는 중입니다. 인터넷 연결을 확인하세요')
            ],
          ):
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 30,right: 10,left: 10, bottom: 15),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(width: 3,color: Colors.black87),
                    borderRadius: BorderRadius.all(
                        Radius.circular(15.0))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Container(


                            decoration: BoxDecoration(

                                color: Colors.black45,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15.0))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(document['storeName'],style: TextStyle(fontSize: 25,color: Colors.white
                                      ,fontFamily: "beat"

                                      ),),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Text('메뉴',style: TextStyle(color: Colors.black87,fontSize: 30,fontFamily: "beat"),),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: _menuStream(),
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData)
                                      {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                    return ListView(
                                      children: snapshot.data.documents.map((doc){
                                        return Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey,

                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))
                                            ),
                                            child: ListTile(
                                              title: Text(doc['menuName'],style: TextStyle(fontSize: 20
                                              ,color: Colors.white,fontFamily: "beat"
                                              ),),
                                              trailing: getable(doc),

                                            ),
                                          ),
                                        );
                                      }).toList(),

                                    );

                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),


    );
  }
Widget getable(DocumentSnapshot doc){
    if(doc['able']==false)
      {
        return Text('매진',style: TextStyle(fontSize: 20
            ,color: Colors.red,fontFamily: "beat"));
      }

    return Text('${doc['cost']}원',style: TextStyle(fontSize: 20
        ,color: Colors.white,fontFamily: "beat"
    ),);
}
 Stream<QuerySnapshot> _menuStream() {
    return Firestore.instance
        .collection('Store')
        .document(document.documentID)
        .collection('메뉴')
        .snapshots();

 }
}
