import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/model/thread.dart';
import 'package:flutter/material.dart';

// 历史会话列表
class HistoryThreadPage extends StatefulWidget {
  HistoryThreadPage({Key? key}) : super(key: key);

  @override
  _HistoryThreadPageState createState() => _HistoryThreadPageState();
}

// TODO: 点击thread会话直接进入对话页面
class _HistoryThreadPageState extends State<HistoryThreadPage> {
  //
  int _page = 0;
  int _size = 20;
  List<Thread> _historyThreadList = [];
  //
  @override
  void initState() {
    _getVisitorThreads();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('历史会话'),
          elevation: 0,
        ),
        body: RefreshIndicator(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemBuilder: (_, int index) => ListTile(
              leading: Image.network(_historyThreadList[index].avatar!),
              title: Text(
                  '${_historyThreadList[index].nickname}, ${_historyThreadList[index].timestamp}'),
              subtitle: Text('${_historyThreadList[index].content}'),
              onTap: () {
                // 进入客服页面
                // BytedeskKefu.startChatThread(
                //     context, _historyThreadList[index]);
                BytedeskKefu.startChatThreadIM(context, _historyThreadList[index]);
              },
            ),
            itemCount: _historyThreadList.length,
          ),
          onRefresh: _onRefresh,
        ));
  }

  void _getVisitorThreads() {
    BytedeskKefu.getVisitorThreads(_page, _size).then((value) => {
          setState(() {
            _historyThreadList = value;
          })
        });
  }

  Future<void> _onRefresh() async {
    _getVisitorThreads();
    _page++;
  }
}
