import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mts_1/user_detail_page.dart';
import 'package:flutter_mts_1/user_eval_list_page.dart';



class UserTabPage extends StatefulWidget {

  DocumentSnapshot document;
  int j;
  UserTabPage(this.document,this.j);

  @override
  _UserTabPageState createState() => _UserTabPageState();
}

class _UserTabPageState extends State<UserTabPage> {
  int _selectedIndex = 0;

  List _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      UserDetailPage(widget.document),
      UserEvalListPage(widget.document,widget.j)
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('tab_page created');
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text('메뉴판')),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text('리뷰')),

        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
