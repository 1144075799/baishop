import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarPage extends StatefulWidget {
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {

  List<String> testList=[];
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 300.0,
            child: ListView.builder(
              itemCount: testList.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(testList[index]),
                );
              },
            ),
          ),
          RaisedButton(
            onPressed: (){
              _add();
            },
            child: Text('增加'),
          ),
          RaisedButton(
            onPressed: (){
              _clear();
            },
            child: Text('删除'),
          )
        ],
      ),
    );
  }

  //增加方法
  void _add() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();   //初始化
    String temp="jspang";
    testList.add(temp);
    preferences.setStringList('testInfo', testList);              //持久化
    _show();
  }

  //查询方法
  void _show() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();   //初始化
    if(preferences.getStringList('testInfo')!=null){
      setState(() {
        testList=preferences.getStringList('testInfo');
      });
    }
  }

  //删除方法
  void _clear() async{
   SharedPreferences preferences=await SharedPreferences.getInstance();   //初始化
    // preferences.clear();                                //删除所有的key value
    preferences.remove('testInfo');                        //移除指定的key
    setState(() {
     testList=[]; 
    });
  }
}