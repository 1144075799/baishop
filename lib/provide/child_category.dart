import 'package:flutter/material.dart';
import '../model/category.dart';



class ChildCategory with ChangeNotifier{

  List<BxMallSubDto> chilCategoryList=[];

  getChildCategory(List list){
    chilCategoryList=list;
    notifyListeners();              //通知听众 局部刷新
  }

}
