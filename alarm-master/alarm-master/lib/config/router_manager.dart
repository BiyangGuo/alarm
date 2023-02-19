import 'package:alarm_master/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RouterManager{

  static List<Widget> _listPages = [
    HomePage(),
  ];

   static to(int index,BuildContext context){
     Navigator.push(context, MaterialPageRoute(builder: (context) => _listPages[index]));
   }
}
