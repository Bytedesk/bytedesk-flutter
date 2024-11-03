/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-08-13 11:16:14
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-10 15:30:42
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
// ignore_for_file: file_names, prefer_interpolation_to_compose_strings

import 'dart:async';
// import 'dart:convert';

// import 'package:bytedesk_flutter/util/bytedesk_utils.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:path/path.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sqflite/sqflite.dart';

import '../util/bytedesk_constants.dart';
import 'user_protobuf.dart';
import 'message.dart';

// https://pub.dev/packages/sqflite
class MessageProvider {
  //
  static final MessageProvider _singleton = MessageProvider._internal();
  factory MessageProvider() {
    return _singleton;
  }
  MessageProvider._internal() {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return;
    }
    open();
  }
  //
  final String? tableMessage = 'messages';
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
      join(await getDatabasesPath(), 'bytedesk-message-v1.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database. autoincrement
        return db.execute("CREATE TABLE $tableMessage (" +
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
    // database path:/Users/ningjinpeng/Library/Developer/CoreSimulator/Devices/9B8D4445-E6DE-42A4-AEF0-6668B684D2DB/data/Containers/Data/Application/E7501356-E8A6-45A8-AF63-437348AEDCC3/Documents/bytedesk-message-v10.db
    // debugPrint('database path:${database!.path}');
  }

  Future<int> insert(Message message) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }

    String currentUid = SpUtil.getString(BytedeskConstants.VISITOR_UID)!;

    // Check if a message with the same uid already exists
    List<Map> maps = await database!.query("$tableMessage",
        columns: [columnId!],
        where: "$columnUid = ?",
        whereArgs: [message.uid]);

    if (maps.isNotEmpty) {
      // A message with the same uid already exists, so we can update it
      // await update(message.uid, message.status);
      return 0; // or return the id of the updated message
    }
    // debugPrint('insert avatar:' + message.avatar + ' conten:' + message.content + ' timestamp:' + message.timestamp);
    return await database!.insert(tableMessage!, message.toMap(currentUid));
  }

  //
  Future<List<Message>> getTopicMessages(
      String? topic, String? currentUid, int? page, int? size) async {
    // debugPrint('1: ' + topic! + ' currentUid:' + currentUid!);
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return [];
    }
    // debugPrint('2');
    //
    List<Map> maps = await database!.query(tableMessage!,
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
      return Message(
        uid: maps[i][columnUid],
        type: maps[i][columnType],
        content: maps[i][columnContent],
        status: maps[i][columnStatus],
        createdAt: maps[i][columnCreatedAt],
        client: maps[i][columnClient],
        extra: maps[i][columnExtra],
        //
        threadTopic: maps[i][columnThreadTopic],
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
        .delete(tableMessage!, where: '$columnUid = ?', whereArgs: [uid]);
  }

  Future<int> update(String? uid, String? status) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    return await database!.rawUpdate(
        'UPDATE $tableMessage SET $columnStatus = ? WHERE $columnUid = ?',
        [status, uid]);
  }

  Future<int> updateContent(String? uid, String? content) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    return await database!.rawUpdate(
        'UPDATE $tableMessage SET $columnContent = ? WHERE $columnUid = ?',
        [content, uid]);
  }

  Future close() async => database!.close();
}
