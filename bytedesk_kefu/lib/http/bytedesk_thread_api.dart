import 'dart:convert';
// import 'dart:io';

import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
import 'package:bytedesk_kefu/model/markThread.dart';
import 'package:bytedesk_kefu/model/requestThread.dart';
import 'package:bytedesk_kefu/model/thread.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:sp_util/sp_util.dart';

class BytedeskThreadHttpApi extends BytedeskBaseHttpApi {
  //
  // 客服端-加载会话列表
  Future<List<Thread>> getThreads() async {
    // final threadUrl = '$baseUrl/api/thread/get?client=$client';
    final threadUrl =
        Uri.http(BytedeskConstants.host, '/api/thread/get', {'client': client});
    // BytedeskUtils.printLog("thread Url $threadUrl");
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    List<Thread> threadList = [];

    List<Thread> agentThreadList =
        (responseJson['data']['agentThreads'] as List<dynamic>)
            .map((item) => Thread.fromWorkGroupJson(item))
            .toList();
    threadList.addAll(agentThreadList);

    List<Thread> contactThreadList =
        (responseJson['data']['contactThreads'] as List<dynamic>)
            .map((item) => Thread.fromContactJson(item))
            .toList();
    threadList.addAll(contactThreadList);

    List<Thread> groupThreadList =
        (responseJson['data']['groupThreads'] as List<dynamic>)
            .map((item) => Thread.fromGroupJson(item))
            .toList();
    threadList.addAll(groupThreadList);

    return threadList;
  }

  // 客服端-历史客服会话
  Future<List<Thread>> getHistoryThreads(int? page, int? size) async {
    //
    // final threadUrl =
    //     '$baseUrl/api/thread/history/records?page=$page&size=$size&client=$client';
    final threadUrl = Uri.http(
        BytedeskConstants.host,
        '/api/thread/history/records',
        {'page': page.toString(), 'size': size.toString(), 'client': client});
    // BytedeskUtils.printLog("thread Url $threadUrl");
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());

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

    List<Thread> threadList = [];

    List<Thread> agentThreadList =
        (responseJson['data']['content'] as List<dynamic>)
            .map((item) => Thread.fromHistoryJson(item))
            .toList();
    threadList.addAll(agentThreadList);

    return threadList;
  }

  // 访客端-加载访客会话列表-分页
  Future<List<Thread>> getVisitorThreads(int? page, int? size) async {
    //
    final threadUrl = Uri.http(
        BytedeskConstants.host,
        '/api/thread/visitor/history',
        {'page': page.toString(), 'size': size.toString(), 'client': client});
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("getVisitorThreads responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    List<Thread> threadList = (responseJson['data']["content"] as List<dynamic>)
        .map((item) => Thread.fromWorkGroupJson2(item))
        .toList();
    //
    return threadList;
  }

  // 访客端-加载访客会话列表-全部
  Future<List<Thread>> getVisitorThreadsAll() async {
    //
    final threadUrl = Uri.http(BytedeskConstants.host,
        '/api/thread/visitor/history/all', {'client': client});
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("getVisitorThreadsAll responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    List<Thread> threadList = (responseJson['data'] as List<dynamic>)
        .map((item) => Thread.fromWorkGroupJson2(item))
        .toList();
    //
    return threadList;
  }

  // 请求客服会话
  Future<RequestThreadResult> requestThread(
      String? wid, String? type, String? aid) async {
    //
    final threadUrl = Uri.http(BytedeskConstants.host, '/api/thread/request',
        {'wId': wid, 'type': type, 'aId': aid, 'client': client});
    BytedeskUtils.printLog(threadUrl);
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("requestThread:");
    // BytedeskUtils.printLog(responseJson);
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return RequestThreadResult.fromJson(responseJson);
  }

  // 机器人分类会话
  Future<RequestThreadResult> requestWorkGroupThreadV2(String? wid) async {
    //
    final threadUrl = Uri.http(BytedeskConstants.host,
        '/api/v2/thread/workGroup', {'wId': wid, 'client': client});
    BytedeskUtils.printLog(threadUrl);
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("requestWorkGroupThreadV2:");
    BytedeskUtils.printLog(responseJson);
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return RequestThreadResult.fromJsonV2(responseJson);
  }

  // 请求人工客服，不管此工作组是否设置为默认机器人，只要有人工客服在线，则可以直接对接人工
  Future<RequestThreadResult> requestAgent(
      String? wid, String? type, String? aid) async {
    //
    final threadUrl = Uri.http(
        BytedeskConstants.host,
        '/api/thread/request/agent',
        {'wId': wid, 'type': type, 'aId': aid, 'client': client});
    BytedeskUtils.printLog("request agent Url $threadUrl");
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return RequestThreadResult.fromJson(responseJson);
  }

  // 请求一对一会话
  Future<RequestThreadResult> requestContactThread(String? cid) async {
    //
    final threadUrl = Uri.http(BytedeskConstants.host, '/api/thread/contact',
        {'cid': cid, 'client': client});
    BytedeskUtils.printLog("request contact thread Url $threadUrl");
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return RequestThreadResult.fromJson(responseJson);
  }

  // 请求群组会话
  Future<RequestThreadResult> requestGroupThread(String? gid) async {
    //
    final threadUrl = Uri.http(BytedeskConstants.host, '/api/thread/group',
        {'gid': gid, 'client': client});
    BytedeskUtils.printLog("request contact thread Url $threadUrl");
    final initResponse =
        await this.httpClient.get(threadUrl, headers: getHeaders());

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return RequestThreadResult.fromJson(responseJson);
  }

  // 会话置顶
  Future<MarkThreadResult> markTop(String? tid) async {
    //
    String? uid = SpUtil.getString(BytedeskConstants.uid);
    //
    var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
    final threadUrl = Uri.http(
      BytedeskConstants.host,
      '/api/v2/thread/mark/top',
    );
    final initResponse = await this
        .httpClient
        .post(threadUrl, headers: getHeaders(), body: body);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return MarkThreadResult.fromJson(responseJson);
  }

  // 取消会话置顶
  Future<MarkThreadResult> unmarkTop(String? tid) async {
    //
    String? uid = SpUtil.getString(BytedeskConstants.uid);
    //
    var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
    final threadUrl = Uri.http(
      BytedeskConstants.host,
      '/api/v2/thread/unmark/top',
    );
    final initResponse = await this
        .httpClient
        .post(threadUrl, headers: getHeaders(), body: body);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return MarkThreadResult.fromJson(responseJson);
  }

  // 会话免打扰
  Future<MarkThreadResult> markNodisturb(String? tid) async {
    //
    String? uid = SpUtil.getString(BytedeskConstants.uid);
    //
    var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
    final threadUrl = Uri.http(
      BytedeskConstants.host,
      '/api/v2/thread/mark/nodisturb',
    );
    final initResponse = await this
        .httpClient
        .post(threadUrl, headers: getHeaders(), body: body);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return MarkThreadResult.fromJson(responseJson);
  }

  // 取消会话免打扰
  Future<MarkThreadResult> unmarkNodisturb(String? tid) async {
    //
    String? uid = SpUtil.getString(BytedeskConstants.uid);
    //
    var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
    final threadUrl = Uri.http(
      BytedeskConstants.host,
      '/api/v2/thread/unmark/nodisturb',
    );
    final initResponse = await this
        .httpClient
        .post(threadUrl, headers: getHeaders(), body: body);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return MarkThreadResult.fromJson(responseJson);
  }

  // 会话未读
  Future<MarkThreadResult> markUnread(String? tid) async {
    //
    String? uid = SpUtil.getString(BytedeskConstants.uid);
    //
    var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
    final threadUrl = Uri.http(
      BytedeskConstants.host,
      '/api/v2/thread/mark/unread',
    );
    final initResponse = await this
        .httpClient
        .post(threadUrl, headers: getHeaders(), body: body);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return MarkThreadResult.fromJson(responseJson);
  }

  // 取消会话未读
  Future<MarkThreadResult> unmarkUnread(String? tid) async {
    //
    String? uid = SpUtil.getString(BytedeskConstants.uid);
    //
    var body = json.encode({'tid': tid, 'uid': uid, 'client': client});
    final threadUrl = Uri.http(
      BytedeskConstants.host,
      '/api/v2/thread/unmark/unread',
    );
    final initResponse = await this
        .httpClient
        .post(threadUrl, headers: getHeaders(), body: body);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }

    return MarkThreadResult.fromJson(responseJson);
  }

  // 删除会话
  Future<MarkThreadResult> delete(String? tid) async {
    //
    var body = json.encode({"tid": tid, "client": client});
    final initUrl = Uri.http(BytedeskConstants.host, '/api/thread/delete');
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

    return MarkThreadResult.fromJson(responseJson);
  }
}
