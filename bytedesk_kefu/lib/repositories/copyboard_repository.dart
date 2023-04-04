// import 'package:bytedesk_kefu/http/bytedesk_copyboard_api.dart';
import 'package:bytedesk_kefu/http/bytedesk_message_api.dart';
import 'package:bytedesk_kefu/http/bytedesk_thread_api.dart';
// import 'package:bytedesk_kefu/model/copyboard.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/message.dart';
import 'package:bytedesk_kefu/model/requestThreadFileHelper.dart';

class CopyBoardRepository {
  //
  // final BytedeskCopyBoardHttpApi bytedeskHttpApi = BytedeskCopyBoardHttpApi();
  final BytedeskMessageHttpApi bytedeskHttpApi = BytedeskMessageHttpApi();

  final BytedeskThreadHttpApi bytedeskThreadHttpApi = BytedeskThreadHttpApi();

  CopyBoardRepository();

  // 请求文件助手会话
  Future<RequestThreadFileHelperResult> requestFileHelperThread() async {
    return bytedeskThreadHttpApi.requestFileHelperThread();
  }

  Future<List<Message>> getCopyBoards(
      String? topic, int? page, int? size) async {
    return await bytedeskHttpApi.loadTopicMessagesFileHelper(topic, page, size);
  }

  Future<JsonResult> sendCopyBoard(String? json) async {
    return await bytedeskHttpApi.sendMessageRest(json);
  }
}
