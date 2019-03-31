import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

//总体配置
class Routes{
  static String root='/';       //根目录
  static String detailsPage='/detail';      //详细页面
  static void configureRoutes(Router router){
    router.notFoundHandler=new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        print('ERROR======>ROUTE WAS NOT FOUND!!!!');
      }
    );         //找不到路由

    //配置路由
    router.define(detailsPage,handler: detailsHandler);
  }
}