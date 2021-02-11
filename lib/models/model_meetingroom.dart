class ModelMeetingRoom {
  final int roomNum;
  final String roomName;
  final String subRoomName; //21.02.11 필드확장을 위해 모델 변경
  final bool isUsing;
  final String time;
  final String userNum;


  ModelMeetingRoom({this.roomNum,this.roomName,this.subRoomName,this.isUsing,this.time,this.userNum});

}