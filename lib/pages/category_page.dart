import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import 'package:provide/provide.dart';
import '../model/categoryGoodsList.dart';
import '../provide/category_goods_list.dart';

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品分类')),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCatgegoryNav(),
            Column(
              children: <Widget>[
                RightCatgoryNav(),
                CategoryGoodsList()
              ],
            )
          ],
        ),
      ),
    );
  }

  
}

// 左侧大类导航
class LeftCatgegoryNav extends StatefulWidget {
  
  _LeftCatgegoryNavState createState() => _LeftCatgegoryNavState();
}

class _LeftCatgegoryNavState extends State<LeftCatgegoryNav> {

  List list=[];
  var listIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    _getCategory();
    _getGoodsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       width: ScreenUtil().setWidth(180),
       decoration: BoxDecoration(
         border: Border(
           right: BorderSide(width: 1,color: Colors.black12)
         )
       ),
       child: ListView.builder(
         itemCount: list.length,                                                //列表长度
         itemBuilder: (BuildContext context, int index) {
          return _leftInkWell(index);
        },
       ),
    );
  }

  Widget _leftInkWell(int index){
    bool isClick=false;
    isClick=(index==listIndex)?true:false;
    return InkWell(
      onTap: (){
        setState(() {
         listIndex=index; 
        });
        var childList=list[index].bxMallSubDto;
        var categoryId=list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
        _getGoodsList(categoryId:categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10,top: 20),
        decoration: BoxDecoration(
          color: isClick?Color.fromRGBO(236, 236, 236, 1.0):Colors.white,
          border: Border( 
            bottom: BorderSide(width: 1,color: Colors.black12)      //设置底边
          )
        ),
        child: Text(list[index].mallCategoryName,style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }

  void _getCategory() async{
    await request('getCategory').then((val){
      var data=json.decode(val.toString());
      CategoryModel category =CategoryModel.fromJson(data);
      setState(() {
        list=category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto);
    });
  }

  void _getGoodsList({String categoryId}) async{
      var data={
        'categoryId':categoryId==null?'4':categoryId,
        'categorySubId ':"",
        'page':1
      };

      await request('getMallGoods',formData: data).then((val){
        var data=json.decode(val.toString());
        CategoryGoodsListModel goodsList=CategoryGoodsListModel.fromJson(data);
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      });
    }

}

// 右侧二级导航
class RightCatgoryNav extends StatefulWidget {
  _RightCatgoryNavState createState() => _RightCatgoryNavState();
}

class _RightCatgoryNavState extends State<RightCatgoryNav> {


  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context,child,childCategory){
        return Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width:1,color: Colors.black12)
              )
            ),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: childCategory.chilCategoryList.length,
                itemBuilder: (BuildContext context, int index) {
                return _rightInkWell(childCategory.chilCategoryList[index]);
              },
            ),
        );
      },
    );
    
  }

  Widget _rightInkWell(BxMallSubDto item){
    
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style:TextStyle(fontSize:ScreenUtil().setSp(28))
        ),
      ),
    );
  }
}

// 商品列表
class CategoryGoodsList extends StatefulWidget {
  final Widget child;

  CategoryGoodsList({Key key, this.child}) : super(key: key);

  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context,child,data){
        return Container(
          width: ScreenUtil().setWidth(570),
          height: ScreenUtil().setHeight(950),
          child: ListView.builder(
            itemCount: data.goodsList.length,
            itemBuilder: (BuildContext context, int index) {
              return _listWidget(data.goodsList,index);
            },
          ),
        );
      },
    );
    
  }

  

  Widget _goodsImage(List newList,index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList,index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList,index){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格:￥${newList[index].presentPrice}',
            style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(30))
          ),
           Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _listWidget(List newList,int index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top:5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList,index),
            Column(
              children: <Widget>[
                _goodsName(newList,index),
                _goodsPrice(newList,index)
              ],
            )
          ],
        ),
      ),
    );
  }
}