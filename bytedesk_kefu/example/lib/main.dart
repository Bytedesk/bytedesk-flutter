import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu_example/notification/custom_notification.dart';
import 'package:bytedesk_kefu_example/page/chat_type_page.dart';
import 'package:bytedesk_kefu_example/page/history_thread_page.dart';
import 'package:bytedesk_kefu_example/page/online_status_page.dart';
import 'package:bytedesk_kefu_example/page/setting_page.dart';
import 'package:bytedesk_kefu_example/page/switch_user_page.dart';
import 'package:bytedesk_kefu_example/page/user_info_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';
// import 'package:audioplayers/audioplayers.dart';

void main() {
  // runApp(MyApp());
  runApp(OverlaySupport(
      child: MaterialApp(
    debugShowCheckedModeBanner: false, // 去除右上角debug的标签
    home: MyApp(),
  )));

  // 参考文档：https://github.com/Bytedesk/bytedesk-flutter
  // 管理后台：https://www.bytedesk.com/admin
  // appkey和subDomain请替换为真实值
  // 获取appkey，登录后台->渠道管理->Flutter->添加应用->获取appkey
  String _appKey = '81f427ea-4467-4c7c-b0cd-5c0e4b51456f';
  // 获取subDomain，也即企业号：登录后台->客服管理->客服账号->企业号
  String _subDomain = "vip";
  // 第一步：初始化
  BytedeskKefu.init(_appKey, _subDomain);
  // 注：如果需要多平台统一用户（用于同步聊天记录等），可使用下列接口，其中：username只能包含数字或字母，不能含有汉字和特殊字符等，nickname可以使用汉字
  // 注：如需切换用户，请首先执行BytedeskKefu.logout()
  // BytedeskKefu.initWithUsernameAndNicknameAndAvatar('myflutterusername', '我是美女', 'https://bytedesk.oss-cn-shenzhen.aliyuncs.com/avatars/girl.png', _appKey, _subDomain);
  // BytedeskKefu.initWithUsername('myflutterusername', _appKey, _subDomain); // 其中：username为自定义用户名，可与开发者所在用户系统对接
  // 如果还需要自定义昵称/头像，可以使用 initWithUsernameAndNickname或initWithUsernameAndNicknameAndAvatar，
  // 具体参数可以参考 bytedesk_kefu/bytedesk_kefu.dart 文件
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // // 获取appkey，登录后台->渠道管理->Flutter->添加应用->获取appkey
  // String _appKey = '81f427ea-4467-4c7c-b0cd-5c0e4b51456f';
  // // 获取subDomain，也即企业号：登录后台->客服管理->客服账号->企业号
  // String _subDomain = "vip";
  //
  String _title = '萝卜丝客服Demo(连接中...)';
  // AudioCache audioCache = AudioCache();
  // bool _isConnected = false;
  //
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
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
              // 第二步：联系客服，完毕
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
              // 需要首先调用anonymousLogin之后，再调用设置用户信息接口
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
            title: Text('消息提示'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new SettingPage();
              }));
            },
          ),
          ListTile(
            title: Text('切换用户'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new SwitchUserPage();
              }));
            },
          ),
          // ListTile(
          //   title: Text('退出登录'),
          //   onTap: () {
          //     BytedeskKefu.logout();
          //   },
          // ),
          // ListTile(
          //   title: Text('重新初始化'),
          //   onTap: () {
          //     BytedeskKefu.initWithUsernameAndNicknameAndAvatar(
          //         'myflutterusername2',
          //         '我是帅哥',
          //         'https://bytedesk.oss-cn-shenzhen.aliyuncs.com/avatars/boy.png',
          //         _appKey,
          //         _subDomain);
          //   },
          // ),
          ListTile(
            title: Text('技术支持: QQ-3群: 825257535'),
          )
        ],
      ).toList()),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // 第二步：到 客服管理->技能组-有一列 ‘唯一ID（wId）’, 默认设置工作组wid
      //     // 说明：一个技能组可以分配多个客服，访客会按照一定的规则分配给组内的各个客服账号
      //     String _workGroupWid = "201807171659201"; // 默认人工
      //     BytedeskKefu.startWorkGroupChat(context, _workGroupWid, "技能组客服-默认人工");
      //   },
      //   tooltip: '客服',
      //   child: Icon(Icons.message),
      // ), // Th
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
    // 监听消息，开发者可在此决定是否振动或播放提示音声音
    bytedeskEventBus.on<ReceiveMessageEventBus>().listen((event) {
      // print('receive message:' + event.message.content);
      // 1. 首先将example/assets/audio文件夹中文件拷贝到自己项目；2.在自己项目pubspec.yaml中添加assets
      // 播放发送消息提示音
      if (BytedeskKefu.getPlayAudioOnSendMessage()! &&
          event.message.isSend == 1) {
        print('play send audio');
        // 修改为自己项目中语音文件路径
        // audioCache.play('audio/bytedesk_dingdong.wav');
      }
      if (event.message.isSend == 1) {
        // 自己发送的消息，直接返回
        return;
      }
      // 接收消息播放提示音
      if (BytedeskKefu.getPlayAudioOnReceiveMessage()! &&
          event.message.isSend == 0) {
        print('play receive audio');
        // audioCache.play('audio/bytedesk_dingdong.wav');
      }
      // 振动
      if (BytedeskKefu.getVibrateOnReceiveMessage()! &&
          event.message.isSend == 0) {
        print('should vibrate');
        vibrate();
      }
      if (event.message.type == BytedeskConstants.MESSAGE_TYPE_TEXT) {
        print('文字消息: ' + event.message.content!);
        // 判断当前是否客服页面，如否，则显示顶部通知栏
        if (!BytedeskUtils.isCurrentChatKfPage()!) {
          // https://github.com/boyan01/overlay_support
          showOverlayNotification((context) {
            return MessageNotification(
              avatar: event.message.user!.avatar!,
              nickname: event.message.user!.nickname!,
              content: event.message.content!,
              onReply: () {
                //
                OverlaySupportEntry.of(context)!.dismiss();
                // 进入客服页面，支持自定义页面标题
                BytedeskKefu.startChatThread(context, event.message.thread!,
                    title: '客服会话');
              },
            );
          }, duration: Duration(milliseconds: 4000));
        }
      } else if (event.message.type == BytedeskConstants.MESSAGE_TYPE_IMAGE) {
        print('图片消息:' + event.message.imageUrl!);
      } else if (event.message.type == BytedeskConstants.MESSAGE_TYPE_VOICE) {
        print('语音消息:' + event.message.voiceUrl!);
      } else if (event.message.type == BytedeskConstants.MESSAGE_TYPE_VIDEO) {
        print('视频消息:' + event.message.videoUrl!);
      } else if (event.message.type == BytedeskConstants.MESSAGE_TYPE_FILE) {
        print('文件消息:' + event.message.fileUrl!);
      } else {
        print('其他类型消息:' + event.message.type!);
      }
    });
    // token过期
    // bytedeskEventBus.on<InvalidTokenEventBus>().listen((event) {
    //   // 执行重新初始化
    //   print('InvalidTokenEventBus, token过期');
    // });
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

  // 振动
  void vibrate() async {
    // if (await Vibration.hasVibrator()) {
    //   Vibration.vibrate();
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
    // audioCache?
  }
}
