import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/services/service_background_noti.dart';
import 'package:inpsyt_meeting/views/screen_meetingrooms.dart';
import 'package:inpsyt_meeting/views/screen_reserve.dart';
import 'views/screen_firstAuthen.dart';



void main() {


  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.white,
      child: Text(
        //details.toString(),
        '',
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      ),
    );
  };
  runApp(MyApp());




}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // home: StreamBuilder(
      //   stream: getLinksStream(),
      //   builder: (context,snapshot){
      //
      //     if(snapshot.hasData) {
      //       var uri = Uri.parse(snapshot.data);
      //       var list = uri.queryParametersAll.entries.toList();
      //
      //       return Text(list.map((e) => e.toString()).join('-'));
      //     }else{
      //       return Text('');
      //     }
      //   },
      // ),
      //



      //home: ScreenReserve(new ModelMeetingRoom(roomNum: 5,roomName: 'TEST',subRoomName: 'none',isUsing: false,time: 'none',userNum: '1234')),
     home: ScreenMeetingRooms(),

      theme: ThemeData(accentColor: color_skyBlue,fontFamily: 'NanumSquare'),
    );
  }
}
