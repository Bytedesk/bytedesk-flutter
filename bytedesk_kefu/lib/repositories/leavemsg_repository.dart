import 'package:bytedesk_kefu/http/bytedesk_leavemsg_api.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';

class LeaveMsgRepository {
  final BytedeskLeaveMsgHttpApi bytedeskHttpApi = BytedeskLeaveMsgHttpApi();

  LeaveMsgRepository();

  Future<List<HelpCategory>> getHelpLeaveMsgCategories(String? uid) async {
    return await bytedeskHttpApi.getHelpLeaveMsgCategories(uid);
  }

  Future<JsonResult> submitLeaveMsg(
      String? content, List<String>? imageUrls) async {
    return await bytedeskHttpApi.submitLeaveMsg(content, imageUrls);
  }

  Future<String> upload(String? filePath) async {
    return await bytedeskHttpApi.upload(filePath);
  }
}
