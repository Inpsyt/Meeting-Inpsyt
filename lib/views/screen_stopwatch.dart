import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/services/service_background_noti.dart';
import 'package:inpsyt_meeting/views/widgets/widget_buttons.dart';
import 'package:inpsyt_meeting/views/widgets/widget_labels.dart';
import 'package:ntp/ntp.dart';

class ScreenStopWatch extends StatefulWidget {
  final ModelMeetingRoom _modelMeetingRoom;

  ScreenStopWatch(this._modelMeetingRoom);

  @override
  _ScreenStopWatchState createState() =>
      _ScreenStopWatchState(this._modelMeetingRoom);
}

class _ScreenStopWatchState extends State<ScreenStopWatch> {
  //final ServiceBackgroundNoti serviceBackgroundNoti = ServiceBackgroundNoti();
  Timer _timer;
  final ModelMeetingRoom _modelMeetingRoom;

  _ScreenStopWatchState(this._modelMeetingRoom);

  // DateTime endTime
  DateTime currentTime;

  //ModelMeetingRoom newRoom; //지금 현재 데이터베이스에 있는 방정보
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

  _checkTimeOver() async {
    //자동 나가기

    //await sleep(Duration(seconds: 1));
    if (backgroundLeftTime <= 0) {
     // Vibration.vibrate(duration: 1500);
      print('시작 경과' + backgroundLeftTime.toString());

     // _checkOutAndPop();
    }
  }

  _startBackground() async {

    WidgetsFlutterBinding.ensureInitialized();

    await FlutterBackgroundService.initialize(onStart);


    //FlutterBackgroundService().sendData({"roomNum": _modelMeetingRoom.roomNum.toString()});


    Future.delayed(
        Duration(milliseconds: 500),
        () => {
              FlutterBackgroundService().sendData({"roomNum": _modelMeetingRoom.roomNum.toString()})
            });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _startBackground();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      setState(() {
        if (leftTime <= 0) {
          t.cancel();
        }
        _checkTimeOver();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    // Vibration.vibrate(duration: 200);
    print('stopwatch');

    //  _getDocument(roomNum);

    //endTime = DateTime.parse(newRoom==null?'2222-01-01 00:00':newRoom.time.trim());

    currentTime = DateTime.now();


    //  _checkTimeOver();

    return Scaffold(
      // floatingActionButton: DiamondNotchedFab(
      //   onPressed: () {},
      //   tooltip: 'QR스캔',
      //   borderRadius: 14,
      //   child: Padding(
      //       padding: EdgeInsets.all(13),
      //       child: Image.asset('assets/images/qricon.png')),
      // ),
      body: Column(
        children: [
          //상단부 영역
          Container(
            //상단부 영역
            height: 130,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 8, offset: Offset(0.1, 0.9))
              ],
              color: color_skyBlue,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: color_white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Text(
                      'Meeting Room',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: color_white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.transparent,
                        ),
                        onPressed: () {}),
                  ],
                ),
                Text(
                  _modelMeetingRoom == null
                      ? '불러오는중..'
                      : _modelMeetingRoom.roomName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color_yellow,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 30,
          ),

          //하단부 영역
          Container(
            width: deviceWidth / 1.1,
            height: deviceHeight / 1.9,
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
                return backgroundLeftTime>0?Column(
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
                ):Column(
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

            //파이어베이스 직접접속
            // StreamBuilder(
            //   stream: Firestore.instance
            //       .collection('rooms')
            //       .document(_modelMeetingRoom.roomNum.toString())
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return CircularProgressIndicator();
            //     }
            //
            //     final document = snapshot.data;
            //
            //     leftTime = DateTime.parse(document['time'])
            //         .difference(DateTime.now())
            //         .inMinutes;
            //     return Column(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Text(
            //           '현 회의 잔여시간',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               color: color_dark,
            //               fontSize: 25,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         Text(
            //           // newRoom==null?'불러오는 중':endTime.difference(currentTime).inMinutes.toString()+'분',
            //           leftTime.toString() + '분',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               color: color_dark,
            //               fontSize: 50,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         Text(
            //           '남았습니다',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               color: color_dark,
            //               fontSize: 25,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         Container(
            //           child: Image.asset('assets/images/anime.gif'),
            //           height: 100,
            //         ),
            //         GradientButton(
            //             Column(
            //               children: [
            //                 Text(
            //                   '체크아웃',
            //                   style: TextStyle(
            //                       color: color_white,
            //                       fontSize: 25,
            //                       fontWeight: FontWeight.bold),
            //                 ),
            //               ],
            //             ),
            //             color_gradientBlueStart,
            //             color_gradientBlueEnd,
            //             60,
            //             deviceWidth / 1.3,
            //             10, () {
            //           _checkOutAndPop();
            //         }),
            //       ],
            //     );
            //   },
            // ),
          ),
          Expanded(
              child: Container(
            child:Center(child: WidgetCurrentTime())

          ))
          ],
      ),
    );
  }

  _checkOutAndPop() async{

    final service = FlutterBackgroundService();


    if((await service.isServiceRunning())){
      service.sendData({'action':'stopService'});
    }

   // if(backgroundLeftTime>0)FlutterBackgroundService().sendData({'action': 'stopService'}); //FlutterBackgroundService() 가 이미 종료됐는데 sendData통해서 stopService호출되게하면 앱이 다르게 인식하고
    //상호연동이 안됨
    Navigator.pop(context);
    Firestore.instance
        .collection('rooms')
        .document(_modelMeetingRoom.roomNum.toString())
        .updateData({'time': 'none', 'isUsing': false, 'userNum': 'none'});
  }
}
