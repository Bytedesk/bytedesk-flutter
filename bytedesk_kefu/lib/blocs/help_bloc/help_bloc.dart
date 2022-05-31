// import 'dart:async';
import 'package:bytedesk_kefu/blocs/help_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpArticle.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/repositories/help_repository.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bloc/bloc.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  //
  final HelpRepository helpRepository = new HelpRepository();

  HelpBloc() : super(new UnHelpState()) {
    on<GetHelpCategoryEvent>(_mapGetHelpCategoryToState);
    on<GetHelpArticleEvent>(_mapGetHelpArticleState);
  }

  // @override
  // Stream<HelpState> mapEventToState(HelpEvent event) async* {
  //   if (event is GetHelpCategoryEvent) {
  //     yield* _mapGetHelpCategoryToState(event);
  //   } else if (event is GetHelpArticleEvent) {
  //     yield* _mapGetHelpArticleState(event);
  //   }
  // }

  void _mapGetHelpCategoryToState(
      GetHelpCategoryEvent event, Emitter<HelpState> emit) async {
    emit(HelpLoading());
    try {
      final List<HelpCategory> categoryList =
          await helpRepository.getHelpCategories(event.uid);
      emit(HelpCategoryState(categoryList));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(HelpLoadError());
    }
  }

  void _mapGetHelpArticleState(
      GetHelpArticleEvent event, Emitter<HelpState> emit) async {
    emit(HelpLoading());
    try {
      final List<HelpArticle> categoryList =
          await helpRepository.getCategoryArticles(event.categoryId);
      emit(HelpArticleState(categoryList));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(HelpLoadError());
    }
  }
}
