import 'dart:convert';

import 'package:alarm_master/data/stop_watch_data.dart';
import 'package:alarm_master/event/save_watch_tevent.dart';
import 'package:alarm_master/event/stop_watch_tevent.dart';
import 'package:alarm_master/pages/stop_watch_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_master/config/application.dart';
import 'package:alarm_master/neumorphic/widget/button.dart';
import 'package:alarm_master/neumorphic/widget/container.dart';
import 'package:shared_preferences/shared_preferences.dart';


///秒表
class StopWatchGroupWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StopWatchGroupWidgetState();
  }
}

class _StopWatchGroupWidgetState extends State<StopWatchGroupWidget> {
  static const String KEY = "watch";
  bool _isTime = false;
  List<StopWatchData> dataList = [];
  SharedPreferences? sharedPreferences;
  String _time = '00:00:00';
  @override
  void initState() {
    super.initState();
    _initData();
    Application.eventBus.on<SaveWatchEvent>().listen((event) {
      _time = event.time;
    });
  }

  _initData() async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      dataList = getObjList<StopWatchData>(KEY, (v) => StopWatchData.fromJson(v), defValue: []);
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

  /// get obj list.
   List<T> getObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
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
        StopWatchWidget(),
        SizedBox(
          height: 20,
        ),
        _getLayoutActions(context),
        Container(child: _dataLayout(context), height: 250)
        // _dataLayout(context)
        // Expanded(child: _dataLayout(context))
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
            if(_time != "00:00:00") {
              setState(() {
                dataList.add(StopWatchData(time: _time));
                putObjectList(KEY, dataList);
              });
            }
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

  _dataLayout(BuildContext context) {
    return ListView.builder(
        shrinkWrap:true,
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
                 (index + 1).toString(),
                 style: TextStyle(
                     fontSize: 20,
                     color: Color.fromARGB(255, 49, 68, 106),
                     fontWeight: FontWeight.w700),
               ),
               SizedBox(
                 width: 6,
               ),
               Text(
                 'Lap',
                 style: TextStyle(
                     fontSize: 12,
                     color: Color.fromARGB(255, 147, 162, 184),
                     fontWeight: FontWeight.w700),
               ),
               Expanded(child: SizedBox()),
               Text(
                 dataList[index].time,
                 style: TextStyle(
                     fontWeight: FontWeight.w700,
                     fontSize: 16,
                     color: Color.fromARGB(255, 64, 83, 118)),
               )
             ],
           ),
         ),
       );
    });
  }

  _getLayoutActions(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16,right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NeumorphicButton(
            style: NeumorphicStyle(
              color: Color.fromARGB(255, 227, 237, 247),
            ),
            child: Container(
              width: 120,
              alignment: Alignment.center,
              child: Text(
                _isTime?'Stop':'Start',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color.fromARGB(255, 64, 83, 118)),
              ),
            ),
            onPressed: () {
              setState(() {
                _isTime = !_isTime;
                if(_isTime){
                  Application.eventBus.fire(StopWatchEvent(StopWatchState.TIME));
                }else{
                  Application.eventBus.fire(StopWatchEvent(StopWatchState.STOP));
                }

              });
            },
          ),
          NeumorphicButton(
            style: NeumorphicStyle(
              color: Color.fromARGB(255, 227, 237, 247),
            ),
            child: Container(
              width: 120,
              alignment: Alignment.center,
              child: Text(
                'Reset',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color.fromARGB(255, 234, 111, 113)),
              ),
            ),
            onPressed: () {
              setState(() {
                Application.eventBus.fire(StopWatchEvent(StopWatchState.RESET));
              });
            },
          ),
        ],
      ),
    );
  }
}
