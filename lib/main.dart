import 'package:flutter/material.dart';
import 'package:flutter_app3/views/screen_meetingrooms.dart';
import 'package:flutter_app3/constants/const_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScreenMeetingRooms(),
      theme: ThemeData(accentColor: color_skyBlue,),
    );
  }
}
