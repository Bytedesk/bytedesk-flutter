import 'dart:async';
// import 'dart:convert';

import 'package:bytedesk_kefu/model/answer.dart';
import 'package:bytedesk_kefu/model/category.dart';
// import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bytedesk_kefu/model/model.dart';

// https://pub.dev/packages/sqflite
// FIXME: 不支持web
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
  final String? columnMid = 'mid';
  final String? columnType = 'type';
  final String? columnTopic = 'topic';
  final String? columnContent = 'content';
  final String? columnImageUrl = 'imageUrl';
  final String? columnVoiceUrl = 'voiceUrl';
  final String? columnVideoUrl = 'videoUrl';
  final String? columnFileUrl = 'fileUrl';

  final String? columnNickname = 'nickname';
  final String? columnAvatar = 'avatar';

  final String? columnStatus = 'status';
  final String? columnIsSend = 'isSend';
  final String? columnTimestamp = 'timestamp';
  final String? columnCurrentUid = 'currentUid';
  final String? columnClient = 'client';
  final String? columnAnswers = 'answers';
  final String? columnCategories = 'categories';
  //
  Database? database;

  Future open() async {
    // Open the database and store the reference.
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'bytedesk-message-v10.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database. autoincrement
        return db.execute(
          "CREATE TABLE $tableMessage($columnId INTEGER PRIMARY KEY AUTOINCREMENT, " +
              "$columnMid TEXT, $columnType TEXT, $columnTopic TEXT, $columnContent TEXT, $columnImageUrl TEXT, $columnVoiceUrl TEXT,$columnVideoUrl TEXT, $columnFileUrl TEXT, $columnNickname TEXT, $columnAvatar TEXT, $columnStatus TEXT, " +
              "$columnIsSend INTEGER, $columnTimestamp TEXT, $columnCurrentUid TEXT, $columnClient TEXT, $columnAnswers TEXT, $columnCategories TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 10,
    );
    // database path:/Users/ningjinpeng/Library/Developer/CoreSimulator/Devices/715CBA02-A602-4DE1-8C57-75A64B53BF03/data/Containers/Data/Application/8F46273D-9492-4C42-A618-4DF3815562BA/Documents/bytedesk-message-v9.db
    BytedeskUtils.printLog('database path:' + database!.path);
  }

  Future<int> insert(Message message) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    // BytedeskUtils.printLog('insert avatar:' + message.avatar + ' conten:' + message.content + ' timestamp:' + message.timestamp);
    return await database!.insert(tableMessage!, message.toMap());
  }

  //
  Future<List<Message>> getTopicMessages(
      String? topic, String? currentUid, int? page, int? size) async {
    // BytedeskUtils.printLog('1: ' + topic! + ' currentUid:' + currentUid!);
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return [];
    }
    // BytedeskUtils.printLog('2');
    //
    List<Map> maps = await database!.query(tableMessage!,
        columns: [
          columnMid!,
          columnContent!,
          columnImageUrl!,
          columnVoiceUrl!,
          columnVideoUrl!,
          columnFileUrl!,
          columnType!,
          columnTopic!,
          columnStatus!,
          columnTimestamp!,
          columnNickname!,
          columnAvatar!,
          columnIsSend!,
          columnClient!,
          columnAnswers!,
          columnCategories!
        ],
        where: '$columnTopic = ? and $columnCurrentUid = ?',
        whereArgs: [topic, currentUid],
        orderBy: '$columnTimestamp DESC, $columnIsSend ASC',
        limit: size,
        offset: page! * size!);
    //
    // BytedeskUtils.printLog('3');
    // BytedeskUtils.printLog(maps.length);
    //
    return List.generate(maps.length, (i) {
      //
      List<Answer> robotQaList = [];
      // FIXME: 下面解析报错
      // if (maps[i]['type'] == BytedeskConstants.MESSAGE_TYPE_ROBOT) {
      //   robotQaList = maps[i][columnAnswers] == null
      //       ? []
      //       : (json.decode(maps[i][columnAnswers]) as List<dynamic>)
      //           .map((item) => Answer.fromJson(item))
      //           .toList();
      // }
      List<Category> categoriesList = [];
      // FIXME: 下面解析报错
      // if (maps[i]['type'] == BytedeskConstants.MESSAGE_TYPE_ROBOT_V2) {
      //   categoriesList = maps[i][columnCategories] == null
      //       ? []
      //       : (json.decode(maps[i][columnCategories]) as List<dynamic>)
      //           .map((item) => Category.fromJson(item))
      //           .toList();
      // }
      // BytedeskUtils.printLog('4');
      return Message(
          mid: maps[i]['mid'],
          content: maps[i]['content'],
          imageUrl: maps[i]['imageUrl'],
          voiceUrl: maps[i]['voiceUrl'],
          videoUrl: maps[i]['videoUrl'],
          fileUrl: maps[i]['fileUrl'],
          type: maps[i]['type'],
          topic: maps[i]['topic'],
          status: maps[i]['status'],
          timestamp: maps[i]['timestamp'],
          nickname: maps[i]['nickname'],
          avatar: maps[i]['avatar'],
          isSend: maps[i]['isSend'],
          client: maps[i]['client'],
          answers: robotQaList,
          categories: categoriesList);
    });
  }

  Future<int> delete(String? mid) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    return await database!
        .delete(tableMessage!, where: '$columnMid = ?', whereArgs: [mid]);
  }

  Future<int> update(String? mid, String? status) async {
    // FIXME: 暂不支持web
    if (BytedeskUtils.isWeb) {
      return 0;
    }
    return await database!.rawUpdate(
        'UPDATE $tableMessage SET $columnStatus = ? WHERE $columnMid = ?',
        [status, mid]);
  }

  Future close() async => database!.close();
}
