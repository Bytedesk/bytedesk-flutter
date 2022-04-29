import 'package:bytedesk_kefu/model/helpArticle.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:equatable/equatable.dart';

abstract class HelpState extends Equatable {
  HelpState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnHelpState extends HelpState {
  UnHelpState();

  @override
  String toString() => 'UnHelpState';
}

class HelpEmpty extends HelpState {
  @override
  String toString() => 'HelpEmpty';
}

class HelpLoading extends HelpState {
  @override
  String toString() => 'HelpLoading';
}

class HelpLoadError extends HelpState {
  @override
  String toString() => 'HelpLoadError';
}

/// Initialized
class HelpCategoryState extends HelpState {
  final List<HelpCategory> categoryList;

  HelpCategoryState(this.categoryList) : super();

  @override
  String toString() => 'GetHelpCategoryState';
}

class HelpArticleState extends HelpState {
  final List<HelpArticle> articleList;

  HelpArticleState(this.articleList) : super();

  @override
  String toString() => 'GetHelpArticleState';
}
