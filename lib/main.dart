import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/views/screen_firstAuthen.dart';
import 'package:inpsyt_meeting/views/screen_meetingrooms.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:uni_links/uni_links.dart';



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



     home: ScreenMeetingRooms(),

     // home: ScreenFistAuthen(),
      theme: ThemeData(accentColor: color_skyBlue,fontFamily: 'NanumSquare'),
    );
  }
}
