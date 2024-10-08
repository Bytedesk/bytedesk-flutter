/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-06 11:12:22
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'package:bytedesk_kefu/blocs/message_bloc/bloc.dart';
import 'package:bytedesk_kefu/blocs/thread_bloc/bloc.dart';
import 'package:bytedesk_kefu/ui/chat/page/chat_kf_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 需要请求会话
class ChatKFProvider extends StatelessWidget {
  final String? sid;
  final String? type;
  final String? title;
  final String? custom;
  final String? postscript;
  final ValueSetter<String>? customCallback;
  //
  const ChatKFProvider(
      {super.key,
      this.sid,
      this.type,
      this.title,
      this.custom,
      this.postscript,
      this.customCallback});
  //
  @override
  Widget build(BuildContext context) {
    //
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThreadBloc>(
          create: (BuildContext context) => ThreadBloc()
            ..add(RequestThreadEvent(sid: sid, type: type, forceAgent: false )),
        ),
        BlocProvider<MessageBloc>(
          create: (BuildContext context) => MessageBloc(),
        ),
      ],
      child: ChatKFPage(
          sid: sid,
          type: type,
          title: title,
          custom: custom,
          postscript: postscript,
          // isThread: false,
          customCallback: customCallback),
    );
  }
}
