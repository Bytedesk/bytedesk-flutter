// import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bytedesk_kefu/blocs/friend_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/friend.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu/repositories/friend_repository.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendRepository friendRepository = new FriendRepository();

  FriendBloc() : super(UnFriendState()) {
    on<QueryFriendEvent>(_mapQueryFriendToState);
    on<QueryFriendAddressEvent>(_mapQueryFriendAddressToState);
    on<UploadFriendAddressEvent>(_mapUploadFriendAddressToState);
    on<QueryFriendNearbyEvent>(_mapQueryFriendNearbyToState);
    on<UpdateFriendNearbyEvent>(_mapUpdateFriendNearbyToState);
  }

  // @override
  // void mapEventToState(FriendEvent event) async {
  //   //
  //   if (event is QueryFriendEvent) {
  //     yield* _mapQueryFriendToState(event);
  //   } else if (event is UploadFriendAddressEvent) {
  //     yield* _mapUploadFriendAddressToState(event);
  //   } else if (event is QueryFriendAddressEvent) {
  //     yield* _mapQueryFriendAddressToState(event);
  //   } else if (event is QueryFriendNearbyEvent) {
  //     yield* _mapQueryFriendNearbyToState(event);
  //   } else if (event is UpdateFriendNearbyEvent) {
  //     yield* _mapUpdateFriendNearbyToState(event);
  //   }
  // }

  void _mapQueryFriendToState(
      QueryFriendEvent event, Emitter<FriendState> emit) async {
    emit(FriendLoading());
    try {
      final List<Friend> friendList =
          await friendRepository.getFriends(event.page, event.size);
      emit(FriendLoadSuccess(friendList));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(ErrorFriendState('friend error'));
    }
  }

  void _mapQueryFriendAddressToState(
      QueryFriendAddressEvent event, Emitter<FriendState> emit) async {
    emit(FriendLoading());
    try {
      final List<Friend> friendList =
          await friendRepository.getFriendsAddress(event.page, event.size);
      emit(FriendLoadSuccess(friendList));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(ErrorFriendState('friend error'));
    }
  }

  void _mapUploadFriendAddressToState(
      UploadFriendAddressEvent event, Emitter<FriendState> emit) async {
    emit(FriendLoading());
    try {
      final Friend friend =
          await friendRepository.uploadAddress(event.nickname, event.mobile);
      emit(FriendCreateSuccess(friend: friend));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(ErrorFriendState('friend error'));
    }
  }

  void _mapQueryFriendNearbyToState(
      QueryFriendNearbyEvent event, Emitter<FriendState> emit) async {
    emit(FriendLoading());
    try {
      final List<Friend> friendList =
          await friendRepository.getFriendsNearby(event.page, event.size);
      emit(FriendLoadSuccess(friendList));
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(ErrorFriendState('friend error'));
    }
  }

  void _mapUpdateFriendNearbyToState(
      UpdateFriendNearbyEvent event, Emitter<FriendState> emit) async {
    emit(FriendLoading());
    try {
      await friendRepository.updateLocation(event.latitude, event.longtitude);
      emit(FriendUpdateSuccess());
    } catch (error) {
      BytedeskUtils.printLog(error);
      emit(ErrorFriendState('friend error'));
    }
  }
}
