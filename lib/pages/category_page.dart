import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import 'package:provide/provide.dart';

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
        Provide.value<ChildCategory>(context).getChildCategory(childList);
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
    _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('商品列表'),
    );
  }

  void _getGoodsList() async{
    var data={
      'categoryId':'4',
      'categorySubId ':"",
      'page':1
    };

    await request('getMallGoods',formData: data).then((val){
      var data=json.decode(val.toString());
      print('分类商品列表:>>>>>>>>>>>>>>>>>>>>>>>>>>>${val}');
    });
  }
}