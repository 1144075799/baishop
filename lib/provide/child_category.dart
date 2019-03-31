import 'package:flutter/material.dart';
import '../model/category.dart';



class ChildCategory with ChangeNotifier{

  List<BxMallSubDto> chilCategoryList=[];
  int childIndex=0;                           //子类高亮索引
  String categoryId='4';                      //大类id
  String subId='';                            //小类id
  int page=1;                                 //列表页数
  String noMoreText='';                       //显示没有数据的文字

  //大类切换逻辑
  getChildCategory(List<BxMallSubDto> list,String id){
    page=1;
    noMoreText='';
    childIndex=0;
    categoryId=id;
    BxMallSubDto all= BxMallSubDto();
    all.mallSubId='';
    all.mallCategoryId='00';
    all.mallSubName='全部';
    all.comments='null';
    chilCategoryList=[all];
    chilCategoryList.addAll(list);
    notifyListeners();              //通知听众 局部刷新
  }

  // 改变子类索引 切换小类
  changeChildIndex(index,String id){
     page=1;
    noMoreText='';
    childIndex=index;
    subId=id;
    notifyListeners();
  }

  //增加page的方法
  addPage(){
    page++;
  }
  changeNoMoreText(String text){
    noMoreText=text;
    notifyListeners();
  }
}
