import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:equatable/equatable.dart';

abstract class TicketState extends Equatable {
  TicketState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnTicketState extends TicketState {
  UnTicketState();

  @override
  String toString() => 'UnTicketState';
}

class TicketEmpty extends TicketState {
  @override
  String toString() => 'TicketEmpty';
}

class TicketLoading extends TicketState {
  @override
  String toString() => 'TicketLoading';
}

class TicketLoadError extends TicketState {
  @override
  String toString() => 'TicketLoadError';
}

/// Initialized
class TicketCategoryState extends TicketState {
  final List<HelpCategory> categoryList;

  TicketCategoryState(this.categoryList) : super();

  @override
  String toString() => 'GetTicketCategoryState';
}

class UploadImageSuccess extends TicketState {
  //
  final String url;
  UploadImageSuccess(this.url);
  @override
  List<Object> get props => [url];
  @override
  String toString() => 'UploadImageSuccess { logo: $url }';
}

class UpLoadImageError extends TicketState {
  @override
  String toString() => 'UpLoadImageError';
}
