import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'master_detail_page.dart';

class MasterMainPage extends StatefulWidget {
  @override
  _MasterMainPageState createState() => _MasterMainPageState();
}

class _MasterMainPageState extends State<MasterMainPage> {
  bool message = true;
  final textEditingController = TextEditingController();

  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('Store').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5, right: 5, left: 5),
                                child: TextField(
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '가게 코드 입력',
                                    hintStyle: TextStyle(fontFamily: 'beat'),
                                  ),
                                  cursorColor: Colors.white10,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                print('push');
                                nextStage(snapshot.data.documents);



                              },
                              icon: Icon(Icons.search)),
                          Text(warningMessage()),
                          SizedBox(
                            height: 30,
                          ),

                          Text(
                            '가게 코드는 대소문자를 구분합니다',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'beat', color: Colors.deepOrange),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '등록되어 있지 않은 가게의 경우 \n홈페이지에서 신청하신 후 이용할 수 있습니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'beat', color: Colors.orangeAccent),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
            })

        //body: Container(
        );
  }

  void nextStage(List<DocumentSnapshot> Documents) {
    var check = 0;
    for (int i = 0; i < Documents.length; i++) {
      if (Documents[i]['userName'] == textEditingController.text) {
        check =  1;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MasterDetailPage(Documents[i], i)));
      }
    }
    if(check ==0)
      {
    setState(() {
      message=false;
    });}
    if(check ==1)
      {
        setState(() {
          message=true;
        });
      }

  }

  String warningMessage() {


    if(message == false)
      {
        return '잘못된 코드입니다.';
      }else{
      return '';
    }

  }
}
