import 'package:equatable/equatable.dart';

class MarkThreadResult extends Equatable {
  //
  final String? message;
  final int? statusCode;
  final String? tid;

  MarkThreadResult({this.message, this.statusCode, this.tid}) : super();

  static MarkThreadResult fromJson(dynamic json) {
    return MarkThreadResult(
        message: json["message"],
        statusCode: json["status_code"],
        tid: json["data"]);
  }

  @override
  List<Object> get props => [this.tid!];
}
