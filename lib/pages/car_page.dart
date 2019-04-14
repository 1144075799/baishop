import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './car_page/car_items.dart';
import './car_page/car_bottom.dart';

class CarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List cartList=Provide.value<CartProvide>(context).cartList;

            return Stack(
              children: <Widget>[
                  ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context,index){
                      return CartItem(cartList[index]);
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CarButtom(),
                  )
              ],
            );
          }else{
            return Text('正在加载....');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async{
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}
