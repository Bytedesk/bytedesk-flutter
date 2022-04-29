import 'dart:async';
import 'package:bytedesk_kefu/blocs/help_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpArticle.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/repositories/help_repository.dart';
import 'package:bloc/bloc.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  //
  final HelpRepository helpRepository = new HelpRepository();

  HelpBloc() : super(new UnHelpState());

  @override
  Stream<HelpState> mapEventToState(HelpEvent event) async* {
    if (event is GetHelpCategoryEvent) {
      yield* _mapGetHelpCategoryToState(event);
    } else if (event is GetHelpArticleEvent) {
      yield* _mapGetHelpArticleState(event);
    }
  }

  Stream<HelpState> _mapGetHelpCategoryToState(
      GetHelpCategoryEvent event) async* {
    yield HelpLoading();
    try {
      final List<HelpCategory> categoryList =
          await helpRepository.getHelpCategories(event.uid);
      yield HelpCategoryState(categoryList);
    } catch (error) {
      print(error);
      yield HelpLoadError();
    }
  }

  Stream<HelpState> _mapGetHelpArticleState(GetHelpArticleEvent event) async* {
    yield HelpLoading();
    try {
      final List<HelpArticle> categoryList =
          await helpRepository.getCategoryArticles(event.categoryId);
      yield HelpArticleState(categoryList);
    } catch (error) {
      print(error);
      yield HelpLoadError();
    }
  }
}
