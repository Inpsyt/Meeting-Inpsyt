import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/services/service_background_noti.dart';
import 'package:inpsyt_meeting/views/screen_firstAuthen.dart';
import 'package:inpsyt_meeting/views/screen_result.dart';
import 'package:inpsyt_meeting/views/widgets/widget_labels.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenTimeSelect extends StatefulWidget {
  final ModelMeetingRoom modelMeetingRoom;

  ScreenTimeSelect(this.modelMeetingRoom);

  @override
  _ScreenTimeSelectState createState() =>
      _ScreenTimeSelectState(this.modelMeetingRoom);
}

class _ScreenTimeSelectState extends State<ScreenTimeSelect> {
  ModelMeetingRoom modelMeetingRoom;
  SharedPreferences _preferences;
  String _userNum = '';

  _ScreenTimeSelectState(this.modelMeetingRoom);

  DateTime curTime;

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

  _setCurrentTime() async {


    curTime = DateTime.now();

    //실제 네트워크상 실제 표준시간을 가져와 UTC로 변환하고 9시간을 더해 한국화... 휴대폰 국적이 바뀌어도 시간은 동일
    curTime = (await NTP.now()).toUtc().add(Duration(hours: 9));


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCheckUserNumPref();
    _setCurrentTime();
  }

  _backgroundStart() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterBackgroundService.initialize(onStart);
    Future.delayed(
        Duration(milliseconds: 500),
        () => {
              FlutterBackgroundService()
                  .sendData({"roomNum": modelMeetingRoom.roomNum.toString()})
            });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    print('timeselect');
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
                  modelMeetingRoom.roomName,
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
            height: deviceHeight / 1.6,
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
                  '이용시간을 선택하세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color_dark,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                _timeButton('2분'),
                _timeButton('60분'),
                _timeButton('90분'),
                _timeButton('120분'),
                _timeButton('하루종일'),
              ],
            ),
          ),

          Expanded(
              child: Container(
            child: Center(child: WidgetCurrentTime()),
          ))
        ],
      ),
    );
  }

  Widget _timeButton(String text) {
    final String selectedTime = text.replaceAll('분', '');

    return ButtonTheme(
      minWidth: 200,
      child: RaisedButton(
        onPressed: () {
          _documentUsingSet(_addConvertedTime(selectedTime));
          _navigateResultScreen(modelMeetingRoom, 0);
        },
        color: color_lightBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(color: color_deepShadowGrey)),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              text,
              style: TextStyle(fontSize: 18),
            )),
      ),
    );
  }

  _navigateResultScreen(ModelMeetingRoom room, int resultMode) async {
    /*
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ScreenResult(room, resultMode)));

     */
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context, b, c) => ScreenResult(room, resultMode),
          transitionDuration: Duration(seconds: 0)),
    );

    Navigator.pop(context, 'selected');
  }

  _addConvertedTime(String increaseTime) {
    // DateTime time = DateTime.now();

    print('네트워크시간 NTP : ' + curTime.toString());

    if (increaseTime.trim() == '하루종일') {
      return DateFormat('yyyy-MM-dd HH:mm').format(new DateTime(
          curTime.year, curTime.month, curTime.day, 21, 0, 0, 0, 0));
    }

    return DateFormat('yyyy-MM-dd HH:mm')
        .format(curTime.add(Duration(minutes: int.parse(increaseTime))));
  }

  _documentUsingSet(String timeSet) {
    //room은 정보제공용, 그 우측으로는 모두 수정할 사항들 기입
    Firestore.instance
        .collection('rooms')
        .document(modelMeetingRoom.roomNum.toString())
        .updateData({'isUsing': true, 'time': timeSet, 'userNum': _userNum});


    //시간만 새로고침
    modelMeetingRoom = new ModelMeetingRoom(
        roomName: modelMeetingRoom.roomName,
        roomNum: modelMeetingRoom.roomNum,
        time: timeSet,
        isUsing: modelMeetingRoom.isUsing,
        userNum: modelMeetingRoom.userNum);

    _backgroundStart();
  }
}
