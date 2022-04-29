import 'dart:async';
import 'package:bytedesk_kefu/blocs/feedback_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
// import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/repositories/feedback_repository.dart';
import 'package:bloc/bloc.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  //
  final FeedbackRepository feedbackRepository = new FeedbackRepository();

  FeedbackBloc() : super(new UnFeedbackState());

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {
    if (event is GetFeedbackCategoryEvent) {
      yield* _mapGetFeedbackCategoryToState(event);
    } else if (event is SubmitFeedbackEvent) {
      yield* _mapSubmitFeedbackToState(event);
    } else if (event is UploadImageEvent) {
      yield* _mapUploadImageToState(event);
    }
  }

  Stream<FeedbackState> _mapGetFeedbackCategoryToState(
      GetFeedbackCategoryEvent event) async* {
    yield FeedbackLoading();
    try {
      final List<HelpCategory> categoryList =
          await feedbackRepository.getHelpFeedbackCategories(event.uid);
      yield FeedbackCategoryState(categoryList);
    } catch (error) {
      print(error);
      yield FeedbackLoadError();
    }
  }

  Stream<FeedbackState> _mapSubmitFeedbackToState(
      SubmitFeedbackEvent event) async* {
    yield FeedbackSubmiting();
    try {
      // final JsonResult jsonResult =
      await feedbackRepository.submitFeedback(event.content, event.imageUrls);
      yield FeedbackSubmitSuccess();
    } catch (error) {
      print(error);
      yield FeedbackSubmitError();
    }
  }

  Stream<FeedbackState> _mapUploadImageToState(UploadImageEvent event) async* {
    yield ImageUploading();
    try {
      final String url = await feedbackRepository.upload(event.filePath);
      yield UploadImageSuccess(url);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }
}
