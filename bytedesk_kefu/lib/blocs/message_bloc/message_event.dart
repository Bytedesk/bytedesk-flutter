import 'package:bytedesk_kefu/model/message.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class ReceiveMessageEvent extends MessageEvent {
  final Message? message;

  ReceiveMessageEvent({@required this.message}) : super();
}

class UploadImageEvent extends MessageEvent {
  final String? filePath;

  UploadImageEvent({@required this.filePath}) : super();
}

class UploadVideoEvent extends MessageEvent {
  final String? filePath;

  UploadVideoEvent({@required this.filePath}) : super();
}

class SendMessageRestEvent extends MessageEvent {
  final String? json;

  SendMessageRestEvent({@required this.json}) : super();
}

class LoadHistoryMessageEvent extends MessageEvent {
  final String? uid;
  final int? page;
  final int? size;

  LoadHistoryMessageEvent(
      {@required this.uid, @required this.page, @required this.size})
      : super();
}

class LoadTopicMessageEvent extends MessageEvent {
  final String? topic;
  final int? page;
  final int? size;

  LoadTopicMessageEvent(
      {@required this.topic, @required this.page, @required this.size})
      : super();
}

class LoadChannelMessageEvent extends MessageEvent {
  final String? cid;
  final int? page;
  final int? size;

  LoadChannelMessageEvent(
      {@required this.cid, @required this.page, @required this.size})
      : super();
}

class LoadUnreadMessagesEvent extends MessageEvent {
  final String? wid;
  final int? page;
  final int? size;

  LoadUnreadMessagesEvent(
      {@required this.wid, @required this.page, @required this.size})
      : super();
}

class LoadUnreadVisitorMessagesEvent extends MessageEvent {
  final int? page;
  final int? size;

  LoadUnreadVisitorMessagesEvent(
      {@required this.page, @required this.size})
      : super();
}

class LoadUnreadAgentMessagesEvent extends MessageEvent {
  final int? page;
  final int? size;

  LoadUnreadAgentMessagesEvent({@required this.page, @required this.size})
      : super();
}

class QueryAnswerEvent extends MessageEvent {
  final String? tid;
  final String? aid;
  final String? mid;

  QueryAnswerEvent({@required this.tid, @required this.aid, @required this.mid}) : super();
}

class QueryCategoryEvent extends MessageEvent {
  final String? tid;
  final String? cid;

  QueryCategoryEvent({@required this.tid, @required this.cid})
      : super();
}

class MessageAnswerEvent extends MessageEvent {
  // final String? type;
  final String? wid;
  // final String? aid;
  final String? content;

  MessageAnswerEvent(
      {
        // @required this.type,
      @required this.wid,
      // @required this.aid,
      @required this.content})
      : super();
}

class RateAnswerEvent extends MessageEvent {
  final String? aid;
  final String? mid;
  final bool? rate;

  RateAnswerEvent({@required this.aid, @required this.mid, @required this.rate})
      : super();
}
