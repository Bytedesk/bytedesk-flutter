import 'bytedesk_kefu_platform_interface.dart';
import 'dart:async';
// import 'dart:io';

import 'package:bytedesk_kefu/http/bytedesk_device_api.dart';

import 'package:sp_util/sp_util.dart';
import 'package:flutter/material.dart';

import 'http/bytedesk_user_api.dart';
import 'stomp/bytedesk_stomp.dart';
import 'ui/chat/page/chat_webview_page.dart';
import 'ui/chat/provider/chat_kf_provider.dart';
import 'util/bytedesk_constants.dart';

class BytedeskKefu {
  //
  Future<String?> getPlatformVersion() {
    return BytedeskKefuPlatform.instance.getPlatformVersion();
  }

  // 下面为 自定义接口
  static void init(String orgUid) async {
    /// sp初始化
    await SpUtil.getInstance();
    // 
    String uid = SpUtil.getString(BytedeskConstants.VISITOR_UID)!;
    String nickname = SpUtil.getString(BytedeskConstants.VISITOR_NICKNAME)!;
    String avatar = SpUtil.getString(BytedeskConstants.VISITOR_AVATAR)!;
    // initWithUid(orgUid, uid);
    await BytedeskUserHttpApi().init(orgUid, uid, nickname, avatar);
    // 
    connect();
  }

  // 支持自定义用户名，方便跟APP业务系统对接
  static void initWithUid(String orgUid, String uid) async {
    /// sp初始化
    await SpUtil.getInstance();
    // 
    SpUtil.putString(BytedeskConstants.VISITOR_UID, uid);
    String nickname = SpUtil.getString(BytedeskConstants.VISITOR_NICKNAME)!;
    String avatar = SpUtil.getString(BytedeskConstants.VISITOR_AVATAR)!;
    // initWithUidAndNickname(orgUid, uid, "");
    await BytedeskUserHttpApi().init(orgUid, uid, nickname, avatar);
    // 
    connect();
  }

  static void initWithUidAndNickname(String orgUid, String uid, String nickname) async {

    String avatar = SpUtil.getString(BytedeskConstants.VISITOR_AVATAR)!;
    // initWithUidAndNicknameAndAvatar(orgUid, uid, nickname, "");
    await BytedeskUserHttpApi().init(orgUid, uid, nickname, avatar);
    // 
    connect();
  }

  static void initWithUidAndNicknameAndAvatar(String orgUid, String uid, String nickname, String avatar) async {
    
    await BytedeskUserHttpApi().init(orgUid, uid, nickname, avatar);
    // 
    connect();
  }

  // 建立长连接
  static void connect() {
    // return BytedeskMqtt().connect();
    return BytedeskStomp().connect();
  }

  // 重连
  // static bool reconnect() {
  //   return BytedeskUtils.mqttReConnect();
  // }

  // 断开
  static void disconnect() {
    // BytedeskUtils.mqttDisconnect();
    return BytedeskStomp().disconnect();
  }

  // 判断长连接状态
  static bool isConnected() {
    // return BytedeskUtils.isMqttConnected();
    return BytedeskStomp().isConnected();
  }

  // 技能组客服会话
  static void startWorkGroupChat(BuildContext context, String uid, String title) {
    startChatDefault(context, uid, '1', title);
  }

  // static void startWorkGroupChatV2Robot(
  //     BuildContext context, String wid, String title) {
  //   startChatDefault(
  //       context, wid, BytedeskConstants.CHAT_TYPE_WORKGROUP, title, true);
  // }

  // // 发送附言消息
  // static void startWorkGroupChatPostscript(
  //     BuildContext context, String wid, String title, String postScript) {
  //   startChat(context, wid, BytedeskConstants.CHAT_TYPE_WORKGROUP, title, '',
  //       postScript, false, null);
  // }

  // // 电商接口，携带商品参数
  // // type/title/content/price/url/imageUrl/id/categoryCode
  // static void startWorkGroupChatShop(
  //     BuildContext context, String wid, String title, String commodity) {
  //   startChatShop(context, wid, BytedeskConstants.CHAT_TYPE_WORKGROUP, title,
  //       commodity, null);
  // }

  // static void startWorkGroupChatShopCallback(BuildContext context, String wid,
  //     String title, String commodity, ValueSetter<String> customCallback) {
  //   startChatShop(context, wid, BytedeskConstants.CHAT_TYPE_WORKGROUP, title,
  //       commodity, customCallback);
  // }

  // 指定客服会话
  static void startAppointedChat(BuildContext context, String uid, String title) {
    startChatDefault(context, uid, '0', title);
  }

  // // 发送附言消息
  // static void startAppointedChatPostscript(
  //     BuildContext context, String uid, String title, String postScript) {
  //   startChat(context, uid, BytedeskConstants.CHAT_TYPE_APPOINTED, title, '',
  //       postScript, false, null);
  // }

  // // 电商接口，携带商品参数
  // static void startAppointedChatShop(
  //     BuildContext context, String uid, String title, String commodity) {
  //   startChatShop(context, uid, BytedeskConstants.CHAT_TYPE_APPOINTED, title,
  //       commodity, null);
  // }

  // static void startAppointedChatShopCallback(BuildContext context, String uid,
  //     String title, String commodity, ValueSetter<String> customCallback) {
  //   startChatShop(context, uid, BytedeskConstants.CHAT_TYPE_APPOINTED, title,
  //       commodity, customCallback);
  // }

  // 默认设置商品信息和附言为空
  static void startChatDefault(BuildContext context, String uuid, String type, String title) {
    startChat(context, uuid, type, title, '', '', null);
  }

  // // 电商对话-自定义类型(技能组、指定客服)
  // static void startChatShop(BuildContext context, String uuid, String type,
  //     String title, String commodity, ValueSetter<String>? customCallback) {
  //   startChat(context, uuid, type, title, commodity, '', false, customCallback);
  // }

  // // 发送附言消息-自定义类型(技能组、指定客服)
  // static void startChatPostscript(BuildContext context, String uuid,
  //     String type, String title, String postScript) {
  //   startChat(context, uuid, type, title, '', postScript, false, null);
  // }

  // 客服会话-自定义类型(技能组、指定客服)
  static void startChat(
      BuildContext context,
      String uuid,
      String type,
      String title,
      String commodity,
      String postScript,
      ValueSetter<String>? customCallback) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ChatKFProvider(
        sid: uuid,
        type: type,
        title: title,
        custom: commodity,
        postscript: postScript,
        customCallback: customCallback,
      );
    }));
  }

  // // 从历史会话或者点击通知栏进入
  // static void startChatThread(BuildContext context, Thread thread,
  //     {String title = ''}) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return ChatThreadProvider(
  //       thread: thread,
  //       title: title,
  //     );
  //   }));
  // }

  // 应用内打开H5客服页面
  static void startH5Chat(BuildContext context, String url, String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ChatWebViewPage(
        url: url,
        title: title,
      );
    }));
  }

  // 应用内打开网页
  static void openWebView(BuildContext context, String url, String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ChatWebViewPage(
        url: url,
        title: title,
      );
    }));
  }

  // TODO: 好友一对一聊天
  // static void startContactChat(BuildContext context, String cid, String title) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return ChatIMProvider(
  //       // cid: cid,
  //       title: title,
  //     );
  //   }));
  // }

  // TODO: 好友一对一，携带商品参数
  // static void startContactChatShop(
  //     BuildContext context, String cid, String title, String commodity) {
  //   Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
  //     return new ChatIMProvider(
  //       // cid: cid,
  //       title: title,
  //       custom: commodity,
  //     );
  //   }));
  // }

  // TODO: 客服端-进入接待访客对话页面
  // static void startChatThreadIM(BuildContext context, Thread thread) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return ChatIMProvider(
  //       thread: thread,
  //       isThread: true,
  //     );
  //   }));
  // }

  // // 常见问题列表
  // static void showFaq(BuildContext context, String uid, String title) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return HelpProvider(
  //       uid: uid,
  //       title: title,
  //     );
  //   }));
  // }

  // // 意见反馈
  // static void showFeedback(BuildContext context, String uid) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return FeedbackProvider(uid: uid);
  //   }));
  // }

  // // TODO: 提交工单
  // static void showTicket(BuildContext context, String uid) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return TicketProvider(uid: uid);
  //   }));
  // }

  // static void showWorkGroupLeaveMessage(
  //     BuildContext context, String wid, String tip) {
  //   showLeaveMessage(
  //       context, wid, wid, BytedeskConstants.CHAT_TYPE_WORKGROUP, tip);
  // }

  // static void showAppointedLeaveMessage(
  //     BuildContext context, String aid, String tip) {
  //   showLeaveMessage(
  //       context, aid, aid, BytedeskConstants.CHAT_TYPE_APPOINTED, tip);
  // }

  // // 留言
  // static void showLeaveMessage(
  //     BuildContext context, String wid, String aid, String type, String tip) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return LeaveMsgProvider(
  //       wid: wid,
  //       aid: aid,
  //       type: type,
  //       tip: tip,
  //     );
  //   }));
  // }

  // // 留言历史
  // static void showLeaveMessageHistory(
  //     BuildContext context, String wid, String aid, String type) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return LeaveMsgHistoryProvider(
  //       wid: wid,
  //       aid: aid,
  //       type: type,
  //     );
  //   }));
  // }

  // TODO: 提交工单
  // 频道消息
  // static void showChannel(BuildContext context, Thread thread) {
  //   Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
  //     return new ChannelProvider(
  //       thread: thread,
  //     );
  //   }));
  // }

  // 访客历史会话
  // static Future<List<Thread>> getVisitorThreads(int page, int size) async {
  //   return BytedeskThreadHttpApi().getVisitorThreads(page, size);
  // }

  // // 消息提示设置
  // static bool? getPlayAudioOnSendMessage() {
  //   return SpUtil.getBool(BytedeskConstants.PLAY_AUDIO_ON_SEND_MESSAGE,
  //       defValue: true);
  // }

  // static void setPlayAudioOnSendMessage(bool flag) {
  //   SpUtil.putBool(BytedeskConstants.PLAY_AUDIO_ON_SEND_MESSAGE, flag);
  // }

  // static bool? getPlayAudioOnReceiveMessage() {
  //   return SpUtil.getBool(BytedeskConstants.PLAY_AUDIO_ON_RECEIVE_MESSAGE,
  //       defValue: true);
  // }

  // static void setPlayAudioOnReceiveMessage(bool flag) {
  //   SpUtil.putBool(BytedeskConstants.PLAY_AUDIO_ON_RECEIVE_MESSAGE, flag);
  // }

  // static bool? getVibrateOnReceiveMessage() {
  //   return SpUtil.getBool(BytedeskConstants.VIBRATE_ON_RECEIVE_MESSAGE,
  //       defValue: true);
  // }

  // static void setVibrateOnReceiveMessage(bool flag) {
  //   SpUtil.putBool(BytedeskConstants.VIBRATE_ON_RECEIVE_MESSAGE, flag);
  // }

  // // 上传ios devicetoken
  // static Future<void> uploadIOSDeviceToken(
  //     String appkey, String deviceToken) async {
  //   BytedeskDeviceHttpApi()
  //       .updateIOSDeviceToken(appkey, BytedeskConstants.build, deviceToken);
  // }

  // build的值只有两种情况，测试设置为：debug 或 线上设置为：release
  // static Future<void> uploadIOSDeviceToken(
  //     String appkey, String build, String deviceToken) async {
  //   BytedeskDeviceHttpApi().updateIOSDeviceToken(appkey, build, deviceToken);
  // }

  // build的值只有两种情况，测试设置为：debug 或 线上设置为：release
  // static Future<void> deleteIOSDeviceToken(String build) async {
  //   BytedeskDeviceHttpApi().deleteIOSDeviceToken(build);
  // }

  // The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  static Future<String> getAppVersion() {
    return BytedeskDeviceHttpApi().getAppVersion();
  }

  // The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  static Future<String> getAppBuildNumber() {
    return BytedeskDeviceHttpApi().getAppBuildNumber();
  }

  // 从服务器检测当前APP是否有新版
  // static Future<App> checkAppVersion(String androidKey, String iosKey) {
  //   if (BytedeskUtils.isWeb) {
  //     // FIXME: 仅用于占位，待修改
  //     return BytedeskUserHttpApi().checkAppVersion(iosKey);
  //   } else if (BytedeskUtils.isAndroid) {
  //     return BytedeskUserHttpApi().checkAppVersion(androidKey);
  //   }
  //   return BytedeskUserHttpApi().checkAppVersion(iosKey);
  // }

  // // 从服务器检测当前APP是否有新版
  // static Future<App> checkAppVersion2(String flutterKey) {
  //   return BytedeskUserHttpApi().checkAppVersion(flutterKey);
  // }

  // // 退出登录
  // static Future<void> logout() {
  //   // 断开长链接
  //   disconnect();
  //   BytedeskUtils.clearUserCache();
  //   // 通知服务器，并清空本地数据
  //   return BytedeskUserHttpApi().logout();
  // }
}
