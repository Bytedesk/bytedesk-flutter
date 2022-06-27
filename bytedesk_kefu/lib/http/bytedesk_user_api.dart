import 'dart:convert';
import 'dart:io';

import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
import 'package:bytedesk_kefu/model/app.dart';
import 'package:bytedesk_kefu/model/model.dart';
import 'package:bytedesk_kefu/model/userJsonResult.dart';
import 'package:bytedesk_kefu/model/wechatResult.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
// import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:sp_util/sp_util.dart';
import 'package:http/http.dart' as http;

//
class BytedeskUserHttpApi extends BytedeskBaseHttpApi {
  // 授权
  Future<OAuth> oauth(String? username, String? password) async {
    var oauthUrl = Uri.http(BytedeskConstants.host, '/oauth/token');
    // BytedeskUtils.printLog("http api client: oauthUrl $oauthUrl");
    Map<String, String> headers = {
      "Authorization": "Basic Y2xpZW50OnNlY3JldA=="
    };
    Map<String, String> bodyMap = {
      "username": "$username",
      "password": "$password",
      "grant_type": "password",
      "scope": "all"
    };
    final oauthResponse =
        await this.httpClient.post(oauthUrl, headers: headers, body: bodyMap);
    // BytedeskUtils.printLog('oauth result: $oauthResponse');
    // check the status code for the result
    int statusCode = oauthResponse.statusCode;
    // BytedeskUtils.printLog("statusCode $statusCode");
    // 200: 授权成功，否则授权失败
    final oauthJson = jsonDecode(oauthResponse.body);
    BytedeskUtils.printLog('oauth:');
    BytedeskUtils.printLog(oauthJson);
    SpUtil.putBool(BytedeskConstants.isLogin, true);
    SpUtil.putString(BytedeskConstants.accessToken, oauthJson['access_token']);
    //
    return OAuth.fromJson(statusCode, oauthJson);
  }

  // 验证码登录
  Future<OAuth> smsOAuth(String? mobile, String? code) async {
    //
    // final oauthUrl = '$baseUrl/mobile/token';
    // final oauthUrl = Uri.http(BytedeskConstants.host, '/mobile/token');
    final oauthUrl = Uri.http(BytedeskConstants.host, '/mobile/token');
    // BytedeskUtils.printLog("http api client: oauthUrl $oauthUrl");
    Map<String, String> headers = {
      "Authorization": "Basic Y2xpZW50OnNlY3JldA=="
    };
    Map<String, String> bodyMap = {
      "mobile": "$mobile",
      "code": "$code",
      "grant_type": "mobile",
      "scope": "all"
    };
    //
    final oauthResponse =
        await this.httpClient.post(oauthUrl, headers: headers, body: bodyMap);
    // BytedeskUtils.printLog('oauth result: $oauthResponse');
    int statusCode = oauthResponse.statusCode;
    // 200: 授权成功，否则授权失败
    final oauthJson = jsonDecode(oauthResponse.body);
    BytedeskUtils.printLog('smsOAuth:');
    BytedeskUtils.printLog(oauthJson);
    if (statusCode == 200) {
      SpUtil.putBool(BytedeskConstants.isLogin, true);
      SpUtil.putBool(BytedeskConstants.isAuthenticated, true);
      SpUtil.putString(BytedeskConstants.mobile, mobile!);
      SpUtil.putString(
          BytedeskConstants.accessToken, oauthJson['access_token']);
    }
    return OAuth.fromJson(statusCode, oauthJson);
  }

  // 通过微信unionId登录
  Future<OAuth> unionIdOAuth(String? unionid) async {
    //
    // final oauthUrl = '$baseUrl/wechat/token';
    final oauthUrl = Uri.http(BytedeskConstants.host, '/wechat/token');
    // BytedeskUtils.printLog("http api client: oauthUrl $oauthUrl");
    Map<String, String> headers = {
      "Authorization": "Basic Y2xpZW50OnNlY3JldA=="
    };
    Map<String, String> bodyMap = {
      "unionid": "$unionid",
      "grant_type": "wechat",
      "scope": "all"
    };
    //
    final oauthResponse =
        await this.httpClient.post(oauthUrl, headers: headers, body: bodyMap);
    // BytedeskUtils.printLog('oauth result: $oauthResponse');
    // check the status code for the result
    int statusCode = oauthResponse.statusCode;
    // BytedeskUtils.printLog("statusCode $statusCode");
    // 200: 授权成功，否则授权失败
    final oauthJson = jsonDecode(oauthResponse.body);
    BytedeskUtils.printLog('unionIdOAuth:');
    BytedeskUtils.printLog(oauthJson);
    if (statusCode == 200) {
      SpUtil.putBool(BytedeskConstants.isLogin, true);
      SpUtil.putBool(BytedeskConstants.isAuthenticated, true);
      SpUtil.putString(BytedeskConstants.unionid, unionid!);
      SpUtil.putString(
          BytedeskConstants.accessToken, oauthJson['access_token']);
    }
    return OAuth.fromJson(statusCode, oauthJson);
  }

  // 良师-手机号注册
  Future<JsonResult> register(String? mobile, String? password) async {
    //
    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = json.encode({
      "mobile": mobile,
      "password": password,
      "admin": false, // 学校端时，修改为true
      "client": client
    });

    // final initUrl = '$baseUrl/visitors/api/v1/register/mobile';
    final initUrl =
        Uri.http(BytedeskConstants.host, '/visitors/api/v1/register/mobile');
    final initResponse =
        await this.httpClient.post(initUrl, headers: headers, body: body);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("register:");
    // BytedeskUtils.printLog(responseJson);

    return JsonResult.fromJson(responseJson);
  }

  // 萝卜丝-访客端-注册匿名用户
  Future<User> registerAnonymous(String? subDomain) async {
    //
    Map<String, String> headers = {"Content-Type": "application/json"};
    //
    final initUrl = Uri.http(BytedeskConstants.host, '/visitor/api/username',
        {'subDomain': subDomain, 'client': client});
    final initResponse = await this.httpClient.get(initUrl, headers: headers);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("registerAnonymous:");
    // BytedeskUtils.printLog(responseJson);
    //
    User user = User.fromJson(responseJson['data']);
    //
    SpUtil.putString(BytedeskConstants.uid, user.uid!);
    SpUtil.putString(BytedeskConstants.username, user.username!);
    SpUtil.putString(BytedeskConstants.nickname, user.nickname!);
    SpUtil.putString(BytedeskConstants.avatar, user.avatar!);
    SpUtil.putString(BytedeskConstants.description, user.description!);
    SpUtil.putString(BytedeskConstants.subDomain, user.subDomain!);
    SpUtil.putString(BytedeskConstants.role, BytedeskConstants.ROLE_VISITOR);
    // 解析用户资料
    return user;
  }

  // 注册自定义普通用户：用于IM,
  Future<User> registerUser(String? username, String? nickname,
      String? password, String? avatar, String? subDomain) async {
    //
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = json.encode({
      "username": username,
      "nickname": nickname,
      "password": password,
      "avatar": avatar,
      "subDomain": subDomain,
      "client": client
    });
    //
    final initUrl =
        Uri.http(BytedeskConstants.host, '/visitor/api/register/user');
    final initResponse =
        await this.httpClient.post(initUrl, headers: headers, body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("registerUser:");
    BytedeskUtils.printLog(responseJson);
    //
    int statusCode = responseJson['status_code'];
    if (statusCode == 200) {
      User user = User.fromJson(responseJson['data']);
      //
      SpUtil.putString(BytedeskConstants.uid, user.uid!);
      SpUtil.putString(BytedeskConstants.username, user.username!);
      SpUtil.putString(BytedeskConstants.password, password!);
      SpUtil.putString(BytedeskConstants.nickname, user.nickname!);
      SpUtil.putString(BytedeskConstants.avatar, user.avatar!);
      SpUtil.putString(BytedeskConstants.description, user.description!);
      SpUtil.putString(BytedeskConstants.subDomain, user.subDomain!);
      // 解析用户资料
      return user;
    } else {
      //
      SpUtil.putString(BytedeskConstants.uid, responseJson['data']);
      SpUtil.putString(
          BytedeskConstants.username, username! + '@' + subDomain!);
      SpUtil.putString(BytedeskConstants.password, password!);
      SpUtil.putString(BytedeskConstants.nickname, nickname!);
      SpUtil.putString(BytedeskConstants.avatar, avatar!);
      SpUtil.putString(BytedeskConstants.description, "");
      SpUtil.putString(BytedeskConstants.subDomain, subDomain);
    }
    return new User();
  }

  // 修改密码
  Future<JsonResult> changePassword(String? mobile, String? password) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var body =
        json.encode({"mobile": mobile, "password": password, "client": client});

    final initUrl = Uri.http(BytedeskConstants.host, '/visitors/api/v1/change');
    final initResponse =
        await this.httpClient.post(initUrl, headers: headers, body: body);

    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // final responseJson = json.decode(initResponse.body);
    // BytedeskUtils.printLog("changePassword");
    // BytedeskUtils.printLog(responseJson);

    return JsonResult.fromJson(responseJson);
  }

  // 请求验证码
  Future<CodeResult> requestCode(String? mobile) async {
    //
    Map<String, String> headers = {"Content-Type": "application/json"};
    final initUrl = Uri.http(BytedeskConstants.host,
        '/sms/api/send/liangshibao', {'mobile': mobile, 'client': client});
    final initResponse = await this.httpClient.get(initUrl, headers: headers);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("requestCode:");
    // BytedeskUtils.printLog(responseJson);

    SpUtil.putBool(BytedeskConstants.exist, responseJson['data']['exist']);
    SpUtil.putString(BytedeskConstants.code, responseJson['data']['code']);

    return CodeResult.fromJson(responseJson);
  }

  // 绑定手机号
  Future<JsonResult> bindMobile(String? mobile) async {
    //
    String? uid = SpUtil.getString(BytedeskConstants.uid);
    var body = json.encode({"uid": uid, "mobile": mobile, "client": client});
    //
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/bind/mobile');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    int statusCode = responseJson['status_code'];
    if (statusCode == 200) {
      SpUtil.putBool(BytedeskConstants.isAuthenticated, true);
      SpUtil.putString(BytedeskConstants.mobile, mobile!);
      SpUtil.putString(BytedeskConstants.nickname, '用户${mobile.substring(7)}');
    }
    return JsonResult.fromJson(responseJson);
  }

  /// 初始化
  Future<User> getProfile() async {
    //
    final initUrl = Uri.http(
        BytedeskConstants.host, '/api/user/profile/simple', {'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("getProfile:");
    // BytedeskUtils.printLog(responseJson);
    //
    User user = User.fromJson(responseJson['data']);
    //
    SpUtil.putString(BytedeskConstants.uid, user.uid!);
    SpUtil.putString(BytedeskConstants.username, user.username!);
    SpUtil.putString(BytedeskConstants.nickname, user.nickname!);
    SpUtil.putString(BytedeskConstants.avatar, user.avatar!);
    SpUtil.putString(BytedeskConstants.mobile, user.mobile ?? '');
    SpUtil.putString(BytedeskConstants.description, user.description!);
    SpUtil.putString(BytedeskConstants.subDomain, user.subDomain!);
    // TODO: 通知前端更新
    // 解析用户资料
    return user;
  }

  // 更新昵称
  Future<User> updateNickname(String? nickname) async {
    //
    var body = json.encode({"nickname": nickname, "client": client});
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/nickname');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("updateNickname:");
    BytedeskUtils.printLog(responseJson);
    // 更新本地数据
    SpUtil.putString(BytedeskConstants.nickname, nickname!);

    return User.fromJson(responseJson['data']);
  }

  // 更新头像
  Future<User> updateAvatar(String? avatar) async {
    //
    var body = json.encode({"avatar": avatar, "client": client});
    //
    // final initUrl = '$baseUrl/api/user/avatar';
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/avatar');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("updateAvatar:");
    BytedeskUtils.printLog(responseJson);
    // 更新本地数据
    SpUtil.putString(BytedeskConstants.avatar, avatar!);

    return User.fromJson(responseJson['data']);
  }

  // 更新个性签名
  Future<User> updateDescription(String? description) async {
    //
    var body = json.encode({"description": description, "client": client});
    //
    // final initUrl = '$baseUrl/api/user/description';
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/description');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("updateDescription:");
    BytedeskUtils.printLog(responseJson);
    // 更新本地数据
    SpUtil.putString(BytedeskConstants.description, description!);

    return User.fromJson(responseJson['data']);
  }

  // 一个接口同时设置：昵称、头像、备注
  Future<User> updateProfile(
      String? nickname, String? avatar, String? description) async {
    //
    var body = json.encode({
      "nickname": nickname,
      "avatar": avatar,
      "description": description,
      "client": client
    });
    //
    final initUrl =
        Uri.http(BytedeskConstants.host, '/api/user/update/visitor/profile');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("updateProfile:");
    BytedeskUtils.printLog(responseJson);
    // 更新本地数据
    SpUtil.putString(BytedeskConstants.nickname, nickname!);
    SpUtil.putString(BytedeskConstants.avatar, avatar!);
    SpUtil.putString(BytedeskConstants.description, description!);

    return User.fromJson(responseJson['data']);
  }

  // 更新性别
  Future<User> updateSex(bool? sex) async {
    //
    var body = json.encode({"sex": sex, "client": client});
    //
    // final initUrl = '$baseUrl/api/user/sex';
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/sex');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("updateSex $responseJson");
    // 更新本地数据
    SpUtil.putBool(BytedeskConstants.sex, sex!);

    return User.fromJson(responseJson['data']);
  }

  // 更新地区
  Future<User> updateLocation(String? location) async {
    //
    var body = json.encode({"location": location, "client": client});
    //
    // final initUrl = '$baseUrl/api/user/location';
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/location');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("updateLocation $responseJson");
    // 更新本地数据
    SpUtil.putString(BytedeskConstants.location, location!);

    return User.fromJson(responseJson['data']);
  }

  // 更新生日
  Future<User> updateBirthday(String? birthday) async {
    //
    var body = json.encode({"birthday": birthday, "client": client});
    //
    // final initUrl = '$baseUrl/api/user/birthday';
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/birthday');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("updateBirthday $responseJson");
    // 更新本地数据
    SpUtil.putString(BytedeskConstants.birthday, birthday!);

    return User.fromJson(responseJson['data']);
  }

  // 更新手机号
  Future<User> updateMobile(String? mobile) async {
    //
    var body = json.encode({"mobile": mobile, "client": client});
    //
    // final initUrl = '$baseUrl/api/user/mobile';
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/mobile');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("updateMobile $responseJson");
    // 更新本地数据
    SpUtil.putString(BytedeskConstants.mobile, mobile!);

    return User.fromJson(responseJson['data']);
  }

  // https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html
  Future<String> upload(String? filePath) async {
    //
    String? fileName = filePath!.split("/").last;
    String? username = SpUtil.getString(BytedeskConstants.uid);

    final uploadUrl = '$baseUrl/visitor/api/upload/image';
    BytedeskUtils.printLog("fileName $fileName, username $username, upload Url $uploadUrl");

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
    // BytedeskUtils.printLog("responseJson $responseJson");
    // TODO: 根据status_code判断结果，并解析

    String? url = responseJson['data'];
    // BytedeskUtils.printLog('url:' + url);
    return url!;
  }

  // 获取技能组在线状态
  Future<String> getWorkGroupStatus(String? workGroupWid) async {
    //
    // final initUrl =
    //     '$baseUrl/api/status/workGroup?wid=$workGroupWid&client=$client';
    final initUrl = Uri.http(BytedeskConstants.host, '/api/status/workGroup',
        {'wid': workGroupWid, 'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // TODO: 根据status_code判断结果，并解析
    // 解析
    return responseJson['data']['status'].toString();
  }

  // 获取客服在线状态
  Future<String> getAgentStatus(String? agentUid) async {
    //
    final initUrl = Uri.http(BytedeskConstants.host, '/api/status/agent',
        {'uid': agentUid, 'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // TODO: 根据status_code判断结果，并解析
    // 解析
    return responseJson['data']['status'].toString();
  }

  // 查询当前用户-某技能组wid或指定客服未读消息数目
  // 注意：技能组wid或指定客服唯一id
  // 适用于 访客 和 客服
  Future<String> getUnreadCount(String? wid) async {
    //
    final initUrl = Uri.http(BytedeskConstants.host,
        '/api/messages/unreadCount', {'wid': wid, 'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // TODO: 根据status_code判断结果，并解析
    // 解析
    return responseJson['data'].toString();
  }

  // 访客端-查询访客所有未读消息数目
  Future<String> getUnreadCountVisitor() async {
    //
    final initUrl = Uri.http(BytedeskConstants.host,
        '/api/messages/unreadCount/visitor', {'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // TODO: 根据status_code判断结果，并解析
    // 解析
    return responseJson['data'].toString();
  }

  // 客服端-查询客服所有未读消息数目
  Future<String> getUnreadCountAgent() async {
    //
    final initUrl = Uri.http(BytedeskConstants.host,
        '/api/messages/unreadCount/agent', {'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // TODO: 根据status_code判断结果，并解析
    // 解析
    return responseJson['data'].toString();
  }

  // 检测是否有新版本
  Future<App> checkAppVersion(String? appkey) async {
    //
    final initUrl = Uri.http(BytedeskConstants.host, '/api/app/version',
        {'key': appkey, 'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("checkAppVersion:");
    BytedeskUtils.printLog(responseJson);
    // 判断token是否过期
    if (responseJson.toString().contains('invalid_token')) {
      bytedeskEventBus.fire(InvalidTokenEventBus());
    }
    // TODO: 根据status_code判断结果，并解析
    int statusCode = responseJson['status_code'];
    if (statusCode == 200) {
      return App.fromJson(responseJson['data']);
    }
    return App(version: "0");
  }

  // 通过token获取手机号
  Future<String> getAliyunOneKeyLoginMobile(String? token) async {
    //
    final initUrl = Uri.http(BytedeskConstants.host, '/aliyun/mobile',
        {'token': token, 'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 解析
    return responseJson['data'].toString();
  }

  // 微信登录之后，获取微信用户信息
  Future<WeChatResult> getWechatUserinfo(String? code) async {
    //
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    final initUrl = Uri.http(BytedeskConstants.host,
        '/visitor/api/lsb/app/wechat/info', {'code': code, 'client': client});
    final initResponse = await this.httpClient.get(initUrl, headers: headers);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("responseJson $responseJson");
    // 解析
    return WeChatResult.fromJson(responseJson);
  }

  // 手机端注册微信登录用户-绑定手机号
  Future<UserJsonResult> registerWechatMobile(String? mobile, String? nickname,
      String? avatar, String? unionid, String? openid) async {
    //
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json"
    };
    //
    var body = json.encode({
      "mobile": mobile,
      "nickname": nickname,
      "avatar": avatar,
      "unionid": unionid,
      "openid": openid,
      "admin": false,
      "client": client
    });
    //
    final initUrl =
        Uri.http(BytedeskConstants.host, '/visitor/api/register/wechat/mobile');
    final initResponse =
        await this.httpClient.post(initUrl, headers: headers, body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    //
    UserJsonResult userJsonResult = UserJsonResult.fromJson(responseJson);
    if (userJsonResult.statusCode == 200) {
      SpUtil.putString(BytedeskConstants.mobile, mobile!);
      SpUtil.putString(BytedeskConstants.nickname, nickname!);
      SpUtil.putString(BytedeskConstants.avatar, avatar!);
      SpUtil.putString(BytedeskConstants.unionid, unionid!);
      SpUtil.putString(BytedeskConstants.openid, openid!);
    }
    // 新账号，mqtt需要重连
    return userJsonResult;
  }

  // 将unionid绑定到已经存在的手机账号
  Future<UserJsonResult> bindWeChatMobile(
      String? mobile, String? unionid) async {
    //
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json"
    };
    //
    var body =
        json.encode({"mobile": mobile, "unionid": unionid, "client": client});
    //
    // final initUrl = '$baseUrl/visitor/api/bind/wechat/mobile';
    final initUrl =
        Uri.http(BytedeskConstants.host, '/visitor/api/bind/wechat/mobile');
    final initResponse =
        await this.httpClient.post(initUrl, headers: headers, body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("responseJson $responseJson");
    //
    UserJsonResult userJsonResult = UserJsonResult.fromJson(responseJson);
    if (userJsonResult.statusCode == 200) {
      SpUtil.putString(BytedeskConstants.mobile, mobile!);
      SpUtil.putString(BytedeskConstants.unionid, unionid!);
      SpUtil.putBool(BytedeskConstants.isAuthenticated, true);
    }
    //
    return userJsonResult;
  }

  // 查询是否已经关注
  Future<bool> isFollowed(String? uid) async {
    //
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/isfollowed',
        {'uid': uid, 'client': client});
    final initResponse =
        await this.httpClient.get(initUrl, headers: getHeaders());
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("responseJson $responseJson");
    // 解析
    return responseJson['data'];
  }

  // 关注
  Future<JsonResult> follow(String? uid) async {
    //
    var body = json.encode({"uid": uid, "client": client});
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/follow');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("responseJson $responseJson");
    //
    return JsonResult.fromJson(responseJson);
  }

  // 取消关注
  Future<JsonResult> unfollow(String? uid) async {
    //
    var body = json.encode({"uid": uid, "client": client});
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/unfollow');
    final initResponse =
        await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    // BytedeskUtils.printLog("unfollow:");
    // BytedeskUtils.printLog(responseJson);
    return JsonResult.fromJson(responseJson);
  }

  // 退出登录
  Future<void> logout() async {
    String? accessToken = SpUtil.getString(BytedeskConstants.accessToken);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = json.encode({"client": client});
    final initUrl = Uri.http(BytedeskConstants.host, '/api/user/logout',
        {'access_token': accessToken});
    final initResponse =
        await this.httpClient.post(initUrl, headers: headers, body: body);
    //解决json解析中的乱码问题
    Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
    //将string类型数据 转换为json类型的数据
    final responseJson =
        json.decode(utf8decoder.convert(initResponse.bodyBytes));
    BytedeskUtils.printLog("logout:");
    BytedeskUtils.printLog(responseJson);
    BytedeskUtils.clearUserCache();
  }
}
