/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-10-08 12:08:19
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-08 13:22:42
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
//
// import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sp_util/sp_util.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../model/message.dart';
import '../model/message_provider.dart';
import '../util/bytedesk_constants.dart';
import '../util/bytedesk_events.dart';

// https://github.com/blackhorse-one/stomp_dart_client/blob/master/example/main.dart
class BytedeskStomp {
  //
  StompClient? stompClient;
  String? transformedTopic;
  List<String>? subscribedTopics;
  MessageProvider? messageProvider;
  String? orgUid;

  // 单例模式
  static final BytedeskStomp _singleton = BytedeskStomp._internal();
  factory BytedeskStomp() {
    return _singleton;
  }
  BytedeskStomp._internal();

  void connect() async {
    if (stompClient != null && stompClient!.connected) {
      debugPrint('already connected');
      return;
    }
    debugPrint('connecting...');
    bytedeskEventBus.fire(
        ConnectionEventBus(BytedeskConstants.CONNECTION_STATUS_CONNECTING));
    messageProvider = MessageProvider();
    orgUid = SpUtil.getString(BytedeskConstants.VISITOR_ORGUID);

    // 初始化StompClient对象
    subscribedTopics = [];
    stompClient = StompClient(
      config: StompConfig(
        url: BytedeskConstants.stompWsUrl,
        onConnect: onConnect,
        beforeConnect: () async {
          // await Future.delayed(const Duration(milliseconds: 200));
          debugPrint('before connecting...');
        },
        onWebSocketError: (dynamic error) => debugPrint(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    stompClient?.activate();
  }

  void onConnect(StompFrame frame) {
    debugPrint('connected: ${frame}');
    // Timer.periodic(const Duration(seconds: 10), (_) {
    // });
  }

  void sendMessage(String message) {
    debugPrint("sendMessage");

    if (stompClient == null) {
      debugPrint("stompClient is null");
      return;
    }

    if (!stompClient!.connected) {
      debugPrint("stompClient is not connected");
      return;
    }

    stompClient?.send(
      destination: '/app/$transformedTopic',
      // body: json.encode({'a': 123}),
      body: message,
    );
  }

  void subscribe(String topic) {
    transformedTopic = topic.replaceAll('/', '.'); // 直接替换所有'/'为'.'
    //
    debugPrint("stompSubscribe");
    if (stompClient == null) {
      debugPrint("stompClient is null");
      return;
    }
    // 检查是否已订阅该主题
    if (subscribedTopics!.contains(transformedTopic)) {
      return; // 如果已订阅，则直接返回
    }
    // 如果未订阅，则添加到订阅列表
    subscribedTopics!.add(transformedTopic!);
    // 订阅主题
    stompClient?.subscribe(
      destination: '/topic/$transformedTopic',
      callback: (frame) {
        Map<String, dynamic>? result = json.decode(frame.body!);
        String uid = result!['uid'];
        debugPrint('Received message: uid $uid, $result');
        // {client: MACOS, 
        //  content: 20241008130653a430395dffed44ff85878a38628abe3b,
        //  createdAt: 2024-10-08 13:06:53.536, 
        //  extra: {"orgUid":"df_org_uid"},
        //  status: SUCCESS,
        //  thread: {topic: org/workgroup/df_wg_uid/1490702810794244, type: WORKGROUP, uid: 1490786847869184,
        //          user: {avatar: https://cdn.weiyuai.cn/avatars/apple_default_avatar.png, nickname: Local[192.168.0.104], type: VISITOR, uid: 1490702810794244}},
        //  type: READ, 
        //  uid: a30cbb1238684d1fa0a7c8b2b4fc987e,
        //  user: {avatar: https://cdn.weiyuai.cn/avatars/admin_default_avatar.png, nickname: i18n.agent.nickname, type: AGENT, uid: df_ag_uid}}
        
        debugPrint(
            'uid: ${result['uid']}, type: ${result['type']}, content: ${result['content']}, user:avatar ${result['user']['avatar']}, user:nickname: ${result['user']['nickname']}');
        // 收到消息后，显示在聊天界面
        Message message = Message.fromProtobufJson(result);
        if (!message.isSend()) {
          // 接收的非自己发送消息
          switch (message.type) {
            case BytedeskConstants.MESSAGE_TYPE_READ:
            case BytedeskConstants.MESSAGE_TYPE_DELIVERED:
              // 回执消息
              updateMessageStatus(message);
              return;
            case BytedeskConstants.MESSAGE_TYPE_TYPING:
            case BytedeskConstants.MESSAGE_TYPE_PROCESSING:
              // 非自己发送的：正在输入
              handleTypingMessage(message);
              return;
            case BytedeskConstants.MESSAGE_TYPE_PREVIEW:
              // 非自己发送的：消息预知
              handlePreviewMessage(message);
              return;
            case BytedeskConstants.MESSAGE_TYPE_FAQ_UP:
            case BytedeskConstants.MESSAGE_TYPE_FAQ_DOWN:
            case BytedeskConstants.MESSAGE_TYPE_ROBOT_UP:
            case BytedeskConstants.MESSAGE_TYPE_ROBOT_DOWN:
            case BytedeskConstants.MESSAGE_TYPE_RATE_SUBMIT:
            case BytedeskConstants.MESSAGE_TYPE_RATE_CANCEL:
              // 访客提交评价或取消评价
              updateMessageStatus(message);
              return;
            case BytedeskConstants.MESSAGE_TYPE_STREAM:
              // handleTypingMessage(currentThread, thread, messageProtobuf.getType());
              break;
            case BytedeskConstants.MESSAGE_TYPE_TRANSFER:
              // 转接
              debugPrint("transfer message");
              // handleTransferMessage(message, thread);
              break;
            case BytedeskConstants.MESSAGE_TYPE_TRANSFER_ACCEPT:
              // 转接被接受
              debugPrint("transfer accept message");
              // handleTransferAcceptMessage(message, thread);
              return;
            case BytedeskConstants.MESSAGE_TYPE_TRANSFER_REJECT:
              // 转接被拒绝
              debugPrint("transfer reject message");
              // handleTransferRejectMessage(message, thread);
              return;
            default:
              // 向服务器发送消息送达回执
              var vibrateType = FeedbackType.success;
              Vibrate.feedback(vibrateType);
            //
            // if (BytedeskUtils.shouldSendReceipt(messageProto.type)) {
            //   sendReceiptReceivedMessage(messageProto.uid, thread);
            // }
          }
        } else {
          // 自己发送的消息
          switch (message.type) {
            case BytedeskConstants.MESSAGE_TYPE_READ:
            case BytedeskConstants.MESSAGE_TYPE_DELIVERED:
              // 自己发送的消息回执
              updateMessageStatus(message);
              return;
            case BytedeskConstants.MESSAGE_TYPE_TYPING:
            case BytedeskConstants.MESSAGE_TYPE_PROCESSING:
              // 自己发送的在输入
              return;
            case BytedeskConstants.MESSAGE_TYPE_PREVIEW:
              return;
            case BytedeskConstants.MESSAGE_TYPE_TRANSFER:
              // 转接
              debugPrint("transfer message");
              // handleTransferMessage(message, thread);
              break;
            case BytedeskConstants.MESSAGE_TYPE_TRANSFER_ACCEPT:
              // 转接被接受
              debugPrint("transfer accept message");
              // handlTransferAcceptMessage(message, thread);
              return;
            case BytedeskConstants.MESSAGE_TYPE_TRANSFER_REJECT:
              // 转接被拒绝
              debugPrint("transfer reject message");
              // handleTransferRejectMessage(message, thread);
              return;
            default:
              // 收到从服务器返回自己发的消息，发送成功
              updateMessageSuccess(uid);
          }
        }
        messageProvider?.insert(message);
        // 通知界面显示聊天记录
        bytedeskEventBus.fire(ReceiveMessageEventBus(message));
      },
    );
  }

  void unsubscribe(String topic) {
    transformedTopic = topic.replaceAll('/', '.'); // 直接替换所有'/'为'.'
    //
    debugPrint("stompUnsubscribe");
    if (stompClient == null) {
      debugPrint("stompClient is null");
      return;
    }
    // 检查是否已订阅该主题
    if (!subscribedTopics!.contains(transformedTopic)) {
      return; // 如果未订阅，则直接返回
    }
    // 如果已订阅，则从订阅列表中移除该主题
    subscribedTopics?.remove(transformedTopic);
  }

  bool isConnected() {
    return stompClient?.connected ?? false;
  }

  void disconnect() async {
    stompClient?.deactivate();
  }

  //
  void updateMessageStatus(Message message) {
    String uid = message.content!;
    String status = message.type!;
    messageProvider?.update(uid, status);
    //
    bytedeskEventBus.fire(ReceiveMessageReceiptEventBus(uid, status));
  }

  void updateMessageSuccess(String uid) {
    messageProvider?.update(uid, BytedeskConstants.MESSAGE_STATUS_SUCCESS);
    //
    bytedeskEventBus.fire(ReceiveMessageReceiptEventBus(
        uid, BytedeskConstants.MESSAGE_STATUS_SUCCESS));
  }

  void handleTypingMessage(Message message) {
    bytedeskEventBus.fire(ReceiveMessagePreviewEventBus(message));
  }

  void handlePreviewMessage(Message message) {
    bytedeskEventBus.fire(ReceiveMessagePreviewEventBus(message));
  }

  void handleTransferMessage() {}
  
}
