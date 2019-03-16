import 'package:flutter/material.dart';


class Counter with ChangeNotifier{

  int value=0;

  //相加方法
  increment(){
    value++;
    notifyListeners();              //通知听众 局部刷新
  }

}
