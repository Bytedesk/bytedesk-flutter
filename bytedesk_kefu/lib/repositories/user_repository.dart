import 'dart:async';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:bytedesk_kefu/model/codeResult.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/user.dart';
import 'package:bytedesk_kefu/http/bytedesk_user_api.dart';
import 'package:bytedesk_kefu/model/oauth.dart';
// import 'package:meta/meta.dart';

class UserRepository {
  final BytedeskUserHttpApi bytedeskHttpApi = BytedeskUserHttpApi();

  UserRepository();

  Future<OAuth> login(String? username, String? password) {
    return bytedeskHttpApi.oauth(username, password);
  }

  Future<OAuth> smsOAuth(String? mobile, String? code) {
    return bytedeskHttpApi.smsOAuth(mobile, code);
  }

  Future<OAuth> unionIdOAuth(String? unionid) {
    return bytedeskHttpApi.unionIdOAuth(unionid);
  }

  Future<JsonResult> register(String? mobile, String? password) {
    return bytedeskHttpApi.register(mobile, password);
  }

  Future<JsonResult> changePassword(String? mobile, String? password) {
    return bytedeskHttpApi.changePassword(mobile, password);
  }

  Future<CodeResult> requestCode(String? mobile) {
    return bytedeskHttpApi.requestCode(mobile);
  }

  Future<JsonResult> bindMobile(String? mobile) {
    return bytedeskHttpApi.bindMobile(mobile);
  }

  Future<String> upload(String? filePath) {
    return bytedeskHttpApi.upload(filePath);
  }

  Future<User> updateAvatar(String? avatar) {
    return bytedeskHttpApi.updateAvatar(avatar);
  }

  Future<User> updateNickname(String? nickname) {
    return bytedeskHttpApi.updateNickname(nickname);
  }

  Future<User> updateDescription(String? description) {
    return bytedeskHttpApi.updateDescription(description);
  }

  Future<User> updateSex(bool? sex) {
    return bytedeskHttpApi.updateSex(sex);
  }

  Future<User> updateLocation(String? location) {
    return bytedeskHttpApi.updateLocation(location);
  }

  Future<User> updateBirthday(String? birthday) {
    return bytedeskHttpApi.updateBirthday(birthday);
  }

  Future<User> updateMobile(String? mobile) {
    return bytedeskHttpApi.updateMobile(mobile);
  }

  Future<bool> isFollowed(String? uid) {
    return bytedeskHttpApi.isFollowed(uid);
  }

  Future<JsonResult> follow(String? uid) {
    return bytedeskHttpApi.follow(uid);
  }

  Future<JsonResult> unfollow(String? uid) {
    return bytedeskHttpApi.unfollow(uid);
  }

  Future<void> logout() {
    // BytedeskUtils.printLog("user_repository logout");
    return Future.wait([bytedeskHttpApi.logout()]);
  }

  // Future<bool> isLogin() {
  //   BytedeskUtils.printLog("user_repository isSignedIn");
  //   // final currentUser = BytedeskHttpApi.currentUser();
  //   // return currentUser != null;
  // }

  Future<User> getProfile() {
    return bytedeskHttpApi.getProfile();
  }

  // Future<String> getUsername() {
  //   BytedeskUtils.printLog("user_repository getUsername");
  //   return (BytedeskHttpApi.currentUser()).username;
  // }

}
