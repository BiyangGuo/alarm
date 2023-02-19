import 'package:alarm_master/pages/stop_watch_group_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'alarm_group_widget.dart';
import 'bottom_bar_widget.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'notifications.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  late Watch watch = Watch.ALARM;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    NotificationApi.init();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    showToast("Alarm is coming");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 227, 237, 247),
        child: Column(
          children: [
            _getClockWidget(),
            Expanded(child: SizedBox(),),
            _getBottomBar(context)

          ],
        ),
      ),
    );
  }

  _getBottomBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16,right: 16,bottom: 30),
      child: BottomBarWidget(watch: watch, onChanged: (watch){
        setState(() {
          this.watch = watch;
        });
      }),
    );
  }

  _getClockWidget() {
    if(watch == Watch.ALARM) {
      return AlarmGroupWidget();
    } else {
      return StopWatchGroupWidget();
    }
  }
}
