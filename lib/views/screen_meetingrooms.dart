import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/views/screen_firstAuthen.dart';
import 'package:inpsyt_meeting/views/screen_room.dart';
import 'package:inpsyt_meeting/views/screen_stopwatch.dart';
import 'package:diamond_notched_fab/diamond_notched_fab.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ScreenMeetingRooms extends StatefulWidget {
  @override
  _ScreenMeetingRoomsState createState() => _ScreenMeetingRoomsState();
}

class _ScreenMeetingRoomsState extends State<ScreenMeetingRooms> {
  List<ModelMeetingRoom> roomList;
  SharedPreferences _preferences;
  String _userNum = '';
  bool _youAreUsingNow = false;

  String _output = 'Empty Scan Code'; //qr 인식용

  _getCheckUserNumPref() async {
    _preferences = await SharedPreferences.getInstance();

    _userNum = (_preferences.getString('userNum') ?? '');




    if (_userNum == '') {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ScreenFistAuthen()));

      if (result == 'authenticated') {
        _getCheckUserNumPref();
      }

    }

    print('userNum=' + _userNum);
    setState(() {
      //화면의 사용자: 이부분에 번호가 안뜨므로 async가 끝나는대로 화면 새로그리기함
    });
  }


  Future _scan() async {
    await Permission.camera.request();
    //스캔 시작 - 이때 스캔 될때까지 blocking
    String barcode = await scanner.scan();
    //스캔 완료하면 _output 에 문자열 저장하면서 상태 변경 요청.
    setState(() => _output = barcode);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCheckUserNumPref();



  }

  @override
  Widget build(BuildContext context) {

    Firestore.instance.collection('rooms').where('userNum',isEqualTo: _userNum).getDocuments().then((QuerySnapshot ds){
      _youAreUsingNow = false;
      ds.documents.forEach((element) {_youAreUsingNow = true;});
      setState(() {

      });
    });


    return Scaffold(
      floatingActionButton: DiamondNotchedFab(
        onPressed: () {
          _scan();

        },
        tooltip: 'QR스캔',
        borderRadius: 14,
        child: Padding(
            padding: EdgeInsets.all(13),
            child: Image.asset('assets/images/qricon.png')),
      ),
      body: Column(
        children: [
          Container(
            //상단부 영역
            height: 130,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: color_deepShadowGrey,
                    blurRadius: 5,
                    offset: Offset(0.1, 0.9))
              ],
              color: color_skyBlue,
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    '이 자리에서\n회의실을 예약하세요',
                    style: TextStyle(
                        color: color_white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  bottom: 20,
                  left: 15,
                ),
                Positioned(child:  Text(
                  '사용자: '+_userNum,
                  style: TextStyle(
                      color: color_white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                  bottom: 20,
                  right: 15,)
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('rooms')
                .orderBy('roomNum')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final documents = snapshot.data.documents;
              return Expanded(
                child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];

                      return _MeetingRoomItem(doc);
                    }),
              );
            },
          )
        ],
      ),
    );
  }

  //회의실 아이템
  Widget _MeetingRoomItem(DocumentSnapshot doc) {
    ModelMeetingRoom room = ModelMeetingRoom(
        roomNum: doc['roomNum'],
        roomName: doc['roomName'],
        isUsing: doc['isUsing'],
        time: doc['time'],
        userNum: doc['userNum']);

    // ignore: deprecated_member_use
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: RaisedButton(
        elevation: _youAreUsingNow?(room.userNum == _userNum?3:1):3,

        onPressed: _youAreUsingNow?(room.userNum == _userNum?()
        {
          _getCheckUserNumPref();
          if(_userNum == '')return; //번호 입력 안하고 백키 누를 경우를 대비해 그냥 실행 방지
          if (room.isUsing && (room.userNum.trim() == _userNum)) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                new ScreenStopWatch(room),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => new ScreenRoom(room),
              ),
            );
          }
        }:(){}):()
        {
          _getCheckUserNumPref();
          if(_userNum == '')return; //번호 입력 안하고 백키 누를 경우를 대비해 그냥 실행 방지
          if (room.isUsing && (room.userNum.trim() == _userNum)) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                new ScreenStopWatch(room),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => new ScreenRoom(room),
              ),
            );
          }
        },
        color: _youAreUsingNow?(room.userNum == _userNum?Colors.white:Colors.white60):Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 29),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                room.roomName,
                style: TextStyle(fontSize: 21),
              ),
              Text(
                room.isUsing
                    ? room.time.substring(10, room.time.length).trim() +
                        '부터 사용가능'
                    : '현재 사용가능',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _roomStatus(){

    //if(room)

  }



}
