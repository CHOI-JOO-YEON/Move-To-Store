
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserEvalPage extends StatefulWidget {
  DocumentSnapshot document;

  UserEvalPage(this.document);


  @override
  _UserEvalPageState createState() => _UserEvalPageState();
}

class _UserEvalPageState extends State<UserEvalPage> {


  int _starNum =5;


  final textEditingControllerComent = TextEditingController();



  @override
  void dispose() {
    textEditingControllerComent.dispose();

    super.dispose();
  }


  Future<void> _upload(BuildContext context) async{

    await Firestore.instance.collection('Store').document(widget.document.documentID).collection('리뷰').add(
        {
          'comment' : textEditingControllerComent.text,
          'starNum' : _starNum,


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
                    controller: textEditingControllerComent,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '코멘트를 남기세요',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {
                  if(_starNum==0)
                  {

                  }
                  else{
                    setState(() {
                      _starNum--;
                    });

                  }

                }, icon: Icon(Icons.remove)),
                Text(_starNum.toString(),style: TextStyle(fontFamily: 'beat'),),
                IconButton(onPressed: () {
                  if(_starNum==5)
                  {

                  }
                  else{
                    setState(() {
                      _starNum++;
                    });

                  }
                }, icon: Icon(Icons.add))

              ],
            ),

            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text('리뷰 생성',style: TextStyle(fontFamily: 'beat'),),
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

