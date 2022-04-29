import 'dart:async';
// import 'dart:io';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// import 'package:bytedesk_kefu/http/bytedesk_device_api.dart';
// import 'package:bytedesk_kefu/http/bytedesk_thread_api.dart';
// import 'package:bytedesk_kefu/model/app.dart';
// import 'package:bytedesk_kefu/model/jsonResult.dart';
// import 'package:bytedesk_kefu/model/thread.dart';
// import 'package:bytedesk_kefu/model/userJsonResult.dart';
// import 'package:bytedesk_kefu/model/wechatResult.dart';
// import 'package:bytedesk_kefu/ui/channel/provider/channel_provider.dart';
// import 'package:bytedesk_kefu/ui/chat/page/chat_webview_page.dart';
// import 'package:bytedesk_kefu/ui/chat/provider/chat_im_provider.dart';
// import 'package:bytedesk_kefu/ui/chat/provider/chat_thread_provider.dart';
// import 'package:bytedesk_kefu/ui/faq/provider/help_provider.dart';
// import 'package:bytedesk_kefu/ui/feedback/provider/feedback_provider.dart';
// import 'package:bytedesk_kefu/ui/leavemsg/provider/leavemsg_provider.dart';
// import 'package:bytedesk_kefu/ui/ticket/provider/ticket_provider.dart';
// import 'package:flutter/services.dart';

// import 'package:bytedesk_kefu/http/bytedesk_user_api.dart';
// import 'package:bytedesk_kefu/ui/chat/provider/chat_kf_provider.dart';
// import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
// import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
// import 'package:flutter/material.dart';

// import 'model/user.dart';

/// A web implementation of the BytedeskKefu plugin.
class BytedeskKefuWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'bytedesk_kefu',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = BytedeskKefuWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
        // break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'bytedesk_kefu for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }
}
