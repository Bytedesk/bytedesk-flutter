import 'dart:async';
// import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_webview_pro/webview_flutter.dart';
// import 'package:path_provider/path_provider.dart';

// TODO: 支持访问相册发送图片
// TODO: 支持右上角在其他浏览器打开
class ChatWebViewPage extends StatefulWidget {
  const ChatWebViewPage({
    Key? key,
    @required this.title,
    @required this.url, 
    // this.cookieManager
  }) : super(key: key);

  final String? title;
  final String? url;
  // final CookieManager? cookieManager;

  @override
  _ChatWebViewPageState createState() => _ChatWebViewPageState();
}

class _ChatWebViewPageState extends State<ChatWebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          elevation: 0,
          actions: const [
            // NavigationControls(_controller.future),
            // SampleMenu(_controller.future, widget.cookieManager),
          ],
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            // if (request.url.startsWith('')) {
            //   debugPrint('blocking navigation to $request}');
            //   return NavigationDecision.prevent;
            // }
            debugPrint('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          // geolocationEnabled: false,//support geolocation or not
        ));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

}
