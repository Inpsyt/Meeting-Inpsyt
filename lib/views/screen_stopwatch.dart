import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/services/service_background_noti.dart';
import 'package:inpsyt_meeting/views/widgets/widget_buttons.dart';
import 'package:inpsyt_meeting/views/widgets/widget_labels.dart';

class ScreenStopWatch extends StatefulWidget {
  final ModelMeetingRoom _modelMeetingRoom;

  ScreenStopWatch(this._modelMeetingRoom);

  @override
  _ScreenStopWatchState createState() =>
      _ScreenStopWatchState(this._modelMeetingRoom);
}

class _ScreenStopWatchState extends State<ScreenStopWatch> {
  final ModelMeetingRoom _modelMeetingRoom;

  _ScreenStopWatchState(this._modelMeetingRoom);

  DateTime currentTime;

  int leftTime = 10;
  int backgroundLeftTime;

/*
  _getDocument(int roomNum) async {
    //파이어스토어로부터 지정된 문서를 받아옴
    DocumentSnapshot doc = await Firestore.instance
        .collection('rooms')
        .document(roomNum.toString())
        .get();
    newRoom = new ModelMeetingRoom(
        roomNum: doc.data['roomNum'],
        roomName: doc.data['roomName'],
        time: doc.data['time'],
        isUsing: doc.data['isUsing'],
        userNum: doc.data['userNum']);
    setState(() {});
  }



 */

  _startBackground() async {
    // WidgetsFlutterBinding.ensureInitialized();
    // if(!await FlutterBackgroundService().isServiceRunning())

    await FlutterBackgroundService.initialize(onStart);

    FlutterBackgroundService service = FlutterBackgroundService();

    Future.delayed(
        Duration(milliseconds: 500),
        () => {
              service.sendData({"roomNum": _modelMeetingRoom.roomNum}),
              service.sendData({"time": _modelMeetingRoom.time}),
            });
  }

  _stopBackground() async{

    final service = FlutterBackgroundService();

    if(await service.isServiceRunning()){
      service.sendData({'action':'stopService'});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _startBackground();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    print('stopwatch');

    currentTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_skyBlue,
        centerTitle: true,
        title: Text(
          _modelMeetingRoom.roomName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: color_yellow, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [

          SizedBox(
            height: 30,
          ),

          //하단부 영역
          Container(
            width: deviceWidth / 1.1,
            height: deviceHeight / 1.5,
            decoration: BoxDecoration(
              color: color_white,
              boxShadow: [
                BoxShadow(
                    color: color_shadowGrey,
                    offset: Offset(0.1, 5.9),
                    blurRadius: 9),
              ],
            ),
            child: StreamBuilder<Map<String, dynamic>>(
              stream: FlutterBackgroundService().onDataReceived,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data;
                // DateTime date = DateTime.tryParse(data["current_date"]);
                backgroundLeftTime = int.parse(data['leftTime']);
                return backgroundLeftTime > 0
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '현 회의 잔여시간',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: color_dark,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            // newRoom==null?'불러오는 중':endTime.difference(currentTime).inMinutes.toString()+'분',
                            backgroundLeftTime.toString() + '분',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: color_dark,
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '남았습니다',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: color_dark,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            child: Image.asset('assets/images/anime.gif'),
                            height: 100,
                          ),

                          /*
                    GradientButton(
                        Column(
                          children: [
                            Text(
                              '시간연장',
                              style: TextStyle(
                                  color: color_white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        color_gradientBlueStart,
                        color_gradientBlueEnd,
                        60,
                        deviceWidth / 1.3,
                        10, () {
                      _checkOutAndPop();
                    }),


                     */

                          GradientButton(
                              Column(
                                children: [
                                  Text(
                                    '체크아웃',
                                    style: TextStyle(
                                        color: color_white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              color_gradientBlueStart,
                              color_gradientBlueEnd,
                              60,
                              deviceWidth / 1.3,
                              10, () {
                            _checkOutAndPop();
                          }),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '회의가 종료되었습니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: color_dark,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          GradientButton(
                              Column(
                                children: [
                                  Text(
                                    '나가기',
                                    style: TextStyle(
                                        color: color_white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              color_gradientBlueStart,
                              color_gradientBlueEnd,
                              60,
                              deviceWidth / 1.3,
                              10, () {
                            _checkOutAndPop();
                          }),
                        ],
                      );
              },
            ),
          ),
          Expanded(child: Container(child: Center(child: WidgetCurrentTime())))
        ],
      ),
    );
  }

  _checkOutAndPop() async {


    _stopBackground();

    // FlutterBackgroundService().sendData({'action':'stopService'});

    //if(backgroundLeftTime>0)FlutterBackgroundService().sendData({'action': 'stopService'}); //FlutterBackgroundService() 가 이미 종료됐는데 sendData통해서 stopService호출되게하면 앱이 다르게 인식하고
    //상호연동이 안됨
    Navigator.pop(context);
    Firestore.instance
        .collection('rooms')
        .document(_modelMeetingRoom.roomNum.toString())
        .updateData({'time': 'none', 'isUsing': false, 'userNum': 'none'});
  }
}
