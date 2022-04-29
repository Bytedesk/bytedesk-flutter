import 'dart:async';
import 'package:bytedesk_kefu/model/markThread.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:bytedesk_kefu/repositories/repositories.dart';
import 'package:bytedesk_kefu/model/model.dart';

class ThreadBloc extends Bloc<ThreadEvent, ThreadState> {
  //
  final ThreadRepository threadRepository = new ThreadRepository();

  ThreadBloc() : super(ThreadEmpty());

  @override
  Stream<ThreadState> mapEventToState(ThreadEvent event) async* {
    //
    if (event is InitThreadEvent) {
      yield InitialThreadState();
    } else if (event is RefreshThreadEvent) {
      yield* _mapRefreshThreadToState(event);
    } else if (event is RefreshHistoryThreadEvent) {
      yield* _mapRefreshHistoryThreadToState(event);
    } else if (event is RefreshVisitorThreadEvent) {
      yield* _mapRefreshVisitorThreadToState(event);
    } else if (event is RefreshVisitorThreadAllEvent) {
      yield* _mapRefreshVisitorThreadAllToState(event);
    } else if (event is RequestThreadEvent) {
      yield* _mapRequestThreadToState(event);
    } else if (event is RequestAgentEvent) {
      yield* _mapRequestAgentToState(event);
    } else if (event is RequestContactThreadEvent) {
      yield* _mapRequestContactThreadToState(event);
    } else if (event is RequestGroupThreadEvent) {
      yield* _mapRequestGroupThreadToState(event);
    } else if (event is MarkTopThreadEvent) {
      yield* _mapMarkTopThreadEventToState(event);
    } else if (event is UnMarkTopThreadEvent) {
      yield* _mapUnMarkTopThreadEventToState(event);
    } else if (event is MarkNodisturbThreadEvent) {
      yield* _mapMarkNodisturbThreadEventToState(event);
    } else if (event is UnMarkNodisturbThreadEvent) {
      yield* _mapUnMarkNodisturbThreadEventToState(event);
    } else if (event is MarkUnreadThreadEvent) {
      yield* _mapMarkUnreadThreadEventToState(event);
    } else if (event is UnMarkUnreadThreadEvent) {
      yield* _mapUnMarkUnreadThreadEventToState(event);
    } else if (event is DeleteThreadEvent) {
      yield* _mapDeleteThreadEventToState(event);
    }
  }

  Stream<ThreadState> _mapRefreshThreadToState(
      RefreshThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final List<Thread> threadList = await threadRepository.getThreads();
      yield ThreadLoadSuccess(threadList);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapRefreshHistoryThreadToState(
      RefreshHistoryThreadEvent event) async* {
    yield ThreadHistoryLoading();
    try {
      final List<Thread> threadList =
          await threadRepository.getHistoryThreads(event.page, event.size);
      yield ThreadLoadSuccess(threadList);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapRefreshVisitorThreadToState(
      RefreshVisitorThreadEvent event) async* {
    yield ThreadVisitorLoading();
    try {
      final List<Thread> threadList =
          await threadRepository.getVisitorThreads(event.page, event.size);
      yield ThreadLoadSuccess(threadList);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapRefreshVisitorThreadAllToState(
      RefreshVisitorThreadAllEvent event) async* {
    yield ThreadLoading();
    try {
      final List<Thread> threadList =
          await threadRepository.getVisitorThreadsAll();
      yield ThreadLoadSuccess(threadList);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapRequestThreadToState(
      RequestThreadEvent event) async* {
    yield RequestThreading();
    try {
      final RequestThreadResult thread = await threadRepository.requestThread(
          event.wid, event.type, event.aid);
      yield RequestThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield RequestThreadError();
    }
  }

  Stream<ThreadState> _mapRequestAgentToState(RequestAgentEvent event) async* {
    yield RequestAgentThreading();
    try {
      final RequestThreadResult thread =
          await threadRepository.requestAgent(event.wid, event.type, event.aid);
      yield RequestAgentSuccess(thread);
    } catch (error) {
      print(error);
      yield RequestAgentThreadError();
    }
  }

  Stream<ThreadState> _mapRequestContactThreadToState(
      RequestContactThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final RequestThreadResult thread =
          await threadRepository.requestContactThread(event.cid);
      yield RequestContactThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapRequestGroupThreadToState(
      RequestGroupThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final RequestThreadResult thread =
          await threadRepository.requestGroupThread(event.gid);
      yield RequestGroupThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapMarkTopThreadEventToState(
      MarkTopThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final MarkThreadResult thread = await threadRepository.markTop(event.tid);
      yield MarkTopThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapUnMarkTopThreadEventToState(
      UnMarkTopThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final MarkThreadResult thread =
          await threadRepository.unmarkTop(event.tid);
      yield UnMarkTopThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapMarkNodisturbThreadEventToState(
      MarkNodisturbThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final MarkThreadResult thread =
          await threadRepository.markNodisturb(event.tid);
      yield MarkNodisturbThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapUnMarkNodisturbThreadEventToState(
      UnMarkNodisturbThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final MarkThreadResult thread =
          await threadRepository.unmarkNodisturb(event.tid);
      yield UnMarkNodisturbThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapMarkUnreadThreadEventToState(
      MarkUnreadThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final MarkThreadResult thread =
          await threadRepository.markUnread(event.tid);
      yield MarkUnreadThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapUnMarkUnreadThreadEventToState(
      UnMarkUnreadThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final MarkThreadResult thread =
          await threadRepository.unmarkUnread(event.tid);
      yield UnMarkUnreadThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }

  Stream<ThreadState> _mapDeleteThreadEventToState(
      DeleteThreadEvent event) async* {
    yield ThreadLoading();
    try {
      final MarkThreadResult thread = await threadRepository.delete(event.tid);
      yield DeleteThreadSuccess(thread);
    } catch (error) {
      print(error);
      yield ThreadLoadError();
    }
  }
}
