class AlarmData {
  late int hour;
  late int minute;
  late bool isAm;
  late bool isActive;

  AlarmData({
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.isActive
  });

  AlarmData.fromJson(Map<dynamic, dynamic> json) {
    hour = json['hour'];
    minute = json['minute'];
    isAm = json['isAm'];
    isActive = json['isActive'];
  }

  static AlarmData transform(Map<dynamic, dynamic> map) {
    return AlarmData.fromJson(map);
  }

  Map toJson() {
    Map map = new Map();
    map["hour"] = this.hour;
    map["minute"] = this.minute;
    map["isAm"] = this.isAm;
    map["isActive"] = this.isActive;
    return map;
  }

  @override
  String toString() {
    return 'AlarmData{hour: $hour, minute: $minute, isAm: $isAm, isActive: $isActive}';
  }
}