/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-08-12 19:09:37
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-08 10:33:39
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import '../protobuf/message.pb.dart' as protomsg;
import 'message_protobuf.dart';

class UserProtobuf {
  //
  String? uid;
  String? nickname;
  String? avatar;
  //
  UserProtobuf({this.uid, this.nickname, this.avatar});

  static UserProtobuf fromJson(dynamic json) {
    return UserProtobuf(
      uid: json['uid'],
      nickname: json['nickname'],
      avatar: json['avatar'],
    );
  }

  static UserProtobuf fromThreadProto(protomsg.Message messageProto) {
    return UserProtobuf(
      uid: messageProto.thread.user.uid,
      nickname: messageProto.thread.user.nickname,
      avatar: messageProto.thread.user.avatar,
    );
  }

  static UserProtobuf fromProto(protomsg.Message messageProto) {
    return UserProtobuf(
      uid: messageProto.user.uid,
      nickname: messageProto.user.nickname,
      avatar: messageProto.user.avatar,
    );
  }

  static UserProtobuf fromProtobuf(MessageProtobuf messageProtobuf) {
    return UserProtobuf(
      uid: messageProtobuf.user!.uid!,
      nickname: messageProtobuf.user!.nickname!,
      avatar: messageProtobuf.user!.avatar!,
    );
  }

  //
  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'nickname': nickname,
        'avatar': avatar,
      };

  //
  static UserProtobuf init() {
    return UserProtobuf(
      uid: '',
      nickname: '',
      avatar: '',
    );
  }

  // @override
  // List<Object?> get props => [uid];
  //
}
