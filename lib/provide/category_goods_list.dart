import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';



class CategoryGoodsListProvide with ChangeNotifier{

  List<CategroyListData> goodsList=[];

  // 点击大类时 更换商品列表
  getGoodsList(List<CategroyListData> list){
    goodsList=list;
    notifyListeners();
  }

  getMoreList(List<CategroyListData> list){
    goodsList.addAll(list);
    notifyListeners();
  }

}
