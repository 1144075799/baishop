import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier{
  String cartString="[]";
  List<CartInfoModel> cartList=[];

  double allPrice=0;      //总价
  int allGoodsCount=0;    //商品总数量


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
          'images':images,
          'isCheck':true
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
       allPrice=0;
       allGoodsCount=0;
       tempList.forEach((item){

         if(item['isCheck']){
           allPrice+=(item['count']*item['price']);
           allGoodsCount+=item['count'];
         }

         cartList.add(CartInfoModel.fromJson(item));                          //转变对象形式
       });
     }

     notifyListeners();
  }

  // 删除单个购物车商品
  deleteOneGoods(String goodsId) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    cartString=preferences.getString('cartInfo');
    List<Map> tempList=(json.decode(cartString.toString()) as List).cast();
    int tempIndex=0;
    int delIndex=0;
    tempList.forEach((item){
      if(item['goodsId']==goodsId){
        delIndex=tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    cartString=json.encode(tempList).toString();
    preferences.setString('cartInfo', cartString);
    await getCartInfo();
  }

}