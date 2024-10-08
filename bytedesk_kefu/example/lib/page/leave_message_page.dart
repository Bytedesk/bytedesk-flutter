// /*
//  * @Author: jackning 270580156@qq.com
//  * @Date: 2023-04-10 10:26:36
//  * @LastEditors: jackning 270580156@qq.com
//  * @LastEditTime: 2024-10-05 19:37:19
//  * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
//  *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
//  *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
//  *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
//  *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
//  *  contact: 270580156@qq.com 
//  *  联系：270580156@qq.com
//  * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
//  */
// import 'package:bytedesk_kefu/bytedesk_kefu.dart';
// import 'package:flutter/material.dart';

// class LeaveMessagePage extends StatefulWidget {
//   const LeaveMessagePage({super.key});

//   @override
//   State<LeaveMessagePage> createState() => _LeaveMessagePageState();
// }

// class _LeaveMessagePageState extends State<LeaveMessagePage> {
//   // 说明：一个技能组可以分配多个客服，访客会按照一定的规则分配给组内的各个客服账号
//   final String _workGroupWid = "201807171659201"; // 默认人工
//   // 说明：直接发送给此一个客服账号，一对一会话
//   final String _agentUid = "201808221551193";
//   //
//   final String _tip = "当前客服不在线，请留言";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('留言类型'),
//         elevation: 0,
//       ),
//       body: ListView(
//         children: ListTile.divideTiles(context: context, tiles: [
//           ListTile(
//             title: const Text('技能组留言'),
//             subtitle: const Text('留言给组内，支持多人处理'),
//             trailing: const Icon(Icons.keyboard_arrow_right),
//             onTap: () {
//               BytedeskKefu.showWorkGroupLeaveMessage(
//                   context, _workGroupWid, _tip);
//             },
//           ),
//           ListTile(
//             title: const Text('指定客服留言'),
//             subtitle: const Text('留言给某个客服，单人处理留言'),
//             trailing: const Icon(Icons.keyboard_arrow_right),
//             onTap: () {
//               BytedeskKefu.showAppointedLeaveMessage(context, _agentUid, _tip);
//             },
//           ),
//         ]).toList(),
//       ),
//     );
//   }
// }
