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
  // final List<String>? imageUrls;
  final String? wid;
  final String? aid;
  final String? type;
  final String? mobile;
  final String? email;
  final String? content;
  // @required this.imageUrls
  SubmitLeaveMsgEvent({@required this.wid, @required this.aid, @required this.type, @required this.mobile, @required this.email, @required this.content})
      : super();
}

class UploadImageEvent extends LeaveMsgEvent {
  final String? filePath;

  UploadImageEvent({@required this.filePath}) : super();
}
