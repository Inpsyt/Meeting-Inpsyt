import 'package:flutter/material.dart';
import 'package:flutter_app3/constants/const_colors.dart';
import 'package:flutter_app3/views/widgets/widget_buttons.dart';
import 'package:diamond_notched_fab/diamond_fab_notched_shape.dart';
import 'package:diamond_notched_fab/diamond_notched_fab.dart';

class ScreenMeetingRooms extends StatefulWidget {
  @override
  _ScreenMeetingRoomsState createState() => _ScreenMeetingRoomsState();
}

class _ScreenMeetingRoomsState extends State<ScreenMeetingRooms> {
  @override
  Widget build(BuildContext context) {
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
          Container(//상단부 영역
            height: 150,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 8,
                    offset: Offset(0.1, 0.9))
              ],
              color: color_skyBlue,
            ),
            child: Stack(
              children: [
                Positioned(child: Text('이 자리에서\n회의실을 예약하세요',style: TextStyle(color: color_white,fontSize: 25),),bottom: 20,left: 15,)
              ],
            ),
          ),

        ],
      ),
    );
  }

}


