// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu_example/example.dart';
import 'package:get/get.dart';
// import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';

import 'l10n/translations.dart';
// import 'package:vibration/vibration.dart';
// import 'package:audioplayers/audioplayers.dart';

void main() {
  // runApp(const OverlaySupport(child: MyApp()));
  runApp(const MyApp());

  // 第二步：初始化
  // 获取企业uid，登录后台->客服->渠道->flutter
  // http://www.weiyuai.cn/admin/cs/channel
  String orgUid = "df_org_uid";
  // 第一步：初始化
  BytedeskKefu.init(orgUid);
  // 注：如果需要多平台统一用户（用于同步聊天记录等），可使用:
  // BytedeskKefu.initWithUidAndNicknameAndAvatar(orgUid, 'myflutteruid', '我是美女', 'https://bytedesk.oss-cn-shenzhen.aliyuncs.com/avatars/girl.png');
  // BytedeskKefu.initWithUid(orgUid, 'myflutteruid'); // 其中：uid为自定义uid，可与开发者所在用户系统对接，用于多用户切换
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const _mobileWidthThreshold = 500;
  static const _mobileWidth = 420.0;
  static const _mobileHeight = 900.0;
  final _appKey = GlobalKey();
  bool _hasFrame = false;
  bool get _checkSize => BytedeskUtils.isWeb;
  bool _mobileStyle = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: _appKey,
      debugShowCheckedModeBanner: false, // 去除右上角debug的标签
      home: const ExamplePage(),
      translations: AppTranslations(),
      supportedLocales: AppTranslations.supportedLocales,
      locale: AppTranslations.fallbackLocale,
      fallbackLocale: AppTranslations.fallbackLocale,
      localizationsDelegates: AppTranslations.localizationsDelegates,
      builder: (context, widget) {
        if (_checkSize) {
          final size = Get.size;
          final hasFrame = size.width > _mobileWidthThreshold;
          if (hasFrame) {
            return _buildFrame(widget!);
          }
        }
        return widget!;
      },
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   debugPrint("main didChangeAppLifecycleState:" + state.toString());
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
  void didChangeMetrics() {
    if (_checkSize) {
      final size = Get.size;
      final hasFrame = size.width > _mobileWidthThreshold;
      if (_hasFrame != hasFrame) {
        setState(() {
          _hasFrame = hasFrame;
        });
      }
    }
  }

  // 主要用于在web端调试，右上角添加一个按钮，切换宽窄页面
  Widget _buildFrame(Widget app) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        body: _mobileStyle
            ? Center(
                child: Card(
                  elevation: 10,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    height: _mobileHeight,
                    width: _mobileWidth,
                    child: app,
                  ),
                ),
              )
            : app,
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _mobileStyle = !_mobileStyle;
            });
          },
          child: Icon(_mobileStyle ? Icons.computer : Icons.phone_android),
        ).marginOnly(top: 16),
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    // audioCache?
  }
}
