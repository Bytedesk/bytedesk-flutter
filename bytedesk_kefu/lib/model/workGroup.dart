import 'package:equatable/equatable.dart';

class WorkGroup extends Equatable {
  final String? wid;
  final String? nickname;

  WorkGroup({this.wid, this.nickname}) : super();

  static WorkGroup fromJson(dynamic json) {
    return WorkGroup(wid: json['wid'], nickname: json['nickname']);
  }

  @override
  List<Object> get props => [];
}
