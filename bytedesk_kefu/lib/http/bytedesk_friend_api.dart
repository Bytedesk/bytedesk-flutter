import 'dart:convert';

import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
import 'package:bytedesk_kefu/model/friend.dart';
import 'package:bytedesk_kefu/util/bytedesk_events.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';

class BytedeskFriendHttpApi extends BytedeskBaseHttpApi {
  //
  Future<List<Friend>> getFriends(int? page, int? size) async {
    //
    // final friendsUrl =
    //     '$baseUrl/api/friend/query?page=$page&size=$size&client=$client';
    final friendsUrl = Uri.http(BytedeskConstants.host, '/api/friend/query',
        {'page': page.toString(), 'size': size.toString(), 'client': client});
    BytedeskUtils.printLog("get friends Url $friendsUrl");
    final initResponse =
        await this.httpClient.get(friendsUrl, headers: getHeaders());

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

    List<Friend> orders = (responseJson['data']['content'] as List<dynamic>)
        .map((item) => Friend.fromJson(item))
        .toList();

    return orders;
  }

  // 加载通讯录列表
  Future<List<Friend>> getFriendsAddress(int? page, int? size) async {
    //
    // final addressUrl =
    //     '$baseUrl/api/friend/address/query?page=$page&size=$size&client=$client';
    final addressUrl = Uri.http(
        BytedeskConstants.host,
        '/api/friend/address/query',
        {'page': page.toString(), 'size': size.toString(), 'client': client});
    BytedeskUtils.printLog("address Url $addressUrl");
    final initResponse =
        await this.httpClient.get(addressUrl, headers: getHeaders());

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

    List<Friend> orders = (responseJson['data']['content'] as List<dynamic>)
        .map((item) => Friend.fromJson(item))
        .toList();

    return orders;
  }

  //
  Future<Friend> uploadAddress(String? nickname, String? mobile) async {
    //
    var body =
        json.encode({"nickname": nickname, "mobile": mobile, "client": client});
    //
    // final initUrl = '$baseUrl/api/friend/address/create';
    final initUrl =
        Uri.http(BytedeskConstants.host, '/api/friend/address/create');
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

    return Friend.fromJson(responseJson['data']);
  }

  // 加载附近列表
  Future<List<Friend>> getFriendsNearby(int? page, int? size) async {
    //
    double? latitude = BytedeskUtils.getLatitude();
    double? longtitude = BytedeskUtils.getLongtitude();
    //
    // final addressUrl =
    //     '$baseUrl/api/friend/nearby/query?lat=$latitude&lng=$longtitude&page=$page&size=$size&client=$client';
    final addressUrl =
        Uri.http(BytedeskConstants.host, '/api/friend/nearby/query', {
      'lat': latitude,
      'lng': longtitude,
      'page': page.toString(),
      'size': size.toString(),
      'client': client
    });
    BytedeskUtils.printLog("address Url $addressUrl");
    final initResponse =
        await this.httpClient.get(addressUrl, headers: getHeaders());

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

    List<Friend> friends = (responseJson['data']['searchHits'] as List<dynamic>)
        .map((item) => Friend.fromElasticJson(item['content']))
        .toList();

    // List<Friend> friends = (responseJson['data']['content'] as List<dynamic>)
    //     .map((item) => Friend.fromJson(item))
    //     .toList();

    return friends;
  }

  //
  Future<void> updateLocation(double? latitude, double? longtitude) async {
    //
    var body =
        json.encode({"lat": latitude, "lng": longtitude, "client": client});
    // final initUrl = '$baseUrl/api/friend/nearby/update';
    final initUrl =
        Uri.http(BytedeskConstants.host, '/api/friend/nearby/update');
    await this.httpClient.post(initUrl, headers: getHeaders(), body: body);
  }
}
