/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-10-05 12:13:49
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-06 10:53:20
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
import 'package:equatable/equatable.dart';
import 'thread_protobuf.dart';
import 'user_protobuf.dart';

class MessageProtobuf extends Equatable {
  //
  final String? uid;
  final String? type;
  final String? content;
  final String? status;
  final String? createdAt;
  final String? client;
  final String? extra;
  //
  final ThreadProtobuf? thread;
  final UserProtobuf? user;

  const MessageProtobuf(
      {this.uid,
      this.type,
      this.content,
      this.status,
      this.createdAt,
      this.client,
      this.extra,
      //
      this.thread,
      this.user});

  //
  static MessageProtobuf fromJson(dynamic json) {
    return MessageProtobuf(
      uid: json['uid'],
      type: json['type'],
      content: json['content'],
      status: json['status'],
      createdAt: json['createdAt'],
      client: json['client'],
      extra: json['extra'],
      //
      thread: ThreadProtobuf.fromJson(json['thread']),
      user: UserProtobuf.fromJson(json['user']),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uid];
}
