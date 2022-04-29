import 'package:equatable/equatable.dart';
import 'message.dart';

class RequestAnswerResult extends Equatable {
  final String? message;
  final int? statusCode;
  //
  final Message? query;
  final Message? anwser;

  RequestAnswerResult({this.message, this.statusCode, this.query, this.anwser})
      : super();

  static RequestAnswerResult fromJson(dynamic json) {
    return RequestAnswerResult(
        message: json["message"],
        statusCode: json["status_code"],
        query: Message.fromJsonThread(json["data"]["query"]),
        anwser: Message.fromJsonThread(json["data"]["reply"]));
  }

  static RequestAnswerResult fromRateJson(dynamic json) {
    return RequestAnswerResult(
        message: json["message"],
        statusCode: json["status_code"],
        anwser: Message.fromJsonThread(json["data"]));
  }

  @override
  List<Object> get props => [this.statusCode!];
}
