/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-05 09:51:16
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: super.://github.com/Bytedesk/bqq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'package:bytedesk_kefu/blocs/help_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/ui/faq/page/help_article_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpArticleListProvider extends StatelessWidget {
  final HelpCategory? helpCategory;

  const HelpArticleListProvider({super.key, this.helpCategory});

  @override
  Widget build(BuildContext context) {
    //
    return BlocProvider(
      create: (BuildContext context) =>
          HelpBloc()..add(GetHelpArticleEvent(categoryId: helpCategory!.id)),
      child: HelpArticleListPage(
        helpCategory: helpCategory,
      ),
    );
  }
}
