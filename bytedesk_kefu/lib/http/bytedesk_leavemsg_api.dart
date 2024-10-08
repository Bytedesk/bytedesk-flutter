/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-08 11:35:30
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'dart:convert';

import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
// import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:sp_util/sp_util.dart';

class BytedeskLeaveMsgHttpApi extends BytedeskBaseHttpApi {
  // 获取意见反馈分类
  Future<List<HelpCategory>> getHelpLeaveMsgCategories(String? uid) async {
    //
    final categoriesUrl = BytedeskUtils.getHostUri(
        '/visitor/api/category/feedback', {'uid': uid, 'client': client});
    debugPrint("categories Url $categoriesUrl");
    final initResponse = await httpClient.get(categoriesUrl);
    //
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    //
    List<HelpCategory> categories = (responseJson['data'] as List<dynamic>)
        .map((item) => HelpCategory.fromJson(item))
        .toList();

    return categories;
  }

  // 提交意见反馈 
  Future<JsonResult> submitLeaveMsg(String? wid, String? aid, String? type,
      String? mobile, String? email, String? content, List<String>? imageUrls) async {
    //
    var body = json.encode({
      "wid": wid,
      "aid": aid,
      "type": type,
      "mobile": mobile,
      "email": email,
      "content": content,
      "images": imageUrls,
      "client": client
    });
    final initUrl = BytedeskUtils.getHostUri('/api/leavemsg/save');
    final initResponse =
        await httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    debugPrint("submitLeaveMsg:");
    BytedeskUtils.printLog(responseJson);
    // 判断token是否过期
    // if (responseJson.toString().contains('invalid_token')) {
    //   bytedeskEventBus.fire(InvalidTokenEventBus());
    // }
    // return User.fromJson(responseJson);
    return const JsonResult();
  }

  // https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html
  // Future<String> upload(String? filePath) async {
  //   //
  //   String fileName = filePath!.split("/").last;
  //   String? username = SpUtil.getString(BytedeskConstants.uid);

  //   final uploadUrl = '$baseUrl/visitor/api/upload/image';
  //   BytedeskUtils.printLog(
  //       "fileName $fileName, username $username, upload Url $uploadUrl");

  //   var uri = Uri.parse(uploadUrl);
  //   var request = http.MultipartRequest('POST', uri)
  //     ..fields['file_name'] = fileName
  //     ..fields['username'] = username!
  //     ..files.add(await http.MultipartFile.fromPath('file', filePath));

  //   http.Response response =
  //       await http.Response.fromStream(await request.send());
  //   // debugPrint("Result: ${response.body}");

  //   //解决json解析中的乱码问题
  //   Utf8Decoder utf8decoder = const Utf8Decoder(); // fix 中文乱码
  //   //将string类型数据 转换为json类型的数据
  //   final responseJson = json.decode(utf8decoder.convert(response.bodyBytes));
  //   debugPrint("responseJson $responseJson");

  //   String url = responseJson['data'];
  //   debugPrint('url:$url');
  //   return url;
  // }


}
