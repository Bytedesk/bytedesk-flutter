import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LeaveMsgEvent extends Equatable {
  const LeaveMsgEvent();

  @override
  List<Object> get props => [];
}

class GetLeaveMsgCategoryEvent extends LeaveMsgEvent {
  final String? uid;
  GetLeaveMsgCategoryEvent({@required this.uid}) : super();
}

class SubmitLeaveMsgEvent extends LeaveMsgEvent {
  final List<String>? imageUrls;
  final String? content;

  SubmitLeaveMsgEvent({@required this.content, @required this.imageUrls})
      : super();
}

class UploadImageEvent extends LeaveMsgEvent {
  final String? filePath;

  UploadImageEvent({@required this.filePath}) : super();
}
