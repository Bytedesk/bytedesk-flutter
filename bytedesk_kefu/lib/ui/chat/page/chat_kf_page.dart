// ignore_for_file: use_build_context_synchronously, use_full_hex_values_for_flutter_colors

import 'dart:async';
import 'dart:typed_data';
// import 'dart:io';

import 'package:bytedesk_kefu/blocs/message_bloc/bloc.dart';
import 'package:bytedesk_kefu/blocs/thread_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/model.dart';
import 'package:bytedesk_kefu/stomp/bytedesk_stomp.dart';
import 'package:bytedesk_kefu/ui/chat/widget/message_widget.dart';
import 'package:bytedesk_kefu/ui/widget/expanded_viewport.dart';
// import 'package:bytedesk_kefu/ui/widget/image_choose_widget.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu/util/bytedesk_uuid.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:sp_util/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_video_compress/flutter_video_compress.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:bytedesk_kefu/ui/widget/chat_input.dart';
import 'package:bytedesk_kefu/ui/widget/extra_item.dart';

import '../../../model/message_provider.dart';
import '../../../model/thread_protobuf.dart';
import '../../widget/send_button_visibility_mode.dart';
// import '../../../model/thread.dart';
// import 'package:bytedesk_kefu/ui/widget/send_button_visibility_mode.dart';
// import 'package:bytedesk_kefu/ui/widget/voice_record/voice_widget.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// TODO: 接通客服之前，在title显示loading
// 客服关闭会话，或者 自动关闭会话，则禁止继续发送消息
// 点击商品信息，回调接口-进入商品详情页面
// TODO: 右上角增加按钮回调入口，支持用户自定义按钮，进入店铺/学校详情页面
// TODO: 增加是否显示历史记录参数
// 系统消息居中显示
class ChatKFPage extends StatefulWidget {
  //
  final String? sid;
  final String? type;
  final String? title;
  final String? custom;
  final String? postscript;
  // 从历史会话或者点击通知栏进入
  // final bool? isThread;
  // final Thread? thread;
  final ValueSetter<String>? customCallback;
  //
  const ChatKFPage(
      {super.key,
      this.sid,
      this.type,
      this.title,
      this.custom,
      this.postscript,
      // this.isThread,
      // this.thread,
      this.customCallback});
  //
  @override
  State<ChatKFPage> createState() => _ChatKFPageState();
}

class _ChatKFPageState extends State<ChatKFPage>
    with
        AutomaticKeepAliveClientMixin<ChatKFPage>,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  //
  String? _title;
  // 下拉刷新
  final RefreshController _refreshController = RefreshController();
  // 输入文字
  final TextEditingController _textController = TextEditingController();
  // 滚动监听
  final ScrollController _scrollController = ScrollController();
  // 聊天记录本地存储
  final MessageProvider _messageProvider = MessageProvider();
  // 聊天记录内存存储
  final List<MessageWidget> _messages = <MessageWidget>[];
  // 图片
  final ImagePicker _picker = ImagePicker();
  // 长连接
  // final BytedeskMqtt _bdMqtt = BytedeskMqtt();
  final BytedeskStomp _bdStomp = BytedeskStomp();
  // 当前用户uid
  final String? _currentUid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
  // final String? _currentUsername = SpUtil.getString(BytedeskConstants.username);
  // final String? _currentNickname = SpUtil.getString(BytedeskConstants.VISITOR_NICKNAME);
  // final String? _currentAvatar = SpUtil.getString(BytedeskConstants.VISITOR_AVATAR);
  // 当前会话
  ThreadProtobuf? _currentThread;
  // User? _robotUser;
  // 判断是否机器人对话状态
  bool _isRobot = false;
  // 分页加载聊天记录
  int _page = 0;
  final int _size = 20;
  // 延迟发送preview消息
  Timer? _debounce;
  // 定时拉取聊天记录
  Timer? _loadHistoryTimer;
  //
  Timer? _resendTimer;
  // 视频压缩
  // final _flutterVideoCompress = FlutterVideoCompress();
  bool _isRequestingThread = true;
  //
  @override
  void initState() {
    // debugPrint('chat_kf_page init');
    // SpUtil.putBool(BytedeskConstants.isCurrentChatKfPage, true);
    // 从历史会话或者顶部通知栏进入
    // if (widget.isThread! && widget.thread != null) {
    //   // _currentThread = widget.thread;
    //   // FIXME: 在访客端-标题显示访客的名字，应该显示客服或技能组名字或固定写死
    //   _title = widget.title!.trim().isNotEmpty
    //       ? widget.title
    //       : widget.thread!.user!.nickname;
    //   // _getMessages(_page, _size);
    // } else {
    // 从请求客服页面进入
    _title = widget.title;
    // }
    WidgetsBinding.instance.addObserver(this);
    // 监听build完成，https://blog.csdn.net/baoolong/article/details/85097318
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   debugPrint('addPostFrameCallback');
    // });
    // Fluttertoast.showToast(msg: "请求中, 请稍后...");
    initListeners();
    super.initState();
    // 定时拉取聊天记录 10s
    _loadHistoryTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      // debugPrint('从服务器 load history');
      //   // TODO: 暂时禁用从服务器加载历史记录
      // BlocProvider.of<MessageBloc>(context)
      //   ..add(LoadHistoryMessageEvent(uid: _currentUid, page: 0, size: 10));
      //   // 每隔 1 秒钟会调用一次，如果要结束调用
      //   // timer.cancel();
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // TODO: 检测-消息是否超时发送失败
      for (var i = 0; i < _messages.length; i++) {
        Message? message = _messages[i].message;
        // 自己发送的 && 消息状态为发送中...
        if (message!.isSend == 1 &&
            message.status == BytedeskConstants.MESSAGE_STATUS_SENDING) {
          var nowTime = DateTime.now();
          var messageTime = DateTime.parse(message.createdAt!);
          int diff = nowTime.difference(messageTime).inSeconds;
          if (diff > 15) {
            // 超时15秒，设置为消息状态为error
            _messageProvider.update(
                message.uid, BytedeskConstants.MESSAGE_STATUS_ERROR);
          } else if (diff > 5) {
            // 5秒没有发送成功，则尝试使用http rest接口发送
            String content = message.content!;
            sendMessage(message.uid!, message.type!, content);
          }
        }
      }
    });
    // BlocProvider.of<MessageBloc>(context)
    //   ..add(LoadUnreadVisitorMessagesEvent(page: 0, size: 10));
    // BytedeskMqtt().connect();
  }

  //
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //
    return Scaffold(
        appBar: AppBar(
          title: Text(_title ?? '请求中, 请稍后...'),
          centerTitle: true,
          elevation: 0,
          actions: [
            // TODO: 评价
            // TODO: 常见问题
            Visibility(
              visible: _isRobot,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      width: 60,
                      child: InkWell(
                        onTap: () {
                          // BlocProvider.of<ThreadBloc>(context).add(
                          //     RequestAgentEvent(
                          //         wid: widget.sid,
                          //         type: widget.type));
                        },
                        child: const Text(
                          '转人工',
                          // style: TextStyle(color: Colors.black),
                        ),
                      ))),
            )
          ],
        ),
        body: MultiBlocListener(
            listeners: [
              BlocListener<ThreadBloc, ThreadState>(
                listener: (context, state) {
                  // 隐藏toast
                  // Fluttertoast.cancel();
                  if (state is RequestThreading) {
                    setState(() {
                      _isRequestingThread = true;
                    });
                  } else if (state is RequestThreadSuccess) {
                    debugPrint(
                        "RequestThreadSuccess ${state.threadResult.data}");
                    ThreadProtobuf? thread = state.threadResult.data?.thread;
                    BytedeskStomp().subscribe(thread!.topic!);
                    setState(() {
                      _isRobot = false; // 需要，勿删
                      _currentThread = thread;
                      _isRequestingThread = false;
                    });
                    //
                    Message message =
                        Message.fromProtobuf(state.threadResult.data!);
                    pushToMessageArray(message, true);

                    // TODO: 加载本地历史消息
                    // _getMessages(_page, _size);
                  }
                },
              ),
              BlocListener<MessageBloc, MessageState>(
                listener: (context, state) {
                  debugPrint('message state change');
                  if (state is UploadImageSuccess) {
                    // 图片上传成功
                    String? content = state.uploadJsonResult.url;
                    debugPrint('图片上传成功 $content');
                    //
                    String? uid = BytedeskUuid.uuid();
                    sendMessage(uid, BytedeskConstants.MESSAGE_TYPE_IMAGE, content!);
                    //
                  } else if (state is UpLoadImageError) {
                    // 图片上传失败
                    Fluttertoast.showToast(msg: '图片上传失败');
                  } else if (state is UploadVideoSuccess) {
                    // 视频上传成功
                    String? content = state.uploadJsonResult.url;
                    debugPrint('视频上传成功 $content');
                    //
                    String? uid = BytedeskUuid.uuid();
                    sendMessage(uid, BytedeskConstants.MESSAGE_TYPE_VIDEO, content!);
                    //
                  } else if (state is UpLoadVideoError) {
                    // 视频上传失败
                    Fluttertoast.showToast(msg: '视频上传失败');
                  }
                  //
                },
              ),
            ],
            child: _isRequestingThread
                ? Container(
                    margin: const EdgeInsets.only(top: 50),
                    alignment: Alignment.center,
                    child: const Column(children: <Widget>[
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      Text('会话请求中, 请稍后...')
                    ]))
                : Container(
                    alignment: Alignment.bottomCenter,
                    // color: const Color(0xffdeeeeee),
                    color: BytedeskUtils.isDarkMode(context)
                        ? Colors.transparent
                        : const Color(0xffdeeeeee),
                    child: Column(
                      children: <Widget>[
                        // 参考pull_to_refresh库中 QQChatList例子
                        Expanded(
                          //
                          child: SmartRefresher(
                            enablePullDown: false,
                            onLoading: () async {
                              // debugPrint('TODO: 下拉刷新'); // 注意：方向跟默认是反着的
                              // await Future.delayed(Duration(milliseconds: 1000));
                              _getMessages(_page, _size);
                              setState(() {});
                              _refreshController.loadComplete();
                            },
                            footer: const ClassicFooter(
                              idleText: "上拉加载",
                              loadingText: "加载中...",
                              noDataText: "没有更多了",
                              failedText: "加载失败",
                              canLoadingText: "加载中...",
                              loadStyle: LoadStyle.ShowWhenLoading,
                            ),
                            enablePullUp: true,
                            //
                            controller: _refreshController,
                            //
                            child: Scrollable(
                              controller: _scrollController,
                              axisDirection: AxisDirection.up,
                              viewportBuilder: (context, offset) {
                                return ExpandedViewport(
                                  offset: offset,
                                  axisDirection: AxisDirection.up,
                                  slivers: <Widget>[
                                    SliverExpanded(),
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (c, i) => _messages[i],
                                          childCount: _messages.length),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1.0,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                            ),
                            // child: _textComposerWidget(),
                            // FIXME: 表情在web和Android有问题？暂时仅在iOS启用表情
                            // child: (BytedeskUtils.isWeb || BytedeskUtils.isAndroid) ? _textComposerWidget() : _chatInput(),
                            child: _chatInput()),
                      ],
                    ),
                  )));
  }

  Widget _chatInput() {
    return ChatInput(
      // 发送触发事件
      isRobot: _isRobot,
      onSendPressed: _handleSendPressed,
      sendButtonVisibilityMode: SendButtonVisibilityMode.editing,
      // voiceWidget: VoiceRecord(),
      // voiceWidget: VoiceWidget(
      //   startRecord: () {},
      //   stopRecord: _handleVoiceSelection,
      //   // 加入定制化Container的相关属性
      //   height: 40.0,
      //   margin: EdgeInsets.zero,
      // ),
      extraWidget: ExtraItems(
          // 照片
          handleImageSelection: _handleImageSelection,
          // 文件
          handleFileSelection: _handleFileSelection,
          // 拍摄
          handlePickerSelection: _handlePickerSelection,
          // 上传视频
          handleUploadVideo: _handleUploadVideo,
          // 录制视频
          handleCaptureVideo: _handleCaptureVideo),
    );
  }

  //
  // void _handleVoiceSelection(AudioFile? obj) async {
  //   debugPrint('_handleVoiceSelection');
  //   if (obj != null) {
  //   }
  // }

  //
  Future<bool> _handleSendPressed(String content) async {
    debugPrint('send: $content');
    _handleSubmitted(content);
    return true;
  }

  void _handleImageSelection() async {
    debugPrint('_handleImageSelection');
    _pickImage();
  }

  void _handleFileSelection() async {
    debugPrint('_handleFileSelection');
  }

  Future<void> _handlePickerSelection() async {
    debugPrint('_handlePickerSelection');
    _takeImage();
    return;
  }

  void _handleUploadVideo() async {
    debugPrint('_handleUploadVideo');
    _pickVideo();
  }

  void _handleCaptureVideo() async {
    debugPrint('_handleCaptureVideo');
    _captureVideo();
  }

  //
  @override
  bool get wantKeepAlive => true;

  // 发送消息
  void _handleSubmitted(String? text) {
    _textController.clear();
    // 内容为空，直接返回
    if (text!.trim().isEmpty) {
      return;
    }
    //
    String? uid = BytedeskUuid.uuid();
    sendMessage(uid, BytedeskConstants.MESSAGE_TYPE_TEXT, text);
  }

  // http rest 接口发送消息，长链接断开情况下调用
  void sendMessage(String uid, String type, String content) {
    //
    Message message = Message.fromUidTypeContent(uid, type, content);
    pushToMessageArray(message, true);
    //
    if (_bdStomp.isConnected()) {
      if (_currentThread == null) {
        Fluttertoast.showToast(msg: '请求客服中, 请稍后...');
        return;
      }
      // 长连接正常情况下，调用长连接接口
      // _bdMqtt.sendTextMessage(uid, content, _currentThread!);
      String? jsonString =
          BytedeskUtils.messageToJson(uid, type, content, _currentThread!);
      _bdStomp.sendMessage(jsonString!);
    } else {
      //
      String? jsonString =
          BytedeskUtils.messageToJson(uid, type, content, _currentThread!);
      BlocProvider.of<MessageBloc>(context)
          .add(SendMessageRestEvent(json: jsonString));
    }
  }

  //
  initListeners() {
    // 更新消息状态
    bytedeskEventBus.on<ReceiveMessageReceiptEventBus>().listen((event) {
      debugPrint('更新状态:${event.uid}-${event.status}');
      if (mounted) {
        // 更新界面
        for (var i = 0; i < _messages.length; i++) {
          MessageWidget messageWidget = _messages[i];
          if (messageWidget.message!.uid == event.uid &&
              _messages[i].message!.status !=
                  BytedeskConstants.MESSAGE_STATUS_READ) {
            debugPrint('do update status:${messageWidget.message!.uid!}');
            // setState(() {
            //   _messages[i].message!.status = event.status; // 不更新
            // });
            // 必须重新创建一个messageWidget才会更新
            Message message =
                Message.fromMessage(messageWidget.message!, event.status);
            // Message message = messageWidget.message!;
            // message.status = event.status;
            MessageWidget messageWidget2 = MessageWidget(
                message: message,
                customCallback: widget.customCallback,
                animationController: AnimationController(
                    vsync: this, duration: const Duration(milliseconds: 500)));
            setState(() {
              _messages[i] = messageWidget2;
            });
          }
        }
      }
    });
    bytedeskEventBus.on<ReceiveMessagePreviewEventBus>().listen((event) {
      debugPrint('消息预知');
      if (mounted) {
        setState(() {
          // TODO: 国际化，支持英文
          _title = '对方正在输入';
        });
      }
      // 还原title
      Timer(
        const Duration(seconds: 3),
        () {
          // debugPrint('timer');
          if (mounted) {
            setState(() {
              _title = widget.title;
            });
          }
        },
      );
    });
    // 接收到新消息
    bytedeskEventBus.on<ReceiveMessageEventBus>().listen((event) {
      debugPrint('chatkfpage receive message:${event.message.content}');
      // if (_currentThread != null &&
      //     (event.message.thread!.topic != _currentThread!.topic)) {
      //   return;
      // }
      // 非自己发送的，发送已读回执
      // if (event.message.isSend == 0) {
      //   _bdMqtt.sendReceiptReadMessage(
      //       event.message.uid!, event.message.thread!);
      // }
      //
      pushToMessageArray(event.message, true);
      // if (this.mounted) {
      //   // 界面显示
      //   MessageWidget messageWidget = new MessageWidget(
      //       message: event.message,
      //       customCallback: widget.customCallback,
      //       animationController: new AnimationController(
      //           vsync: this, duration: Duration(milliseconds: 500)));
      //   setState(() {
      //     _messages.insert(0, messageWidget);
      //     // _messages.add(messageWidget);
      //   });
      // }
    });
    // 删除消息
    bytedeskEventBus.on<DeleteMessageEventBus>().listen((event) {
      if (mounted) {
        // 从sqlite中删除
        _messageProvider.delete(event.uid);
        // 更新界面
        setState(() {
          _messages.removeWhere((element) => element.message!.uid == event.uid);
        });
      }
    });
    // 点击机器人消息 ‘人工客服’
    bytedeskEventBus.on<RequestAgentThreadEventBus>().listen((event) {
      if (mounted) {
        BlocProvider.of<ThreadBloc>(context)
            .add(RequestAgentEvent(sid: widget.sid, type: widget.type));
      }
    });
    // 滚动监听, https://learnku.com/articles/30338
    _scrollController.addListener(() {
      // 隐藏软键盘
      FocusScope.of(context).requestFocus(FocusNode());
      // 如果滑动到底部
      // if (_scrollController.position.pixels ==
      //     _scrollController.position.maxScrollExtent) {
      //   debugPrint('已经到底了');
      // }
    });
  }

  // 选择图片
  Future<void> _pickImage() async {
    try {
      //
      XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, maxWidth: 800, imageQuality: 95);
      //
      if (pickedFile != null) {
        debugPrint('pick image path: ${pickedFile.path}');
        // TODO: 将图片显示到对话消息中
        // TODO: 显示处理中loading
        // 压缩
        // final dir = await path_provider.getTemporaryDirectory();
        // final targetPath = dir.absolute.path +
        //     "/" +
        //     BytedeskUtils.currentTimeMillis().toString() +
        //     ".jpg";
        // debugPrint('targetPath: $targetPath');
        // await BytedeskUtils.compressImage(File(pickedFile.path), targetPath);
        // // 上传压缩后图片
        // BlocProvider.of<MessageBloc>(context)
        //   ..add(UploadImageEvent(filePath: targetPath));
        //
        if (BytedeskUtils.isWeb) {
          // web
          String? fileName = pickedFile.path.split("/").last;
          Uint8List? fileBytes = await pickedFile.readAsBytes();
          String? mimeType = pickedFile.mimeType;
          //
          BlocProvider.of<MessageBloc>(context).add(UploadImageBytesEvent(
            fileName: fileName,
            fileBytes: fileBytes,
            mimeType: mimeType,
          ));
        } else {
          // 其他
          BlocProvider.of<MessageBloc>(context)
              .add(UploadImageEvent(filePath: pickedFile.path));
        }
      } else {
        Fluttertoast.showToast(msg: '未选取图片');
      }
    } catch (e) {
      debugPrint('pick image error ${e.toString()}');
      Fluttertoast.showToast(msg: "未选取图片");
    }
  }

  // 拍照
  Future<void> _takeImage() async {
    try {
      XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.camera, maxWidth: 800, imageQuality: 95);
      //
      if (pickedFile != null) {
        debugPrint('take image path: ${pickedFile.path}');
        // TODO: 将图片显示到对话消息中
        // TODO: 显示处理中loading
        // 压缩
        // final dir = await path_provider.getTemporaryDirectory();
        // final targetPath = dir.absolute.path +
        //     "/" +
        //     BytedeskUtils.currentTimeMillis().toString() +
        //     ".jpg";
        // debugPrint('targetPath: $targetPath');
        // await BytedeskUtils.compressImage(File(pickedFile.path), targetPath);
        // // 上传压缩后图片
        // BlocProvider.of<MessageBloc>(context)
        //   ..add(UploadImageEvent(filePath: targetPath));
        //
        if (BytedeskUtils.isWeb) {
          // web
          String? fileName = pickedFile.path.split("/").last;
          Uint8List? fileBytes = await pickedFile.readAsBytes();
          String? mimeType = pickedFile.mimeType;
          //
          BlocProvider.of<MessageBloc>(context).add(UploadImageBytesEvent(
            fileName: fileName,
            fileBytes: fileBytes,
            mimeType: mimeType,
          ));
        } else {
          // 其他
          BlocProvider.of<MessageBloc>(context)
              .add(UploadImageEvent(filePath: pickedFile.path));
        }
      } else {
        Fluttertoast.showToast(msg: '未拍照');
      }
    } catch (e) {
      debugPrint('take image error ${e.toString()}');
      Fluttertoast.showToast(msg: "未选取图片");
    }
  }

  // 上传视频
  // FIXME: image_picker有bug，选择视频后缀为.jpg
  // 手机可以播放，但chrome无法播放
  Future<void> _pickVideo() async {
    try {
      XFile? pickedFile = await _picker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 10));

      if (pickedFile != null) {
        debugPrint('pick video path: ${pickedFile.path}');
        //
        if (BytedeskUtils.isWeb) {
          // web
          String? fileName =
              pickedFile.path.split("/").last.replaceAll(".jpg", ".mp4");
          Uint8List? fileBytes = await pickedFile.readAsBytes();
          String? mimeType = pickedFile.mimeType;
          //
          BlocProvider.of<MessageBloc>(context).add(UploadVideoBytesEvent(
            fileName: fileName,
            fileBytes: fileBytes,
            mimeType: mimeType,
          ));
        } else {
          // 其他
          BlocProvider.of<MessageBloc>(context)
              .add(UploadVideoEvent(filePath: pickedFile.path));
        }
        // BlocProvider.of<MessageBloc>(context)
        //     .add(UploadVideoEvent(filePath: pickedFile.path));
      } else {
        Fluttertoast.showToast(msg: '未选取视频');
      }
      // 使用file_picker替换image_picker
      // List<PlatformFile>? _paths = (await FilePicker.platform.pickFiles(
      //   type: FileType.video,
      //   allowMultiple: false,
      //   allowedExtensions: [],
      // ))
      //     ?.files;
      // if (_paths!.length > 0) {
      //   // TODO: 将视频显示到对话消息中
      //   // TODO: 显示处理中loading
      //   // 压缩
      //   // final info = await _flutterVideoCompress.compressVideo(
      //   //   _paths[0].path,
      //   //   quality:
      //   //       VideoQuality.LowQuality, // default(VideoQuality.DefaultQuality)
      //   //   deleteOrigin: false, // default(false)
      //   // );
      //   // // debugBytedeskUtils.printLog(info.toJson().toString());
      //   // String? afterPath = info.toJson()['path'];
      //   // // debugPrint('video path: ${_paths[0].path}, compress path: $afterPath');
      //   // // 上传
      //   // BlocProvider.of<MessageBloc>(context)
      //   //   ..add(UploadVideoEvent(filePath: afterPath));
      //   // 压缩后上传
      //   BlocProvider.of<MessageBloc>(context)
      //     ..add(UploadVideoEvent(filePath: _paths[0].path));
      // }
    } catch (e) {
      debugPrint('pick video error ${e.toString()}');
      Fluttertoast.showToast(msg: "未选取视频");
    }
  }

  // 录制视频
  Future<void> _captureVideo() async {
    try {
      XFile? pickedFile = await _picker.pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 10));
      //
      if (pickedFile != null) {
        debugPrint('take video path: ${pickedFile.path}');
        // TODO: 将图片显示到对话消息中
        // TODO: 显示处理中loading
        // 压缩
        // final info = await _flutterVideoCompress.compressVideo(
        //   pickedFile.path,
        //   quality:
        //       VideoQuality.LowQuality, // default(VideoQuality.DefaultQuality)
        //   deleteOrigin: false, // default(false)
        // );
        // // debugBytedeskUtils.printLog(info.toJson().toString());
        // String? afterPath = info.toJson()['path'];
        // // debugPrint('video path: ${pickedFile.path}, compress path: $afterPath');
        // // 上传
        // BlocProvider.of<MessageBloc>(context)
        //   ..add(UploadVideoEvent(filePath: afterPath));
        //
        //
        if (BytedeskUtils.isWeb) {
          // web
          String? fileName =
              pickedFile.path.split("/").last.replaceAll(".jpg", ".mp4");
          Uint8List? fileBytes = await pickedFile.readAsBytes();
          String? mimeType = pickedFile.mimeType;
          //
          BlocProvider.of<MessageBloc>(context).add(UploadVideoBytesEvent(
            fileName: fileName,
            fileBytes: fileBytes,
            mimeType: mimeType,
          ));
        } else {
          // 其他
          BlocProvider.of<MessageBloc>(context)
              .add(UploadVideoEvent(filePath: pickedFile.path));
        }
      } else {
        Fluttertoast.showToast(msg: '未录制视频');
      }
    } catch (e) {
      debugPrint('take video error ${e.toString()}');
      Fluttertoast.showToast(msg: "未录制视频");
    }
  }

  // 加载更多聊天记录
  // Future<void> _loadMoreMessages() async {
  //   debugPrint('load more');
  //   // TODO: 从服务器加载
  //   _getMessages(_page, _size);
  // }

  // 分页加载本地历史聊天记录
  // TODO: 从服务器加载聊天记录
  // FIXME: 消息排序错乱
  Future<void> _getMessages(int page, int size) async {
    // BlocProvider.of<MessageBloc>(context)
    //     ..add(LoadHistoryMessageEvent(uid: _currentUid, page: page, size: size));
    //
    List<Message> messageList = await _messageProvider.getTopicMessages(
        _currentThread!.topic, _currentUid, page, size);
    // BytedeskUtils.printLog(messageList.length);
    int length = messageList.length;
    // for (var i = 0; i < length; i++) {
    //   Message message = messageList[i];
    //   if (message.type ==
    //           BytedeskConstants.MESSAGE_TYPE_NOTIFICATION_FORM_REQUEST ||
    //       message.type ==
    //           BytedeskConstants.MESSAGE_TYPE_NOTIFICATION_FORM_RESULT) {
    //     // 暂时忽略表单消息
    //   } else if (message.type ==
    //       BytedeskConstants.MESSAGE_TYPE_NOTIFICATION_THREAD_REENTRY) {
    //     // 连续的 ‘继续会话’ 消息，只显示最后一条
    //     if (i + 1 < length) {
    //       var nextmsg = messageList[i + 1];
    //       if (nextmsg.type ==
    //           BytedeskConstants.MESSAGE_TYPE_NOTIFICATION_THREAD_REENTRY) {
    //         continue;
    //       } else {
    //         pushToMessageArray(message, false);
    //       }
    //     }
    //   } else {
    //     pushToMessageArray(message, false);
    //   }
    // }
    //
    _page += 1;
  }

  void pushToMessageArray(Message message, bool append) {
    _messageProvider.insert(message);
    //
    if (mounted) {
      bool contains = false;
      for (var i = 0; i < _messages.length; i++) {
        Message? element = _messages[i].message;
        if (element!.uid == message.uid) {
          contains = true;
          // 更新消息状态
          _messageProvider.update(element.uid, message.status);
        }
      }
      if (!contains) {
        MessageWidget messageWidget = MessageWidget(
            message: message,
            customCallback: widget.customCallback,
            animationController: AnimationController(
                vsync: this, duration: const Duration(milliseconds: 500)));
        setState(() {
          if (append) {
            _messages.insert(0, messageWidget);
          } else {
            _messages.add(messageWidget);
            _messages.sort((a, b) {
              return b.message!.createdAt!.compareTo(a.message!.createdAt!);
            });
          }
        });
      }
    }
    if (message.status != BytedeskConstants.MESSAGE_STATUS_READ) {
      // 发送已读回执
      if (!message.isSend() && _currentThread != null) {
        // debugPrint('message.uid ${message.uid}');
        // debugPrint('_currentThread ${_currentThread!.uid}');
        // _bdMqtt.sendReceiptReadMessage(message.uid!, _currentThread!);
      }
    }
  }

  // Future<void> _appendMessage(Message message) async {
  //   debugPrint('append:${message.uid!}content:${message.content!}');
  //   pushToMessageArray(message, true);
  // }

  void scrollToBottom() {
    // After 1 second, it takes you to the bottom of the ListView
    // Timer(
    //   Duration(seconds: 1),
    //   () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    // );
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // debugPrint("didChangeAppLifecycleState:" + state.toString());
  //   switch (state) {
  //     case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
  //       break;
  //     case AppLifecycleState.paused: // 应用程序不可见，后台
  //       break;
  //     case AppLifecycleState.resumed: // 应用程序可见，前台
  //       // APP切换到前台之后，重连
  //       // BytedeskUtils.mqttReConnect();
  //       // TODO: 拉取离线消息
  //       break;
  //     case AppLifecycleState.detached: // 申请将暂时暂停
  //       break;
  //   }
  // }

  @override
  void dispose() {
    // debugPrint('chat_kf_page dispose');
    // SpUtil.putBool(BytedeskConstants.isCurrentChatKfPage, false);
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _loadHistoryTimer?.cancel();
    _resendTimer?.cancel();
    // bytedeskEventBus.destroy(); // FIXME: 只能取消监听，不能destroy
    super.dispose();
  }
}
