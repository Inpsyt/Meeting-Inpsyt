import 'package:flutter/material.dart';
import 'package:flutter_app3/constants/const_colors.dart';
import 'package:flutter_app3/views/widgets/widget_buttons.dart';
import 'package:diamond_notched_fab/diamond_fab_notched_shape.dart';
import 'package:diamond_notched_fab/diamond_notched_fab.dart';
import 'package:flutter_app3/models/model_meetingroom.dart';

class ScreenMeetingRooms extends StatefulWidget {
  @override
  _ScreenMeetingRoomsState createState() => _ScreenMeetingRoomsState();
}

class _ScreenMeetingRoomsState extends State<ScreenMeetingRooms> {
  List<ModelMeetingRoom> roomList;

  @override
  Widget build(BuildContext context) {
    roomList = <ModelMeetingRoom>[];
    roomList.add(ModelMeetingRoom(
        roomNum: 1,
        roomName: 'WISC',
        time: '14:00 예약가능',
        isUsing: true,
        userNum: '8521'));
    roomList.add(ModelMeetingRoom(
        roomNum: 2,
        roomName: 'MLST',
        time: '지금 예약가능',
        isUsing: false,
        userNum: '8521'));

    roomList.add(ModelMeetingRoom(
        roomNum: 3,
        roomName: 'Holland',
        time: '지금 예약가능',
        isUsing: false,
        userNum: '8521'));

    roomList.add(ModelMeetingRoom(
        roomNum: 4,
        roomName: 'NEO',
        time: '지금 예약가능',
        isUsing: false,
        userNum: '8521'));

    return Scaffold(
      floatingActionButton: DiamondNotchedFab(
        onPressed: () {},
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
            height: 150,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 8, offset: Offset(0.1, 0.9))
              ],
              color: color_skyBlue,
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    '이 자리에서\n회의실을 예약하세요',
                    style: TextStyle(color: color_white, fontSize: 25,fontWeight: FontWeight.bold),
                  ),
                  bottom: 20,
                  left: 15,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: roomList.length,
                itemBuilder: (context, index) {
                  return _MeetingRoomItem(roomList[index]);
                }),
          )
        ],
      ),
    );
  }

  Widget _MeetingRoomItem(ModelMeetingRoom modelMeetingRoom) {
    // ignore: deprecated_member_use
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: RaisedButton(
        elevation: 3,
        onPressed: () {},
          color: Colors.white,
        shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),

      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 29),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(modelMeetingRoom.roomName,style: TextStyle(fontSize: 21 ),),
            Text(modelMeetingRoom.time,style: TextStyle(fontSize:16),)

          ],
        ),
      ),),

    );
  }
}
