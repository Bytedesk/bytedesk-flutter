import 'dart:async';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// TODO: 支持右上角在其他浏览器打开
class ChatWebViewPage extends StatefulWidget {
  const ChatWebViewPage({
    Key? key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  final String? title;
  final String? url;

  @override
  _ChatWebViewPageState createState() => _ChatWebViewPageState();
}

class _ChatWebViewPageState extends State<ChatWebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              if (snapshot.hasData) {
                var canGoBack = await snapshot.data!.canGoBack();
                if (canGoBack) {
                  // 网页可以返回时，优先返回上一页
                  await snapshot.data!.goBack();
                  return Future.value(false);
                }
              }
              return Future.value(true);
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.title!),
                  elevation: 0,
                  actions: [
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Container(
                    //       padding: new EdgeInsets.only(right: 10),
                    //       child: InkWell(
                    //           onTap: () {
                    //             BytedeskUtils.printLog('share');
                    //             // showShareSheet(context);
                    //           },
                    //           child: Image.asset(
                    //             // 'assets/images/weibo/icon_more.png',
                    //             'assets/images/weibo/video_detail_share.png',
                    //             width: 23.0,
                    //             height: 23.0,
                    //           )))),
                  ],
                ),
                body: WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                )),
          );
        });
  }

  // void showShareSheet(BuildContext context) {
  //   showFLBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return FLCupertinoOperationSheet(
  //           sheetStyle: FLCupertinoActionSheetStyle.filled,
  //           cancelButton: CupertinoActionSheetAction(
  //             child: Text(
  //               '取消',
  //             ),
  //             isDefaultAction: true,
  //             onPressed: () {
  //               Navigator.pop(context, 'cancel');
  //             },
  //           ),
  //           header: Container(
  //             padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
  //             child: Text('分享', style: TextStyle(fontSize: 18)),
  //           ),
  //           itemList: [
  //             [
  //               FLCupertinoOperationSheetItem(
  //                 imagePath: 'assets/images/circle/weibo.png',
  //                 title: '复制链接', // TODO
  //                 onPressed: () {
  //                   Navigator.pop(context, 'weibo');
  //                 },
  //               ),
  //               FLCupertinoOperationSheetItem(
  //                 imagePath: 'assets/images/circle/weibo.png',
  //                 title: '浏览器打开', // TODO
  //                 onPressed: () {
  //                   Navigator.pop(context, 'weibo');
  //                 },
  //               ),
  //               FLCupertinoOperationSheetItem(
  //                 imagePath: 'assets/images/circle/weibo.png',
  //                 title: '刷新', // TODO
  //                 onPressed: () {
  //                   Navigator.pop(context, 'weibo');
  //                 },
  //               ),
  //             ],
  //           ],
  //         );
  //       }).then((value) {
  //     //
  //     BytedeskUtils.printLog('share $value');
  //     if (value == 'wechat') {
  //       // TODO: 分享到微信
  //     } else if (value == 'weibo') {
  //       // TODO: 分享到微博
  //     }
  //   });
  // }
}
