/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-05-17 15:12:35
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  技术/商务联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

class JsonResult extends Equatable {
  final String? message;
  final int? code;
  final dynamic data;

  const JsonResult({this.message, this.code, this.data}) : super();

  static JsonResult fromJson(dynamic json) {
    return JsonResult(
        message: json["message"], 
        code: json["code"], 
        data: json["data"]
      );
  }

  @override
  List<Object> get props => [];
}
