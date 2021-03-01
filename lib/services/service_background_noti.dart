import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:ntp/ntp.dart';
import 'package:vibration/vibration.dart';

void onStart() {

  //안드로이드에서만 지원하게 될 기능..
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  Timer timerObject = null;

  DateTime currentTime = null;
  DateTime endTime = null;
  int leftTime;

  int currentTimeCheckCNT = 0;

  int roomNum;

  NTP.now().then((value) => {
        //실제 네트워크상 실제 표준시간을 가져와 UTC로 변환하고 9시간을 더해 한국화... 휴대폰 국적이 바뀌어도 시간은 동일
        currentTime = DateTime.parse(
            value.toUtc().add(Duration(hours: 9)).toString().substring(0, 22))
      });

  int countDonwDuration = 500;

  service.onDataReceived.listen((event) {
    if (event["roomNum"] != null) roomNum = event["roomNum"];

    if (event["time"] != null) endTime = DateTime.parse(event["time"]);

    if (event["action"] == "stopService") {

      service.stopBackgroundService();

    }
  });

  {
    currentTime = DateTime.now();

    NTP.now().then((value) => {
          //실제 네트워크상 실제 표준시간을 가져와 UTC로 변환하고 9시간을 더해 한국화... 휴대폰 국적이 바뀌어도 시간은 동일
          currentTime = DateTime.parse(
              value.toUtc().add(Duration(hours: 9)).toString().substring(0, 22))
        });








    //타이머 주기 시작
    //Start periodic
    timerObject = Timer.periodic(Duration(milliseconds: countDonwDuration),
        (timer) async {
      if (!(await service.isServiceRunning())) timerObject.cancel();



      if(currentTimeCheckCNT >= 10){
        currentTime = DateTime.now();
        NTP.now().then((value) => {
          //실제 네트워크상 실제 표준시간을 가져와 UTC로 변환하고 9시간을 더해 한국화... 휴대폰 국적이 바뀌어도 시간은 동일
          currentTime = DateTime.parse(
              value.toUtc().add(Duration(hours: 9)).toString().substring(0, 22))
        });

        if(endTime == null){
          service.stopBackgroundService();
        }

        print('네트워크 시간 5초후 새로고침 기능 작동');

        currentTimeCheckCNT = 0;
      }


      currentTimeCheckCNT ++;


      print('ServiceNoti: ===================================================');

      currentTime = currentTime.add(Duration(milliseconds: countDonwDuration));

      print('ServiceNoti: current: ' + currentTime.toString());
      print('ServiceNoti: endTime: ' + endTime.toString());
      print('ServiceNoti: roomNum: ' +
          roomNum.toString()); //아이폰에서는 방번호는 잘 불러오나, DB에서 값을 못 가져옴
      leftTime = endTime.difference(currentTime).inMinutes;


      service.sendData({
        'leftTime': leftTime.toString(),
      });

      service.setNotificationInfo(
          title: '잔여시간: ' + leftTime.toString() + '분',
          //+ leftTime.toString(),
          content: '시간 초과시 자동으로 Check-Out 됩니다.');

      if (leftTime <= 0) { //시간 초과시 실행하게 될 메서드
        service.sendData({
          'leftTime': leftTime.toString(),
        });

        Firestore.instance
            .collection('rooms')
            .document(roomNum.toString())
            .updateData({'time': 'none', 'isUsing': false, 'userNum': 'none'});

        service.setForegroundMode(false);
        Vibration.vibrate(duration: 1500);

        await LaunchApp.openApp(
          androidPackageName: 'com.kkumsoft.inpsyt_meeting',
          iosUrlScheme: 'meting://',
          appStoreLink:
              'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
          // openStore: false
        );


        timerObject.cancel();
        timerObject = null;

        service.stopBackgroundService();
      }
    });
  }
}
