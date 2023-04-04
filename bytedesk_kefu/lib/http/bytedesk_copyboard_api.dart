// import 'dart:convert';

// import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
// // import 'package:bytedesk_kefu/model/copyboard.dart';
// import 'package:bytedesk_kefu/model/jsonResult.dart';
// import 'package:bytedesk_kefu/model/message.dart';
// import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
// import 'package:bytedesk_kefu/util/bytedesk_events.dart';
// import 'package:bytedesk_kefu/util/bytedesk_utils.dart';

// //
// class BytedeskCopyBoardHttpApi extends BytedeskBaseHttpApi {

//    //
//   Future<JsonResult> sendMessageRest(String? jsonString) async {
//     //
//     var body = json.encode({"json": jsonString, "client": client});
//     //
//     final sendMessageUrl =
//         BytedeskUtils.getHostUri('/api/messages/send');
//     final sendMessageResponse = await httpClient.post(sendMessageUrl,
//         headers: getHeaders(), body: body);
//     //解决json解析中的乱码问题
//     Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
//     //将string类型数据 转换为json类型的数据
//     final responseJson =
//         json.decode(utf8decoder.convert(sendMessageResponse.bodyBytes));
//     BytedeskUtils.printLog("responseJson $responseJson");
//     // 判断token是否过期
//     if (responseJson.toString().contains('invalid_token')) {
//       bytedeskEventBus.fire(InvalidTokenEventBus());
//     }
//     //
//     return JsonResult(message: "发送消息成功", statusCode: 200, data: jsonString);
//   }

//   Future<List<Message>> loadTopicMessages(
//       String? topic, int? page, int? size) async {
//     //
//     final loadTopicMessagesUrl =
//         BytedeskUtils.getHostUri('/api/messages/topic', {
//       'page': page.toString(),
//       'size': size.toString(),
//       'topic': topic,
//       'client': client
//     });
//     final initResponse =
//         await httpClient.get(loadTopicMessagesUrl, headers: getHeaders());
//     //
//     //解决json解析中的乱码问题
//     Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
//     //将string类型数据 转换为json类型的数据
//     final responseJson =
//         json.decode(utf8decoder.convert(initResponse.bodyBytes));
//     // 判断token是否过期
//     if (responseJson.toString().contains('invalid_token')) {
//       bytedeskEventBus.fire(InvalidTokenEventBus());
//     }
//     //
//     List<Message> messageList =
//         (responseJson['data']['content'] as List<dynamic>)
//             .map((item) => Message.fromJson(item))
//             .toList();

//     return messageList;
//   }

//   //
//   // Future<List<CopyBoard>> getCopyBoards(int? page, int? size) async {
//   //   //
//   //   final threadUrl = Uri.http(
//   //       BytedeskConstants.host,
//   //       '/api/copyboard/query',
//   //       {'page': page.toString(), 'size': size.toString(), 'client': client});
//   //   final initResponse = await httpClient.get(threadUrl, headers: getHeaders());
//   //   //
//   //   //解决json解析中的乱码问题
//   //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
//   //   //将string类型数据 转换为json类型的数据
//   //   final responseJson =
//   //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
//   //   // BytedeskUtils.printLog("getVisitorThreads responseJson $responseJson");
//   //   // 判断token是否过期
//   //   if (responseJson.toString().contains('invalid_token')) {
//   //     bytedeskEventBus.fire(InvalidTokenEventBus());
//   //   }

//   //   List<CopyBoard> copyboardList = (responseJson['data']["content"] as List<dynamic>)
//   //       .map((item) => CopyBoard.fromJson(item))
//   //       .toList();
//   //   //
//   //   return copyboardList;
//   // }

//   // Future<JsonResult> sendCopyBoard(String? content, String? type) async {
//   //   //
//   //   var body = json
//   //       .encode({"content": content, "type": type, "client": client});
//   //   final initUrl = BytedeskUtils.getHostUri('/api/copyboard/create');
//   //   final initResponse =
//   //       await httpClient.post(initUrl, headers: getHeaders(), body: body);
//   //   //解决json解析中的乱码问题
//   //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
//   //   //将string类型数据 转换为json类型的数据
//   //   final responseJson =
//   //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
//   //   BytedeskUtils.printLog("responseJson $responseJson");
//   //   // 判断token是否过期
//   //   if (responseJson.toString().contains('invalid_token')) {
//   //     bytedeskEventBus.fire(InvalidTokenEventBus());
//   //   }
//   //   // 
//   //   return JsonResult.fromJson(responseJson);
//   // }


// }
