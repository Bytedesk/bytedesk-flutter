import 'package:equatable/equatable.dart';

class Category extends Equatable {
  //
  final String? cid;
  final String? name;
  //
  Category({this.cid, this.name}) : super();
  //
  static Category fromJson(dynamic json) {
    return Category(
        cid: json['cid'], name: json['name']);
  }

  //
  @override
  List<Object> get props => [cid!];
}
