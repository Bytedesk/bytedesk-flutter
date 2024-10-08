/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-06 10:37:58
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
// import 'package:meta/meta.dart';
import 'package:bytedesk_kefu/http/bytedesk_thread_api.dart';
// import 'package:bytedesk_kefu/model/requestThread.dart';
import 'package:bytedesk_kefu/model/model.dart';
// import 'package:bytedesk_kefu/model/requestThreadZhipuAI.dart';
// import 'package:bytedesk_kefu/model/threadZhipuAI.dart';
// import 'package:http/http.dart' as http;

class ThreadRepository {
  //
  final BytedeskThreadHttpApi bytedeskHttpApi = BytedeskThreadHttpApi();

  ThreadRepository();

  Future<RequestThreadResult> requestThread(String? sid, String? type, bool? forceAgent) {
    return bytedeskHttpApi.requestThread(sid, type, forceAgent);
  }

  // Future<List<Thread>> getThreads() async {
  //   return await bytedeskHttpApi.getThreads();
  // }

  // Future<List<Thread>> getHistoryThreads(int? page, int? size) async {
  //   return await bytedeskHttpApi.getHistoryThreads(page, size);
  // }

  // Future<List<Thread>> getVisitorThreads(int? page, int? size) async {
  //   return await bytedeskHttpApi.getVisitorThreads(page, size);
  // }

  // Future<List<Thread>> getVisitorThreadsAll() async {
  //   return await bytedeskHttpApi.getVisitorThreadsAll();
  // }

  // Future<RequestThreadResult> requestThread(
  //     String? wid, String? type, String? aid, bool? isV2Robot) async {
  //   if (isV2Robot!) {
  //     return await bytedeskHttpApi.requestWorkGroupThreadV2(wid);
  //   }
  //   return await bytedeskHttpApi.requestThread(wid, type, aid);
  // }

  // Future<RequestThreadZhipuAIResult> requestZhipuAIThread(
  //     String? wid, String? forceNew) async {
  //   return await bytedeskHttpApi.requestZhipuAIThread(wid, forceNew);
  // }

  // Future<List<ThreadZhipuAI>> getZhipuAIThreadHistory(
  //     int? page, int? size) async {
  //   return await bytedeskHttpApi.getZhipuAIThreadHistory(page, size);
  // }

  // Future<RequestThreadResult> requestAgent(
  //     String? wid, String? type) async {
  //   return await bytedeskHttpApi.requestAgent(wid, type);
  // }

  // Future<RequestThreadResult> requestContactThread(String? cid) async {
  //   return await bytedeskHttpApi.requestContactThread(cid);
  // }

  // Future<RequestThreadResult> requestGroupThread(String? gid) async {
  //   return await bytedeskHttpApi.requestGroupThread(gid);
  // }

  // Future<MarkThreadResult> markTop(String? tid) async {
  //   return await bytedeskHttpApi.markTop(tid);
  // }

  // Future<MarkThreadResult> unmarkTop(String? tid) async {
  //   return await bytedeskHttpApi.unmarkTop(tid);
  // }

  // Future<MarkThreadResult> markNodisturb(String? tid) async {
  //   return await bytedeskHttpApi.markNodisturb(tid);
  // }

  // Future<MarkThreadResult> unmarkNodisturb(String? tid) async {
  //   return await bytedeskHttpApi.unmarkNodisturb(tid);
  // }

  // Future<MarkThreadResult> markUnread(String? tid) async {
  //   return await bytedeskHttpApi.markUnread(tid);
  // }

  // Future<MarkThreadResult> unmarkUnread(String? tid) async {
  //   return await bytedeskHttpApi.unmarkUnread(tid);
  // }

  // Future<MarkThreadResult> delete(String? tid) async {
  //   return await bytedeskHttpApi.delete(tid);
  // }
}
