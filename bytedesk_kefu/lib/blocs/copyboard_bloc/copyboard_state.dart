// import 'package:bytedesk_kefu/model/copyboard.dart';
import 'package:bytedesk_kefu/model/message.dart';
// import 'package:bytedesk_kefu/model/requestThread.dart';
import 'package:bytedesk_kefu/model/requestThreadFileHelper.dart';
import 'package:equatable/equatable.dart';

abstract class CopyBoardState extends Equatable {
  const CopyBoardState();

  @override
  List<Object> get props => [];
}

class UnCopyBoardState extends CopyBoardState {
  const UnCopyBoardState();

  @override
  String toString() => 'UnCopyBoardState';
}

class CopyBoardLoading extends CopyBoardState {
  @override
  String toString() => 'CopyBoardLoading';
}

class CopyBoardLoadError extends CopyBoardState {
  @override
  String toString() => 'CopyBoardLoadError';
}

class CopyBoardEmpty extends CopyBoardState {
  @override
  String toString() => 'CopyBoardEmpty';
}

class CopyBoardRequestThreadSuccess extends CopyBoardState {
  final RequestThreadFileHelperResult? requestThreadResult;

  const CopyBoardRequestThreadSuccess(this.requestThreadResult);

  @override
  List<Object> get props => [requestThreadResult!];

  @override
  String toString() => 'CopyBoardRequestTheradSuccess';
}

class CopyBoardLoadMessageSuccess extends CopyBoardState {
  final List<Message>? messageList;

  const CopyBoardLoadMessageSuccess(this.messageList);

  @override
  List<Object> get props => [messageList!];

  @override
  String toString() =>
      'CopyBoardLoadSuccess { copyboardList: ${messageList!.length} }';
}

class CopyBoardSending extends CopyBoardState {
  @override
  String toString() => 'CopyBoardSending';
}

class CopyBoardSendError extends CopyBoardState {
  @override
  String toString() => 'CopyBoardSendError';
}

/// Initialized
class CopyBoardSendMessageSuccess extends CopyBoardState {
  const CopyBoardSendMessageSuccess() : super();

  @override
  String toString() => 'CopyBoardSendMessageSuccess';
}

class CopyBoardImageUploading extends CopyBoardState {
  @override
  String toString() => 'CopyBoardImageUploading';
}

class CopyBoardUploadImageSuccess extends CopyBoardState {
  //
  final String url;
  const CopyBoardUploadImageSuccess(this.url);

  @override
  List<Object> get props => [url];

  @override
  String toString() => 'CopyBoardUploadImageSuccess { logo: $url }';
}

class CopyBoardUpLoadImageError extends CopyBoardState {
  @override
  String toString() => 'CopyBoardUpLoadImageError';
}
