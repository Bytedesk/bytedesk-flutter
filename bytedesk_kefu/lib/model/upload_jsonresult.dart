/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-08-21 21:02:40
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-08-21 21:05:38
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
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class UploadJsonResult {
  String? message;
  int? code;
  String? data;
  AssetEntity? entity;

  UploadJsonResult({this.message, this.code, this.data, this.entity}) : super();

  static UploadJsonResult fromJson(dynamic json, AssetEntity entity) {
    return UploadJsonResult(
        message: json["message"],
        code: json["code"],
        data: json["data"],
        entity: entity);
  }
}
