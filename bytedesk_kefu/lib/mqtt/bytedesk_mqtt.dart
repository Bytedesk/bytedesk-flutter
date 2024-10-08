/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-08-13 09:56:55
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-08 13:23:04
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
// https://pub.dev/packages/mqtt_client/install
import 'dart:convert';

import 'package:bytedesk_kefu/util/bytedesk_uuid.dart';
import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sp_util/sp_util.dart';
// import 'package:typed_data/src/typed_buffer.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../model/message.dart';
import '../model/message_protobuf.dart';
import '../model/message_provider.dart';
// import '../model/thread.dart';
import '../model/thread_protobuf.dart';
import '../model/user_protobuf.dart';
import '../protobuf/message.pb.dart' as protomsg;
import '../protobuf/thread.pb.dart' as protothread;
import '../protobuf/user.pb.dart' as protouser;
import '../util/bytedesk_constants.dart';
import '../util/bytedesk_events.dart';
import '../util/bytedesk_utils.dart';
import 'payload_builder.dart';

class BytedeskMqtt {
  //
  // var mqttClient;
  MqttServerClient? mqttClient;
  String? clientId;
  int keepAlivePeriod = 20;
  String? currentUid;
  String? nickname;
  String? avatar;
  String? orgUid;
  String? deviceUid;
  String? client;
  MessageProvider? messageProvider;

  // 单例模式
  static final BytedeskMqtt _singleton = BytedeskMqtt._internal();
  factory BytedeskMqtt() {
    return _singleton;
  }
  BytedeskMqtt._internal();

  void connect() async {
    //
    if (isConnected()) {
      debugPrint('mqtt is connected, return');
      return;
    }
    debugPrint('connecting mqtt....');
    bytedeskEventBus.fire(
        ConnectionEventBus(BytedeskConstants.CONNECTION_STATUS_CONNECTING));
    //
    currentUid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
    nickname = SpUtil.getString(BytedeskConstants.VISITOR_NICKNAME);
    avatar = SpUtil.getString(BytedeskConstants.VISITOR_AVATAR);
    orgUid = SpUtil.getString(BytedeskConstants.VISITOR_ORGUID);
    client = BytedeskUtils.client();
    deviceUid = SpUtil.getString(BytedeskConstants.VISITOR_DEVICEUID);
    clientId = "$currentUid/$client/$deviceUid";
    messageProvider = MessageProvider();
    debugPrint('mqtt clientId: $clientId');

    //注意：必须要先判断web，否则在web运行会报错：
    //  Unsupported operation: Platform._operatingSystem
    // if (BytedeskUtils.isWeb) {
    //   if (BytedeskConstants.isDebug) {
    //     mqttClient = MqttBrowserClient.withPort(
    //         'ws://127.0.0.1/websocket', clientId!, BytedeskConstants.mqttPort);
    //   } else {
    //     mqttClient = MqttBrowserClient.withPort(
    //         BytedeskConstants.webSocketWssUrl, clientId!, 443);
    //   }
    // } else {
    if (BytedeskConstants.isWebSocketWss) {
      debugPrint('isWebSocketWss mqttClient connecting....');
      mqttClient =
          MqttServerClient(BytedeskConstants.webSocketWssUrl, clientId!);
      mqttClient?.useWebSocket = true;
      mqttClient?.port = 443;

      /// You can also supply your own websocket protocol list or disable this feature using the websocketProtocols
      /// setter, read the API docs for further details here, the vast majority of brokers will support the client default
      /// list so in most cases you can ignore this. Mosquito needs the single default setting.
      // mqttClient.websocketProtocols = MqttClientBytedeskConstants.protocolsSingleDefault;
    } else {
      debugPrint('isTcp mqttClient connecting....');
      mqttClient = MqttServerClient(BytedeskConstants.mqttHost, clientId!);
      mqttClient?.port = BytedeskConstants.mqttPort;
      mqttClient?.secure = BytedeskConstants.isSecure;
    }
    // }

    // 启用3.1.1版本协议，否则clientId限制最大长度为23
    mqttClient?.setProtocolV311();

    /// Set logging on if needed, defaults to off
    mqttClient?.logging(on: BytedeskConstants.isDebug);
    // mqttClient?.logging(on: false);
    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    mqttClient?.keepAlivePeriod = keepAlivePeriod;
    mqttClient?.autoReconnect = true; // FIXME:
    mqttClient?.onAutoReconnect = _onAutoReconnect; // FIXME:
    mqttClient?.onDisconnected = _onDisconnected;
    mqttClient?.onConnected = _onConnected;
    mqttClient?.onSubscribed = _onSubscribed;
    mqttClient?.onUnsubscribed = _onUnSubscribed;
    mqttClient?.onSubscribeFail = _onSubscribeFailed;

    /// Set a ping received callback if needed, called whenever a ping response(pong) is received from the broker.
    mqttClient?.pongCallback = _onPong;

    // Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final MqttConnectMessage connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId!)
        .authenticateAs(currentUid, '');
    // .keepAliveFor(keepAlivePeriod); // Must agree with the keep alive set above or not set
    // 取消客户端设置，直接在服务器端统一内容格式推送
    // .withWillTopic('protobuf/lastWill/mqtt') // If you set this you must set a will message
    // .withWillMessage('My Will message')
    // .startClean() // Non persistent session for testing
    // .withWillQos(MqttQos.atLeastOnce);
    debugPrint('mqttClient connecting....');
    mqttClient?.connectionMessage = connMessage;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however eill
    /// never send malformed messages.
    try {
      await mqttClient?.connect();
    } on Exception catch (e) {
      debugPrint('mqttClient exception - $e');
      mqttClient?.disconnect();
    }
    //
    mqttClient?.published?.listen((MqttPublishMessage messageBinary) {
      protomsg.Message messageProto =
          protomsg.Message.fromBuffer(messageBinary.payload.message);
      var uid = messageProto.uid;
      debugPrint(
          'receive message uid: $uid, ${messageProto.type}, ${messageProto.content}');
      // 处理接收消息
      // Thread  thread = Thread .fromProto(messageProto);
      Message message = Message.fromProto(messageProto);
      //
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
      //
      messageProvider?.insert(message);
      // 通知界面显示聊天记录
      bytedeskEventBus.fire(ReceiveMessageEventBus(message));
      // bytedeskEventBus.fire(ReceiveThreadEventBus(thread));
      // // 接收消息播放提示音，放到SDK外实现，迁移到demo中
      // if (BytedeskKefu.getPlayAudioOnReceiveMessage()! && !message.isSend()) {
      //   SystemSound.play(SystemSoundType.click);
      // }
      // // 振动，放到SDK外实现，迁移到demo中
      // if (BytedeskKefu.getVibrateOnReceiveMessage()! && !message.isSend()) {
      //   vibrate();
      // }
      //
    });
  }

// FIXME: ld: library not found for -lvibration
  void vibrate() async {
    // if (await Vibration.hasVibrator()) {
    //   Vibration.vibrate();
    // }
  }

  void subscribe(String topic) {
    debugPrint('Subscribing to the hello topic');
    mqttClient?.subscribe(topic, MqttQos.exactlyOnce);
  }

  void unsubscribe(String topic) {
    mqttClient?.unsubscribe(topic);
  }

  void sendTextMessage(
      String uid, String content, ThreadProtobuf currentThread) {
    publish(uid, content, BytedeskConstants.MESSAGE_TYPE_TEXT, currentThread);
  }

  void sendImageMessage(
      String uid, String content, ThreadProtobuf currentThread) {
    publish(uid, content, BytedeskConstants.MESSAGE_TYPE_IMAGE, currentThread);
  }

  void sendFileMessage(
      String uid, String content, ThreadProtobuf currentThread) {
    publish(uid, content, BytedeskConstants.MESSAGE_TYPE_FILE, currentThread);
  }

  void sendAudioMessage(
      String uid, String content, ThreadProtobuf currentThread) {
    publish(uid, content, BytedeskConstants.MESSAGE_TYPE_AUDIO, currentThread);
  }

  void sendVideoMessage(
      String uid, String content, ThreadProtobuf currentThread) {
    publish(uid, content, BytedeskConstants.MESSAGE_TYPE_VIDEO, currentThread);
  }

  void sendPreviewMessage(
      String previewContent, ThreadProtobuf currentThread) {}

  void sendRecallMessage(String uid, ThreadProtobuf currentThread) {}

  void sendReceiptReceivedMessage(String uid, ThreadProtobuf currentThread) {
    publish(BytedeskUuid.uuid(), uid, BytedeskConstants.MESSAGE_TYPE_DELIVERED,
        currentThread);
  }

  void sendReceiptReadMessage(String uid, ThreadProtobuf currentThread) {
    publish(BytedeskUuid.uuid(), uid, BytedeskConstants.MESSAGE_TYPE_READ,
        currentThread);
  }

  void publish(String messageUid, String content, String type,
      ThreadProtobuf currentThread) {
    debugPrint(
        'publish message content: $type, $content, ${currentThread.uid}');
    // String? agentInfo = SpUtil.getString(BytedeskConstants.agentInfo);
    // AgentJson agentJson = AgentJson.fromJson(jsonDecode(agentInfo!));
    //
    if (isConnected()) {
      // 发送消息
      protothread.Thread thread = protothread.Thread();
      thread.uid = currentThread.uid!;
      thread.type = currentThread.type!;
      thread.topic = currentThread.topic!;
      //
      protouser.User threadUser = protouser.User();
      threadUser.uid = currentThread.user!.uid!;
      threadUser.nickname = currentThread.user!.nickname!;
      threadUser.avatar = currentThread.user!.avatar!;
      thread.user = threadUser;
      //
      protouser.User user = protouser.User();
      user.uid = currentUid!;
      user.nickname = nickname!;
      user.avatar = avatar!;
      //
      var messageExtra = {
        orgUid: orgUid!,
      };
      protomsg.Message message = protomsg.Message();
      message.uid = messageUid;
      message.type = type;
      message.status = BytedeskConstants.MESSAGE_STATUS_SENDING;
      message.createdAt = BytedeskUtils.formatedDateNow();
      message.client = BytedeskUtils.client();
      message.content = content;
      message.extra = jsonEncode(messageExtra);
      //
      message.user = user;
      message.thread = thread;
      // 先通知界面本地显示聊天记录，然后再发送
      // if (shouldInsertLocal) {
      // 插入本地数据库
      // if (messageProvider != null) {
      // messageProvider.insert(message);
      // }
      // bytedeskEventBus.fire(ReceiveMessageEventBus(message));
      // midList.add(message.mid!);
      // }
      //
      final PayloadBuilder builder = PayloadBuilder();
      // 注意：此函数为自行添加，原先库中没有
      builder.addProtobuf(message.writeToBuffer());
      mqttClient?.publishMessage(
          currentThread.topic!, MqttQos.exactlyOnce, builder.payload!);
    } else {
      // TODO: 长连接断开，调用rest api发送消息
      String? createdAt = BytedeskUtils.formatedDateNow();
      String? client = BytedeskUtils.getClient();
      //
      ThreadProtobuf threadProtobuf = ThreadProtobuf(
          uid: currentThread.uid,
          topic: currentThread.topic,
          type: currentThread.type,
          user: UserProtobuf(
            uid: currentThread.user!.uid,
            nickname: currentThread.user!.nickname,
            avatar: currentThread.user!.avatar,
          ));
      //
      UserProtobuf userProtobuf = UserProtobuf(
        uid: currentUid,
        nickname: nickname,
        avatar: avatar,
      );
      //
      var messageExtra = {
        orgUid: orgUid!,
      };
      MessageProtobuf messageProtobuf = MessageProtobuf(
        uid: messageUid,
        type: type,
        content: content,
        status: BytedeskConstants.MESSAGE_STATUS_SENDING,
        createdAt: createdAt,
        client: client,
        extra: jsonEncode(messageExtra),
        //
        thread: threadProtobuf,
        user: userProtobuf,
      );
      //
      String? jsonString = jsonEncode(messageProtobuf);
      debugPrint("TODO: jsonString:$jsonString");
      //MessageHttpApi().sendRestMessage(jsonString);
      //

      // BlocProvider.of<MessageBloc>(context)
      //     .add(SendMessageRestEvent(json: jsonString));
      // // 插入本地数据库
      // _messageProvider.insert(message);
    }
  }

// 断开长连接
  void disconnect() {
    mqttClient?.disconnect();
  }

  /// The subscribed callback
  void _onSubscribed(String? topic) {
    debugPrint('Subscription confirmed for topic $topic');
  }

  /// The unsubscribed callback
  void _onUnSubscribed(String? topic) {
    debugPrint('UnSubscription confirmed for topic $topic');
  }

  /// The subscribed callback
  void _onSubscribeFailed(String? topic) {
    debugPrint('Subscribe Failed confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void _onDisconnected() {
    // _isConnected = false;
    debugPrint('OnDisconnected client callback - Client disconnection');
    // eventbus发广播，通知长连接断开
    bytedeskEventBus.fire(
        ConnectionEventBus(BytedeskConstants.CONNECTION_STATUS_DISCONNECTED));
    // if (mqttClient.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
    //   debugPrint('OnDisconnected callback is solicited, this is correct');
    // }
    // 延时10s执行重连
    // Future.delayed(const Duration(seconds: 10), () {
    //   debugPrint('start reconnecting');
    //   // reconnect();
    // });
  }

  /// The unsolicited disconnect callback
  void _onAutoReconnect() {
    if (isConnected()) {
      return;
    }
    debugPrint(
        'EXAMPLE::onAutoReconnect client callback - Client auto reconnection sequence will start');
    connect();
  }

  /// The successful connect callback
  void _onConnected() {
    debugPrint('OnConnected client callback - Client connection was sucessful');
    // TODO: eventbus发广播，通知长连接建立
    bytedeskEventBus.fire(
        ConnectionEventBus(BytedeskConstants.CONNECTION_STATUS_CONNECTED));
  }

  /// Pong callback
  void _onPong() {
    debugPrint('Ping response client callback invoked');
  }

  bool isConnected() {
    return mqttClient?.connectionStatus?.state == MqttConnectionState.connected;
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

  void sendMessageRest(String uid, String type, String content) {}
}
