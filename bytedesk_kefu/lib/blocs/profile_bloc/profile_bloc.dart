import 'dart:async';
import 'package:bytedesk_kefu/model/jsonResult.dart';
import 'package:bytedesk_kefu/model/user.dart';
import 'package:bytedesk_kefu/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  //
  final UserRepository userRepository = new UserRepository();

  ProfileBloc() : super(InitialProfileState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    //
    if (event is GetProfileEvent) {
      yield* _mapProfileState();
    } else if (event is UploadImageEvent) {
      yield* _mapUploadImageToState(event);
    } else if (event is UpdateAvatarEvent) {
      yield* _mapUpdateAvatarToState(event);
    } else if (event is UpdateNicknameEvent) {
      yield* _mapUpdateNicknameToState(event);
    } else if (event is UpdateDescriptionEvent) {
      yield* _mapUpdateDescriptionToState(event);
    } else if (event is UpdateMobileEvent) {
      yield* _mapUpdateMobileToState(event);
    } else if (event is UpdateSexEvent) {
      yield* _mapUpdateSexToState(event);
    } else if (event is UpdateLocationEvent) {
      yield* _mapUpdateLocationToState(event);
    } else if (event is UpdateBirthdayEvent) {
      yield* _mapUpdateBirthdayToState(event);
    } else if (event is QueryFollowEvent) {
      yield* _mapQueryFollowToState(event);
    } else if (event is UserFollowEvent) {
      yield* _mapUserFollowToState(event);
    } else if (event is UserUnfollowEvent) {
      yield* _mapUserUnfollowToState(event);
    }
  }

  Stream<ProfileState> _mapProfileState() async* {
    yield ProfileInProgress();
    try {
      User user = await userRepository.getProfile();
      yield ProfileSuccess(user: user);
    } catch (error) {
      // 网络或其他错误
      yield ProfileFailure(error: error.toString());
    }
  }

  Stream<ProfileState> _mapUploadImageToState(UploadImageEvent event) async* {
    yield ProfileInProgress();
    try {
      final String url = await userRepository.upload(event.filePath);
      yield UploadImageSuccess(url);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<ProfileState> _mapUpdateAvatarToState(UpdateAvatarEvent event) async* {
    yield ProfileInProgress();
    try {
      final User user = await userRepository.updateAvatar(event.avatar);
      yield UpdateAvatarSuccess(user);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<ProfileState> _mapUpdateNicknameToState(
      UpdateNicknameEvent event) async* {
    yield ProfileInProgress();
    try {
      final User user = await userRepository.updateNickname(event.nickname);
      yield UpdateNicknameSuccess(user);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<ProfileState> _mapUpdateDescriptionToState(
      UpdateDescriptionEvent event) async* {
    yield ProfileInProgress();
    try {
      final User user =
          await userRepository.updateDescription(event.description);
      yield UpdateDescriptionSuccess(user);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<ProfileState> _mapUpdateMobileToState(UpdateMobileEvent event) async* {
    yield ProfileInProgress();
    try {
      final User user = await userRepository.updateMobile(event.mobile);
      yield UpdateMobileSuccess(user);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<ProfileState> _mapUpdateSexToState(UpdateSexEvent event) async* {
    yield ProfileInProgress();
    try {
      final User user = await userRepository.updateSex(event.sex);
      yield UpdateSexSuccess(user);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<ProfileState> _mapUpdateLocationToState(
      UpdateLocationEvent event) async* {
    yield ProfileInProgress();
    try {
      final User user = await userRepository.updateLocation(event.location);
      yield UpdateLocationSuccess(user);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<ProfileState> _mapUpdateBirthdayToState(
      UpdateBirthdayEvent event) async* {
    yield ProfileInProgress();
    try {
      final User user = await userRepository.updateBirthday(event.birthday);
      yield UpdateBirthdaySuccess(user);
    } catch (error) {
      print(error);
      yield UpLoadImageError();
    }
  }

  Stream<ProfileState> _mapQueryFollowToState(QueryFollowEvent event) async* {
    yield QueryFollowing();
    try {
      final bool isFollowed = await userRepository.isFollowed(event.uid);
      yield QueryFollowSuccess(isFollowed);
    } catch (error) {
      print(error);
      yield QueryFollowError();
    }
  }

  Stream<ProfileState> _mapUserFollowToState(UserFollowEvent event) async* {
    yield Following();
    try {
      final JsonResult jsonResult = await userRepository.follow(event.uid);
      yield FollowResultSuccess(jsonResult);
    } catch (error) {
      print(error);
      yield FollowError();
    }
  }

  Stream<ProfileState> _mapUserUnfollowToState(UserUnfollowEvent event) async* {
    yield Following();
    try {
      final JsonResult jsonResult = await userRepository.unfollow(event.uid);
      yield UnfollowResultSuccess(jsonResult);
    } catch (error) {
      print(error);
      yield UnFollowError();
    }
  }
}
