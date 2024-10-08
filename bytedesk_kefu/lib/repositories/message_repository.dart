/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-06 14:35:37
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'package:bytedesk_kefu/http/bytedesk_message_api.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/uploadJsonResult.dart';

class MessageRepository {
  final BytedeskMessageHttpApi bytedeskHttpApi = BytedeskMessageHttpApi();

  MessageRepository();

  Future<JsonResult> sendMessageRest(String? jsonString) async {
    return await bytedeskHttpApi.sendMessageRest(jsonString);
  }

  // Future<JsonResult> sendZhipuAIMessageRest(String? jsonString) async {
  //   return await bytedeskHttpApi.sendZhipuAIMessageRest(jsonString);
  // }

  // Future<List<Message>> loadHistoryMessages(
  //     String? uid, int? page, int? size) async {
  //   return await bytedeskHttpApi.loadHistoryMessages(uid, page, size);
  // }

  // Future<List<Message>> loadTopicMessages(
  //     String? topic, int? page, int? size) async {
  //   return await bytedeskHttpApi.loadTopicMessages(topic, page, size);
  // }

  // Future<List<Message>> loadUnreadMessages(
  //     String? wid, int? page, int? size) async {
  //   return await bytedeskHttpApi.loadUnreadMessages(wid, page, size);
  // }

  // Future<List<Message>> loadUnreadVisitorMessages(int? page, int? size) async {
  //   return await bytedeskHttpApi.loadUnreadMessagesVisitor(page, size);
  // }

  // Future<List<Message>> loadUnreadAgentMessages(int? page, int? size) async {
  //   return await bytedeskHttpApi.loadUnreadMessagesAgent(page, size);
  // }

  Future<UploadJsonResult> uploadImage(String? filePath) async {
    return await bytedeskHttpApi.uploadImage(filePath);
  }

  Future<UploadJsonResult> uploadImageBytes(
      String? fileName, List<int>? fileBytes, String? mimeType) async {
    return await bytedeskHttpApi.uploadImageBytes(
        fileName, fileBytes, mimeType);
  }

  Future<UploadJsonResult> uploadVideo(String? filePath) async {
    return await bytedeskHttpApi.uploadVideo(filePath);
  }

  Future<UploadJsonResult> uploadVideoBytes(
      String? fileName, List<int>? fileBytes, String? mimeType) async {
    return await bytedeskHttpApi.uploadVideoBytes(
        fileName, fileBytes, mimeType);
  }
}
