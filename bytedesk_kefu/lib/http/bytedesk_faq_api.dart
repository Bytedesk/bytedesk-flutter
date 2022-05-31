import 'dart:convert';

import 'package:bytedesk_kefu/http/bytedesk_base_api.dart';
import 'package:bytedesk_kefu/model/helpArticle.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';

class BytedeskFaqHttpApi extends BytedeskBaseHttpApi {
  //
  // 常见问题分类
  Future<List<HelpCategory>> getHelpSupportCategories(String? uid) async {
    //
    final categoriesUrl = Uri.http(BytedeskConstants.host,
        '/visitor/api/category/support', {'uid': uid, 'client': client});
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

  // 常见问题分类-所属文章
  Future<List<HelpArticle>> getHelpSupportArticles(int? categoryId) async {
    //
    // final categoriesUrl =
    //     '$baseUrl/visitor/api/category/articles?categoryId=$categoryId&client=$client';
    final categoriesUrl = Uri.http(
        BytedeskConstants.host,
        '/visitor/api/category/articles',
        {'categoryId': categoryId, 'client': client});
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
    List<HelpArticle> articles = (responseJson['data'] as List<dynamic>)
        .map((item) => HelpArticle.fromJson(item))
        .toList();
    //
    return articles;
  }
}
