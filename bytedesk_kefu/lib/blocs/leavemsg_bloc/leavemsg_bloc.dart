// import 'dart:async';
import 'package:bytedesk_kefu/blocs/leavemsg_bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/repositories/leavemsg_repository.dart';

class LeaveMsgBloc extends Bloc<LeaveMsgEvent, LeaveMsgState> {
  //
  final LeaveMsgRepository leaveMsgRepository = new LeaveMsgRepository();

  LeaveMsgBloc() : super(new UnLeaveMsgState()) {
    on<SubmitLeaveMsgEvent>(_mapSubmitLeaveMsgToState);
    on<UploadImageEvent>(_mapUploadImageToState);
  }

  // @override
  // Stream<LeaveMsgState> mapEventToState(
  //   LeaveMsgEvent event,
  // ) async* {
  //   if (event is SubmitLeaveMsgEvent) {
  //     yield* _mapSubmitLeaveMsgToState(event);
  //   } else if (event is UploadImageEvent) {
  //     yield* _mapUploadImageToState(event);
  //   }
  // }

  void _mapSubmitLeaveMsgToState(
      SubmitLeaveMsgEvent event, Emitter<LeaveMsgState> emit) async {
    emit(LeaveMsgSubmiting());
    try {
      // final JsonResult jsonResult =
      await leaveMsgRepository.submitLeaveMsg(event.content, event.imageUrls);
      emit(LeaveMsgSubmitSuccessState());
    } catch (error) {
      print(error);
      emit(LeaveMsgSubmitError());
    }
  }

  void _mapUploadImageToState(UploadImageEvent event, Emitter<LeaveMsgState> emit) async {
    emit(ImageUploading());
    try {
      final String url = await leaveMsgRepository.upload(event.filePath);
      emit(UploadImageSuccess(url));
    } catch (error) {
      print(error);
      emit(UpLoadImageError());
    }
  }
}
