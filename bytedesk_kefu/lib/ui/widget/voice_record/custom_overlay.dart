/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-06-26 22:37:10
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-08 15:10:14
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

class CustomOverlay extends StatelessWidget {
  final Widget? icon;
  final BoxDecoration decoration;
  final double width;
  final double height;

  const CustomOverlay({
    super.key,
    this.icon,
    this.decoration = const BoxDecoration(
      color: Color(0xff77797A),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    this.width = 160,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.5 - width / 2,
      left: MediaQuery.of(context).size.width * 0.5 - height / 2,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Opacity(
            opacity: 0.8,
            child: Container(
              width: width,
              height: height,
              decoration: decoration,
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
