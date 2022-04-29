import 'dart:async';
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

  MessageBloc() : super(InitialMessageState());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is ReceiveMessageEvent) {
      yield* _mapRefreshCourseToState(event);
    } else if (event is UploadImageEvent) {
      yield* _mapUploadImageToState(event);
    } else if (event is UploadVideoEvent) {
      yield* _mapUploadVideoToState(event);
    } else if (event is QueryAnswerEvent) {
      yield* _mapQueryAnswerToState(event);
    } else if (event is MessageAnswerEvent) {
      yield* _mapMessageAnswerToState(event);
    } else if (event is RateAnswerEvent) {
      yield* _mapRateAnswerToState(event);
    } else if (event is LoadHistoryMessageEvent) {
      yield* _mapLoadHistoryMessageToState(event);
    } else if (event is LoadTopicMessageEvent) {
      yield* _mapLoadTopicMessageToState(event);
    } else if (event is LoadChannelMessageEvent) {
      yield* _mapLoadChannelMessageToState(event);
    } else if (event is SendMessageRestEvent) {
      yield* _mapSendMessageRestToState(event);
    }
  }

  Stream<MessageState> _mapRefreshCourseToState(
      ReceiveMessageEvent event) async* {
    try {
      yield ReceiveMessageState(message: event.message);
    } catch (error) {
      print(error);
    }
  }

  Stream<MessageState> _mapUploadImageToState(UploadImageEvent event) async* {
    yield MessageUpLoading();
    try {
      final UploadJsonResult uploadJsonResult =
          await messageRepository.uploadImage(event.filePath);
      yield UploadImageSuccess(uploadJsonResult);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<MessageState> _mapUploadVideoToState(UploadVideoEvent event) async* {
    yield MessageUpLoading();
    try {
      final UploadJsonResult uploadJsonResult =
          await messageRepository.uploadVideo(event.filePath);
      yield UploadVideoSuccess(uploadJsonResult);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<MessageState> _mapSendMessageRestToState(
      SendMessageRestEvent event) async* {
    yield RestMessageSending();
    try {
      final JsonResult jsonResult =
          await messageRepository.sendMessageRest(event.json);
      yield SendMessageRestSuccess(jsonResult);
    } catch (error) {
      print(error);
      yield SendMessageRestError();
    }
  }

  Stream<MessageState> _mapLoadHistoryMessageToState(
      LoadHistoryMessageEvent event) async* {
    yield MessageLoading();
    try {
      final List<Message> messageList = await messageRepository
          .loadHistoryMessages(event.uid, event.page, event.size);
      yield LoadHistoryMessageSuccess(messageList: messageList);
    } catch (error) {
      print(error);
      yield LoadHistoryMessageError();
    }
  }

  Stream<MessageState> _mapLoadTopicMessageToState(
      LoadTopicMessageEvent event) async* {
    yield MessageLoading();
    try {
      final List<Message> messageList = await messageRepository
          .loadTopicMessages(event.topic, event.page, event.size);
      yield LoadTopicMessageSuccess(messageList: messageList);
    } catch (error) {
      print(error);
      yield LoadTopicMessageError();
    }
  }

  Stream<MessageState> _mapLoadChannelMessageToState(
      LoadChannelMessageEvent event) async* {
    yield MessageLoading();
    try {
      final List<Message> messageList = await messageRepository
          .loadChannelMessages(event.cid, event.page, event.size);
      yield LoadChannelMessageSuccess(messageList: messageList);
    } catch (error) {
      print(error);
      yield LoadChannelMessageError();
    }
  }

  Stream<MessageState> _mapQueryAnswerToState(QueryAnswerEvent event) async* {
    yield MessageLoading();
    try {
      final RequestAnswerResult requestAnswerResult =
          await messageRepository.queryAnswer(event.tid, event.aid);
      yield QueryAnswerSuccess(
          query: requestAnswerResult.query, answer: requestAnswerResult.anwser);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<MessageState> _mapMessageAnswerToState(
      MessageAnswerEvent event) async* {
    yield MessageLoading();
    try {
      final RequestAnswerResult requestAnswerResult = await messageRepository
          .messageAnswer(event.type, event.wid, event.aid, event.content);
      yield MessageAnswerSuccess(
          query: requestAnswerResult.query, answer: requestAnswerResult.anwser);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<MessageState> _mapRateAnswerToState(RateAnswerEvent event) async* {
    yield MessageLoading();
    try {
      final RequestAnswerResult requestAnswerResult =
          await messageRepository.rateAnswer(event.aid, event.mid, event.rate);
      yield RateAnswerSuccess(result: requestAnswerResult.anwser);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }
}
