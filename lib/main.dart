import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';

void main(){
  ///
  /// 强制竖屏
  /// 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  var counter=Counter();
  var providers=Providers();

  providers..provide(Provider<Counter>.value(counter));   //添加依赖  多个状态就是这里增加

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