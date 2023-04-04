// import 'dart:async';
import 'package:bytedesk_kefu/blocs/copyboard_bloc/copyboard_event.dart';
import 'package:bytedesk_kefu/blocs/copyboard_bloc/copyboard_state.dart';
// import 'package:bytedesk_kefu/model/copyboard.dart';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/message.dart';
// import 'package:bytedesk_kefu/model/requestThread.dart';
import 'package:bytedesk_kefu/model/requestThreadFileHelper.dart';
import 'package:bytedesk_kefu/repositories/copyboard_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';

class CopyBoardBloc extends Bloc<CopyBoardEvent, CopyBoardState> {
  //
  final CopyBoardRepository copyboardRepository = CopyBoardRepository();

  CopyBoardBloc() : super(const UnCopyBoardState()) {
    on<CopyBoardRequestThreadEvent>(_mapCopyBoardRequestThreadEventToState);
    on<CopyBoardLoadMessageEvent>(_mapCopyBoardLoadEventToState);
    on<CopyBoardSendMessageEvent>(_mapCopyBoardSendEventState);
  }

  void _mapCopyBoardRequestThreadEventToState(
      CopyBoardRequestThreadEvent event, Emitter<CopyBoardState> emit) async {
    emit(CopyBoardLoading());
    try {
      final RequestThreadFileHelperResult requestThreadResult =
          await copyboardRepository.requestFileHelperThread();
      emit(CopyBoardRequestThreadSuccess(requestThreadResult));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(CopyBoardLoadError());
    }
  }

  void _mapCopyBoardLoadEventToState(
      CopyBoardLoadMessageEvent event, Emitter<CopyBoardState> emit) async {
    emit(CopyBoardLoading());
    try {
      final List<Message> messageList = await copyboardRepository.getCopyBoards(
          event.topic, event.page, event.size);
      emit(CopyBoardLoadMessageSuccess(messageList));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(CopyBoardLoadError());
    }
  }

  void _mapCopyBoardSendEventState(
      CopyBoardSendMessageEvent event, Emitter<CopyBoardState> emit) async {
    emit(CopyBoardLoading());
    try {
      final JsonResult jsonResult =
          await copyboardRepository.sendCopyBoard(event.json);
      if (jsonResult.statusCode == 200) {
        emit(const CopyBoardSendMessageSuccess());
      } else {
        emit(CopyBoardSendError());
      }
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(CopyBoardLoadError());
    }
  }
}
