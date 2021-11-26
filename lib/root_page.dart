import 'package:flutter/material.dart';
import 'user_main_page.dart';

import 'master_main_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Move to Store',
                    style: TextStyle(
                        fontSize: 45,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: "beat"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: 270,
                      child: Image.network(
                          'https://cdn.pixabay.com/photo/2015/08/19/02/27/restaurant-895428_960_720.png')),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 310,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: RaisedButton(
                        color: Colors.grey[600],
                        child: Text(
                          '고객 페이지',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: "beat"),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserMainPage()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 310,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: RaisedButton(
                        color: Colors.grey[600],
                        child: Text('점주 페이지',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontFamily: "beat")),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MasterMainPage()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
