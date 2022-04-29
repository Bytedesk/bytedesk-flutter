import 'package:equatable/equatable.dart';

class CodeResult extends Equatable {
  //
  final String? message;
  final int? statusCode;
  final bool? exist;
  final String? code;

  CodeResult({this.message, this.statusCode, this.exist, this.code}) : super();

  static CodeResult fromJson(dynamic json) {
    return CodeResult(
        message: json["message"],
        statusCode: json["status_code"],
        exist: json["data"]["exist"],
        code: json["data"]["code"]);
  }

  @override
  List<Object> get props =>
      [this.message!, this.statusCode!, this.exist!, this.code!];
}
