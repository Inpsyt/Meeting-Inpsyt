import 'package:flutter/material.dart';
import 'package:flutter_app3/constants/const_colors.dart';
import 'package:flutter_app3/models/model_meetingroom.dart';
import 'package:flutter_app3/views/widgets/widget_buttons.dart';

class ScreenTimeSelect extends StatefulWidget {

  final ModelMeetingRoom modelMeetingRoom;

  ScreenTimeSelect(this.modelMeetingRoom);

  @override
  _ScreenTimeSelectState createState() => _ScreenTimeSelectState(this.modelMeetingRoom);
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
                  '체크인 하세요!',
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
                          '체크인',
                          style: TextStyle(color: color_white,fontSize: 25,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '회의실 이용을 시작합니다',
                          style: TextStyle(color: color_white,fontSize: 17),
                        ),
                      ],
                    ),
                    color_gradientBlueStart,
                    color_gradientBlueEnd,
                    90,
                    deviceWidth/1.3,
                    10,(){


                }),
                GradientButton(
                    Column(
                      children: [
                        Text(
                          '체크아웃',
                          style: TextStyle(color: color_white,fontSize: 25,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '회의실 이용을 종료합니다',
                          style: TextStyle(color: color_white,fontSize: 17),
                        ),
                      ],
                    ),
                    color_gradientBlueStart,
                    color_gradientBlueEnd,
                    90,
                    deviceWidth/1.3,
                    10,(){


                })
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
}
