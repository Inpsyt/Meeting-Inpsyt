import 'package:flutter/material.dart';

class ScreenTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,
          ),



          RaisedButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Control Button',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          SizedBox(height: 20,),
          RaisedButton(
            color: Colors.yellow,
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Second Button',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
