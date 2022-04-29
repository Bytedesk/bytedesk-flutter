import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FriendEvent extends Equatable {
  const FriendEvent();
  @override
  List<Object> get props => [];
}

class InitFriendEvent extends FriendEvent {}

class QueryFriendEvent extends FriendEvent {
  final int? page;
  final int? size;

  QueryFriendEvent({@required this.page, @required this.size});
}

class UploadFriendAddressEvent extends FriendEvent {
  final String? nickname;
  final String? mobile;

  UploadFriendAddressEvent({@required this.nickname, @required this.mobile});
}

class QueryFriendAddressEvent extends FriendEvent {
  final int? page;
  final int? size;

  QueryFriendAddressEvent({@required this.page, @required this.size});
}

class QueryFriendNearbyEvent extends FriendEvent {
  final int? page;
  final int? size;

  QueryFriendNearbyEvent({@required this.page, @required this.size});
}

class UpdateFriendNearbyEvent extends FriendEvent {
  final double? latitude;
  final double? longtitude;

  UpdateFriendNearbyEvent({@required this.latitude, @required this.longtitude});
}
