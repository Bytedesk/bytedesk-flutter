// import 'dart:async';
import 'package:bytedesk_kefu/blocs/feedback_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
// import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu/repositories/feedback_repository.dart';
import 'package:bloc/bloc.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  //
  final FeedbackRepository feedbackRepository = FeedbackRepository();

  FeedbackBloc() : super(const UnFeedbackState()) {
    on<GetFeedbackCategoryEvent>(_mapGetFeedbackCategoryToState);
    on<SubmitFeedbackEvent>(_mapSubmitFeedbackToState);
    on<UploadImageEvent>(_mapUploadImageToState);
  }

  void _mapGetFeedbackCategoryToState(
      GetFeedbackCategoryEvent event, Emitter<FeedbackState> emit) async {
    emit(FeedbackLoading());
    try {
      final List<HelpCategory> categoryList =
          await feedbackRepository.getHelpFeedbackCategories(event.uid);
      emit(FeedbackCategoryState(categoryList));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(FeedbackLoadError());
    }
  }

  void _mapSubmitFeedbackToState(
      SubmitFeedbackEvent event, Emitter<FeedbackState> emit) async {
    emit(FeedbackSubmiting());
    try {
      await feedbackRepository.submitFeedback(event.content, event.imageUrls);
      emit(FeedbackSubmitSuccess());
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(FeedbackSubmitError());
    }
  }

  void _mapUploadImageToState(
      UploadImageEvent event, Emitter<FeedbackState> emit) async {
    emit(ImageUploading());
    try {
      final String url = await feedbackRepository.upload(event.filePath);
      emit(UploadImageSuccess(url));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(UpLoadImageError());
    }
  }
}
