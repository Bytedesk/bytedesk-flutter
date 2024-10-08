/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-10-05 12:13:49
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-06 10:54:31
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

import 'user_protobuf.dart';

class ThreadProtobuf extends Equatable {
  //
  final String? uid;
  final String? topic;
  final String? type;
  final String? status;
  final String? extra;
  //
  final UserProtobuf? user;

  const ThreadProtobuf({
    this.uid,
    this.topic,
    this.type,
    this.status,
    this.extra,
    //
    this.user,
  });

  static ThreadProtobuf fromJson(dynamic json) {
    return ThreadProtobuf(
      uid: json["uid"],
      topic: json["topic"],
      type: json["type"],
      status: json["status"],
      extra: json["extra"],
      //
      user: UserProtobuf.fromJson(json["user"]),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uid];
}
