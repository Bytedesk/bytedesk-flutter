/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-13 21:13:59
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
// // import 'package:equatable/equatable.dart';

// class Friend {
//   // extends ISuspensionBean

//   final String? uid;
//   final String? username;
//   final String? nickname;
//   final String? avatar;
//   final String? description;
//   final String? mobile;
//   final double? latitude;
//   final double? longtitude;
//   String? tagIndex;
//   String? namePinyin;

//   Friend(
//       {this.uid,
//       this.username,
//       this.nickname,
//       this.avatar,
//       this.description,
//       this.mobile,
//       this.latitude,
//       this.longtitude,
//       this.tagIndex,
//       this.namePinyin});

//   // @override
//   // List<Object> get props => [uid, username, nickname, avatar, description, tagIndex, namePinyin];

//   static Friend fromJson(dynamic json) {
//     return Friend(
//         uid: json['uid'],
//         username: json['username'],
//         nickname: json['nickname'],
//         avatar: json['avatar'],
//         description: json['description'],
//         mobile: json['mobile']);
//   }

//   // TODO: 未显示距离
//   static Friend fromElasticJson(dynamic json) {
//     return Friend(
//         uid: json['uid'],
//         username: json['username'],
//         nickname: json['nickname'],
//         avatar: json['avatar'],
//         description: json['description'],
//         mobile: json['mobile'],
//         latitude: json['location']['lat'],
//         longtitude: json['location']['lon']);
//   }

//   // @override
//   // String? getSuspensionTag() => tagIndex;

// }
