import 'package:flutter/material.dart';
import '../model/category.dart';



class ChildCategory with ChangeNotifier{

  List<BxMallSubDto> chilCategoryList=[];
  int childIndex=0;                       //子类高亮索引

  //大类切换逻辑
  getChildCategory(List<BxMallSubDto> list){
    childIndex=0;
    BxMallSubDto all= BxMallSubDto();
    all.mallSubId='00';
    all.mallCategoryId='00';
    all.mallSubName='全部';
    all.comments='null';
    chilCategoryList=[all];
    chilCategoryList.addAll(list);
    notifyListeners();              //通知听众 局部刷新
  }

  // 改变子类索引
  changeChildIndex(index){
    childIndex=index;
    notifyListeners();
  }

}
