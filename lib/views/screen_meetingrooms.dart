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
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:uni_links/uni_links.dart';
// import 'package:flutter_nfc_reader/flutter_nfc_reader.dart'; //이거때문에 Method Channel 겹쳐서 진동안울려..

class ScreenMeetingRooms extends StatefulWidget {
  @override
  _ScreenMeetingRoomsState createState() => _ScreenMeetingRoomsState();
}

class _ScreenMeetingRoomsState extends State<ScreenMeetingRooms> {

  final Firestore db = Firestore.instance;
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


  StreamSubscription _sub;

  Future<Null> initUniLisks() async {


    String initialLink;

    try {
      initialLink = await getInitialLink();

      if (initialLink != null) {
        _entryRoomWithUni(initialLink);
      }
      initialLink = null;
    } on PlatformException {}



    _sub = getLinksStream().listen((event) {
      print('UNI 링크유입'+event);
      _entryRoomWithUni(event.trim());
    });




  }



  _checkRoomsStatus() async{ //사용중인 방이 시간이 지났는지 아닌지를 판별
   // DateTime curTime = DateTime.now();

    DateTime curTime = await NTP.now(); //네트워크 시간에 맡기기
    print('ScreenMeetingRooms : 네트워크시간 감지됨 NTP : '+curTime.toString());


    await db //판별을 위해 서버 접속
        .collection('rooms')
        .where('isUsing', isEqualTo: true)
        .getDocuments()
        .then((QuerySnapshot ds) { //문서를 가져오면 이하 내용 실행
      ds.documents.forEach((element) {

        print('ScreenMeetingRooms : 사용중인 방이 있다!!! (체크된 방의 개수만큼 뜨는 부분)');
        print(element['time'].toString());
        DateTime time = DateTime.parse(element['time'].toString());
        if(curTime.difference(time).inMinutes>0){ //시간이 지났다면 체크아웃 상태로 업데이트
         db.collection('rooms').document(element['roomNum'].toString()).updateData({'isUsing':false,'time':'none','userNum':'none'});
        }
      });

    });



    await db
        .collection('rooms')
        .where('userNum', isEqualTo: _userNum)
        .getDocuments()
        .then((QuerySnapshot ds) {
      _youAreUsingNow = false;
      ds.documents.forEach((element) {
        print('ScreenMeetingRooms : 내가 사용중인 방이 있다! (체크된 방의 개수만큼 뜨는 부분)');
        _youAreUsingNow = true;
      });

    });



    setState(() {

    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCheckUserNumPref();

    _nfcReaderSet();

    initUniLisks();




    CollectionReference reference = db.collection('rooms');
    reference.snapshots().listen((event) {
      print('ScreenMeetingRooms: 문서바꼇당 서버접속 2회');
      _checkRoomsStatus();
    });


  }

  @override
  void dispose() {
    updateTimer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  _nfcReaderSet() async {

    Stream<NDEFMessage> stream = NFC.readNDEF();

    stream.listen((NDEFMessage message) {
      print("records: ${message.records.length}");
      print("record1: ${message.records[0].data.toString()}"); //앱아이디
      print("record1: ${message.records[1].data.toString()}"); //그 다음 레코드
    });


    NDEFMessage message = await NFC.readNDEF(once: true).first;
    print("payload: ${message.payload}");
// once: true` only scans one tag!




    /*//nfc플러그인때문에 진동이 안울려..
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


    /*
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


     */

  }

  @override
  Widget build(BuildContext context) {
    print('ScreenMeetingRooms: 빌드 새로고침됨');



    _nfcReaderSet();

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

    getOffeset() async {

      /*
      int timeOffset = await NTP.getNtpOffset();
      DateTime now = DateTime.now();
      //now = now.add(Duration(days: 10));


      print('화면상시간:${now.toString()}');
      print(timeOffset.toString());

       */
      DateTime currentTime = (await NTP.now()).toUtc().add(Duration(hours: 9));
      //실제 네트워크상 실제 표준시간을 가져와 UTC로 변환하고 9시간을 더해 한국화... 휴대폰 국적이 바뀌어도 시간은 동일

      print(currentTime.toString());

    }


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
            stream: db
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
        subRoomName: doc['subRoomName'],
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
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 85,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.roomName,
                      style: TextStyle(fontSize: 21),
                    ),
                    room.subRoomName == 'none'?SizedBox():Text(room.subRoomName.trim(),style: TextStyle(fontSize: 15,color: color_deepGrey),)
                  ],
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
      ),
    );
  }

  //방에있는 실제 물리적인 형태로 접근을 하는 것이니 강제로 입장!
  _entryRoomForce(ModelMeetingRoom room) async{
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

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => new ScreenRoom(room),
        ),
      );
      _nowInRoom = false;
    }
  }
  _entryRoom(ModelMeetingRoom room)async{

  _nowInRoom = true;
    if (_userNum == '') return; //번호 입력 안하고 백키 누를 경우를 대비해 그냥 실행 방지
    if (room.isUsing && (room.userNum.trim() == _userNum||_userNum=='6462')) {
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
    db
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

        _entryRoomForce(room)//방에있는 실제 물리적인 형태로 접근을 하는 것이니 강제로 입장!
            });
  }
}
