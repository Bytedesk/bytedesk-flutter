//
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'thread.pb.dart' as $1;
import 'user.pb.dart' as $0;

/// 消息三要素：1. 谁发送的消息？ 2. 发送给谁的消息？ 3. 发送的消息内容是什么？
class Message extends $pb.GeneratedMessage {
  factory Message({
    $core.String? uid,
    $core.String? type,
    $core.String? content,
    $core.String? status,
    $core.String? createdAt,
    $core.String? client,
    $1.Thread? thread,
    $0.User? user,
    $core.String? extra,
  }) {
    final $result = create();
    if (uid != null) {
      $result.uid = uid;
    }
    if (type != null) {
      $result.type = type;
    }
    if (content != null) {
      $result.content = content;
    }
    if (status != null) {
      $result.status = status;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (client != null) {
      $result.client = client;
    }
    if (thread != null) {
      $result.thread = thread;
    }
    if (user != null) {
      $result.user = user;
    }
    if (extra != null) {
      $result.extra = extra;
    }
    return $result;
  }
  Message._() : super();
  factory Message.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Message.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Message', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uid')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..aOS(4, _omitFieldNames ? '' : 'status')
    ..aOS(5, _omitFieldNames ? '' : 'createdAt', protoName: 'createdAt')
    ..aOS(6, _omitFieldNames ? '' : 'client')
    ..aOM<$1.Thread>(7, _omitFieldNames ? '' : 'thread', subBuilder: $1.Thread.create)
    ..aOM<$0.User>(8, _omitFieldNames ? '' : 'user', subBuilder: $0.User.create)
    ..aOS(9, _omitFieldNames ? '' : 'extra')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Message clone() => Message()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message)) as Message;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => $pb.PbList<Message>();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  /// 唯一mid
  @$pb.TagNumber(1)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);

  /// 消息类型
  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  /// 消息内容，可能是文本，图片，语音，视频，文件等，json
  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => clearField(3);

  /// 消息发送状态
  @$pb.TagNumber(4)
  $core.String get status => $_getSZ(3);
  @$pb.TagNumber(4)
  set status($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  /// 时间戳
  @$pb.TagNumber(5)
  $core.String get createdAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set createdAt($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => clearField(5);

  /// 消息来源客户端
  @$pb.TagNumber(6)
  $core.String get client => $_getSZ(5);
  @$pb.TagNumber(6)
  set client($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasClient() => $_has(5);
  @$pb.TagNumber(6)
  void clearClient() => clearField(6);

  /// 会话
  @$pb.TagNumber(7)
  $1.Thread get thread => $_getN(6);
  @$pb.TagNumber(7)
  set thread($1.Thread v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasThread() => $_has(6);
  @$pb.TagNumber(7)
  void clearThread() => clearField(7);
  @$pb.TagNumber(7)
  $1.Thread ensureThread() => $_ensure(6);

  /// 发送者
  @$pb.TagNumber(8)
  $0.User get user => $_getN(7);
  @$pb.TagNumber(8)
  set user($0.User v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasUser() => $_has(7);
  @$pb.TagNumber(8)
  void clearUser() => clearField(8);
  @$pb.TagNumber(8)
  $0.User ensureUser() => $_ensure(7);

  /// 自定义扩展/附加信息
  @$pb.TagNumber(9)
  $core.String get extra => $_getSZ(8);
  @$pb.TagNumber(9)
  set extra($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasExtra() => $_has(8);
  @$pb.TagNumber(9)
  void clearExtra() => clearField(9);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
