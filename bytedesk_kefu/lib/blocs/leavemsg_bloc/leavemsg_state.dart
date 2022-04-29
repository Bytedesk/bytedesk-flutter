// import 'package:bytedesk_kefu/model/helpCategory.dart'; 
import 'package:equatable/equatable.dart';

abstract class LeaveMsgState extends Equatable {
  LeaveMsgState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnLeaveMsgState extends LeaveMsgState {
  UnLeaveMsgState();

  @override
  String toString() => 'UnLeaveMsgState';
}

class LeaveMsgEmpty extends LeaveMsgState {
  @override
  String toString() => 'LeaveMsgEmpty';
}

class LeaveMsgSubmiting extends LeaveMsgState {
  @override
  String toString() => 'LeaveMsgSubmiting';
}

class LeaveMsgSubmitError extends LeaveMsgState {
  @override
  String toString() => 'LeaveMsgSubmitError';
}

/// Initialized
class LeaveMsgSubmitSuccessState extends LeaveMsgState {
  LeaveMsgSubmitSuccessState() : super();

  @override
  String toString() => 'LeaveMsgSubmitSuccessState';
}

class ImageUploading extends LeaveMsgState {
  @override
  String toString() => 'ImageUploading';
}

class UploadImageSuccess extends LeaveMsgState {
  //
  final String url;
  UploadImageSuccess(this.url);
  @override
  List<Object> get props => [url];
  @override
  String toString() => 'UploadImageSuccess { logo: $url }';
}

class UpLoadImageError extends LeaveMsgState {
  @override
  String toString() => 'UpLoadImageError';
}
