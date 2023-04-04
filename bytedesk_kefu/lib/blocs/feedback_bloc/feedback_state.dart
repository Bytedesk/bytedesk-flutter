import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnFeedbackState extends FeedbackState {
  const UnFeedbackState();

  @override
  String toString() => 'UnFeedbackState';
}

class FeedbackEmpty extends FeedbackState {
  @override
  String toString() => 'FeedbackEmpty';
}

class FeedbackLoading extends FeedbackState {
  @override
  String toString() => 'FeedbackLoading';
}

class FeedbackLoadError extends FeedbackState {
  @override
  String toString() => 'FeedbackLoadError';
}

/// Initialized
class FeedbackCategoryState extends FeedbackState {
  final List<HelpCategory> categoryList;

  const FeedbackCategoryState(this.categoryList) : super();

  @override
  String toString() => 'GetFeedbackCategoryState';
}

class FeedbackSubmiting extends FeedbackState {
  @override
  String toString() => 'FeedbackSubmiting';
}

class FeedbackSubmitSuccess extends FeedbackState {
  @override
  String toString() => 'FeedbackSubmitSuccess';
}

class FeedbackSubmitError extends FeedbackState {
  @override
  String toString() => 'FeedbackSubmitError';
}

class ImageUploading extends FeedbackState {
  @override
  String toString() => 'ImageUploading';
}

class UploadImageSuccess extends FeedbackState {
  //
  final String url;
  const UploadImageSuccess(this.url);
  @override
  List<Object> get props => [url];
  @override
  String toString() => 'UploadImageSuccess { logo: $url }';
}

class UpLoadImageError extends FeedbackState {
  @override
  String toString() => 'UpLoadImageError';
}
