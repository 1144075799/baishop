import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  //火爆专区参数
  int page=1;
  List<Map> hotGoodsList=[];

  GlobalKey<RefreshFooterState> _footerkey=new GlobalKey<RefreshFooterState>();

  @override
  bool get wantKeepAlive=>true;

  String homePageContent='正在获取数据';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var formDate={'lon':'115.02932','lat':'35.76189'};
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+'),),
      body: FutureBuilder(
        future: request('homePageContent',formData:formDate),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data=json.decode(snapshot.data.toString());
             List<Map> swiper=(data['data']['slides'] as List).cast();
             List<Map> navgatorList=(data['data']['category'] as List).cast();
             String adPicture=data['data']['advertesPicture']['PICTURE_ADDRESS'];
             String leaderImage=data['data']['shopInfo']['leaderImage'];
             String leaderPhone=data['data']['shopInfo']['leaderPhone'];
             List<Map> recommendList=(data['data']['recommend'] as List).cast();
             String floor1Title=data['data']['floor1Pic']['PICTURE_ADDRESS'];
             String floor2Title=data['data']['floor2Pic']['PICTURE_ADDRESS'];
             String floor3Title=data['data']['floor3Pic']['PICTURE_ADDRESS'];
             List<Map> floor1=(data['data']['floor1'] as List).cast();
             List<Map> floor2=(data['data']['floor2'] as List).cast();
             List<Map> floor3=(data['data']['floor3'] as List).cast();

             return EasyRefresh(
               refreshFooter: ClassicsFooter(
                 key: _footerkey,
                 bgColor: Colors.white,
                 textColor: Colors.lightBlue,
                 moreInfoColor: Colors.lightBlue,
                 showMore: true,
                 noMoreText: '',
                 moreInfo: '加载中',
                 loadReadyText: '上拉加载.....',
               ),

                child:ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDateList:swiper),
                    TopNavigator(navigatorList: navgatorList),
                    AdBanner(adPicture:adPicture),
                    LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone,),
                    Recommend(recommendList:recommendList),
                    FloorTitle(picture_address: floor1Title),
                    FloorContent(floorGoodsList: floor1,),
                    FloorTitle(picture_address: floor2Title),
                    FloorContent(floorGoodsList: floor2,),
                    FloorTitle(picture_address: floor3Title),
                    FloorContent(floorGoodsList: floor3,),
                    _hotGoods()
                  ],
                ),
                loadMore: () async{
                  print('开始加载更多......');
                  var formPage={'page':page};
                  await request('homePageBelowConten',formData:formPage).then((val){
                    var data=json.decode(val.toString());
                    List<Map> newGoodsList = (data['data'] as List ).cast();
                    setState(() {
                    hotGoodsList.addAll(newGoodsList);
                    page++;
                    });
                  });
                },
             );
             
             
          }else{
            return Center(
              child: Text('加载中...'),
            );
          }
        },
      ),
    );
  }
  
  //标题
  Widget hotTitle=Container(
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    color: Colors.transparent,      //透明色
    padding: EdgeInsets.all(5.0),
    child: Text('火爆专区'),
  );

  Widget _wrapList(){
    // 判断长度
    if(hotGoodsList.length!=0){
      List<Widget> listWidget=hotGoodsList.map((val){

        return InkWell(
          onTap: (){},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'],width:ScreenUtil().setWidth(370)),
                Text(
                  val['name'],
                  maxLines: 1,                                //最多一行
                  overflow: TextOverflow.ellipsis,            //超出省略号
                  style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),   //删除线
                    )
                  ],
                )
              ],
            ),
          ),
        );

      }).toList();

      // 流布局
      return Wrap(
        spacing: 2,         //每一行是两列
        children: listWidget,
      );
    }else{
      return Text('');
    }
  }

  // 组合
  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }

}

// 首页轮播图组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  SwiperDiy({Key key, this.swiperDateList}) : super(key: key); //接受参数

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network("${swiperDateList[index]['image']}",fit: BoxFit.fill);  //图片
        },
        itemCount: swiperDateList.length,                //个数
        pagination: SwiperPagination(),               //是否有点
        autoplay: true,                               //自动播放
      ),
    );
  }
}

//导航区域
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context,item){
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(this.navigatorList.length>10){
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }

    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),  //禁止回弹
        crossAxisCount: 5,              //每行5个
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}


// 广告
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage;             //店长图片
  final String leaderPhone;             //店长电话

  LeaderPhone({Key key, this.leaderImage,this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: (){_launchURL();},
        child: Image.network(leaderImage),
      )
    );
  }

  //拨打电话
  void _launchURL() async{
    String url='tel:'+'13868548597';    //电话
    // String url='http://jspang.com';       //网页
    if(await canLaunch(url)){     //判断是否可以发射
      await launch(url);  
    }else{
      throw '不能进行访问';
    }
  }

}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);
  
  // 标题方法
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5,color:Colors.black12)
        )
      ),
      child: Text(
        '商品推荐',
        style:TextStyle(color:Colors.pink)
      ),
    );
  }

  // 商品单独项方法
  Widget _item(index){
    return InkWell(
      onTap: (){print('点击了${index}个商品');},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5,color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough, //删除线
                color:Colors.black12
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 横向列表
  Widget _recommedList(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return _item(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList()
        ],
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;
  FloorTitle({Key key, this.picture_address}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

// 楼层商品
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){print('点击了楼层商品');},
        child: Image.network(goods['image']),
      ),
    );
  }
}

