import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:vibration/vibration.dart';

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  int leftTime;
  String roomNum;

  service.onDataReceived.listen((event) {
    if (event["action"] == "stopService") {
      //서비스부분은 애초에 앱과 분리된 개념으로 생각해야된다.
      //따라서 데이터를 주고 받기 위해서는 DataReceive가 필요하고 그에따라 상호작용
      service.stopBackgroundService(); //앱에서 백그라운드중지요청에따라 서비스 종료
    }

    roomNum = event["roomNum"];
    print(roomNum);
  });

  service.setForegroundMode(true);
  //상단에 notificationbar를 띄우기 위해 명시적으로 true 값을 넣어줌.

  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();

    Firestore.instance
        .collection('rooms')
        .document(roomNum)
        .get()
        .then((value) => {
              leftTime = DateTime.parse(value['time'].toString().trim())
                  .difference(DateTime.now())
                  .inMinutes,
            });

    //print(roomNum);

    if (leftTime <= 0) {
      //시간 초과시 앱 실행하도록




      Vibration.vibrate(duration: 1500);

      Firestore.instance
          .collection('rooms')
          .document(roomNum)
          .updateData({'time': 'none', 'isUsing': false, 'userNum': 'none'});

      _runApp();

      timer.cancel();
      service.stopBackgroundService();



    }

    service.setNotificationInfo(
        title: '잔여시간: ' + leftTime.toString() + '분', //+ leftTime.toString(),
        content: '시간 초과시 자동으로 Check-Out 됩니다.');

    service.sendData({
      'leftTime': leftTime.toString(),
    });
  });
}

void _runApp() async {
  await LaunchApp.openApp(
    androidPackageName: 'com.kkumsoft.inpsyt_meeting',
    iosUrlScheme: 'pulsesecure://',
    appStoreLink:
        'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
    // openStore: false
  );
  // Enter thr package name of the App you want to open and for iOS add the URLscheme to the Info.plist file.
  // The second arguments decide wether the app redirects PlayStore or AppStore.
  // For testing purpose you can enter com.instagram.android
}
