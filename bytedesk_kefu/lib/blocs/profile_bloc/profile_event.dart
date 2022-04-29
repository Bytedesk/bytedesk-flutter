import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {}

// 上传头像
class UploadImageEvent extends ProfileEvent {
  final String? filePath;

  UploadImageEvent({@required this.filePath}) : super();
}

// 更新头像
class UpdateAvatarEvent extends ProfileEvent {
  final String? avatar;

  UpdateAvatarEvent({@required this.avatar}) : super();
}

// 更新昵称
class UpdateNicknameEvent extends ProfileEvent {
  final String? nickname;

  UpdateNicknameEvent({@required this.nickname}) : super();
}

// 更新个性签名
class UpdateDescriptionEvent extends ProfileEvent {
  final String? description;

  UpdateDescriptionEvent({@required this.description}) : super();
}

// 更新手机号
class UpdateMobileEvent extends ProfileEvent {
  final String? mobile;

  UpdateMobileEvent({@required this.mobile}) : super();
}

// 更新性别
class UpdateSexEvent extends ProfileEvent {
  final bool? sex;

  UpdateSexEvent({@required this.sex}) : super();
}

// 更新地区
class UpdateLocationEvent extends ProfileEvent {
  final String? location;

  UpdateLocationEvent({@required this.location}) : super();
}

// 更新生日
class UpdateBirthdayEvent extends ProfileEvent {
  final String? birthday;

  UpdateBirthdayEvent({@required this.birthday}) : super();
}

// 查询是否关注
class QueryFollowEvent extends ProfileEvent {
  final String? uid;

  QueryFollowEvent({@required this.uid}) : super();
}

// 关注用户
class UserFollowEvent extends ProfileEvent {
  final String? uid;

  UserFollowEvent({@required this.uid}) : super();
}

// 取消关注用户
class UserUnfollowEvent extends ProfileEvent {
  final String? uid;

  UserUnfollowEvent({@required this.uid}) : super();
}
