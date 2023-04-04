// import 'dart:async';
import 'package:bytedesk_kefu/blocs/leavemsg_bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/repositories/leavemsg_repository.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';

class LeaveMsgBloc extends Bloc<LeaveMsgEvent, LeaveMsgState> {
  //
  final LeaveMsgRepository leaveMsgRepository = LeaveMsgRepository();

  LeaveMsgBloc() : super(const UnLeaveMsgState()) {
    on<SubmitLeaveMsgEvent>(_mapSubmitLeaveMsgToState);
    on<UploadImageEvent>(_mapUploadImageToState);
  }

  void _mapSubmitLeaveMsgToState(
      SubmitLeaveMsgEvent event, Emitter<LeaveMsgState> emit) async {
    emit(LeaveMsgSubmiting());
    try {
      await leaveMsgRepository.submitLeaveMsg(event.wid, event.aid, event.type,
          event.mobile, event.email, event.content);
      emit(const LeaveMsgSubmitSuccessState());
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(LeaveMsgSubmitError());
    }
  }

  void _mapUploadImageToState(
      UploadImageEvent event, Emitter<LeaveMsgState> emit) async {
    emit(ImageUploading());
    try {
      final String url = await leaveMsgRepository.upload(event.filePath);
      emit(UploadImageSuccess(url));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(UpLoadImageError());
    }
  }
}
