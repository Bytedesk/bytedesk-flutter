/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-06 10:56:09
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
// import 'message.dart';
import 'message_protobuf.dart';

class RequestThreadResult extends Equatable {
  final String? message;
  final int? code;
  final MessageProtobuf? data;

  const RequestThreadResult({this.message, this.code, this.data}) : super();

  static RequestThreadResult fromJson(dynamic json) {
    return RequestThreadResult(
        message: json["message"],
        code: json["code"],
        data: MessageProtobuf.fromJson(json["data"]));
  }

  @override
  List<Object> get props => [data!.uid!];
}
