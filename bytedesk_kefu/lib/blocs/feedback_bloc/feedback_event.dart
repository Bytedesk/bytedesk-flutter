import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class GetFeedbackCategoryEvent extends FeedbackEvent {
  final String? uid;
  GetFeedbackCategoryEvent({@required this.uid}) : super();
}

class SubmitFeedbackEvent extends FeedbackEvent {
  final List<String>? imageUrls;
  final String? content;

  SubmitFeedbackEvent({@required this.content, @required this.imageUrls})
      : super();
}

class UploadImageEvent extends FeedbackEvent {
  final String? filePath;

  UploadImageEvent({@required this.filePath}) : super();
}
