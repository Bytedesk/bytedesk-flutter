// ignore_for_file: file_names, prefer_interpolation_to_compose_strings

import 'dart:async';
// import 'dart:convert';

import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sqflite/sqflite.dart';

// import '../../chat/model/user_protobuf.dart';
// import '../../chat/util/chat_consts.dart';
import 'thread.dart';
import 'user_protobuf.dart';

// https://pub.dev/packages/sqflite
class ThreadProvider {
  //
  static final ThreadProvider _singleton = ThreadProvider._internal();
  factory ThreadProvider() {
    return _singleton;
  }
  ThreadProvider._internal() {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return;
    }
    open();
  }
  //
  final String? tableThread = 'threads';
  final String? columnId = '_id';
  final String? columnUid = 'uid';
  final String? columnType = 'type';
  final String? columnContent = 'content';
  final String? columnStatus = 'status';
  final String? columnCreatedAt = 'createdAt';
  final String? columnClient = 'client';
  final String? columnExtra = 'extra';
  //
  final String? columnThreadTopic = 'threadTopic';
  //
  final String? columnUserUid = 'userUid';
  final String? columnUserNickname = 'userNickname';
  final String? columnUserAvatar = 'userAvatar';
  //
  final String? columnCurrentUid = 'currentUid';

  //
  Database? database;

  Future open() async {
    // Open the database and store the reference.
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'bytedesk-thread-v1.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database. autoincrement
        return db.execute("CREATE TABLE $tableThread (" +
            "$columnId INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "$columnUid TEXT, " +
            "$columnType TEXT, " +
            "$columnContent TEXT, " +
            "$columnStatus TEXT, " +
            "$columnCreatedAt TEXT, " +
            "$columnClient TEXT, " +
            "$columnExtra TEXT, " +
            //
            "$columnThreadTopic TEXT, " +
            //
            "$columnUserUid TEXT, " +
            "$columnUserNickname TEXT, " +
            "$columnUserAvatar TEXT, " +
            //
            "$columnCurrentUid TEXT)");
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // database path:/Users/ningjinpeng/Library/Developer/CoreSimulator/Devices/9B8D4445-E6DE-42A4-AEF0-6668B684D2DB/data/Containers/Data/Application/E7501356-E8A6-45A8-AF63-437348AEDCC3/Documents/bytedesk-thread-v10.db
    // debugPrint('database path:${database!.path}');
  }

  Future<int> insert(Thread thread) async {
    String? currentUid = SpUtil.getString(BytedeskConstants.VISITOR_UID);
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    // debugPrint('insert avatar:' + thread.avatar + ' conten:' + thread.content + ' timestamp:' + thread.timestamp);
    return await database!.insert(tableThread!, thread.toMap(currentUid!));
  }

  //
  Future<List<Thread>> getTopicThreads(
      String? topic, String? currentUid, int? page, int? size) async {
    // debugPrint('1: ' + topic! + ' currentUid:' + currentUid!);
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return [];
    }
    // debugPrint('2');
    //
    List<Map> maps = await database!.query(tableThread!,
        columns: [
          columnUid!,
          columnType!,
          columnContent!,
          columnStatus!,
          columnCreatedAt!,
          columnClient!,
          columnExtra!,
          //
          columnThreadTopic!,
          //
          columnUserUid!,
          columnUserNickname!,
          columnUserAvatar!,
          //
          columnCurrentUid!,
        ],
        where: '$columnThreadTopic = ? and $columnCurrentUid = ?',
        whereArgs: [topic, currentUid],
        orderBy: '$columnCreatedAt DESC',
        limit: size,
        offset: page! * size!);
    //
    // debugPrint('3');
    // BytedeskUtils.printLog(maps.length);
    //
    return List.generate(maps.length, (i) {
      // debugPrint('4');
      return Thread(
        uid: maps[i][columnUid],
        type: maps[i][columnType],
        content: maps[i][columnContent],
        state: maps[i][columnStatus],
        // createdAt: maps[i][columnCreatedAt],
        client: maps[i][columnClient],
        extra: maps[i][columnExtra],
        //
        topic: maps[i][columnThreadTopic],
        //
        user: UserProtobuf(
          uid: maps[i][columnUserUid],
          nickname: maps[i][columnUserNickname],
          avatar: maps[i][columnUserAvatar],
        ),
      );
    });
  }

  Future<int> delete(String? uid) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    return await database!
        .delete(tableThread!, where: '$columnUid = ?', whereArgs: [uid]);
  }

  Future<int> update(String? uid, String? status) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    return await database!.rawUpdate(
        'UPDATE $tableThread SET $columnStatus = ? WHERE $columnUid = ?',
        [status, uid]);
  }

  Future<int> updateContent(String? uid, String? content) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    return await database!.rawUpdate(
        'UPDATE $tableThread SET $columnContent = ? WHERE $columnUid = ?',
        [content, uid]);
  }

  Future close() async => database!.close();
}
