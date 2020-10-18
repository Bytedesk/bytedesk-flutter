import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:bytedesk_demo/page/chat_type_page.dart';
import 'package:bytedesk_demo/page/history_thread_page.dart';
import 'package:bytedesk_demo/page/online_status_page.dart';
import 'package:bytedesk_demo/page/setting_page.dart';
import 'package:bytedesk_demo/page/user_info_page.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(MyApp());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // 去除右上角debug的标签
    home: MyApp(),
  ));

  // 参考文档：https://github.com/Bytedesk/bytedesk-flutter
  // 管理后台：https://www.bytedesk.com/antv/user/login
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //
  String _title = '萝卜丝客服Demo';
  // 第二步：到 客服管理->技能组-有一列 ‘唯一ID（wId）’, 默认设置工作组wid
  // String _workGroupWid = "201807171659201";
  //
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
          children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            title: Text('联系客服'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // 第三步：联系客服，完毕
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new ChatTypePage();
              }));
            },
          ),
          ListTile(
            title: Text('用户信息'), // 自定义用户资料，设置
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new UserInfoPage();
              }));
            },
          ),
          ListTile(
            title: Text('在线状态'), // 技能组或客服账号 在线状态
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new OnlineStatusPage();
              }));
            },
          ),
          ListTile(
            title: Text('历史会话'), // 会话记录
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new HistoryThreadPage();
              }));
            },
          ),
          // ListTile(
          //   title: Text('TODO:提交工单'),
          //   trailing: Icon(Icons.keyboard_arrow_right),
          //   onTap: () {
          //     print('ticket');
          //     // TODO: 提交工单
          //   },
          // ),
          // ListTile(
          //   title: Text('TODO:意见反馈'),
          //   trailing: Icon(Icons.keyboard_arrow_right),
          //   onTap: () {
          //     print('feedback');
          //     // TODO: 意见反馈
          //   },
          // ),
          ListTile(
            title: Text('消息设置'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new SettingPage();
              }));
            },
          )
        ],
      ).toList()),
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

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print("main didChangeAppLifecycleState:" + state.toString());
  //   switch (state) {
  //     case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
  //       break;
  //     case AppLifecycleState.paused: // 应用程序不可见，后台
  //       break;
  //     case AppLifecycleState.resumed: // 应用程序可见，前台
  //       // APP切换到前台之后，重连
  //       // BytedeskUtils.mqttReConnect();
  //       break;
  //     case AppLifecycleState.detached: // 申请将暂时暂停
  //       break;
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
