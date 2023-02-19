import 'dart:convert';

import 'package:alarm_master/data/alarm_data.dart';
import 'package:alarm_master/pages/watch_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_master/neumorphic/widget/button.dart';
import 'package:alarm_master/neumorphic/widget/container.dart';
import 'package:alarm_master/neumorphic/widget/switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifications.dart';

//切换闹钟显示
class AlarmGroupWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlarmGroupWidgetState();
  }
}

class _AlarmGroupWidgetState extends State<AlarmGroupWidget> {
  static const String KEY = "alarm";
  List<AlarmData> dataList = [];
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      dataList = getObjList<AlarmData>(KEY, (v) => AlarmData.fromJson(v),
          defValue: []);
    });
  }

  List<Map>? getObjectList(String key) {
    List<String>? dataLis = sharedPreferences?.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    }).toList();
  }

  Future<bool>? putObjectList(String key, List<dynamic> list) {
    List<String>? _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return sharedPreferences?.setStringList(key, _dataList);
  }

  List<T> getObjList<T>(String key, T f(Map v), {List<T> defValue = const []}) {
    List<Map>? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) {
      return f(value);
    }).toList();
    return list ?? defValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _titleBar(context),
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 30),
          child: Text(
            DateTime.now().year.toString() + " / " + DateTime.now().month.toString() +  DateTime.now().day.toString(),
            style: TextStyle(
              color: Color.fromARGB(255, 49, 68, 106),
              fontWeight: FontWeight.w700,
              fontSize: 25,
              shadows: [
                Shadow(
                    color: Colors.black38, offset: Offset(1.0, 1.0), blurRadius: 2)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        WatchWidget(),
        SizedBox(
          height: 20,
        ),
        Container(child: _dataLayout(context), height: 270)
      ],
    );
  }

  _titleBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 227, 237, 247),
      elevation: 0,
      title: Text(
        'Clock',
        style: TextStyle(
          color: Color.fromARGB(255, 49, 68, 106),
          fontWeight: FontWeight.w700,
          fontSize: 28,
          shadows: [
            Shadow(
                color: Colors.black38, offset: Offset(1.0, 1.0), blurRadius: 2)
          ],
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        NeumorphicButton(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 16),
          onPressed: () {
            _showCupertinoDatePickerForDate(context);
          },
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.circle(),
            color: Color.fromARGB(255, 227, 237, 247),
          ),
          child: Image.asset(
            'assets/image/add.png',
            fit: BoxFit.scaleDown,
            width: 23,
            height: 23,
          ),
        ),
      ],
    );
  }

  late DateTime chooseDateTime;

  _getActions(BuildContext context) {
    final Widget actions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "取消",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color.fromARGB(255, 234, 111, 113)),
              )),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(chooseDateTime);
              _showNotification(chooseDateTime.hour, chooseDateTime.minute);
              setState(() {
                print(chooseDateTime);
                dataList.add(AlarmData(hour: chooseDateTime.hour,
                    minute: chooseDateTime.minute,
                    isAm: chooseDateTime.hour < 12, isActive: true));
                putObjectList(KEY, dataList);
              });
            },
            child: Text(
              "确定",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color.fromARGB(255, 64, 83, 118)),
            ),
          ),
        ],
      ),
    );
    return actions;
  }

  _showNotification(int hour, int minute) {
    NotificationApi.showScheduledNotification(
        id: hour + minute,
        title: 'Your Time has Come',
        body: 'Right now at, '
            + hour.toString().padLeft(2,'0') + ' : '
            + minute.toString().padLeft(2, '0'),
        payload: minute.toString(),
        when: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            hour,
            minute
        )
    );
  }

  _dataLayout(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Neumorphic(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.only(left: 10, right: 10),
            style: NeumorphicStyle(
              color: Color.fromARGB(255, 227, 237, 247),
            ),
            child: Container(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                  (dataList[index].isAm
                        ? dataList[index].hour.toString().padLeft(2, '0')
                        : (dataList[index].hour - 12).toString().padLeft(2, '0')) +
                            ":" +
                            dataList[index].minute.toString().padLeft(2, '0'),
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 49, 68, 106),
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    dataList[index].isAm? "am" : "pm",
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 147, 162, 184),
                        fontWeight: FontWeight.w700),
                  ),
                  Expanded(child: SizedBox()),
                  NeumorphicSwitch(
                    isEnabled: true,
                    value: dataList[index].isActive,
                    onChanged: (value) {
                      setState(() {
                        dataList[index].isActive = value;
                        if(!value) {
                          NotificationApi.cancelNotification(
                              dataList[index].hour + dataList[index].minute);
                        } else {
                          _showNotification(dataList[index].hour, dataList[index].minute);
                        }
                      });
                    },
                    style: NeumorphicSwitchStyle(
                        activeTrackColor: Color.fromARGB(255, 185, 206, 226),
                        activeThumbColor: Color.fromARGB(255, 49, 69, 106),
                        inactiveTrackColor: Color.fromARGB(255, 222, 232, 242),
                        inactiveThumbColor: Color.fromARGB(255, 227, 237, 247)),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<DateTime?> _showCupertinoDatePickerForDate(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        final CupertinoDatePicker cupertinoDatePicker = CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          // 日期选择器模式 `time`,`date`,`dateAndTime`, 默认`dateAndTime`
          initialDateTime: DateTime.now(),
          // 初始化日期
          minimumDate: DateTime(2021, 10, 10),
          // 最小可选日期
          maximumDate: DateTime(2023, 12, 22),
          // 最大可选日期
          minimumYear: 2020,
          // 最小年份
          maximumYear: 2025,
          // 最大年份
          minuteInterval: 1,
          // 分钟间隔  initialDateTime.minute 必须可以整除 minuteInterval 必须是 60 的整数因子
          use24hFormat: false,
          // 是否使用24小时制
          dateOrder: DatePickerDateOrder.ymd,
          // 日期选择器排序方式 默认年/月/日
          backgroundColor: Colors.white,
          // 选中日期变化回调
          onDateTimeChanged: (dateTime) {
            chooseDateTime = dateTime;
          },
        );

        // 初始化chooseDateTime
        chooseDateTime = cupertinoDatePicker.initialDateTime;
        return AnimatedContainer(
          duration: Duration(microseconds: 200),
          height: 300,
          width: double.infinity,
          child: Column(
            children: [
              _getActions(context),
              Expanded(
                child: cupertinoDatePicker,
              ),
            ],
          ),
        );
      },
    );
  }
}
