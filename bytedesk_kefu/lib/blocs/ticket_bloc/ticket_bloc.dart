// import 'dart:async';
import 'package:bytedesk_kefu/blocs/ticket_bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu/repositories/ticket_repository.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  //
  final TicketRepository feedbackRepository = new TicketRepository();

  TicketBloc() : super(new UnTicketState()) {
    on<GetTicketCategoryEvent>(_mapGetTicketCategoryToState);
    on<SubmitTicketEvent>(_mapSubmitTicketToState);
    on<UploadImageEvent>(_mapUploadImageToState);
  }

  // @override
  // void mapEventToState(
  //   TicketEvent event,
  // ) async* {
  //   if (event is GetTicketCategoryEvent) {
  //     yield* _mapGetTicketCategoryToState(event);
  //   } else if (event is SubmitTicketEvent) {
  //     yield* _mapSubmitTicketToState(event);
  //   } else if (event is UploadImageEvent) {
  //     yield* _mapUploadImageToState(event);
  //   }
  // }

  void _mapGetTicketCategoryToState(
      GetTicketCategoryEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      // final List<HelpCategory> categoryList =
      //     await feedbackRepository.getHelpTicketCategories();
      // emit(TicketCategoryState(categoryList);
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(TicketLoadError());
    }
  }

  void _mapSubmitTicketToState(
      SubmitTicketEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      // final List<HelpCategory> categoryList =
      //     await feedbackRepository.getHelpTicketCategories();
      // emit(TicketCategoryState(categoryList);
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(TicketLoadError());
    }
  }

  void _mapUploadImageToState(
      UploadImageEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      final String url = await feedbackRepository.upload(event.filePath);
      emit(UploadImageSuccess(url));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(UpLoadImageError());
    }
  }
}
