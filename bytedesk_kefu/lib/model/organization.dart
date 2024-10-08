/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-08-15 16:57:40
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-08-15 16:57:46
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

class Organiztion extends Equatable {
  final String? uid;
  final String? name;
  final String? logo;
  final String? code;
  final String? description;

  const Organiztion({
    this.uid,
    this.name,
    this.logo,
    this.code,
    this.description,
  }) : super();

  //
  static Organiztion fromJson(dynamic json) {
    return Organiztion(
      uid: json['uid'],
      name: json['name'],
      logo: json['logo'],
      code: json['code'],
      description: json['description'],
    );
  }

  //
  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'name': name,
        'logo': logo,
        'code': code,
        'description': description,
      };

  //
  static Organiztion init() {
    return const Organiztion(
      uid: 'default_org_placeholder',
      name: '',
      logo: '',
      code: '',
      description: '',
    );
  }

  @override
  List<Object> get props => [uid!];
}
