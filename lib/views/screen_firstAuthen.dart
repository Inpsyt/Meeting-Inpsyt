import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/services/service_cookierequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenFistAuthen extends StatefulWidget {
  @override
  _ScreenFistAuthenState createState() => _ScreenFistAuthenState();
}

class _ScreenFistAuthenState extends State<ScreenFistAuthen> {
  String userNum = '';
  String userPW = '';
  SharedPreferences _preferences;
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  bool isLoginProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPref();
  }

  _getPref() async {
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
    userNum = (_preferences.getString('userNum') ?? '12');
    emailController.text = userNum;
    print('usernum=' + userNum);
  }

  _checkAccount(BuildContext buildContext) async{
    setState(() {
      isLoginProgress = true;
    });



    bool result = await ServiceCookieRequest.loginGroupWare();

    if(result == true){
      Navigator.pop(buildContext, 'authenticated');
    }else{
      setState(() {
        isLoginProgress = false;
      });
    }

  }

  _saveUserPref() async {
    userNum = emailController.text.trim();
    userPW = pwController.text.trim();
    _preferences.setString('userNum', userNum);
    _preferences.setString('userPW', userPW);
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
              '지오유 계정을 입력해주세요\n회의목록 열람 목적 외에는 절대 사용하지 않습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: TextField(
                    controller: emailController,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        hintText: 'ex)dev@inpsyt.co.kr',
                        labelText: '지오유 Email',
                        prefixIcon: const Icon(
                          Icons.alternate_email,
                          color: Colors.blueAccent,
                        ),
                        prefixText: ' ',
                        suffixStyle: const TextStyle(color: Colors.green)),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: TextField(
                    controller: pwController,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        labelText: '지오유 PW',
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          color: Colors.blueAccent,
                        ),
                        prefixText: ' ',
                        suffixStyle: const TextStyle(color: Colors.green)),
                  ),
                ),
                SizedBox(height: 10,),
                Text('로그인 실패 (계정을 다시 확인해 주세요)',style: TextStyle(color: Colors.red),),
              ],
            ),


            isLoginProgress?CircularProgressIndicator():RaisedButton(
              onPressed: () {
                _saveUserPref();
                _checkAccount(context);


                //_loadUserPref();
              },
              color: color_skyBlue,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 23,
                        color: color_white,
                        fontWeight: FontWeight.normal),
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
