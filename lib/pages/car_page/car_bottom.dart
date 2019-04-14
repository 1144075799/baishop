import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CarButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          selecttAllBtn(),
          allPriceArea(),
          goButton()

        ],
      ),
    );
  }

 //全选按钮
 Widget selecttAllBtn(){
   return Container(
    child: Row(
      children: <Widget>[
        Checkbox(
          value: true,
          activeColor: Colors.lightBlue,
          onChanged: (bool val){},
        ),
        Text('全选')
      ],
    ),
   );
 }

 //合计布局
 Widget allPriceArea(){
   return Container(
     width: ScreenUtil().setWidth(430),
     child: Column(
       children: <Widget>[
         Row(
           children: <Widget>[
             Container(
               alignment: Alignment.centerRight,
               width: ScreenUtil().setWidth(280),
               child: Text(
                 '合计:',
                 style: TextStyle(
                   fontSize: ScreenUtil().setSp(36)
                 ),
                ),
             ),
             Container(
               alignment: Alignment.centerLeft,
               width: ScreenUtil().setWidth(150),
               child: Text(
                 '￥1992',
                 style: TextStyle(
                   fontSize: ScreenUtil().setSp(36),
                   color: Colors.red
                 ),
               ),
             ),
           ],
         ),
         Container(
           width: ScreenUtil().setWidth(430),
           alignment: Alignment.centerRight,
           child: Text(
             '满10元面配送费，预购免配送费',
             style: TextStyle(
               color: Colors.black38,
               fontSize: ScreenUtil().setSp(22)
             ),
           ),
         )
       ],
     ),
   );
 }

 //结算按钮
 Widget goButton(){
   return Container(
     width: ScreenUtil().setWidth(160),
     padding: EdgeInsets.only(left: 10),
     child: InkWell(
       onTap: (){},
       child: Container(
         padding: EdgeInsets.all(10.0),
         alignment: Alignment.center,
         decoration: BoxDecoration(
           color: Colors.red,
           borderRadius: BorderRadius.circular(3.0),
         ),
         child: Text(
           '结算(6)',
           style: TextStyle(
             color: Colors.white
           ),
          ),
       ),
     ),
   );
 }

}