/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2023-02-04 09:49:42
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-08 15:07:40
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'package:flutter/material.dart';

class MessageNotification extends StatelessWidget {
  //
  final VoidCallback? onReply;
  final String? avatar;
  final String? nickname;
  final String? content;

  const MessageNotification({
    super.key,
    @required this.onReply,
    @required this.avatar,
    @required this.nickname,
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(child: Image.network(avatar!))),
          title: Text(nickname!),
          subtitle: Text(content!),
          trailing: IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () {
                if (onReply != null) onReply!();
              }),
        ),
      ),
    );
  }
}
