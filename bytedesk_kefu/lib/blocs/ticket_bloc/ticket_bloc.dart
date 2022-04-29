import 'dart:async';
import 'package:bytedesk_kefu/blocs/ticket_bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/repositories/ticket_repository.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  //
  final TicketRepository feedbackRepository = new TicketRepository();

  TicketBloc() : super(new UnTicketState());

  @override
  Stream<TicketState> mapEventToState(
    TicketEvent event,
  ) async* {
    if (event is GetTicketCategoryEvent) {
      yield* _mapGetTicketCategoryToState(event);
    } else if (event is SubmitTicketEvent) {
      yield* _mapSubmitTicketToState(event);
    } else if (event is UploadImageEvent) {
      yield* _mapUploadImageToState(event);
    }
  }

  Stream<TicketState> _mapGetTicketCategoryToState(
      GetTicketCategoryEvent event) async* {
    yield TicketLoading();
    try {
      // final List<HelpCategory> categoryList =
      //     await feedbackRepository.getHelpTicketCategories();
      // yield TicketCategoryState(categoryList);
    } catch (error) {
      print(error);
      yield TicketLoadError();
    }
  }

  Stream<TicketState> _mapSubmitTicketToState(SubmitTicketEvent event) async* {
    yield TicketLoading();
    try {
      // final List<HelpCategory> categoryList =
      //     await feedbackRepository.getHelpTicketCategories();
      // yield TicketCategoryState(categoryList);
    } catch (error) {
      print(error);
      yield TicketLoadError();
    }
  }

  Stream<TicketState> _mapUploadImageToState(UploadImageEvent event) async* {
    yield TicketLoading();
    try {
      final String url = await feedbackRepository.upload(event.filePath);
      yield UploadImageSuccess(url);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }
}
