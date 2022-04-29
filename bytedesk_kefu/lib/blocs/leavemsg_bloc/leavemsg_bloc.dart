import 'dart:async';
import 'package:bytedesk_kefu/blocs/leavemsg_bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/repositories/leavemsg_repository.dart';

class LeaveMsgBloc extends Bloc<LeaveMsgEvent, LeaveMsgState> {
  //
  final LeaveMsgRepository leaveMsgRepository = new LeaveMsgRepository();

  LeaveMsgBloc() : super(new UnLeaveMsgState());

  @override
  Stream<LeaveMsgState> mapEventToState(
    LeaveMsgEvent event,
  ) async* {
    // if (event is GetLeaveMsgCategoryEvent) {
    //   yield* _mapGetLeaveMsgCategoryToState(event);
    // } else
    if (event is SubmitLeaveMsgEvent) {
      yield* _mapSubmitLeaveMsgToState(event);
    } else if (event is UploadImageEvent) {
      yield* _mapUploadImageToState(event);
    }
  }

  // Stream<LeaveMsgState> _mapGetLeaveMsgCategoryToState(
  //     GetLeaveMsgCategoryEvent event) async* {
  //   yield LeaveMsgLoading();
  //   try {
  //     final List<HelpCategory> categoryList =
  //         await leaveMsgRepository.getHelpLeaveMsgCategories(event.uid);
  //     yield LeaveMsgCategoryState(categoryList);
  //   } catch (error) {
  //     print(error);
  //     yield LeaveMsgLoadError();
  //   }
  // }

  Stream<LeaveMsgState> _mapSubmitLeaveMsgToState(
      SubmitLeaveMsgEvent event) async* {
    yield LeaveMsgSubmiting();
    try {
      // final JsonResult jsonResult =
      await leaveMsgRepository.submitLeaveMsg(event.content, event.imageUrls);
      yield LeaveMsgSubmitSuccessState();
    } catch (error) {
      print(error);
      yield LeaveMsgSubmitError();
    }
  }

  Stream<LeaveMsgState> _mapUploadImageToState(UploadImageEvent event) async* {
    yield ImageUploading();
    try {
      final String url = await leaveMsgRepository.upload(event.filePath);
      yield UploadImageSuccess(url);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }
}
