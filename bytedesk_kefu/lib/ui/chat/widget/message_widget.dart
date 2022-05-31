import 'dart:convert';

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/model/message.dart';
import 'package:bytedesk_kefu/ui/chat/page/video_play_page.dart';
import 'package:bytedesk_kefu/ui/widget/bubble.dart';
import 'package:bytedesk_kefu/ui/widget/bubble_menu.dart';
import 'package:bytedesk_kefu/ui/widget/photo_view_wrapper.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';

// 系统消息居中显示
class MessageWidget extends StatelessWidget {
  //
  final Message? message;
  final themeColor = Color(0xfff5a623);
  final primaryColor = Color(0xff203152);
  final greyColor = Color(0xffaeaeae);
  final greyColor2 = Color(0xffE8E8E8);

  final ValueSetter<String>? customCallback;
  final AnimationController? animationController;

  MessageWidget({this.message, this.customCallback, this.animationController});

  @override
  Widget build(BuildContext context) {
    // 头像组件
    return message!.isSend == 1
        ? _buildSendWidget(context)
        : _buildReceiveWidget(context);
  }

  // 发送消息widget
  Widget _buildSendWidget(BuildContext context) {
    double tWidth = MediaQuery.of(context).size.width - 160;
    // FIXME: 消息状态，待完善
    String status = '';
    if (message!.status == BytedeskConstants.MESSAGE_STATUS_SENDING) {
      status = '发送中';
    } else if (message!.status == BytedeskConstants.MESSAGE_STATUS_STORED) {
      status = ''; // 发送成功
    } else if (message!.status == BytedeskConstants.MESSAGE_STATUS_RECEIVED) {
      status = '送达';
    } else if (message!.status == BytedeskConstants.MESSAGE_STATUS_READ) {
      status = '已读';
    } else if (message!.status == BytedeskConstants.MESSAGE_STATUS_ERROR) {
      status = '失败';
    }
    return Container(
        margin: EdgeInsets.only(top: 8.0, left: 8.0),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // 时间戳
            _buildTimestampWidget(),
            // 消息内容
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Expanded(flex: 1, child: Container()),
                    Text(
                      status,
                      style: TextStyle(fontSize: 10),
                    ),
                    Container(
                      width: 5,
                    ),
                    Column(
                      // Column被Expanded包裹起来，使其内部文本可自动换行
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        // FIXME: 升级2.12兼容null-safty之后，无法显示长按气泡
                        FLBubble(
                            from: FLBubbleFrom.right,
                            backgroundColor: Color.fromRGBO(160, 231, 90, 1),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: tWidth),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 2),
                              child: _buildSendMenuWidget(context, message!),
                            )),
                      ],
                    )
                  ],
                )),
                // 头像
                _buildAvatarWidget()
              ],
            ),
          ],
        ));
  }

  // 点击消息体菜单
  Widget _buildSendMenuWidget(BuildContext context, Message message) {
    return FLBubbleMenuWidget(
      interaction: FLBubbleMenuInteraction.tap,
      child: _buildSendContent(context, message),
      itemBuilder: (BuildContext context) {
        return [
          FLBubbleMenuItem(
            text: '复制',
            value: 'copy',
          ),
          FLBubbleMenuItem(
            text: '删除',
            value: 'delete',
          ),
          // TODO: 消息撤回
          // FLBubbleMenuItem(
          //   text: '撤回',
          //   value: 'recall',
          // ),
          // TODO: 回复此条消息
        ];
      },
      onSelected: (value) {
        BytedeskUtils.printLog('send menu $value');
        // 删除消息
        if (value == 'copy') {
          /// 把文本复制进入粘贴板
          if (message.type == BytedeskConstants.MESSAGE_TYPE_TEXT) {
            Clipboard.setData(ClipboardData(text: message.content));
          } else if (message.type == BytedeskConstants.MESSAGE_TYPE_IMAGE) {
            Clipboard.setData(ClipboardData(text: message.imageUrl));
          } else {
            Clipboard.setData(ClipboardData(text: message.content));
          }
          // Toast
          Fluttertoast.showToast(
              msg: '复制成功',
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 30,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (value == 'delete') {
          bytedeskEventBus.fire(DeleteMessageEventBus(message.mid!));
        } else if (value == 'recall') {
          // TODO: 消息撤回, 限制在5分钟之内允许撤回
        }
      },
      onCancelled: () {
        // BytedeskUtils.printLog('cancel');
      },
    );
  }

  // 发送消息体
  Widget _buildSendContent(BuildContext context, Message message) {
    //
    if (message.type == BytedeskConstants.MESSAGE_TYPE_TEXT) {
      return Text(
        message.content ?? '',
        textAlign: TextAlign.right,
        softWrap: true,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_IMAGE) {
      return InkWell(
        onTap: () {
          // 支持将图片保存到相册
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoViewWrapper(
                imageUrl: message.imageUrl!,
                imageProvider: NetworkImage(
                  message.imageUrl!,
                ),
                loadingBuilder: (context, event) {
                  if (event == null) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  }
                  final value =
                      event.cumulativeBytesLoaded / event.expectedTotalBytes!;
                  final percentage = (100 * value).floor();
                  return Center(
                    child: Text("$percentage%"),
                  );
                },
              ),
            ),
          );
        },
        child: SizedBox(
          width: 100,
          child: CachedNetworkImage(
            imageUrl: message.imageUrl!,
            // placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_COMMODITY) {
      // 商品信息, TODO: add send button
      final commodityJson = json.decode(message.content!);
      String title = commodityJson['title'].toString();
      String content = commodityJson['content'].toString();
      String price = commodityJson['price'].toString();
      String imageUrl = commodityJson['imageUrl'].toString();
      return InkWell(
        onTap: () {
          // BytedeskUtils.printLog('message!.type ${message!.type}, message!.content ${message!.content}');
          if (customCallback != null) {
            customCallback!(message.content!);
          } else {
            BytedeskUtils.printLog('customCallback is null');
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 90.0,
              height: 90.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
            // Gaps.hGap8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Gaps.vGap10,
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 8),
                    child: Text(
                      '¥$price',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 8),
                    child: Text(
                      '$content',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  // Gaps.vGap4,
                ],
              ),
            ),
          ],
        ),
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_VIDEO) {
      return InkWell(
        onTap: () {
          BytedeskUtils.printLog('play video');
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new VideoPlayPage(videoUrl: message.videoUrl);
          }));
        },
        child: SizedBox(
          width: 100,
          height: 100,
          child: CachedNetworkImage(
            imageUrl: BytedeskConstants.VIDEO_PLAY,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    } else {
      return Text(
        message.content ?? '',
        textAlign: TextAlign.right,
        softWrap: true,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      );
    }
  }

  // 接收消息widget
  Widget _buildReceiveWidget(BuildContext context) {
    double tWidth = MediaQuery.of(context).size.width - 160;
    return new Container(
        margin: EdgeInsets.only(top: 8.0, right: 8.0),
        padding: EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          // 时间戳
          _buildTimestampWidget(),
          // 消息
          (message!.type!.startsWith(
                      BytedeskConstants.MESSAGE_TYPE_NOTIFICATION) &&
                  message!.type !=
                      BytedeskConstants.MESSAGE_TYPE_NOTIFICATION_THREAD &&
                  message!.type !=
                      BytedeskConstants.MESSAGE_TYPE_NOTIFICATION_PREVIEW)
              ? _buildSystemMessageWidget()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 头像
                    _buildAvatarWidget(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 昵称
                        Container(
                          // color: Colors.grey,
                          margin: EdgeInsets.only(left: 18, bottom: 2),
                          child: Text(
                            message!.nickname!,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        // FIXME: 升级2.12兼容null-safty之后，无法显示长按气泡
                        FLBubble(
                            from: FLBubbleFrom.left,
                            backgroundColor: Colors.white,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: tWidth),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 2),
                              child: _buildReceiveMenuWidget(context, message!),
                            ))
                      ],
                    )
                  ],
                ),
        ]));
  }

  // 点击消息体菜单
  Widget _buildReceiveMenuWidget(BuildContext context, Message message) {
    return FLBubbleMenuWidget(
      interaction: FLBubbleMenuInteraction.tap,
      child: _buildReceivedContent(context, message),
      itemBuilder: (BuildContext context) {
        return [
          FLBubbleMenuItem(
            text: '复制',
            value: 'copy',
          ),
          FLBubbleMenuItem(
            text: '删除',
            value: 'delete',
          ),
          // TODO: 消息回复
        ];
      },
      onSelected: (value) {
        BytedeskUtils.printLog('send menu $value');
        // 删除消息
        if (value == 'copy') {
          /// 把文本复制进入粘贴板
          if (message.type == BytedeskConstants.MESSAGE_TYPE_TEXT) {
            Clipboard.setData(ClipboardData(text: message.content));
          } else if (message.type == BytedeskConstants.MESSAGE_TYPE_IMAGE) {
            Clipboard.setData(ClipboardData(text: message.imageUrl));
          } else {
            Clipboard.setData(ClipboardData(text: message.content));
          }
          // Toast
          Fluttertoast.showToast(
              msg: '复制成功',
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 30,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (value == 'delete') {
          bytedeskEventBus.fire(DeleteMessageEventBus(message.mid!));
        }
      },
      onCancelled: () {
        // BytedeskUtils.printLog('cancel');
      },
    );
  }

  // 接收消息体
  Widget _buildReceivedContent(BuildContext context, Message message) {
    //
    if (message.type == BytedeskConstants.MESSAGE_TYPE_TEXT) {
      return Text(
        message.content ?? '',
        textAlign: TextAlign.left,
        softWrap: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_IMAGE) {
      return InkWell(
        onTap: () {
          // 支持将图片保存到相册
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoViewWrapper(
                imageUrl: message.imageUrl!,
                imageProvider: NetworkImage(
                  message.imageUrl!,
                ),
                loadingBuilder: (context, event) {
                  if (event == null) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  }
                  final value =
                      event.cumulativeBytesLoaded / event.expectedTotalBytes!;
                  final percentage = (100 * value).floor();
                  return Center(
                    child: Text("$percentage%"),
                  );
                },
              ),
            ),
          );
        },
        child: SizedBox(
          width: 100,
          child: CachedNetworkImage(
            imageUrl: message.imageUrl!,
            // placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_ROBOT) {
      return Column(
        children: <Widget>[
          // Text(
          //   message.content ?? '',
          //   textAlign: TextAlign.left,
          //   softWrap: true,
          //   style: TextStyle(color: Colors.black, fontSize: 16.0),
          // ),
          Visibility(
            visible: message.content != null && message.content!.length > 0,
            child: Html(
              data: message.content ?? '',
              onLinkTap: (url, _, __, ___) {
                // 打开url
                BytedeskKefu.openWebView(context, url!, '网页');
              },
              onImageTap: (src, _, __, ___) {
                // 查看大图
                // BytedeskUtils.printLog("open image $src");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewWrapper(
                      imageUrl: message.imageUrl!,
                      imageProvider: NetworkImage(
                        src!,
                      ),
                      loadingBuilder: (context, event) {
                        if (event == null) {
                          return const Center(
                            child: Text("Loading"),
                          );
                        }
                        final value = event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!;
                        final percentage = (100 * value).floor();
                        return Center(
                          child: Text("$percentage%"),
                        );
                      },
                    ),
                  ),
                );
              },
              onImageError: (exception, stackTrace) {
                BytedeskUtils.printLog(exception);
              },
            ),
          ),
          Visibility(
              visible: message.answers != null && message.answers!.length > 0,
              // visible: false,
              child: Container(
                // color: Colors.black,
                child: ListView.builder(
                  // 如果滚动视图在滚动方向无界约束，那么shrinkWrap必须为true
                  shrinkWrap: true,
                  // 禁用ListView滑动，使用外层的ScrollView滑动
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  itemCount:
                      message.answers == null ? 0 : message.answers!.length,
                  itemBuilder: (_, index) {
                    //
                    var answer = message.answers![index];
                    // return Text(answer.question!);
                    return DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: Divider.createBorderSide(context, width: 0.8),
                        )),
                        child: Container(
                          margin: EdgeInsets.only(top: 6, left: 8, bottom: 8),
                          // color: Colors.pink,
                          child: InkWell(
                              child: Text(
                                answer.question!,
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () => {
                                    // BytedeskUtils.printLog('object:' + answer.question),
                                    bytedeskEventBus.fire(QueryAnswerEventBus(
                                        answer.aid!,
                                        answer.question!,
                                        answer.answer!))
                                  }),
                        ));
                  },
                ),
              )),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Row(
              children: [
                Text('没有找到答案？'),
                GestureDetector(
                  child: Text(
                    '人工客服',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onTap: () {
                    BytedeskUtils.printLog('请求人工客服');
                    bytedeskEventBus.fire(RequestAgentThreadEventBus());
                  },
                )
              ],
            ),
          )
        ],
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_ROBOT_V2) {
      return Column(
        children: <Widget>[
          Text(
            message.content ?? '',
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          Visibility(
              visible:
                  message.categories != null && message.categories!.length > 0,
              // visible: false,
              child: Container(
                // color: Colors.black,
                child: ListView.builder(
                  // 如果滚动视图在滚动方向无界约束，那么shrinkWrap必须为true
                  shrinkWrap: true,
                  // 禁用ListView滑动，使用外层的ScrollView滑动
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  itemCount: message.categories == null
                      ? 0
                      : message.categories!.length,
                  itemBuilder: (_, index) {
                    //
                    var category = message.categories![index];
                    // return Text(answer.question!);
                    return DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: Divider.createBorderSide(context, width: 0.8),
                        )),
                        child: Container(
                          margin: EdgeInsets.only(top: 6, left: 8, bottom: 8),
                          // color: Colors.pink,
                          child: InkWell(
                              child: Text(
                                category.name!,
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () => {
                                    // BytedeskUtils.printLog(category.name),
                                    bytedeskEventBus.fire(QueryCategoryEventBus(
                                        category.cid!, category.name!))
                                  }),
                        ));
                  },
                ),
              )),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Row(
              children: [
                Text('没有找到答案？'),
                GestureDetector(
                  child: Text(
                    '人工客服',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onTap: () {
                    BytedeskUtils.printLog('请求人工客服');
                    bytedeskEventBus.fire(RequestAgentThreadEventBus());
                  },
                )
              ],
            ),
          )
        ],
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_ROBOT_RESULT) {
      return Text(
        message.content ?? '',
        textAlign: TextAlign.left,
        softWrap: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_COMMODITY) {
      // 商品信息, TODO: add send button
      final commodityJson = json.decode(message.content!);
      String title = commodityJson['title'].toString();
      String content = commodityJson['content'].toString();
      String price = commodityJson['price'].toString();
      String imageUrl = commodityJson['imageUrl'].toString();
      return InkWell(
        onTap: () {
          // BytedeskUtils.printLog('message!.type ${message!.type}, message!.content ${message!.content}');
          if (customCallback != null) {
            customCallback!(message.content!);
          } else {
            BytedeskUtils.printLog('customCallback is null');
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 90.0,
              height: 90.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
            // Gaps.hGap8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Gaps.vGap10,
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 8),
                    child: Text(
                      '¥$price',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 8),
                    child: Text(
                      '$content',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  // Gaps.vGap4,
                ],
              ),
            ),
          ],
        ),
      );
    } else if (message.type == BytedeskConstants.MESSAGE_TYPE_VIDEO) {
      return InkWell(
        onTap: () {
          BytedeskUtils.printLog('play video');
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new VideoPlayPage(videoUrl: message.videoUrl);
          }));
        },
        child: SizedBox(
          width: 100,
          height: 100,
          child: CachedNetworkImage(
            imageUrl: BytedeskConstants.VIDEO_PLAY,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    } else {
      return Text(
        message.content ?? '',
        textAlign: TextAlign.left,
        softWrap: true,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      );
    }
  }

  // 时间戳
  Widget _buildTimestampWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 5, top: 5),
          child: Text(
            message!.timestamp ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.0),
          ),
        )
      ],
    );
  }

  // 系统消息居中显示
  Widget _buildSystemMessageWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 5, top: 5),
          child: Text(
            message!.content ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.0),
          ),
        )
      ],
    );
  }

  // 头像
  Widget _buildAvatarWidget() {
    return SizedBox(
      width: 35,
      height: 35,
      child: CachedNetworkImage(
        imageUrl: message!.avatar!,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
