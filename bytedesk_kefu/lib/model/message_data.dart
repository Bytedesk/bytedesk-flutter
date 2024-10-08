/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-08-12 08:50:51
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-08-13 07:50:06
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

import 'message.dart';

class MessageData extends Equatable {
  //
  final List<Message>? messageList; //
  //
  final int? totalPages; //
  final int? totalElements; //
  final bool? last; //
  final int? numberOfElements; //
  final bool? first; //
  final bool? empty;
  //
  const MessageData({
    this.messageList,
    this.totalPages,
    this.totalElements,
    this.last,
    this.numberOfElements,
    this.first,
    this.empty,
  }) : super();
  //
  static MessageData fromJson(dynamic json) {
    return MessageData(
      messageList: (json['content'] as List<dynamic>)
          .map((item) => Message.fromJson(item))
          .toList(),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      last: json['last'],
      numberOfElements: json['numberOfElements'],
      first: json['first'],
      empty: json['empty'],
    );
  }

  //
  Map<String, dynamic> toJson() => <String, dynamic>{
        'content': messageList!.map((item) => item.toJson()).toList(),
        'totalPages': totalPages,
        'totalElements': totalElements,
        'last': last,
        'numberOfElements': numberOfElements,
        'first': first,
        'empty': empty,
      };
  //
  static MessageData init() {
    return const MessageData(
      messageList: [],
      totalPages: 0,
      totalElements: 0,
      last: true,
      numberOfElements: 0,
      first: true,
      empty: true,
    );
  }

  //
  @override
  List<Object> get props => [totalPages!];
}
