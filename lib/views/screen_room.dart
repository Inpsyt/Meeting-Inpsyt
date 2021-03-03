import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/models/model_reserve.dart';
import 'package:inpsyt_meeting/services/service_cookierequest.dart';
import 'package:inpsyt_meeting/views/screen_reserve.dart';

import 'package:inpsyt_meeting/views/screen_timeselect.dart';
import 'package:inpsyt_meeting/views/widgets/widget_buttons.dart';
import 'package:inpsyt_meeting/models/model_meetingroom.dart';
import 'package:inpsyt_meeting/views/widgets/widget_labels.dart';
import 'package:jiffy/jiffy.dart';

class ScreenRoom extends StatefulWidget {
  final ModelMeetingRoom modelMeetingRoom;
  final ServiceCookieRequest _serviceCookieRequest;

  ScreenRoom(this.modelMeetingRoom, this._serviceCookieRequest);

  @override
  _ScreenRoomState createState() =>
      _ScreenRoomState(this.modelMeetingRoom, _serviceCookieRequest);
}

class _ScreenRoomState extends State<ScreenRoom> {
  final ModelMeetingRoom modelMeetingRoom;
  ServiceCookieRequest _serviceCookieRequest;
  DateTime selectedDate;
  ValueKey<DateTime> forceRebuild;

  _ScreenRoomState(this.modelMeetingRoom, this._serviceCookieRequest);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

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

                          //예약기능은 나중에 추가하는 걸로
                          /*
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

                           */
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: color_white,
              boxShadow: [
                BoxShadow(
                    color: color_shadowGrey,
                    offset: Offset(0.1, 5.9),
                    blurRadius: 9),
              ],
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: Text(
                      '지오유 예약 목록',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedDate.toString().substring(0, 10),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.calendar_today)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            key: forceRebuild,
            child: FutureBuilder(
              future: _getReservesList(_serviceCookieRequest),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                List<String> listReserves = snapshot.data;
                for (int i = 0; i < listReserves.length; i++) {
                  //+문자 제거 및 공백제거 가공단계
                  listReserves[i] = listReserves[i].replaceAll('+', '').trim();
                }
                listReserves.remove('');

                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listReserves.length,
                    itemBuilder: (context, index) {
                      return _reserveListItem(listReserves[index]);
                    });
              },
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {},
                color: color_skyBlue,
                textColor: Colors.white,
                child: Icon(
                  Icons.add,
                  size: 20,
                ),
                padding: EdgeInsets.all(16),
                elevation: 5,
                shape: CircleBorder( ),
              )
            ],
          )

          /*
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


                  return _reserveListItem(documents[index]);
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
            },
          )
           */
        ],
      ),
    );
  }

  Future _loginGroupWare() async {
    _serviceCookieRequest = ServiceCookieRequest();
    await _serviceCookieRequest.get(
        'http://gw.hakjisa.co.kr/LoginOK?CorpID=xxxxxxxxxx&UserID=dev%40hakjisa.co.kr&UserPass=gkrwltk6462%21%40&UserOTP=');
  }

  Future<List<String>> _getReservesList(
      ServiceCookieRequest serviceCookieRequest) async {
    int currentWeekNum = Jiffy(selectedDate).week + 1;

    int currentWeek = 4;

    int webRoomNum = -1;

    switch (Jiffy(selectedDate).format('EEEE').trim()) {
      case 'Sunday':
        currentWeek = 4;
        break;
      case 'Monday':
        currentWeek = 5;
        break;
      case 'Tuesday':
        currentWeek = 6;
        break;
      case 'Wednesday':
        currentWeek = 7;
        break;
      case 'Thursday':
        currentWeek = 8;
        break;
      case 'Friday':
        currentWeek = 9;
        break;
      case 'Saturday':
        currentWeek = 10;
        break;
    }

    switch (modelMeetingRoom.roomNum) {
      case 1:
        webRoomNum = 3;
        break;
      case 2:
        webRoomNum = -1;
        break;
      case 3:
        webRoomNum = 1;
        break;
      case 4:
        webRoomNum = 2;
    }

    if (webRoomNum == -1) {
      return new List<String>();
    }

    String rawHtml;
    rawHtml = await serviceCookieRequest.get(
        'http://gw.hakjisa.co.kr/RsvObjMgr/RsvObj_List?Arrow=&CrdNo=&SelDate=&ViewDate=&ViewSeq=&cmbCateNo=0&iYear=2021&iWeek=${currentWeekNum.toString()}&SearchTxt=');

    var parsedHtml = parse(rawHtml);

    var elements = parsedHtml
        .getElementsByTagName('tbody')[0]
        .children[1] //자식들인 tr 2개중 2번째꺼
        .children[0] //두번째 tr의 자식인 td
        .children[0] //td의 자식인 table
        .children[0] //table의 자식인 tbody
        .children[0] //tbody의 자식인 tr 세개 중 첫번째
        .children[2] //tr 의 자식인 세번째 td
        .children[0] //RsvObj_List 바로 밑에 있는 table
        .children[0] //table의 자식인 tbody
        .children[1] //tbody의 자식인 3 tr중 2번째
        .children[0]; //tr의 자식 td (여기서부터 진짜 시작)

    var nameArea = elements.children[0]; //td의 자식 4가지 중 1번쨰 form
    var tableArea =
        elements.children[1].children[0]; //td의 자식 4가지 중 2번째 table 의 tbody

    //여기가 진짜 테이블 위치에 관여
    String sCurrentReserves =
        tableArea.children[webRoomNum].children[currentWeek].text;

    return sCurrentReserves.split('[승인]');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2025),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        // we format the selected date and assign it to the state variable
        selectedDate = d;
        forceRebuild = ValueKey(DateTime.now()); //위젯 강제 새로고침
      });
  }

  Widget _reserveListItem(reserveContent) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
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
            Text(reserveContent, style: TextStyle(fontSize: 17)),
          ],
        ),
      ),
    );
  }

  //////////////////////////한동안 지유오쪽 서버의 데이터를 띄우도록 하기 때문에 사용x

  Widget _fireReserveListItem(dynamic doc) {
    ModelReserve modelReserve = new ModelReserve(
        roomNum: doc['roomNum'],
        date: doc['date'].toDate(),
        start: doc['start'],
        end: doc['end'],
        userNum: doc['userNum']);

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
                ' ${_formatTime(modelReserve.start)} 부터 ~  ${_formatTime(modelReserve.end)} 까지',
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
