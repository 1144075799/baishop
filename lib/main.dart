import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';

void main(){
  ///
  /// 强制竖屏
  /// 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  var counter=Counter();
  var childCategory=ChildCategory();
  var categoryGoodsListProvide=CategoryGoodsListProvide();
  var providers=Providers();

  providers
  ..provide(Provider<Counter>.value(counter))                     //添加依赖 
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));


  runApp(ProviderNode(child: MyApp(),providers: providers,));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.lightBlue
        ),
        home: IndexPage(),
      ),
    );
  }
}