/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-08-15 16:58:05
 * @LastEditors: jack ning github@bytedesk.com
 * @LastEditTime: 2024-10-05 12:14:27
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

import 'organization.dart';

class User extends Equatable {
  final String? uid;
  final String? username;
  final String? nickname;
  final String? email;
  final String? mobile;
  final String? avatar;
  final String? description;
  final String? platform;
  //
  final bool? enabled;
  final bool? superUser;
  final bool? emailVerified;
  final bool? mobileVerified;
  //
  final Organiztion? currentOrganization;
  // final SimpleGrantedAuthority?[] authorities;

  const User({
    this.uid,
    this.username,
    this.nickname,
    this.email,
    this.mobile,
    this.avatar,
    this.description,
    this.platform,
    this.enabled,
    this.superUser,
    this.emailVerified,
    this.mobileVerified,
    this.currentOrganization,
  });

  @override
  List<Object> get props => [uid!];

  static User fromJson(dynamic json) {
    if (json == null) return User.init();

    return User(
      uid: json['uid'],
      username: json['username'],
      nickname: json['nickname'],
      email: json['email'],
      mobile: json['mobile'],
      avatar: json['avatar'],
      description: json['description'],
      platform: json['platform'],
      enabled: json['enabled'],
      superUser: json['superUser'],
      emailVerified: json['emailVerified'],
      mobileVerified: json['mobileVerified'],
      //
      currentOrganization: json['currentOrganization'] != null
          ? Organiztion.fromJson(json['currentOrganization'])
          : Organiztion.init(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "uid": uid,
        "username": username,
        "nickname": nickname,
        "email": email,
        "mobile": mobile,
        "avatar": avatar,
        "description": description,
        "platform": platform,
        "enabled": enabled,
        "superUser": superUser,
        "emailVerified": emailVerified,
      };

  static User init() {
    return const User(
      uid: '',
      username: '',
      nickname: '',
      avatar: '',
      mobile: '',
      description: '',
    );
  }
}
