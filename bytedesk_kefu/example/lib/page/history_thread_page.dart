// /*
//  * @Author: jack ning github@bytedesk.com
//  * @Date: 2023-02-04 09:49:42
//  * @LastEditors: jack ning github@bytedesk.com
//  * @LastEditTime: 2024-08-14 22:37:06
//  * @FilePath: /bytedesk_kefu/example/lib/page/history_thread_page.dart
//  * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
//  */
// import 'package:bytedesk_kefu/bytedesk_kefu.dart';
// import 'package:bytedesk_kefu/model/thread.dart';
// import 'package:flutter/material.dart';

// // 历史会话列表
// class HistoryThreadPage extends StatefulWidget {
//   const HistoryThreadPage({super.key});

//   @override
//   State<HistoryThreadPage> createState() => _HistoryThreadPageState();
// }

// // TODO: 点击thread会话直接进入对话页面
// class _HistoryThreadPageState extends State<HistoryThreadPage> {
//   //
//   int _page = 0;
//   final int _size = 20;
//   List<Thread> _historyThreadList = [];
//   //
//   @override
//   void initState() {
//     _getVisitorThreads();
//     super.initState();
//   }

//   //
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('历史会话'),
//           elevation: 0,
//         ),
//         body: RefreshIndicator(
//           onRefresh: _onRefresh,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(8.0),
//             itemBuilder: (_, int index) => Card(
//               child: ListTile(
//                 leading: Image.network(_historyThreadList[index].avatar!),
//                 title: Text(
//                     '${_historyThreadList[index].nickname}, ${_historyThreadList[index].timestamp}'),
//                 subtitle: Text('${_historyThreadList[index].content}'),
//                 onTap: () {
//                   // 进入客服页面
//                   // BytedeskKefu.startChatThread(context, _historyThreadList[index]);
//                   // BytedeskKefu.startChatThreadIM(
//                   //     context, _historyThreadList[index]);
//                 },
//               ),
//             ),
//             itemCount: _historyThreadList.length,
//           ),
//         ));
//   }

//   void _getVisitorThreads() {
//     BytedeskKefu.getVisitorThreads(_page, _size).then((value) => {
//           setState(() {
//             _historyThreadList = value;
//           })
//         });
//   }

//   Future<void> _onRefresh() async {
//     _getVisitorThreads();
//     _page++;
//   }
// }
