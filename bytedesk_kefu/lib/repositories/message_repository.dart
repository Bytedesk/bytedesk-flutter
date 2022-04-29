import 'package:bytedesk_kefu/http/bytedesk_message_api.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/message.dart';
import 'package:bytedesk_kefu/model/requestAnswer.dart';
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

  Future<RequestAnswerResult> queryAnswer(String? tid, String? aid) async {
    return await bytedeskHttpApi.queryAnswer(tid, aid);
  }

  Future<RequestAnswerResult> messageAnswer(
      String? type, String? wid, String? aid, String? content) async {
    return await bytedeskHttpApi.messageAnswer(type, wid, aid, content);
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
