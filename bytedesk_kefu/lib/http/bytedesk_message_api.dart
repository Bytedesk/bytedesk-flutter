import 'dart:convert';
import 'dart:io';

import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/message.dart';
import 'package:bytedesk_kefu/model/requestAnswer.dart';
import 'package:bytedesk_kefu/model/uploadJsonResult.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:sp_util/sp_util.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class BytedeskMessageHttpApi extends BytedeskBaseHttpApi {
  //
  Future<JsonResult> sendMessageRest(String? jsonString) async {
    //
    var body = json.encode({"json": jsonString, "client": client});
    //
    final sendMessageUrl =
        Uri.http(BytedeskConstants.host, '/api/messages/send');
    // final sendMessageUrl = '$baseUrl/api/messages/send';
    final sendMessageResponse = await this
        .httpClient
        .post(sendMessageUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(sendMessageResponse.bodyBytes));
    print("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }
    //
    return JsonResult(message: "发送消息成功", statusCode: 200, data: jsonString);
  }

  Future<List<Message>> loadHistoryMessages(
      String? uid, int? page, int? size) async {
    //
    final loadHistoryMessagesUrl = Uri.http(
        BytedeskConstants.host, '/api/messages/user', {
      'page': page.toString(),
      'size': size.toString(),
      'uid': uid,
      'client': client
    });
    // print("loadHistoryMessages Url $loadHistoryMessages");
    final initResponse = await this
        .httpClient
        .get(loadHistoryMessagesUrl, headers: getHeaders());
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }
    //
    List<Message> messageList =
        (responseJson['data']['content'] as List<dynamic>)
            .map((item) => Message.fromJson(item))
            .toList();

    return messageList;
  }

  Future<List<Message>> loadTopicMessages(
      String? topic, int? page, int? size) async {
    //
    // final loadTopicMessagesUrl =
    //     '$baseUrl/api/messages/topic?topic=$topic&page=$page&size=$size&client=$client';
    final loadTopicMessagesUrl =
        Uri.http(BytedeskConstants.host, '/api/messages/topic', {
      'page': page.toString(),
      'size': size.toString(),
      'topic': topic,
      'client': client
    });
    // print("loadHistoryMessages Url $loadHistoryMessages");
    final initResponse =
        await this.httpClient.get(loadTopicMessagesUrl, headers: getHeaders());
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }
    //
    List<Message> messageList =
        (responseJson['data']['content'] as List<dynamic>)
            .map((item) => Message.fromJson(item))
            .toList();

    return messageList;
  }

  Future<List<Message>> loadChannelMessages(
      String? cid, int? page, int? size) async {
    //
    // final loadChannelMessagesUrl =
    //     '$baseUrl/api/messages/channel?cid=$cid&page=$page&size=$size&client=$client';
    final loadChannelMessagesUrl = Uri.http(
        BytedeskConstants.host, '/api/messages/channel', {
      'page': page.toString(),
      'size': size.toString(),
      'cid': cid,
      'client': client
    });
    // print("loadChannelMessagesUrl Url $loadHistoryMessages");
    final initResponse = await this
        .httpClient
        .get(loadChannelMessagesUrl, headers: getHeaders());

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }
    //
    List<Message> messageList =
        (responseJson['data']['content'] as List<dynamic>)
            .map((item) => Message.fromJson(item))
            .toList();

    return messageList;
  }

  //
  Future<RequestAnswerResult> queryAnswer(String? tid, String? aid) async {
    //
    // final queryAnswerUrl =
    //     '$baseUrl/api/answer/query?tid=$tid&aid=$aid&client=$client';
    final queryAnswerUrl = Uri.http(BytedeskConstants.host, '/api/answer/query',
        {'tid': tid, 'aid': aid, 'client': client});
    print("query Url $queryAnswerUrl");
    final initResponse =
        await this.httpClient.get(queryAnswerUrl, headers: getHeaders());
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }
    //
    return RequestAnswerResult.fromJson(responseJson);
  }

  //
  Future<RequestAnswerResult> messageAnswer(
      String? type, String? wid, String? aid, String? content) async {
    //
    // final messageAnswerUrl =
    //     '$baseUrl/api/v2/answer/message?type=$type&wid=$wid&aid=$aid&content=$content&client=$client';
    final messageAnswerUrl = Uri.http(
        BytedeskConstants.host, '/api/v2/answer/message', {
      'type': type,
      'wid': wid,
      'aid': aid,
      'content': content,
      'client': client
    });
    print("message Url $messageAnswerUrl");
    final initResponse =
        await this.httpClient.get(messageAnswerUrl, headers: getHeaders());
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    print("messageAnswer responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }
    //
    return RequestAnswerResult.fromJson(responseJson);
  }

  //
  Future<RequestAnswerResult> rateAnswer(
      String? aid, String? mid, bool? rate) async {
    //
    // final rateAnswerUrl =
    //     '$baseUrl/api/answer/rate?aid=$aid&mid=$mid&rate=$rate&client=$client';
    final rateAnswerUrl = Uri.http(BytedeskConstants.host, '/api/answer/rate',
        {'aid': aid, 'mid': mid, 'rate': rate, 'client': client});
    print("rate Url $rateAnswerUrl");
    final initResponse =
        await this.httpClient.get(rateAnswerUrl, headers: getHeaders());
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }
    //
    return RequestAnswerResult.fromRateJson(responseJson);
  }

  // https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html
  Future<UploadJsonResult> uploadImage(String? filePath) async {
    //
    String? fileName = filePath!.split("/").last;
    String? username = SpUtil.getString(BytedeskConstants.uid);

    final uploadUrl =
        '${BytedeskConstants.httpUploadUrl}/visitor/api/upload/image';
    print(
        "uploadImage fileName $fileName, username $username, upload Url $uploadUrl");

    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', uri)
      ..fields['file_name'] = username! + "_" + fileName
      ..fields['username'] = username
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    http.Response response =
        await http.Response.fromStream(await request.send());
    // print("Result: ${response.body}");

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson = json.decode(utf8decoder.convert(response.bodyBytes));
    print("upload image responseJson $responseJson");
    //
    return UploadJsonResult.fromJson(responseJson);
  }

  // https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html
  Future<UploadJsonResult> uploadVideo(String? filePath) async {
    // FIXME: image_picker有bug，选择视频后缀为.jpg，此处替换一下
    String? fileName = filePath!.split("/").last.replaceAll(".jpg", ".mp4");
    String? username = SpUtil.getString(BytedeskConstants.uid);
    final uploadUrl =
        '${BytedeskConstants.httpUploadUrl}/visitor/api/upload/video';
    print(
        "uploadVideo fileName $fileName, username $username, upload Url $uploadUrl");
    //
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "video/mp4",
    };
    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', uri)
      ..fields['file_name'] = username! + "_" + fileName
      ..fields['username'] = username
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('file', filePath,
          // FIXME: 设置不起作用？
          contentType: MediaType('video', 'mp4')));

    http.Response response =
        await http.Response.fromStream(await request.send());
    // print("Result: ${response.body}");

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson = json.decode(utf8decoder.convert(response.bodyBytes));
    print("upload Video responseJson $responseJson");
    //
    return UploadJsonResult.fromJson(responseJson);
  }
}
