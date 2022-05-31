import 'dart:convert';

import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:sp_util/sp_util.dart';
import 'package:http/http.dart' as http;

class BytedeskFeedbackHttpApi extends BytedeskBaseHttpApi {
  //
  // 获取意见反馈分类
  Future<List<HelpCategory>> getHelpFeedbackCategories(String? uid) async {
    //
    // final categoriesUrl =
    //     '$baseUrl/visitor/api/category/feedback?uid=$uid&client=$client';
    final categoriesUrl = Uri.http(BytedeskConstants.host,
        '/visitor/api/category/feedback', {'uid': uid, 'client': client});
    BytedeskUtils.printLog("categories Url $categoriesUrl");
    final initResponse = await this.httpClient.get(categoriesUrl);
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("responseJson $responseJson");
    //
    List<HelpCategory> categories = (responseJson['data'] as List<dynamic>)
        .map((item) => HelpCategory.fromJson(item))
        .toList();

    return categories;
  }

  // TODO: 提交意见反馈
  Future<JsonResult> submitFeedback(
      String? content, List<String>? imageUrls) async {
    //
    var body = json
        .encode({"content": content, "images": imageUrls, "client": client});
    // final initUrl = '$baseUrl/api/feedback/create';
    final initUrl = Uri.http(BytedeskConstants.host, '/api/feedback/create');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return JsonResult.fromJson(responseJson);
  }

  // https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html
  Future<String> upload(String? filePath) async {
    //
    String fileName = filePath!.split("/").last;
    String? username = SpUtil.getString(BytedeskConstants.uid);

    final uploadUrl = '$baseUrl/visitor/api/upload/image';
    BytedeskUtils.printLog(
        "fileName $fileName, username $username, upload Url $uploadUrl");

    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', uri)
      ..fields['file_name'] = fileName
      ..fields['username'] = username!
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    http.Response response =
        await http.Response.fromStream(await request.send());
    // BytedeskUtils.printLog("Result: ${response.body}");

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson = json.decode(utf8decoder.convert(response.bodyBytes));
    BytedeskUtils.printLog("responseJson $responseJson");

    String url = responseJson['data'];
    BytedeskUtils.printLog('url:' + url);
    return url;
  }
}
