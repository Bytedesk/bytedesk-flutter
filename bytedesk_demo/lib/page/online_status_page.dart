import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:flutter/material.dart';

// 查询技能组和指定客服账号的在线状态
class OnlineStatusPage extends StatefulWidget {
  OnlineStatusPage({Key key}) : super(key: key);

  @override
  _OnlineStatusPageState createState() => _OnlineStatusPageState();
}

class _OnlineStatusPageState extends State<OnlineStatusPage> {
  // 到 客服管理->技能组-有一列 ‘唯一ID（wId）’
  String _workGroupWid = "201807171659201";
  // 到 客服管理->客服账号-有一列 ‘唯一ID（uId）’
  String _agentUid = "201808221551193";
  //
  String _workGroupStatus = '';
  String _agentStatus = '';
  //
  @override
  void initState() {
    _getWorkGroupStatus();
    _getAgentStatus();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('在线状态'),
        elevation: 0,
      ),
      body: ListView(
          children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            title: Text('技能组在线状态'),
            subtitle: Text(_workGroupStatus),
            onTap: () {
              _getWorkGroupStatus();
            },
          ),
          ListTile(
            title: Text('客服在线状态'),
            subtitle: Text(_agentStatus),
            onTap: () {
              _getAgentStatus();
            },
          ),
        ],
      ).toList()),
    );
  }

  void _getWorkGroupStatus() {
    BytedeskKefu.getWorkGroupStatus(_workGroupWid).then((status) => {
          print(status),
          setState(() {
            _workGroupStatus = status;
          })
        });
  }

  void _getAgentStatus() {
    BytedeskKefu.getAgentStatus(_agentUid).then((status) => {
          print(status),
          setState(() {
            _agentStatus = status;
          })
        });
  }
}
