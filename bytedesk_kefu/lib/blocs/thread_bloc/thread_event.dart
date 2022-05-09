import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ThreadEvent extends Equatable {
  const ThreadEvent();

  @override
  List<Object> get props => [];
}

// class InitThreadEvent extends ThreadEvent {}

class RefreshThreadEvent extends ThreadEvent {}

class RefreshHistoryThreadEvent extends ThreadEvent {
  final int? page;
  final int? size;
  //
  RefreshHistoryThreadEvent({@required this.page, @required this.size})
      : super();
}

class RefreshVisitorThreadEvent extends ThreadEvent {
  final int? page;
  final int? size;
  //
  RefreshVisitorThreadEvent({@required this.page, @required this.size})
      : super();
}

class RefreshVisitorThreadAllEvent extends ThreadEvent {
  //
  RefreshVisitorThreadAllEvent() : super();
}

class UpdateThreadEvent extends ThreadEvent {
  final String? tid;

  UpdateThreadEvent({@required this.tid})
      : assert(tid != null),
        super();
}

class DeleteThreadEvent extends ThreadEvent {
  final String? tid;

  DeleteThreadEvent({@required this.tid})
      : assert(tid != null),
        super();
}

// 请求客服会话
class RequestThreadEvent extends ThreadEvent {
  final String? wid;
  final String? type;
  final String? aid;
  final bool? isV2Robot;

  RequestThreadEvent(
      {@required this.wid, @required this.type, @required this.aid, @required this.isV2Robot})
      : super();
}

// 请求人工客服，不管此工作组是否设置为默认机器人，只要有人工客服在线，则可以直接对接人工
class RequestAgentEvent extends ThreadEvent {
  final String? wid;
  final String? type;
  final String? aid;

  RequestAgentEvent(
      {@required this.wid, @required this.type, @required this.aid})
      : super();
}

class RequestContactThreadEvent extends ThreadEvent {
  final String? cid;

  RequestContactThreadEvent({@required this.cid}) : super();
}

class RequestGroupThreadEvent extends ThreadEvent {
  final String? gid;

  RequestGroupThreadEvent({@required this.gid}) : super();
}

class MarkTopThreadEvent extends ThreadEvent {
  final String? tid;

  MarkTopThreadEvent({@required this.tid}) : super();
}

class UnMarkTopThreadEvent extends ThreadEvent {
  final String? tid;

  UnMarkTopThreadEvent({@required this.tid}) : super();
}

class MarkNodisturbThreadEvent extends ThreadEvent {
  final String? tid;

  MarkNodisturbThreadEvent({@required this.tid}) : super();
}

class UnMarkNodisturbThreadEvent extends ThreadEvent {
  final String? tid;

  UnMarkNodisturbThreadEvent({@required this.tid}) : super();
}

class MarkUnreadThreadEvent extends ThreadEvent {
  final String? tid;

  MarkUnreadThreadEvent({@required this.tid}) : super();
}

class UnMarkUnreadThreadEvent extends ThreadEvent {
  final String? tid;

  UnMarkUnreadThreadEvent({@required this.tid}) : super();
}
