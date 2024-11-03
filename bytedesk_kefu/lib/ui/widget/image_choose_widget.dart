/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-10-08 15:06:30
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
// import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:flutter/material.dart';

//选择头像底部弹出框
class ImageChooseWidget extends StatelessWidget {
  //
  final VoidCallback? pickImageCallBack;
  final VoidCallback? takeImageCallBack;

  const ImageChooseWidget(
      {super.key,
      this.pickImageCallBack,
      this.takeImageCallBack,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, //wrap_content
      children: <Widget>[
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                //
                Navigator.pop(context);
                takeImageCallBack!();
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: const Center(
                  child: Text('立即拍照',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
              )),
        ),
        Container(
          height: 1,
          color: const Color(0xffEFF1F0),
          //  margin: EdgeInsets.only(left: 60),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                //
                Navigator.pop(context);
                pickImageCallBack!();
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: const Center(
                  child: Text('从相册选择', style: TextStyle(fontSize: 16)),
                ),
              )),
        ),
      ],
    );
  }
}
