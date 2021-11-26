import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuAddPage extends StatefulWidget {
  int num;
  final id;
  MenuAddPage(this.num,this.id);


  @override
  _MenuAddPageState createState() => _MenuAddPageState();
}

class _MenuAddPageState extends State<MenuAddPage> {


  final textEditingControllerName = TextEditingController();
  final textEditingControllerCost = TextEditingController();


  @override
  void dispose() {
    textEditingControllerName.dispose();
    textEditingControllerCost.dispose();
    super.dispose();
  }
  @override
  Future<void> _upload(BuildContext context) async{

    await Firestore.instance.collection('Store').document(widget.id).collection('메뉴').add(
        {
          'menuName' : textEditingControllerName.text,
          'cost' : textEditingControllerCost.text,
          'able' : true,

        }

    ).then((value) => print("완료"))
        .catchError((error) => print("Failed to add user: $error"));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
                    controller: textEditingControllerName,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '메뉴 이름 입력',
                      hintStyle: TextStyle(fontFamily: 'beat'),
                    ),
                    cursorColor: Colors.white10,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
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
                    controller: textEditingControllerCost,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '메뉴 가격 입력',
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
                SizedBox(
                  width: 50,
                ),
                Text('메뉴 생성',style: TextStyle(fontFamily: 'beat'),),
                IconButton(onPressed: () {
                  _upload(context);

                }, icon: Icon(Icons.create)),
              ],
            )
          ],
        ),
      ),


    );
  }
}

