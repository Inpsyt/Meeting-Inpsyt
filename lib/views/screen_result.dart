import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';

class ScreenResult extends StatefulWidget {


  final ModelMeetingRoom modelMeetingRoom;
  final int resultMode;
  //0일때는 체크인 완료표시
  //1일때는 체크아운 완료표시
  //2일때는 체크인 예약표시


  ScreenResult(this.modelMeetingRoom,this.resultMode);

  @override
  _ScreenResultState createState() => _ScreenResultState(modelMeetingRoom,resultMode);
}

class _ScreenResultState extends State<ScreenResult> {

  final ModelMeetingRoom modelMeetingRoom;
  final int resultMode;

  _ScreenResultState(this.modelMeetingRoom,this.resultMode);

  @override
  Widget build(BuildContext context) {

    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

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

            //컨테이너 내부 영역
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  _getTextResult(resultMode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color_dark,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),

                Text(
                  '16:50',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color_dark,
                      fontSize: 90  ,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  _getTextResult2(resultMode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color_dark,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '10초 후 자동 종료됩니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color_dark,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),


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


  String _getTextResult(int resultMode){

    switch(resultMode){
      case 0: return '체크인 되었습니다!';
      case 1: return '체크아웃 되었습니다!';
      case 2: return '체크인 예약되었습니다!';
    }
  }

  String _getTimeResult(int resultMode){ //여기서 데이터베이스에서 데이터를 가져올때 모드에따라서 다른값을 가져올수도 있음
    switch(resultMode){

    }
  }

  String _getTextResult2(int resultMode){
    switch(resultMode){
      case 0: return '까지 이용할 수 있습니다';
      case 1: return '이용하셨습니다';
      case 2: return '까지 이용할 수 있습니다';
    }
  }
}
