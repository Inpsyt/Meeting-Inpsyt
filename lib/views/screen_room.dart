import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_reserve.dart';
import 'package:inpsyt_meeting/views/screen_reserve.dart';

import 'package:inpsyt_meeting/views/screen_timeselect.dart';
import 'package:inpsyt_meeting/views/widgets/widget_buttons.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/views/widgets/widget_labels.dart';

class ScreenRoom extends StatefulWidget {
  final ModelMeetingRoom modelMeetingRoom;

  ScreenRoom(this.modelMeetingRoom);

  @override
  _ScreenRoomState createState() => _ScreenRoomState(this.modelMeetingRoom);
}

class _ScreenRoomState extends State<ScreenRoom> {
  final ModelMeetingRoom modelMeetingRoom;

  _ScreenRoomState(this.modelMeetingRoom);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;

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
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.symmetric(vertical: 30),
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
                  modelMeetingRoom.isUsing ? '사용중!' : '체크인 하세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: modelMeetingRoom.isUsing ? color_dark : color_dark,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: 40,
                ),
                modelMeetingRoom.isUsing
                    ? Text(
                  '사용자 : ' + modelMeetingRoom.userNum,
                  style: TextStyle(fontSize: 17),
                )
                    : Column(
                  children: [
                    GradientButton(
                        Column(
                          children: [
                            Text(
                              '체크인',
                              style: TextStyle(
                                  color: color_white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '회의실 이용을 시작합니다',
                              style: TextStyle(
                                  color: color_white, fontSize: 17),
                            ),
                          ],
                        ),
                        color_gradientBlueStart,
                        color_gradientBlueEnd,
                        70,
                        deviceWidth / 1.3,
                        10, () {
                      _navigateTimeSelect(context, modelMeetingRoom);
                    }),
                    SizedBox(
                      height: 30,
                    ),
                    GradientButton(
                        Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '예약',
                              style: TextStyle(
                                  color: color_white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '회의실을 예약합니다.',
                              style: TextStyle(
                                  color: color_white, fontSize: 17),
                            ),
                          ],
                        ),
                        color_gradientBlueStart,
                        color_gradientBlueEnd,
                        70,
                        deviceWidth / 1.3,
                        10, () {
                      _navigateReserve(context, modelMeetingRoom);
                    }),
                  ],
                ),

                // //더이상 사용안하는 버튼
                // GradientButton(
                //     Column(
                //       children: [
                //         Text(
                //           '체크아웃',
                //           style: TextStyle(color: color_white,fontSize: 25,fontWeight: FontWeight.bold),
                //         ),
                //         Text(
                //           '회의실 이용을 종료합니다',
                //           style: TextStyle(color: color_white,fontSize: 17),
                //         ),
                //       ],
                //     ),
                //     color_gradientBlueStart,
                //     color_gradientBlueEnd,
                //     90,
                //     deviceWidth/1.3,
                //     10,(){
                //
                // })
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: Firestore.instance
                .collection('reserves')
                .where('roomNum', isEqualTo: modelMeetingRoom.roomNum)
                .snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final documents = snapshot.data.documents;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];

                  ModelReserve modelReserve = new ModelReserve(roomNum: doc['roomNum'],
                      date: doc['date'].toDate(),
                      start: doc['start'],
                      end: doc['end'],
                      userNum: doc['userNum']);

                  return _reserveListItem(modelReserve);
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
            },
          )
        ],
      ),
    );
  }

  Widget _reserveListItem(ModelReserve modelReserve) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 100,
      decoration: BoxDecoration(
        color: color_white,
        boxShadow: [
          BoxShadow(
              color: color_shadowGrey, offset: Offset(0.1, 5.9), blurRadius: 9),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                ' ${_formatTime(modelReserve.start)} 부터 ~  ${_formatTime(
                    modelReserve.end)} 까지',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            Text('예약자 : ${modelReserve.userNum}'),
          ],
        ),
      ),
    );
  }

  String _formatTime(int time) {
    if (time == 0 || time == null) {
      return '00:00';
    }
    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;
    return '$hours:$minutes';
  }

  _navigateTimeSelect(BuildContext context, ModelMeetingRoom roomModel) async {
    final result = await Navigator.pushReplacement(
      context,
      PageRouteBuilder(
          pageBuilder: (context, b, c) {
            return ScreenTimeSelect(roomModel);
          },
          transitionDuration: Duration(seconds: 0)),
    );

    if (result == 'selected') {
      Navigator.pop(context, 'roomfinish');
    }
  }

  _navigateReserve(BuildContext context, ModelMeetingRoom roomModel) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ScreenReserve(roomModel);
    }));
  }

  @override
  void dispose() {
    // TODO: implement dispose

    Navigator.pop(context, 'roomfinish');
    super.dispose();
  }
}
