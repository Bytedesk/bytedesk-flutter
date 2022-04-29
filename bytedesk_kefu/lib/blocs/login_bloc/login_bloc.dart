import 'dart:async';
import 'package:bytedesk_kefu/model/codeResult.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/oauth.dart';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/blocs/login_bloc/bloc.dart';
import 'package:bytedesk_kefu/repositories/repositories.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //
  final UserRepository _userRepository = new UserRepository();

  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    //
    if (event is LoginButtonPressed) {
      yield* _mapLoginState(event);
    } else if (event is SMSLoginButtonPressed) {
      yield* _mapSMSLoginState(event);
    } else if (event is RegisterButtonPressed) {
      yield* _mapRegisterState(event);
    } else if (event is RequestCodeButtonPressed) {
      yield* _mapRequestCodeState(event);
    } else if (event is BindMobileEvent) {
      yield* _mapBindMobileState(event);
    } else if (event is UnionidOAuthEvent) {
      yield* _mapUnionidOAuthState(event);
    } else if (event is ResetPasswordButtonPressed) {
      yield* _mapResetPasswordState(event);
    } else if (event is UpdatePasswordButtonPressed) {
      yield* _mapUpdatePasswordState(event);
    }
  }

  Stream<LoginState> _mapLoginState(LoginButtonPressed event) async* {
    yield LoginInProgress();
    try {
      OAuth oauth = await _userRepository.login(event.username, event.password);
      if (oauth.statusCode == 200) {
        // 用户名密码正确，登录成功
        yield LoginSuccess();
      } else {
        // 用户名密码错误，登录失败
        yield LoginError();
      }
    } catch (error) {
      // 网络或其他错误
      yield LoginFailure(error: error.toString());
    }
  }

  Stream<LoginState> _mapSMSLoginState(SMSLoginButtonPressed event) async* {
    yield LoginInProgress();
    try {
      //
      OAuth oauth = await _userRepository.smsOAuth(event.mobile, event.code);
      if (oauth.statusCode == 200) {
        // 用户名密码正确，登录成功
        yield SMSLoginSuccess();
      } else {
        // 用户名密码错误，登录失败
        yield LoginError();
      }
    } catch (error) {
      // 网络或其他错误
      yield LoginFailure(error: error.toString());
    }
  }

  Stream<LoginState> _mapRegisterState(RegisterButtonPressed event) async* {
    yield RegisterInProgress();
    try {
      //
      JsonResult jsonResult =
          await _userRepository.register(event.mobile, event.password);
      if (jsonResult.statusCode == 200) {
        yield RegisterSuccess();
      } else {
        yield RegisterError(
            message: jsonResult.message, statusCode: jsonResult.statusCode);
      }
    } catch (error) {
      // 网络或其他错误
      yield LoginFailure(error: error.toString());
    }
  }

  Stream<LoginState> _mapRequestCodeState(
      RequestCodeButtonPressed event) async* {
    yield RequestCodeInProgress();
    try {
      //
      CodeResult codeResult = await _userRepository.requestCode(event.mobile);
      if (codeResult.statusCode == 200) {
        yield RequestCodeSuccess(codeResult: codeResult);
      } else {
        yield RequestCodeError(
            message: codeResult.message, statusCode: codeResult.statusCode);
      }
    } catch (error) {
      // 网络或其他错误
      yield LoginFailure(error: error.toString());
    }
  }

  Stream<LoginState> _mapBindMobileState(BindMobileEvent event) async* {
    yield BindMobileInProgress();
    try {
      //
      JsonResult jsonResult = await _userRepository.bindMobile(event.mobile);
      if (jsonResult.statusCode == 200) {
        yield BindMobileSuccess(jsonResult: jsonResult);
      } else {
        yield BindMobileError(
            message: jsonResult.message, statusCode: jsonResult.statusCode);
      }
    } catch (error) {
      // 网络或其他错误
      yield LoginFailure(error: error.toString());
    }
  }

  Stream<LoginState> _mapUnionidOAuthState(UnionidOAuthEvent event) async* {
    yield UnionidOAuthInProgress();
    try {
      //
      OAuth oauth = await _userRepository.unionIdOAuth(event.unionid);
      if (oauth.statusCode == 200) {
        // 登录成功
        yield UnionidLoginSuccess();
      } else {
        // 登录失败
        yield LoginError();
      }
    } catch (error) {
      // 网络或其他错误
      yield LoginFailure(error: error.toString());
    }
  }

  Stream<LoginState> _mapResetPasswordState(
      ResetPasswordButtonPressed event) async* {
    yield ResetPasswordInProgress();
    try {
      //
      JsonResult jsonResult =
          await _userRepository.changePassword(event.mobile, event.password);
      if (jsonResult.statusCode == 200) {
        yield ResetPasswordSuccess();
      } else {
        yield ResetPasswordError(
            message: jsonResult.message, statusCode: jsonResult.statusCode);
      }
    } catch (error) {
      // 网络或其他错误
      yield LoginFailure(error: error.toString());
    }
  }

  Stream<LoginState> _mapUpdatePasswordState(
      UpdatePasswordButtonPressed event) async* {
    //
    yield UpdatePasswordInProgress();
    try {
      //
      JsonResult jsonResult =
          await _userRepository.changePassword(event.mobile, event.password);
      if (jsonResult.statusCode == 200) {
        yield UpdatePasswordSuccess();
      } else {
        yield UpdatePasswordError(
            message: jsonResult.message, statusCode: jsonResult.statusCode);
      }
    } catch (error) {
      // 网络或其他错误
      yield LoginFailure(error: error.toString());
    }
  }
}
