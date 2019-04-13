import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier{
  String cartString="[]";
  List<CartInfoModel> cartList=[];

  save(goodsId,goodsName,count,price,images) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();      //初始化
    cartString=preferences.getString('cartInfo');                             //取值
    var temp = cartString==null?[]:json.decode(cartString);                   //三元运算符 有值就转换成json
    List<Map> tempList=(temp as List).cast();                                 //转换成List
    bool isHave=false;
    int ival=0;                                                               //索引
    tempList.forEach((item){
      if(item['goodsId']==goodsId){                                           //存在的话 数量加一
        tempList[ival]['count']=item['count']+1;
        cartList[ival].count++;
        isHave=true;
      }
      ival++;
    });

    if(!isHave){                                                                //如果商品原先不存在的时候,商品加到购物车中
        Map<String,dynamic> newGoods={
          'goodsId':goodsId,
          'goodsName':goodsName,
          'count':count,
          'price':price,
          'images':images
        };
        tempList.add(newGoods);
        cartList.add(CartInfoModel.fromJson(newGoods));                       //map数据转化为json
    }

    cartString=json.encode(tempList).toString();

    print('字符串>>>>>>>>>>>>>>>>>>${cartString}');
    print('数据模型>>>>>>>>>>>>>>>>>>${cartList}');
    preferences.setString('cartInfo', cartString);                            //进行持久化

    notifyListeners();                                                        //通知页面修改

  }

  remove() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();      //初始化
    preferences.remove('cartInfo');
    cartList=[];                                                              //数据模型清空
    print('情况完成-------------------------------');
    notifyListeners();
  }

  getCartInfo() async{
     SharedPreferences preferences=await SharedPreferences.getInstance();      //初始化
     cartString = preferences.getString('cartInfo');
     cartList=[];
     if(cartString==null){
       cartList=[];
     }else{
       List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
       tempList.forEach((item){
         cartList.add(CartInfoModel.fromJson(item));                          //转变对象形式
       });
     }

     notifyListeners();
  }

}