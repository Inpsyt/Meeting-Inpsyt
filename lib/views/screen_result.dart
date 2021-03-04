import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/views/screen_stopwatch.dart';
import 'package:inpsyt_meeting/views/widgets/widget_labels.dart';

class ScreenResult extends StatefulWidget {
  final ModelMeetingRoom modelMeetingRoom;
  final int resultMode;

  ScreenResult(this.modelMeetingRoom, this.resultMode);

  @override
  _ScreenResultState createState() =>
      _ScreenResultState(modelMeetingRoom, resultMode);
}

class _ScreenResultState extends State<ScreenResult> {
  final ModelMeetingRoom modelMeetingRoom;

  final int resultMode;

  _ScreenResultState(this.modelMeetingRoom, this.resultMode);


  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    print('result');

    // getDocument(modelMeetingRoom); //지정된 문서 받아오기 실행

    return Scaffold(

      appBar: AppBar(
        backgroundColor: color_skyBlue,
        centerTitle: true,
        title: Text(
          modelMeetingRoom.roomName,
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
            child:  Column(
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
                      _getTimeResult(resultMode,modelMeetingRoom.time),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: color_dark,
                          fontSize: 90,
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

                    Container(
                      height: 50,
                      width: 150,
                      child: RaisedButton(
                        color: color_skyBlue,
                        onPressed: () {
                          _navigateStopWatch();
                        },
                        child: Text('확인',style: TextStyle(color: color_white,fontSize: 18,fontWeight: FontWeight.w600),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    // 타이머 적용하며 카운트다운은 코딩시간이 오래걸리니 확인버튼만 등재하기
                    // Text(
                    //   '10초 후 자동 종료됩니다',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       color: color_dark,
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.normal),
                    // ),
                  ],
                )

            ),


          Expanded(
              child: Container(
            child: Center(
                child: WidgetCurrentTime()),
          ))
        ],
      ),
    );
  }

  String _getTextResult(int resultMode) {
    switch (resultMode) {
      case 0:
        return '체크인 되었습니다!';
      case 1:
        return '체크아웃 되었습니다!';
      case 2:
        return '체크인 예약되었습니다!';
    }
  }

  String _getTimeResult(int resultMode, String time) {
    //여기서 데이터베이스에서 데이터를 가져올때 모드에따라서 다른값을 가져올수도 있음
    switch (resultMode) {
      case 0:
        return time == 'none' ? '0' : time.substring(10, time.length).trim();

        //   return newRoom.time;

        break;

      case 1:
        return time.substring(0, 10).trim();
        break;

      case 2:
        return time.substring(0, 10).trim();
        break;
    }
  }

  String _getTextResult2(int resultMode) {
    switch (resultMode) {
      case 0:
        return '까지 이용할 수 있습니다';
      case 1:
        return '이용하셨습니다';
      case 2:
        return '까지 이용할 수 있습니다';
    }
  }

  _navigateStopWatch() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                new ScreenStopWatch(modelMeetingRoom)));

    // final result = await Navigator.push(context,
    //   PageRouteBuilder(pageBuilder: (context,b,c)=>ScreenStopWatch(newRoom.roomNum),transitionDuration: Duration(seconds: 0)),
    // );

    Navigator.pop(context);
  }
}
