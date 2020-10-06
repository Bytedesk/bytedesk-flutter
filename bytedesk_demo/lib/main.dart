import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(MyApp());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // 去除右上角debug的标签
    home: MyApp(),
  ));

  // 管理后台：https://www.bytedesk.com/antv/user/login
  // 参考文档：https://github.com/pengjinning/bytedesk-android
  // appkey和subDomain请替换为真实值
  // 获取appkey，登录后台->客服管理->渠道管理->添加应用->appkey
  String _androidKey = "66390193-b2c1-4edb-aa5f-50b1541059e8";
  String _iOSKey = "201809171553112";
  // 获取subDomain，也即企业号：登录后台->客服管理->客服账号->企业号
  String _subDomain = "vip";
  // 第一步：匿名登录
  BytedeskKefu.anonymousLogin(_androidKey, _iOSKey, _subDomain);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //
  String _title = '萝卜丝客服Demo';
  // 到 客服管理->技能组-有一列 ‘唯一ID（wId）’, 默认设置工作组wid
  String _workGroupWid = "201807171659201";
  //
  @override
  void initState() {
    super.initState();
    _listener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('联系客服'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print('chat');
              // 第二步：联系客服，完毕
              BytedeskKefu.startWorkGroupChat(context, _workGroupWid, "技能组客服");
            },
          )
        ],
      ),
    );
  }

  // 监听状态
  _listener() {
    // 监听连接状态
    bytedeskEventBus.on<ConnectionEventBus>().listen((event) {
      print('长连接状态:' + event.content);
      if (event.content == BytedeskConstants.USER_STATUS_CONNECTING) {
        setState(() {
          _title = "萝卜丝客服Demo(连接中...)";
        });
      } else if (event.content == BytedeskConstants.USER_STATUS_CONNECTED) {
        setState(() {
          _title = "萝卜丝客服Demo(连接成功)";
        });
      } else if (event.content == BytedeskConstants.USER_STATUS_DISCONNECTED) {
        setState(() {
          _title = "萝卜丝客服Demo(连接断开)";
        });
      }
    });
    // 监听消息
    bytedeskEventBus.on<ReceiveMessageEventBus>().listen((event) {
      // print('receive message:' + event.message.content);
      if (event.message.type == BytedeskConstants.MESSAGE_TYPE_TEXT) {
        print('文字消息: ' + event.message.content);
      } else if (event.message.type == BytedeskConstants.MESSAGE_TYPE_IMAGE) {
        print('图片消息:' + event.message.imageUrl);
      } else {
        print('其他类型消息');
      }
    });
  }
}
