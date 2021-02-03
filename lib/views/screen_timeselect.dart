import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/views/screen_result.dart';
import 'package:inpsyt_meeting/views/widgets/widget_buttons.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class ScreenTimeSelect extends StatefulWidget {
  final ModelMeetingRoom modelMeetingRoom;

  ScreenTimeSelect(this.modelMeetingRoom);

  @override
  _ScreenTimeSelectState createState() =>
      _ScreenTimeSelectState(this.modelMeetingRoom);
}

class _ScreenTimeSelectState extends State<ScreenTimeSelect> {
  final ModelMeetingRoom modelMeetingRoom;

  _ScreenTimeSelectState(this.modelMeetingRoom);

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
            child: Center(
                child: Text(
              '현재시각 2021.02.01 14:20',
              style: TextStyle(color: color_deepShadowGrey, fontSize: 19),
            )),
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


          _documentUsingSet(modelMeetingRoom, _addConvertedTime(selectedTime) );
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
    final result = await Navigator.push(context,
      PageRouteBuilder(pageBuilder: (context,b,c)=>ScreenResult(room,resultMode),transitionDuration: Duration(seconds: 0)),
    );

    Navigator.pop(context, 'selected');

  }


  String _addConvertedTime(String increaseTime) {
    DateTime time = DateTime.now();

    if(increaseTime.trim() == '하루종일'){
      time = new DateTime(time.year,time.month,time.day,21,0,0,0,0);
      return DateFormat('yyyy-MM-dd HH:mm').format(time);
    }

    time = time.add(Duration(minutes: int.parse(increaseTime)));
    return DateFormat('yyyy-MM-dd HH:mm').format(time);

  }
  
  _documentUsingSet(ModelMeetingRoom room, String timeSet){ //room은 정보제공용, 그 우측으로는 모두 수정할 사항들 기입
    Firestore.instance.collection('rooms').document(room.roomNum.toString()).updateData({'isUsing':true});
    Firestore.instance.collection('rooms').document(room.roomNum.toString()).updateData({'time':timeSet});
    Firestore.instance.collection('rooms').document(room.roomNum.toString()).updateData({'userNum':'1234'}); //번호획득 로직 구현 필요
    
  }


}