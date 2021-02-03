import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/views/widgets/widget_buttons.dart';
import 'package:vibration/vibration.dart';

class ScreenStopWatch extends StatefulWidget {

  final int roomNum;
  ScreenStopWatch(this.roomNum);

  @override
  _ScreenStopWatchState createState() => _ScreenStopWatchState(this.roomNum);
}

class _ScreenStopWatchState extends State<ScreenStopWatch> {
  final roomNum;
  _ScreenStopWatchState(this.roomNum);
  DateTime endTime;
  DateTime currentTime;

  ModelMeetingRoom newRoom; //지금 현재 데이터베이스에 있는 방정보

  int overCount=0;


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





  _checkTimeOver() async{ //자동 나가기

    int leftTime = endTime.difference(currentTime).inMinutes;
    //await sleep(Duration(seconds: 1));
    if(leftTime <= 0 && overCount <3){

      overCount++;
      print('시작 경과'+leftTime.toString());

      sleep(Duration(seconds: 1));

      _checkOutAndPop();

    }

  }



  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    Vibration.vibrate(duration: 100);
    print('stopwatch');

    _getDocument(roomNum);

    endTime = DateTime.parse(newRoom==null?'2222-01-01 00:00':newRoom.time.trim());

    currentTime = DateTime.now();

    _checkTimeOver();



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
                  newRoom==null?'불러오는중..':newRoom.roomName,
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
            child: Column(
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
                  newRoom==null?'불러오는 중':endTime.difference(currentTime).inMinutes.toString()+'분',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color_dark,
                      fontSize: newRoom==null?50:80,
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

                Container(child: Image.asset('assets/images/anime.gif'),height: 100,),

                GradientButton(
                    Column(
                      children: [
                        Text(
                          '체크아웃',
                          style: TextStyle(color: color_white,fontSize: 25,fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                    color_gradientBlueStart,
                    color_gradientBlueEnd,
                    60,
                    deviceWidth/1.3,
                    10,(){

                      _checkOutAndPop();

                }),


              ],
            ),
          ),

          Expanded(
              child: Container(
                child: Center(child: Text('현재시각 2021.02.01 14:20',style: TextStyle(color: color_deepShadowGrey,fontSize: 19),)),
              ))
        ],
      ),
    );


  }

  _checkOutAndPop() {


    Navigator.pop(context);
    newRoom = null;
    Firestore.instance.collection('rooms').document(roomNum.toString()).updateData({'time':'none','isUsing':false,'userNum':'none'});

  }
}