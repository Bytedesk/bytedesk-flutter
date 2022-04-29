import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HelpEvent extends Equatable {
  const HelpEvent();

  @override
  List<Object> get props => [];
}

class GetHelpCategoryEvent extends HelpEvent {
  final String? uid;
  GetHelpCategoryEvent({@required this.uid}) : super();
}

class GetHelpArticleEvent extends HelpEvent {
  final int? categoryId;

  GetHelpArticleEvent({@required this.categoryId}) : super();
}
