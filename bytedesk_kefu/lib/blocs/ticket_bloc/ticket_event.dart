import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object> get props => [];
}

class GetTicketCategoryEvent extends TicketEvent {}

class SubmitTicketEvent extends TicketEvent {
  final List<String>? imageUrls;
  final String? content;

  SubmitTicketEvent({@required this.content, @required this.imageUrls})
      : super();
}

class UploadImageEvent extends TicketEvent {
  final String? filePath;

  UploadImageEvent({@required this.filePath}) : super();
}
