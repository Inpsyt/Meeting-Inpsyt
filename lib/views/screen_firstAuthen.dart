import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenFistAuthen extends StatefulWidget {
  @override
  _ScreenFistAuthenState createState() => _ScreenFistAuthenState();
}

class _ScreenFistAuthenState extends State<ScreenFistAuthen> {


  String userNum = '';
  SharedPreferences _preferences;
  final  controller =TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPref();



  }

  _getPref() async{
    _preferences = await SharedPreferences.getInstance();
    /*
    setState(() {
      userNum = (_preferences.getString('userNum')??'12');
      controller.text = userNum;
      print('usernum='+userNum);
    });
     */

  }

  _loadUserPref() {
    userNum = (_preferences.getString('userNum')??'12');
    controller.text = userNum;
    print('usernum='+userNum);
  }



  _saveUserPref() async {

    userNum = controller.text.trim();
    if(userNum.length<4){

      return;
    }

      _preferences.setString('userNum', userNum);
      _loadUserPref();

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '전화번호 마지막 4자리를 입력해 주세요!',
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: TextField(
                controller: controller,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'ex)4827',
                    labelText: '전화번호 마지막 4자리',
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Colors.blueAccent,
                    ),
                    prefixText: ' ',
                    suffixStyle: const TextStyle(color: Colors.green)),
              ),
            ),
            RaisedButton(
              onPressed: () {
                _saveUserPref();
                Navigator.pop(context,'authenticated');

                //_loadUserPref();

              },
              color: color_skyBlue,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    '확인',
                    style: TextStyle(
                        fontSize: 23,
                        color: color_dark,
                        fontWeight: FontWeight.bold),
                  )),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            )
          ],
        )),
      ),
    );
  }
}
