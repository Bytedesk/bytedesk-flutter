/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-10 19:09:46
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

class UploadJsonResult extends Equatable {
  final String? message;
  final int? code;
  final String? url;

  const UploadJsonResult({this.message, this.code, this.url}) : super();

  static UploadJsonResult fromJson(dynamic json) {
    return UploadJsonResult(
        message: json["message"],
        code: json["code"],
        url: json['data']);
  }

  @override
  List<Object> get props => [url!];
}
