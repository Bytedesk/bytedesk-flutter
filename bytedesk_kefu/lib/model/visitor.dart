/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jack ning github@bytedesk.com
 * @LastEditTime: 2024-10-05 11:58:49
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

class Visitor extends Equatable {
  final String? uid;
  final String? nickname;
  final String? avatar;
  final String? type;
  final String? extra;

  const Visitor({
    this.uid,
    this.nickname,
    this.avatar,
    this.type,
    this.extra
  });

  @override
  List<Object> get props => [uid!];

  static Visitor fromJson(dynamic json) {
    if (json == null) return Visitor.defaultVisitor();

    return Visitor(
      uid: json['uid'],
      nickname: json['nickname'],
      avatar: json['avatar'],
      type: json['type'],
      extra: json['extra'],
    );
  }

  static Visitor defaultVisitor() {
    return const Visitor(
      uid: '',
      nickname: '',
      avatar: '',
      type: '',
      extra: '',
    );
  }
}
