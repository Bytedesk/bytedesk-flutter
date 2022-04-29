import 'package:bytedesk_kefu/http/bytedesk_user_api.dart';

class TicketRepository {
  final BytedeskUserHttpApi bytedeskHttpApi = BytedeskUserHttpApi();

  TicketRepository();

  // Future<List<HelpCategory>> getHelpTicketCategories() async {
  //   return await bytedeskHttpApi.getHelpTicketCategories();
  // }

  // Future<JsonResult> submitTicket(String? content, List<String> imageUrls) async {
  //   return await bytedeskHttpApi.submitTicket(content, imageUrls);
  // }

  Future<String> upload(String? filePath) async {
    return await bytedeskHttpApi.upload(filePath);
  }
}
