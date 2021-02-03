import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/views/screen_room.dart';
import 'package:inpsyt_meeting/views/screen_stopwatch.dart';
import 'package:inpsyt_meeting/views/widgets/widget_buttons.dart';
import 'package:diamond_notched_fab/diamond_fab_notched_shape.dart';
import 'package:diamond_notched_fab/diamond_notched_fab.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';

class ScreenMeetingRooms extends StatefulWidget {
  @override
  _ScreenMeetingRoomsState createState() => _ScreenMeetingRoomsState();
}

class _ScreenMeetingRoomsState extends State<ScreenMeetingRooms> {
  List<ModelMeetingRoom> roomList;

  @override
  Widget build(BuildContext context) {

    print('list');

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
                )
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
        elevation: 3,
        onPressed: () {



          if(room.isUsing) {

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                new ScreenStopWatch(room.roomNum),
              ),
            );


          }else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => new ScreenRoom(room),
              ),
            );
          }






        },
        color: Colors.white,
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
                room.isUsing?room.time.substring(10, room.time.length).trim()+'부터 사용가능':'현재 사용가능',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
