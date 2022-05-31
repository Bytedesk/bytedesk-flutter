// import 'dart:async';
import 'package:bytedesk_kefu/blocs/feedback_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
// import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu/repositories/feedback_repository.dart';
import 'package:bloc/bloc.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  //
  final FeedbackRepository feedbackRepository = new FeedbackRepository();

  FeedbackBloc() : super(new UnFeedbackState()) {
    on<GetFeedbackCategoryEvent>(_mapGetFeedbackCategoryToState);
    on<SubmitFeedbackEvent>(_mapSubmitFeedbackToState);
    on<UploadImageEvent>(_mapUploadImageToState);
  }

  // @override
  // void mapEventToState(
  //   FeedbackEvent event,
  // ) async {
  //   if (event is GetFeedbackCategoryEvent) {
  //     yield* _mapGetFeedbackCategoryToState(event);
  //   } else if (event is SubmitFeedbackEvent) {
  //     yield* _mapSubmitFeedbackToState(event);
  //   } else if (event is UploadImageEvent) {
  //     yield* _mapUploadImageToState(event);
  //   }
  // }

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
