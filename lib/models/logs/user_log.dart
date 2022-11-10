class UserLog {
  String id;
  String userId;
  String contentType;
  String contentId;
  String event;
  String time;
  String seconds;
  String parentLog;
  String status;
  String lastTime;

  UserLog(
      {this.id,
      this.userId,
      this.contentType,
      this.contentId,
      this.event,
      this.time,
      this.seconds,
      this.parentLog,
      this.status,
      this.lastTime});

  UserLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    contentType = json['contentType'];
    contentId = json['contentId'];
    event = json['event'];
    time = json['time'];
    seconds = json['seconds'];
    parentLog = json['parentLog'];
    status = json['status'];
    lastTime = json['lastTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['contentType'] = this.contentType;
    data['contentId'] = this.contentId;
    data['event'] = this.event;
    data['time'] = this.time;
    data['seconds'] = this.seconds;
    data['parentLog'] = this.parentLog;
    data['status'] = this.status;
    data['lastTime'] = this.lastTime;
    return data;
  }
}
