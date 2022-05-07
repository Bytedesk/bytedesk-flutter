// import 'dart:async';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/message.dart';
import 'package:bytedesk_kefu/model/requestAnswer.dart';
import 'package:bytedesk_kefu/model/uploadJsonResult.dart';
import 'package:bytedesk_kefu/repositories/message_repository.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  //
  final MessageRepository messageRepository = new MessageRepository();

  MessageBloc() : super(InitialMessageState()) {
    on<ReceiveMessageEvent>(_mapRefreshCourseToState);
    on<UploadImageEvent>(_mapUploadImageToState);
    on<UploadVideoEvent>(_mapUploadVideoToState);
    on<SendMessageRestEvent>(_mapSendMessageRestToState);
    on<LoadHistoryMessageEvent>(_mapLoadHistoryMessageToState);
    on<LoadTopicMessageEvent>(_mapLoadTopicMessageToState);

    on<LoadChannelMessageEvent>(_mapLoadChannelMessageToState);
    on<QueryAnswerEvent>(_mapQueryAnswerToState);
    on<MessageAnswerEvent>(_mapMessageAnswerToState);
    on<RateAnswerEvent>(_mapRateAnswerToState);
  }

  // @override
  // void mapEventToState(MessageEvent event, Emitter<MessageState> emit) async {
  //   if (event is ReceiveMessageEvent) {
  //     yield* _mapRefreshCourseToState(event);
  //   } else if (event is UploadImageEvent) {
  //     yield* _mapUploadImageToState(event);
  //   } else if (event is UploadVideoEvent) {
  //     yield* _mapUploadVideoToState(event);
  //   } else if (event is QueryAnswerEvent) {
  //     yield* _mapQueryAnswerToState(event);
  //   } else if (event is MessageAnswerEvent) {
  //     yield* _mapMessageAnswerToState(event);
  //   } else if (event is RateAnswerEvent) {
  //     yield* _mapRateAnswerToState(event);
  //   } else if (event is LoadHistoryMessageEvent) {
  //     yield* _mapLoadHistoryMessageToState(event);
  //   } else if (event is LoadTopicMessageEvent) {
  //     yield* _mapLoadTopicMessageToState(event);
  //   } else if (event is LoadChannelMessageEvent) {
  //     yield* _mapLoadChannelMessageToState(event);
  //   } else if (event is SendMessageRestEvent) {
  //     yield* _mapSendMessageRestToState(event);
  //   }
  // }

  void _mapRefreshCourseToState(ReceiveMessageEvent event, Emitter<MessageState> emit) async {
    try {
      emit(ReceiveMessageState(message: event.message));
    } catch (error) {
      print(error);
    }
  }

  void _mapUploadImageToState(UploadImageEvent event, Emitter<MessageState> emit) async {
    emit(MessageUpLoading());
    try {
      final UploadJsonResult uploadJsonResult =
          await messageRepository.uploadImage(event.filePath);
      emit(UploadImageSuccess(uploadJsonResult));
    } catch (error) {
      print(error);
      emit(UpLoadImageError());
    }
  }

  void _mapUploadVideoToState(UploadVideoEvent event, Emitter<MessageState> emit) async {
    emit(MessageUpLoading());
    try {
      final UploadJsonResult uploadJsonResult =
          await messageRepository.uploadVideo(event.filePath);
      emit(UploadVideoSuccess(uploadJsonResult));
    } catch (error) {
      print(error);
      emit(UpLoadImageError());
    }
  }

  void _mapSendMessageRestToState(SendMessageRestEvent event, Emitter<MessageState> emit) async {
    emit(RestMessageSending());
    try {
      final JsonResult jsonResult =
          await messageRepository.sendMessageRest(event.json);
      emit(SendMessageRestSuccess(jsonResult));
    } catch (error) {
      print(error);
      emit(SendMessageRestError());
    }
  }

  void _mapLoadHistoryMessageToState(LoadHistoryMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageLoading());
    try {
      final List<Message> messageList = await messageRepository
          .loadHistoryMessages(event.uid, event.page, event.size);
      emit(LoadHistoryMessageSuccess(messageList: messageList));
    } catch (error) {
      print(error);
      emit(LoadHistoryMessageError());
    }
  }

  void _mapLoadTopicMessageToState(LoadTopicMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageLoading());
    try {
      final List<Message> messageList = await messageRepository
          .loadTopicMessages(event.topic, event.page, event.size);
      emit(LoadTopicMessageSuccess(messageList: messageList));
    } catch (error) {
      print(error);
      emit(LoadTopicMessageError());
    }
  }

  void _mapLoadChannelMessageToState(LoadChannelMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageLoading());
    try {
      final List<Message> messageList = await messageRepository
          .loadChannelMessages(event.cid, event.page, event.size);
      emit(LoadChannelMessageSuccess(messageList: messageList));
    } catch (error) {
      print(error);
      emit(LoadChannelMessageError());
    }
  }

  void _mapQueryAnswerToState(QueryAnswerEvent event, Emitter<MessageState> emit) async {
    emit(MessageLoading());
    try {
      final RequestAnswerResult requestAnswerResult =
          await messageRepository.queryAnswer(event.tid, event.aid);
      emit(QueryAnswerSuccess(
          query: requestAnswerResult.query, answer: requestAnswerResult.anwser));
    } catch (error) {
      print(error);
      emit(UpLoadImageError());
    }
  }

  void _mapMessageAnswerToState(MessageAnswerEvent event, Emitter<MessageState> emit) async {
    emit(MessageLoading());
    try {
      final RequestAnswerResult requestAnswerResult = await messageRepository
          .messageAnswer(event.type, event.wid, event.aid, event.content);
      emit(MessageAnswerSuccess(
          query: requestAnswerResult.query, answer: requestAnswerResult.anwser));
    } catch (error) {
      print(error);
      emit(UpLoadImageError());
    }
  }

  void _mapRateAnswerToState(RateAnswerEvent event, Emitter<MessageState> emit) async {
    emit(MessageLoading());
    try {
      final RequestAnswerResult requestAnswerResult =
          await messageRepository.rateAnswer(event.aid, event.mid, event.rate);
      emit(RateAnswerSuccess(result: requestAnswerResult.anwser));
    } catch (error) {
      print(error);
      emit(UpLoadImageError());
    }
  }
}