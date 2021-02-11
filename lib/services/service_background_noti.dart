import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:ntp/ntp.dart';
import 'package:vibration/vibration.dart';

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  DateTime currentTime = null;
  DateTime endTime = null;
  int leftTime;
  String roomNum;

  service.onDataReceived.listen((event) {
    if (event["action"] == "stopService") {
      //서비스부분은 애초에 앱과 분리된 개념으로 생각해야된다.
      //따라서 데이터를 주고 받기 위해서는 DataReceive가 필요하고 그에따라 상호작용
      //service.stopBackgroundService(); //앱에서 백그라운드중지요청에따라 서비스 종료
      _stopServiceWithCheck(service);
      return;
    }

    if (int.parse(event["roomNum"].toString()) > 0) {
      roomNum = event["roomNum"];
      print(roomNum);
      Firestore.instance.collection('rooms').document(roomNum).get().then((value) =>
          {
            endTime = DateTime.parse(value['time'].toString().trim())
          }); /////매우중요!!!!!!!!!!!! instance는 정말 데이터 접속을 1번만 하기 때문에 stream에 적용한게 아닌 이상 더이상 바뀌지 않음
    }
  });

  //상단에 notificationbar를 띄우기 위해 true 값을 넣어줌.
  service.setForegroundMode(true);

  service.setAutoStartOnBootMode(true);

  Firestore.instance.collection('rooms').document(roomNum).get().then(
      (value) => {endTime = DateTime.parse(value['time'].toString().trim())});

  NTP.now().then((value) => {
        //실제 네트워크상 실제 표준시간을 가져와 UTC로 변환하고 9시간을 더해 한국화... 휴대폰 국적이 바뀌어도 시간은 동일
        currentTime = DateTime.parse(
            value.toUtc().add(Duration(hours: 9)).toString().substring(0, 22))
      });

  int countDonwDuration = 500;
  int notWorkingCount = 20;

  Timer.periodic(Duration(milliseconds: countDonwDuration), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();

    //서버 접속 10회 미 응답시 조치
    if (currentTime == null || endTime == null) {
      notWorkingCount--;
      if (notWorkingCount <= 0) {
        _stopServiceWithCheck(service);
      }
    } else {
      notWorkingCount = 10;
    }

    print('ServiceNoti: ===================================================' +
        notWorkingCount.toString());

    currentTime = currentTime.add(Duration(milliseconds: countDonwDuration));
    print('ServiceNoti: current: ' + currentTime.toString());
    print('ServiceNoti: endTime: ' + endTime.toString());
    leftTime = endTime.difference(currentTime).inMinutes;

    //print(roomNum);

    service.sendData({
      'leftTime': leftTime.toString(),
    });

    service.setNotificationInfo(
        title: '잔여시간: ' + leftTime.toString() + '분', //+ leftTime.toString(),
        content: '시간 초과시 자동으로 Check-Out 됩니다.');

    //Vibration.vibrate(duration: 100);

    if (leftTime <= 0) {
      //시간 초과시 앱 실행하도록

      //  _runApp();

      service.sendData({
        'leftTime': leftTime.toString(),
      });

      Firestore.instance
          .collection('rooms')
          .document(roomNum)
          .updateData({'time': 'none', 'isUsing': false, 'userNum': 'none'});

      _stopServiceWithCheck(service);

      Vibration.vibrate(duration: 1500);

      await LaunchApp.openApp(
        androidPackageName: 'com.kkumsoft.inpsyt_meeting',
        iosUrlScheme: 'pulsesecure://',
        appStoreLink:
            'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
        // openStore: false
      );

      // return;
      //timer.cancel();

    }
  });
}

void _stopServiceWithCheck(FlutterBackgroundService service) async {
  if ((await service.isServiceRunning())) {
    service.stopBackgroundService();
  }
}

void _runApp() async {
  // Enter thr package name of the App you want to open and for iOS add the URLscheme to the Info.plist file.
  // The second arguments decide wether the app redirects PlayStore or AppStore.
  // For testing purpose you can enter com.instagram.android
}
