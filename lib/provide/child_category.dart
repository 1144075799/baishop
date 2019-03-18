import 'package:flutter/material.dart';
import '../model/category.dart';



class ChildCategory with ChangeNotifier{

  List<BxMallSubDto> chilCategoryList=[];

  getChildCategory(List<BxMallSubDto> list){
    BxMallSubDto all= BxMallSubDto();
    all.mallSubId='00';
    all.mallCategoryId='00';
    all.mallSubName='全部';
    all.comments='null';
    chilCategoryList=[all];
    chilCategoryList.addAll(list);
    notifyListeners();              //通知听众 局部刷新
  }

}
