import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/blocs/friend_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/friend.dart';
import 'package:bytedesk_kefu/repositories/friend_repository.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendRepository friendRepository = new FriendRepository();

  FriendBloc() : super(UnFriendState());

  @override
  Stream<FriendState> mapEventToState(FriendEvent event) async* {
    //
    if (event is QueryFriendEvent) {
      yield* _mapQueryFriendToState(event);
    } else if (event is UploadFriendAddressEvent) {
      yield* _mapUploadFriendAddressToState(event);
    } else if (event is QueryFriendAddressEvent) {
      yield* _mapQueryFriendAddressToState(event);
    } else if (event is QueryFriendNearbyEvent) {
      yield* _mapQueryFriendNearbyToState(event);
    } else if (event is UpdateFriendNearbyEvent) {
      yield* _mapUpdateFriendNearbyToState(event);
    }
  }

  Stream<FriendState> _mapQueryFriendToState(QueryFriendEvent event) async* {
    yield FriendLoading();
    try {
      final List<Friend> friendList =
          await friendRepository.getFriends(event.page, event.size);
      yield FriendLoadSuccess(friendList);
    } catch (error) {
      print(error);
      yield ErrorFriendState('friend error');
    }
  }

  Stream<FriendState> _mapQueryFriendAddressToState(
      QueryFriendAddressEvent event) async* {
    yield FriendLoading();
    try {
      final List<Friend> friendList =
          await friendRepository.getFriendsAddress(event.page, event.size);
      yield FriendLoadSuccess(friendList);
    } catch (error) {
      print(error);
      yield ErrorFriendState('friend error');
    }
  }

  Stream<FriendState> _mapUploadFriendAddressToState(
      UploadFriendAddressEvent event) async* {
    yield FriendLoading();
    try {
      final Friend friend =
          await friendRepository.uploadAddress(event.nickname, event.mobile);
      yield FriendCreateSuccess(friend: friend);
    } catch (error) {
      print(error);
      yield ErrorFriendState('friend error');
    }
  }

  Stream<FriendState> _mapQueryFriendNearbyToState(
      QueryFriendNearbyEvent event) async* {
    yield FriendLoading();
    try {
      final List<Friend> friendList =
          await friendRepository.getFriendsNearby(event.page, event.size);
      yield FriendLoadSuccess(friendList);
    } catch (error) {
      print(error);
      yield ErrorFriendState('friend error');
    }
  }

  Stream<FriendState> _mapUpdateFriendNearbyToState(
      UpdateFriendNearbyEvent event) async* {
    yield FriendLoading();
    try {
      await friendRepository.updateLocation(event.latitude, event.longtitude);
      yield FriendUpdateSuccess();
    } catch (error) {
      print(error);
      yield ErrorFriendState('friend error');
    }
  }
}
