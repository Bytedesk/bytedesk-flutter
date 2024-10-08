import 'dart:convert';
// import 'dart:io';

import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
import 'package:bytedesk_kefu/model/requestThread.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

class BytedeskThreadHttpApi extends BytedeskBaseHttpApi {
  
  // 访客请求会话
  Future<RequestThreadResult> requestThread(String? sid,  String? type, bool? forceAgent) async {
    //
    String orgUid = SpUtil.getString(BytedeskConstants.VISITOR_ORGUID)!;
    String uid = SpUtil.getString(BytedeskConstants.VISITOR_UID)!;
    String nickname = SpUtil.getString(BytedeskConstants.VISITOR_NICKNAME)!;
    String avatar = SpUtil.getString(BytedeskConstants.VISITOR_AVATAR)!;
    //
    final requestThreadUrl =
        BytedeskUtils.getHostUri('/visitor/api/v1/thread', {
      'orgUid': orgUid,
      'type': type,
      'sid': sid,
      //
      'uid': uid,
      'nickname': nickname,
      'avatar': avatar,
      //
      'forceAgent': forceAgent.toString(),
      'client': client
    });
    final requestThreadResponse = await httpClient.get(requestThreadUrl,
        headers: getHeadersForVisitor());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(requestThreadResponse.bodyBytes));
    debugPrint("$requestThreadUrl requestThread responseJson $responseJson");

    return RequestThreadResult.fromJson(responseJson);
  }

  //
  // // 客服端-加载会话列表
  // Future<List<Thread>> getThreads() async {
  //   // final threadUrl = '$baseUrl/api/thread/get?client=$client';
  //   final threadUrl =
  //       BytedeskUtils.getHostUri('/api/thread/get', {'client': client});
  //   // debugPrint("thread Url $threadUrl");
  //   final initResponse = await httpClient.get(threadUrl, headers: getHeaders());

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   List<Thread> threadList = [];

  //   // List<Thread> agentThreadList =
  //   //     (responseJson['data']['agentThreads'] as List<dynamic>)
  //   //         .map((item) => Thread.fromWorkGroupJson(item))
  //   //         .toList();
  //   // threadList.addAll(agentThreadList);

  //   // List<Thread> contactThreadList =
  //   //     (responseJson['data']['contactThreads'] as List<dynamic>)
  //   //         .map((item) => Thread.fromContactJson(item))
  //   //         .toList();
  //   // threadList.addAll(contactThreadList);

  //   // List<Thread> groupThreadList =
  //   //     (responseJson['data']['groupThreads'] as List<dynamic>)
  //   //         .map((item) => Thread.fromGroupJson(item))
  //   //         .toList();
  //   // threadList.addAll(groupThreadList);

  //   return threadList;
  // }

  // // 访客端-加载访客会话列表-分页
  // Future<List<Thread>> getVisitorThreads(int? page, int? size) async {
  //   //
  //   final threadUrl = BytedeskUtils.getHostUri('/api/thread/visitor/history', {
  //     'pageNumber': page.toString(),
  //     'pageSize': size.toString(),
  //     'client': client
  //   });
  //   final initResponse = await httpClient.get(threadUrl, headers: getHeaders());
  //   //
  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("getVisitorThreads responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   List<Thread> threadList = [];
  //   //
  //   return threadList;
  // }

  // 访客端-加载访客会话列表-全部
  // Future<List<Thread>> getVisitorThreadsAll() async {
  //   //
  //   final threadUrl = BytedeskUtils.getHostUri(
  //       '/api/thread/visitor/history/all', {'client': client});
  //   final initResponse = await httpClient.get(threadUrl, headers: getHeaders());
  //   //
  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   debugPrint("getVisitorThreadsAll responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   List<Thread> threadList = (responseJson['data'] as List<dynamic>)
  //       .map((item) => Thread.fromWorkGroupJson2(item))
  //       .toList();
  //   //
  //   return threadList;
  // }

  // 请求客服会话
  // Future<RequestThreadResult> requestThread(
  //     String? wid, String? type, String? aid) async {
  //   //
  //   final threadUrl = BytedeskUtils.getHostUri('/api/thread/request',
  //       {'wId': wid, 'type': type, 'aId': aid, 'client': client});
  //   BytedeskUtils.printLog(threadUrl);
  //   final initResponse = await httpClient.get(threadUrl, headers: getHeaders());

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   debugPrint("requestThread: $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return RequestThreadResult.fromJson(responseJson);
  // }

  // 请求人工客服，不管此工作组是否设置为默认机器人，只要有人工客服在线，则可以直接对接人工
  // Future<RequestThreadResult> requestAgent(String? sid, String? type) async {
  //   //
  //   final threadUrl = BytedeskUtils.getHostUri('/api/thread/request/agent',
  //       {'sid': sid, 'type': type, 'client': client});
  //   debugPrint("request agent Url $threadUrl");
  //   final initResponse = await httpClient.get(threadUrl, headers: getHeaders());

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   debugPrint("requestAgent $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return RequestThreadResult.fromJson(responseJson);
  // }

  // // 请求一对一会话
  // Future<RequestThreadResult> requestContactThread(String? cid) async {
  //   //
  //   final threadUrl = BytedeskUtils.getHostUri(
  //       '/api/thread/contact', {'cid': cid, 'client': client});
  //   debugPrint("request contact thread Url $threadUrl");
  //   final initResponse = await httpClient.get(threadUrl, headers: getHeaders());

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   debugPrint("requestContactThread $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return RequestThreadResult.fromJson(responseJson);
  // }

  // // 请求群组会话
  // Future<RequestThreadResult> requestGroupThread(String? gid) async {
  //   //
  //   final threadUrl = BytedeskUtils.getHostUri(
  //       '/api/thread/group', {'gid': gid, 'client': client});
  //   debugPrint("request contact thread Url $threadUrl");
  //   final initResponse = await httpClient.get(threadUrl, headers: getHeaders());

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return RequestThreadResult.fromJson(responseJson);
  // }

  // // 会话置顶
  // Future<MarkThreadResult> markTop(String? tid) async {
  //   //
  //   String? uid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
  //   //
  //   var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
  //   final threadUrl = BytedeskUtils.getHostUri(
  //     '/api/v2/thread/mark/top',
  //   );
  //   final initResponse =
  //       await httpClient.post(threadUrl, headers: getHeaders(), body: body);

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return MarkThreadResult.fromJson(responseJson);
  // }

  // // 取消会话置顶
  // Future<MarkThreadResult> unmarkTop(String? tid) async {
  //   //
  //   String? uid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
  //   //
  //   var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
  //   final threadUrl = BytedeskUtils.getHostUri(
  //     '/api/v2/thread/unmark/top',
  //   );
  //   final initResponse =
  //       await httpClient.post(threadUrl, headers: getHeaders(), body: body);

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return MarkThreadResult.fromJson(responseJson);
  // }

  // // 会话免打扰
  // Future<MarkThreadResult> markNodisturb(String? tid) async {
  //   //
  //   String? uid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
  //   //
  //   var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
  //   final threadUrl = BytedeskUtils.getHostUri(
  //     '/api/v2/thread/mark/nodisturb',
  //   );
  //   final initResponse =
  //       await httpClient.post(threadUrl, headers: getHeaders(), body: body);

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return MarkThreadResult.fromJson(responseJson);
  // }

  // // 取消会话免打扰
  // Future<MarkThreadResult> unmarkNodisturb(String? tid) async {
  //   //
  //   String? uid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
  //   //
  //   var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
  //   final threadUrl = BytedeskUtils.getHostUri(
  //     '/api/v2/thread/unmark/nodisturb',
  //   );
  //   final initResponse =
  //       await httpClient.post(threadUrl, headers: getHeaders(), body: body);

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return MarkThreadResult.fromJson(responseJson);
  // }

  // // 会话未读
  // Future<MarkThreadResult> markUnread(String? tid) async {
  //   //
  //   String? uid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
  //   //
  //   var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
  //   final threadUrl = BytedeskUtils.getHostUri(
  //     '/api/v2/thread/mark/unread',
  //   );
  //   final initResponse =
  //       await httpClient.post(threadUrl, headers: getHeaders(), body: body);

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return MarkThreadResult.fromJson(responseJson);
  // }

  // // 取消会话未读
  // Future<MarkThreadResult> unmarkUnread(String? tid) async {
  //   //
  //   String? uid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
  //   //
  //   var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
  //   final threadUrl = BytedeskUtils.getHostUri(
  //     '/api/v2/thread/unmark/unread',
  //   );
  //   final initResponse =
  //       await httpClient.post(threadUrl, headers: getHeaders(), body: body);

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   // debugPrint("responseJson $responseJson");
  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return MarkThreadResult.fromJson(responseJson);
  // }

  // // 删除会话
  // Future<MarkThreadResult> delete(String? tid) async {
  //   //
  //   var body = json.encode({"tid": tid, "client": client});
  //   final initUrl = BytedeskUtils.getHostUri('/api/thread/delete');
  //   final initResponse =
  //       await httpClient.post(initUrl, headers: getHeaders(), body: body);

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson =
  //       json.decode(utf8decoder.convert(initResponse.bodyBytes));
  //   debugPrint("responseJson $responseJson");

  //   // 判断token是否过期
  //   if (responseJson.toString().contains('invalid_token')) {
  //     bytedeskEventBus.fire(InvalidTokenEventBus());
  //   }

  //   return MarkThreadResult.fromJson(responseJson);
  // }
}
