import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CopyBoardEvent extends Equatable {
  const CopyBoardEvent();

  @override
  List<Object> get props => [];
}

class CopyBoardRequestThreadEvent extends CopyBoardEvent {
  const CopyBoardRequestThreadEvent() : super();
}

class CopyBoardLoadMessageEvent extends CopyBoardEvent {
  final String? topic;
  final int? page;
  final int? size;
  const CopyBoardLoadMessageEvent(
      {@required this.topic, @required this.page, @required this.size})
      : super();
}

class CopyBoardSendMessageEvent extends CopyBoardEvent {
  final String? json;
  // final String? type;
  const CopyBoardSendMessageEvent({@required this.json}) : super();
}
