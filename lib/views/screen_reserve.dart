import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/models/model_reserve.dart';

class ScreenReserve extends StatefulWidget {
  final ModelMeetingRoom _modelMeetingRoom;

  ScreenReserve(this._modelMeetingRoom);

  @override
  _ScreenReserveState createState() => _ScreenReserveState(_modelMeetingRoom);
}

class _ScreenReserveState extends State<ScreenReserve> {
  final ModelMeetingRoom _modelMeetingRoom;

  _ScreenReserveState(this._modelMeetingRoom);

  ValueKey<DateTime> forceRebuild; //강제 새로고침

  final baseColor = color_trans_skyBlue;

  final int _initStart = 62;
  final int _initEnd = 82;

  int _start;
  int _end;

  @override
  void initState() {
    super.initState();

    _start = _initStart;
    _end = _initEnd;


    Firestore.instance.collection('reserves').snapshots().listen((event) {
      print('ScreenReserve : 시간 변경됨');
      setState(() {
        forceRebuild = ValueKey(DateTime.now());//위젯 강제 새로고침
      });

    });

  }

  List<Widget> fetchReserveWidget(List<DocumentSnapshot> docList) {

    List<ModelReserve> reserveList = new List<ModelReserve>();



    List<Widget> reserveWidgetList = new List<Widget>();

    Widget sheetItem = Positioned(
      child: DoubleCircularSlider(
        144, //division
        1, //start
        2, //end
        height: 300.0,
        width: 300.0,
        baseColor: Color.fromRGBO(90, 90, 90, 0.4),
        selectionColor: Colors.transparent,

        handlerColor: Colors.transparent,
        handlerOutterRadius: 12.0,
        sliderStrokeWidth: 12.0,
      ),
    );
    reserveWidgetList.add(sheetItem);

    docList.forEach((element) {

      Widget firstItem = Positioned(
        child: Container(
          key: forceRebuild,
          child: DoubleCircularSlider(
            144, //division
            element['start'], //start
            element['end'], //end
            height: 300.0,
            width: 300.0,
            baseColor: Colors.transparent,
            selectionColor: Colors.red,
            handlerColor: Colors.transparent,
            handlerOutterRadius: 12.0,
            sliderStrokeWidth: 12.0,
          ),
        ),
      );
      reserveWidgetList.add(firstItem);

    });


    Widget topItem = Positioned(
      child: DoubleCircularSlider(
        144,
        _start,
        _end,
        height: 300.0,
        width: 300.0,
        primarySectors: 4,
        secondarySectors: 16,
        baseColor: Color.fromRGBO(255, 255, 255, 0),
        selectionColor: baseColor,
        onSelectionChange: (start, end, what) {
          _updateLabels(start, end);
        },
        handlerColor: baseColor,
        handlerOutterRadius: 13.0,
        sliderStrokeWidth: 12.0,
        child: Padding(
          padding: const EdgeInsets.all(42.0),
          child: Center(
              child: Text('${_formatIntervalTime(_start, _end)}',
                  style: TextStyle(fontSize: 24.0, color: Colors.black))),
        ),
      ),
    );
    reserveWidgetList.add(topItem);

    return reserveWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_skyBlue,
        centerTitle: true,
        title: Text(
          _modelMeetingRoom.roomName + ' 예약',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: color_yellow, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('reserves')
            .where('roomNum', isEqualTo: _modelMeetingRoom.roomNum)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }


          final documents = snapshot.data.documents;



          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '회의실 이용시간을 정하세요.',
                style: TextStyle(color: Colors.black, fontSize: 19),
              ),
              Stack(
                children: fetchReserveWidget(documents),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _formatBedTime('부터', _start),
                _formatBedTime('까지', _end),
              ]),
              FlatButton(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      '결 정',
                      style: TextStyle(fontSize: 18),
                    )),
                color: color_skyBlue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                onPressed: _submit,
              ),
            ],
          );
        },
      ),
    );
  }

  void _submit() async {




    setState(() {

      forceRebuild = ValueKey(DateTime.now());

    var snapshot = Firestore.instance
        .collection('reserves')
        .where('roomNum', isEqualTo: _modelMeetingRoom.roomNum)
        .getDocuments();

    snapshot.then((value) {
      value.documents.forEach((element) async {



        if (_start >= element['start'] && _start <= element['end']) {

          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('시간 겹침'),
                  content: Text('시작시간이 다른 예약과 겹칩니다. \n다른 시간으로 선택해주세요.'),
                  actions: [
                    FlatButton(onPressed: (){Navigator.pop(context,false);}, child: Text('OK')),
                  ],
                );
              });
          return;
        }

        if (_end >= element['start'] && _end <= element['end']) {

          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('시간 겹침'),
                  content: Text('종료시간이 다른 예약과 겹칩니다. \n다른 시간으로 선택해주세요.'),
                  actions: [
                    FlatButton(onPressed: (){Navigator.pop(context,false);}, child: Text('OK')),
                  ],
                );
              });
          return;
        }

        if (_start <= element['start'] && _end >= element['end']) {

          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('시간 겹침'),
                  content: Text('시간이 다른 예약과 겹칩니다. \n다른 시간으로 선택해주세요.'),
                  actions: [
                    FlatButton(onPressed: (){Navigator.pop(context,false);}, child: Text('OK')),
                  ],
                );
              });
          return;
        }
      });
    });


    });
  }

  void _shuffle() {
    setState(() {
      forceRebuild = ValueKey(DateTime.now());
      //_initStart = _generateRandomTime();
     // _initEnd = _generateRandomTime();
      _start = _initStart;
      _end = _initEnd;
    });
  }

  void _updateLabels(int start, int end) {
    setState(() {
      _start = start;
      _end = end;
    });
  }

  Widget _formatBedTime(String pre, int time) {
    return Column(
      children: [
        Text(
          '${_formatTime(time)}',
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        Text(pre, style: TextStyle(color: Colors.black, fontSize: 19)),
      ],
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

  String _formatIntervalTime(int init, int end) {
    var sleepTime = end > init ? end - init : 144 - init + end;
    var hours = sleepTime ~/ 12;
    var minutes = (sleepTime % 12) * 5;
    return '${hours}시간 ${minutes}분';
  }

  int _generateRandomTime() => Random().nextInt(144);
}
