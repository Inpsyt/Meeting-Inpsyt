import 'package:flutter/material.dart';
import 'package:flutter_app3/constants/const_colors.dart';
import 'package:flutter_app3/models/model_meetingroom.dart';
import 'package:flutter_app3/views/widgets/widget_buttons.dart';

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
                
                _timeButton('30분'),
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
  
  Widget _timeButton(String text){
    return ButtonTheme(
      minWidth: 200,
      child: RaisedButton(
        onPressed: () {},
        color: color_lightBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(color:color_deepShadowGrey)

        ),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(text,style: TextStyle(fontSize: 18),)),
      ),
    );
  }
  
}
