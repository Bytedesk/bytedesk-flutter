// /*
//  * @Author: jackning 270580156@qq.com
//  * @Date: 2023-02-04 09:49:42
//  * @LastEditors: jackning 270580156@qq.com
//  * @LastEditTime: 2024-10-05 19:37:29
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
// import 'package:list_tile_switch/list_tile_switch.dart';

// // 消息声音、振动设置页面
// class SettingPage extends StatefulWidget {
//   const SettingPage({super.key});

//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   bool _playAudioOnSendMessage = false;
//   bool _playAudioOnReceiveMessage = false;
//   bool _vibrateOnReceiveMessage = false;
//   //
//   @override
//   void initState() {
//     _playAudioOnSendMessage = BytedeskKefu.getPlayAudioOnSendMessage()!;
//     _playAudioOnReceiveMessage = BytedeskKefu.getPlayAudioOnReceiveMessage()!;
//     _vibrateOnReceiveMessage = BytedeskKefu.getVibrateOnReceiveMessage()!;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('消息设置'),
//         elevation: 0,
//       ),
//       body: ListView(
//           children: ListTile.divideTiles(
//         context: context,
//         tiles: [
//           ListTileSwitch(
//             value: _playAudioOnSendMessage,
//             onChanged: (value) {
//               setState(() {
//                 _playAudioOnSendMessage = value;
//               });
//               BytedeskKefu.setPlayAudioOnSendMessage(value);
//             },
//             title: const Text('发送消息时播放声音'),
//           ),
//           ListTileSwitch(
//             value: _playAudioOnReceiveMessage,
//             onChanged: (value) {
//               setState(() {
//                 _playAudioOnReceiveMessage = value;
//               });
//               BytedeskKefu.setPlayAudioOnReceiveMessage(value);
//             },
//             title: const Text('收到消息时播放声音'),
//           ),
//           ListTileSwitch(
//             value: _vibrateOnReceiveMessage,
//             onChanged: (value) {
//               setState(() {
//                 _vibrateOnReceiveMessage = value;
//               });
//               // 注意：需要在安卓AndroidManifest.xml添加权限<uses-permission android:name="android.permission.VIBRATE"/>
//               BytedeskKefu.setVibrateOnReceiveMessage(value);
//             },
//             title: const Text('收到消息时振动'),
//           ),
//         ],
//       ).toList()),
//     );
//   }
// }
