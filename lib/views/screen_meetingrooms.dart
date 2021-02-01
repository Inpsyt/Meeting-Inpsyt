import 'package:flutter/material.dart';

class ScreenMeetingRooms extends StatefulWidget {
  @override
  _ScreenMeetingRoomsState createState() => _ScreenMeetingRoomsState();
}

class _ScreenMeetingRoomsState extends State<ScreenMeetingRooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 400,
              color: Colors.green,
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: Colors.yellow,
            ),
          )
        ],
      ),
    );
  }
}
