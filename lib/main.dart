import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/index_page.dart';

void main(){
  ///
  /// 强制竖屏
  /// 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(MyApp());
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