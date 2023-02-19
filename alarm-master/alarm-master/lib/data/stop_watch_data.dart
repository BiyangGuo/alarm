class StopWatchData {
 late String time;

  StopWatchData({
    required this.time,
  });

  StopWatchData.fromJson(Map<dynamic, dynamic> json) {
    time = json['time'];
  }

  static StopWatchData transform(Map<dynamic, dynamic> map) {
    return StopWatchData.fromJson(map);
  }

  Map toJson() {
    Map map = new Map();
    map["time"] = this.time;
    return map;
  }

 @override
  String toString() {
    return 'StopWatchData{time: $time}';
 }
}