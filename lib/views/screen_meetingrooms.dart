import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/views/screen_firstAuthen.dart';
import 'package:inpsyt_meeting/views/screen_room.dart';
import 'package:inpsyt_meeting/views/screen_stopwatch.dart';
import 'package:diamond_notched_fab/diamond_notched_fab.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:uni_links/uni_links.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class ScreenMeetingRooms extends StatefulWidget {
  @override
  _ScreenMeetingRoomsState createState() => _ScreenMeetingRoomsState();
}

class _ScreenMeetingRoomsState extends State<ScreenMeetingRooms> {
  Timer updateTimer;
  List<ModelMeetingRoom> roomList;
  SharedPreferences _preferences;
  String _userNum = '';
  bool _youAreUsingNow = true; //오프라인 실행시 또는 체크아웃시 방 들어가지는 버그 수정을 위해 true
  bool _nowInRoom = false;

  String _output = 'Empty Scan Code'; //qr 인식용

  List<String> nfcRoomInfo = <String>[
    '0',
    '0x04c87022422b80',
    '0x04c86e22422b80',
    '0x04c86c22422b80',
    '0x04c87c22422b80',
    '0x04c88022422b80'
  ];

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

   //플레이스토어 업로드시 카메라 권한 문제 때문에 보류
  Future _scan() async {
    await Permission.camera.request();
    //스캔 시작 - 이때 스캔 될때까지 blocking
    String barcode = await scanner.scan();
    //스캔 완료하면 _output 에 문자열 저장하면서 상태 변경 요청.


    setState(() {
      _output = barcode;
      _entryRoomWithUni(barcode);
    });
  }



  Future<Null> initUniLisks() async {
    String initialLink;

    try {
      initialLink = await  getInitialLink();
      print(initialLink);

      if (initialLink != null) {
        _entryRoomWithUni(initialLink);
        print(initialLink);
      }
      initialLink = null;
    } on PlatformException {}
  }



  _checkRoomsStatus() async{ //사용중인 방이 시간이 지났는지 아닌지를 판별
   // DateTime curTime = DateTime.now();

    DateTime curTime = await NTP.now(); //네트워크 시간에 맡기기
    print('네트워크시간 NTP : '+curTime.toString());


    await Firestore.instance //판별을 위해 서버 접속
        .collection('rooms')
        .where('isUsing', isEqualTo: true)
        .getDocuments()
        .then((QuerySnapshot ds) { //문서를 가져오면 이하 내용 실행
      ds.documents.forEach((element) {

        print('사용중인게 있다!!! 이게 뜬다라는 것은 서버에 접속된거겠지');
        print(element['time'].toString());
        DateTime time = DateTime.parse(element['time'].toString());
        if(curTime.difference(time).inMinutes>0){ //시간이 지났다면 체크아웃 상태로 업데이트
         Firestore.instance.collection('rooms').document(element['roomNum'].toString()).updateData({'isUsing':false,'time':'none','userNum':'none'});
        }
      });

    });

    //Firestore.instance.collection('rooms').where('userNum',isEqualTo: _userNum).sna

    await Firestore.instance
        .collection('rooms')
        .where('userNum', isEqualTo: _userNum)
        .getDocuments()
        .then((QuerySnapshot ds) {
      _youAreUsingNow = false;
      ds.documents.forEach((element) {
        _youAreUsingNow = true;
      });
      setState(() {});
    });

    setState(() {

    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCheckUserNumPref();

    //_checkRoomsStatus();

    _nfcReaderSet();



     initUniLisks();

    CollectionReference reference = Firestore.instance.collection('rooms');
    reference.snapshots().listen((event) {
      print('문서바꼇당');
      _checkRoomsStatus();

    });


  }

  @override
  void dispose() {
    updateTimer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  _nfcReaderSet() {


    /*
     FlutterNfcReader.read().then((onData) {
      print(onData.id);
      print(onData.content+'from read');


      if(_nowInRoom){
        return;
      }



      if(onData.id == nfcRoomInfo[1]){
        _entryRoomWithUni('room=1');
      }else if(onData.id == nfcRoomInfo[2]){
        _entryRoomWithUni('room=2');
      }else if(onData.id == nfcRoomInfo[3]){
        _entryRoomWithUni('room=3');
      }else if(onData.id == nfcRoomInfo[5]){
        _entryRoomWithUni('room=4');
      }


    });


     */


    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);
      print(onData.content);


      if(_nowInRoom){
        return;
      }
      _nowInRoom = true;


      if(onData.id == nfcRoomInfo[1]){
        _entryRoomWithUni('room=1');
      }else if(onData.id == nfcRoomInfo[2]){
        _entryRoomWithUni('room=2');
      }else if(onData.id == nfcRoomInfo[3]){
        _entryRoomWithUni('room=3');
      }else if(onData.id == nfcRoomInfo[4]){
        _entryRoomWithUni('room=4');
      }
      else if(onData.id == nfcRoomInfo[5]){
        _entryRoomWithUni('room=4');
      }



    });


  }

  @override
  Widget build(BuildContext context) {
    print('빌드 새로고침됨');



    // StreamBuilder(
    //   stream: Firestore.instance.collection('rooms').where('userNum',isEqualTo: _userNum).snapshots(),
    //   builder: (context,snapshot){
    //
    //     if(!snapshot.hasData){
    //       setState(() {
    //         print('나 없지롱');
    //         _youAreUsingNow = false;
    //       });
    //       return null;
    //     }
    //
    //     setState(() {
    //       print('나 있지롱');
    //       _youAreUsingNow=true;
    //     });
    //     return null;
    //
    //   },
    // );





   // initState();

   // initUniLisks();


    //_checkRoomsStatus();


    //데이터바 바뀔때마다 반응함





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
                /* //사용자번호 확인용
                Positioned(
                  child: Text(
                    '사용자: ' + _userNum,
                    style: TextStyle(
                        color: color_white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  bottom: 20,
                  right: 15,
                )
                
                 */
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
        elevation: _youAreUsingNow ? (room.userNum == _userNum ? 3 : 1) : 3,
        onPressed: () {

          _nowInRoom = false;

          _getCheckUserNumPref();
          _entryRoom(room);

        },

        color: _youAreUsingNow
            ? (room.userNum == _userNum ? Colors.white : Colors.grey)
            : Colors.white,
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


  _entryRoom(ModelMeetingRoom room)async{


/*
    if (_youAreUsingNow && room.userNum != _userNum) {
      return;
    } //현재 내가 어떤 방에 들어있을땐 다른방에 못들어가도록

*/

  _nowInRoom = true;
    if (_userNum == '') return; //번호 입력 안하고 백키 누를 경우를 대비해 그냥 실행 방지
    if (room.isUsing && (room.userNum.trim() == _userNum)) {
        await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => new ScreenStopWatch(room),
        ),
      );
        _nowInRoom = false;
    } else {

      if(_youAreUsingNow)return;
      //이미 회의중이라면 예약조차 몬하게
        await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => new ScreenRoom(room),
        ),
      );

      _nowInRoom = false;
    }

  }

  _entryRoomWithUni(String uri) {



    ModelMeetingRoom room;
    String parsed = uri.substring(uri.length - 1, uri.length);
    print(parsed);
    Firestore.instance
        .collection('rooms')
        .document(parsed)
        .get()
        .then((value) => {
              room = new ModelMeetingRoom(
                  roomNum: value['roomNum'],
                  roomName: value['roomName'],
                  time: value['time'],
                  isUsing: value['isUsing'],
                  userNum: value['userNum']),



        _entryRoom(room)
      

            });
  }
}
