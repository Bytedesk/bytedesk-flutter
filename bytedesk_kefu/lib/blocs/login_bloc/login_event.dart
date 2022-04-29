import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  //
  final String? username;
  final String? password;

  LoginButtonPressed({@required this.username, @required this.password})
      : super();

  @override
  String toString() {
    return 'LoginButtonPressed { username: $username, password: $password }';
  }
}

class SMSLoginButtonPressed extends LoginEvent {
  //
  final String? mobile;
  final String? code;

  SMSLoginButtonPressed({@required this.mobile, @required this.code}) : super();

  @override
  String toString() {
    return 'SMSLoginButtonPressed { username: $mobile, password: $code }';
  }
}

class RegisterButtonPressed extends LoginEvent {
  //
  final String? mobile;
  final String? password;
  //
  RegisterButtonPressed({@required this.mobile, @required this.password})
      : super();
  @override
  String toString() {
    return 'RegisterButtonPressed { mobile: $mobile, password: $password }';
  }
}

class RequestCodeButtonPressed extends LoginEvent {
  //
  final String? mobile;
  RequestCodeButtonPressed({@required this.mobile}) : super();
  @override
  String toString() {
    return 'RequestCodeButtonPressed { mobile: $mobile}';
  }
}

class BindMobileEvent extends LoginEvent {
  //
  final String? mobile;
  BindMobileEvent({@required this.mobile}) : super();
  @override
  String toString() {
    return 'BindMobileEvent { mobile: $mobile}';
  }
}

class UnionidOAuthEvent extends LoginEvent {
  //
  final String? unionid;
  UnionidOAuthEvent({@required this.unionid}) : super();
  //
  @override
  String toString() {
    return 'UnionidOAuthEvent { unionid: $unionid}';
  }
}

class ResetPasswordButtonPressed extends LoginEvent {
  //
  final String? mobile;
  final String? password;
  ResetPasswordButtonPressed({@required this.mobile, @required this.password})
      : super();
  @override
  String toString() {
    return 'ResetPasswordButtonPressed { mobile: $mobile, password: $password }';
  }
}

class UpdatePasswordButtonPressed extends LoginEvent {
  //
  final String? mobile;
  final String? password;

  UpdatePasswordButtonPressed({@required this.mobile, @required this.password})
      : super();

  @override
  String toString() {
    return 'UpdatePasswordButtonPressed { mobile: $mobile, password: $password }';
  }
}

// 将unionid绑定到已经存在的手机账号
class BindWechatMobileEvent extends LoginEvent {
  //
  final String? mobile;
  final String? unionid;
  //
  BindWechatMobileEvent({@required this.mobile, @required this.unionid})
      : super();
  //
  @override
  String toString() {
    return 'BindWechatMobileEvent { username: $mobile, password: $unionid }';
  }
}
