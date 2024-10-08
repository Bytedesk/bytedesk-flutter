/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-05 09:50:18
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'package:bytedesk_kefu/blocs/leavemsg_bloc/leavemsg_bloc.dart';
import 'package:bytedesk_kefu/ui/leavemsg/page/leavemsg_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveMsgProvider extends StatelessWidget {
  final String? wid;
  final String? aid;
  final String? type;
  final String? tip;
  const LeaveMsgProvider(
      {super.key,
      @required this.wid,
      @required this.aid,
      @required this.type,
      @required this.tip});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LeaveMsgBloc(),
      child: LeaveMsgPage(
        wid: wid,
        aid: aid,
        type: type,
        tip: tip,
      ),
    );
  }
}
