import 'package:bytedesk_kefu/http/bytedesk_message_api.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/message.dart';
import 'package:bytedesk_kefu/model/requestAnswer.dart';
import 'package:bytedesk_kefu/model/requestCategory.dart';
import 'package:bytedesk_kefu/model/uploadJsonResult.dart';

class MessageRepository {
  final BytedeskMessageHttpApi bytedeskHttpApi = BytedeskMessageHttpApi();

  MessageRepository();

  Future<JsonResult> sendMessageRest(String? jsonString) async {
    return await bytedeskHttpApi.sendMessageRest(jsonString);
  }

  Future<List<Message>> loadHistoryMessages(
      String? uid, int? page, int? size) async {
    return await bytedeskHttpApi.loadHistoryMessages(uid, page, size);
  }

  Future<List<Message>> loadTopicMessages(
      String? topic, int? page, int? size) async {
    return await bytedeskHttpApi.loadTopicMessages(topic, page, size);
  }

  Future<List<Message>> loadChannelMessages(
      String? cid, int? page, int? size) async {
    return await bytedeskHttpApi.loadChannelMessages(cid, page, size);
  }

  Future<List<Message>> loadUnreadMessages(
      String? wid, int? page, int? size) async {
    return await bytedeskHttpApi.loadUnreadMessages(wid, page, size);
  }

  Future<List<Message>> loadUnreadVisitorMessages(int? page, int? size) async {
    return await bytedeskHttpApi.loadUnreadMessagesVisitor(page, size);
  }

  Future<List<Message>> loadUnreadAgentMessages(int? page, int? size) async {
    return await bytedeskHttpApi.loadUnreadMessagesAgent(page, size);
  }

  Future<RequestAnswerResult> queryAnswer(String? tid, String? aid, String? mid) async {
    return await bytedeskHttpApi.queryAnswer2(tid, aid, mid);
  }

  Future<RequestCategoryResult> queryCategory(
      String? tid, String? cid) async {
    return await bytedeskHttpApi.queryCategory(tid, cid);
  }

  Future<RequestAnswerResult> messageAnswer(String? wid, String? content) async {
    return await bytedeskHttpApi.messageAnswer(wid, content);
  }

  Future<RequestAnswerResult> rateAnswer(
      String? aid, String? mid, bool? rate) async {
    return await bytedeskHttpApi.rateAnswer(aid, mid, rate);
  }

  Future<UploadJsonResult> uploadImage(String? filePath) async {
    return await bytedeskHttpApi.uploadImage(filePath);
  }

  Future<UploadJsonResult> uploadVideo(String? filePath) async {
    return await bytedeskHttpApi.uploadVideo(filePath);
  }
}
