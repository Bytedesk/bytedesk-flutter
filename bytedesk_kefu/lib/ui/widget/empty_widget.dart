/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-13 17:56:42
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

typedef TapCallback = void Function();

class EmptyWidget extends StatelessWidget {
  final String? tip;
  final String? tip2;
  final String? tip3;
  final bool? showIcon;
  final TapCallback? tapCallback;

  const EmptyWidget(
      {super.key,
      this.tip = '内容为空',
      this.tip2 = '',
      this.tip3 = '',
      this.showIcon = true,
      this.tapCallback});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
      onTap: () {
        debugPrint("EmptyWidget onTap");
        // tapCallback!();
      },
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Visibility(
              visible: showIcon!,
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: Image.asset('assets/images/common/nodata.png'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                tip!,
                style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                tip2!,
                style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                tip3!,
                style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
              ),
            ),
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    ));
  }
}
