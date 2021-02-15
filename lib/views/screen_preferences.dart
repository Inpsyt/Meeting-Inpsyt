import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';
import 'package:inpsyt_meeting/views/screen_firstAuthen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenPreferences extends StatefulWidget {
  @override
  _ScreenPreferencesState createState() => _ScreenPreferencesState();
}

class _ScreenPreferencesState extends State<ScreenPreferences> {
  SharedPreferences _preferences;

  String _userNum = '';

  @override
  void initState() {
    // TODO: implement initState
    _getUserPref();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {},
        ),
        title: Text('환경설정'),
        centerTitle: true,
        backgroundColor: color_skyBlue,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '사용자 번호',
                style: TextStyle(fontSize: 19, color: color_deepGrey),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _userNum,
                    style: TextStyle(fontSize: 19),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                    onPressed: () {
                      _navigateFirstAuthen();
                    },
                    child: Text(
                      '변경',
                      style: TextStyle(color: color_white),
                    ),
                    color: color_skyBlue,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getUserPref() async {
    _preferences = await SharedPreferences.getInstance();

    setState(() {
      _userNum = (_preferences.getString('userNum') ?? '');
    });
  }

  void _navigateFirstAuthen()async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return ScreenFistAuthen();
        }));

    if(result == 'authenticated'){
      initState();
    }
  }
}
