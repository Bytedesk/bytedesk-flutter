/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-05-17 10:48:45
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-05-17 17:20:34
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  技术/商务联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'package:equatable/equatable.dart';

import 'user.dart';

class Data {
  final String? accessToken;
  final User? user;

  const Data({
    this.accessToken,
    this.user,
  }) : super();

  static Data fromJson(dynamic json) {
    return Data(
      accessToken: json['accessToken'],
      user: json['user'] == null ? null : User.fromJson(json['user']),
    );
  }
}

class Auth extends Equatable {
  final String? message;
  final int? code;
  final Data? data;

  const Auth({
    this.message,
    this.code,
    this.data,
  }) : super();

  static Auth fromJson(dynamic json) {
    return Auth(
        message: json['message'],
        code: json['code'],
        data: json['data'] == null ? null : Data.fromJson(json['data']));
  }

  @override
  List<Object> get props => [];
}
