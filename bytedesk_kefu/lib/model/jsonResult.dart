import 'package:equatable/equatable.dart';

class JsonResult extends Equatable {
  final String? message;
  final int? statusCode;
  final String? data;

  JsonResult({this.message, this.statusCode, this.data}) : super();

  static JsonResult fromJson(dynamic json) {
    return JsonResult(
        message: json["message"], statusCode: json["status_code"]);
  }

  @override
  List<Object> get props => [this.message!, this.statusCode!];
}
