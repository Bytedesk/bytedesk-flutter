/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-05 09:50:09
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class LeaveMsgHistoryPage extends StatefulWidget {
  //
  final String? wid;
  final String? aid;
  final String? type;
  //
  // String? mobile;
  // String? email;
  // String? content;
  //
  const LeaveMsgHistoryPage(
      {super.key, @required this.wid, @required this.aid, @required this.type});

  @override
  _LeaveMsgHistoryPageState createState() => _LeaveMsgHistoryPageState();
}

class _LeaveMsgHistoryPageState extends State<LeaveMsgHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("留言历史"),
        elevation: 0,
      ),
      body: Container(),
    );
  }
}
