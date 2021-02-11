import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:ntp/ntp.dart';

class WidgetCurrentTime extends StatefulWidget {
  @override
  _WidgetCurrentTimeState createState() => _WidgetCurrentTimeState();
}

class _WidgetCurrentTimeState extends State<WidgetCurrentTime> {
  @override
  Widget build(BuildContext context) {




    return
      StreamBuilder(
      stream: getTime(),

      builder: (context,snapshot){


        if(!snapshot.hasData)
          return Text('네트워크 접속 없음',style: TextStyle(color: color_dark,fontSize: 19),);
        else if(snapshot.hasError){
          return Text('네트워크 접속 실패',style: TextStyle(color: Colors.red,fontSize: 19),);
        }else{
          return Text('현재시각 : '+snapshot.data.toString().substring(5,snapshot.data.toString().length - 7),style: TextStyle(color: color_dark,fontSize: 19),);
        }
      },
    );
  }

  Stream<DateTime> getTime() async*{
    while(true){
      DateTime currentTime = DateTime.now();
      await Future.delayed(Duration(seconds: 1));
      yield currentTime;
    }
  }
}
