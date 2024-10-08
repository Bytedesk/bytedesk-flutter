// ignore_for_file: file_names

import 'package:bytedesk_kefu/model/visitor.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_util/sp_util.dart';

import '../util/bytedesk_constants.dart';

class VisitorJsonResult extends Equatable {
  //
  final String? message;
  final int? code;
  final Visitor? visitor;

  const VisitorJsonResult({this.message, this.code, this.visitor})
      : super();

  static VisitorJsonResult fromJson(dynamic json) {
    Visitor visitor = Visitor.fromJson(json['data']);
    // 
    SpUtil.putString(BytedeskConstants.VISITOR_UID, visitor.uid!);
    SpUtil.putString(BytedeskConstants.VISITOR_NICKNAME, visitor.nickname!);
    SpUtil.putString(BytedeskConstants.VISITOR_AVATAR, visitor.avatar!);
    // 
    return VisitorJsonResult(
        message: json["message"],
        code: json["code"],
        visitor: visitor
    );
  }

  @override
  List<Object> get props => [visitor!.uid!];
}
