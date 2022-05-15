import 'package:bytedesk_kefu/http/bytedesk_leavemsg_api.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';

class LeaveMsgRepository {
  final BytedeskLeaveMsgHttpApi bytedeskHttpApi = BytedeskLeaveMsgHttpApi();

  LeaveMsgRepository();

  Future<List<HelpCategory>> getHelpLeaveMsgCategories(String? uid) async {
    return await bytedeskHttpApi.getHelpLeaveMsgCategories(uid);
  }

  // , List<String>? imageUrls
  Future<JsonResult> submitLeaveMsg(String? wid, String? aid, String? type, String? mobile, String? email, String? content) async {
    return await bytedeskHttpApi.submitLeaveMsg(wid, aid, type, mobile, email, content);
  }

  Future<String> upload(String? filePath) async {
    return await bytedeskHttpApi.upload(filePath);
  }
}
