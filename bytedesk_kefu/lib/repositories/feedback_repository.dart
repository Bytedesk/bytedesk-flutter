import 'package:bytedesk_kefu/http/bytedesk_feedback_api.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';

class FeedbackRepository {
  final BytedeskFeedbackHttpApi bytedeskHttpApi = BytedeskFeedbackHttpApi();

  FeedbackRepository();

  Future<List<HelpCategory>> getHelpFeedbackCategories(String? uid) async {
    return await bytedeskHttpApi.getHelpFeedbackCategories(uid);
  }

  Future<JsonResult> submitFeedback(
      String? content, List<String>? imageUrls) async {
    return await bytedeskHttpApi.submitFeedback(content, imageUrls);
  }

  Future<String> upload(String? filePath) async {
    return await bytedeskHttpApi.upload(filePath);
  }
}
