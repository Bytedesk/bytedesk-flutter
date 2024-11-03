/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2023-08-01 14:26:10
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-17 17:01:06
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'package:equatable/equatable.dart';
import 'user_protobuf.dart';
import '../protobuf/message.pb.dart' as protomsg;

class Thread extends Equatable {
  //
  String? uid;
  String? topic;
  String? content;
  String? type;
  String? state;
  //
  bool? top;
  bool? unread;
  int? unreadCount;
  bool? mute;
  int? star;
  bool? folded;
  //
  String? client;
  String? extra;
  //
  UserProtobuf? user;
  String? updatedAt;
  //
  Thread(
      {this.uid,
      this.topic,
      this.content,
      this.type,
      this.state,
      //
      this.top,
      this.unread,
      this.unreadCount,
      this.mute,
      this.star,
      this.folded,
      //
      this.client,
      this.extra,
      //
      this.user,
      // this.agent,
      //
      this.updatedAt})
      : super();

  //
  static Thread fromJson(dynamic json) {
    return Thread(
      uid: json['uid'],
      topic: json['topic'],
      content: json['content'],
      type: json['type'],
      state: json['status'],
      //
      top: json['top'],
      unread: json['unread'],
      unreadCount: json['unreadCount'],
      mute: json['mute'],
      star: json['star'],
      folded: json['folded'],
      //
      client: json['client'],
      extra: json['extra'],
      //
      user: UserProtobuf.fromJson(json['user']),
      //
      updatedAt: json['updatedAt'],
    );
  }

  //
  static Thread fromProto(protomsg.Message messageProto) {
    return Thread(
      uid: messageProto.thread.uid,
      topic: messageProto.thread.topic,
      content: messageProto.content,
      type: messageProto.thread.type,
      state: messageProto.thread.status,
      unreadCount: 1,
      //
      client: messageProto.client,
      extra: messageProto.thread.extra,
      //
      user: UserProtobuf.fromThreadProto(messageProto),
      updatedAt: messageProto.createdAt,
    );
  }

  //
  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'topic': topic,
        'content': content,
        'type': type,
        'status': state,
        //
        'top': top,
        'unread': unread,
        'unreadCount': unreadCount,
        'mute': mute,

        'star': star,
        'folded': folded,
        //
        'client': client,
        'extra': extra,
        //
        'user': user?.toJson(),
        // 'agent': agent,
        //
        'updatedAt': updatedAt,
      };

  //
  Map<String, dynamic> toMap(String currentUid) => <String, dynamic>{
        'uid': uid,
        'type': type,
        'content': content,
        'status': state,
        'createdAt': updatedAt,
        'client': client,
        'extra': extra,
        //
        'topic': topic,
        //
        'userUid': user?.uid,
        'userNickname': user?.nickname,
        'userAvatar': user?.avatar,
        //
        'currentUid': currentUid
      };

  //
  static Thread init() {
    return Thread(
      uid: '',
      topic: '',
      content: '',
      type: '',
      state: '',
      //
      top: false,
      unread: false,
      unreadCount: 0,
      mute: false,
      star: 0,
      folded: false,
      //
      client: '',
      extra: '',
      //
      user: UserProtobuf.init(),
      // agent: '',
      //
      updatedAt: '',
    );
  }

  //
  @override
  List<Object> get props => [uid!];
}
