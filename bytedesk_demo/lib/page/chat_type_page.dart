import 'dart:convert';

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:flutter/material.dart';

// 多种客服对话类型列表页面
class ChatTypePage extends StatefulWidget {
  ChatTypePage({Key key}) : super(key: key);

  @override
  _ChatTypePageState createState() => _ChatTypePageState();
}

class _ChatTypePageState extends State<ChatTypePage> {
  // 第二步：到 客服管理->技能组-有一列 ‘唯一ID（wId）’, 默认设置工作组wid
  // 说明：一个技能组可以分配多个客服，访客会按照一定的规则分配给组内的各个客服账号
  String _workGroupWid = "201807171659201"; // 默认人工
  String _workGroupWidRobot = "201809061716221"; // 默认机器人
  // 说明：直接发送给此一个客服账号，一对一会话
  String _agentUid = "201808221551193";
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('对话类型'),
        elevation: 0,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text('技能组客服'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                BytedeskKefu.startWorkGroupChat(context, _workGroupWid, "技能组客服-默认人工");
              },
            ),
            ListTile(
              title: Text('技能组客服-机器人'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                BytedeskKefu.startWorkGroupChat(context, _workGroupWidRobot, "技能组客服-默认机器人");
              },
            ),
            ListTile(
              title: Text('技能组客服-电商'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // 商品信息，type/title/content/price/url/imageUrl/id/categoryCode
                var custom = json.encode({
                  "type": BytedeskConstants.MESSAGE_TYPE_COMMODITY,
                  "title": "商品标题",
                  "content": "商品详情",
                  "price": "9.99",
                  "url": "https://item.m.jd.com/product/12172344.html",
                  "imageUrl": "https://bytedesk.oss-cn-shenzhen.aliyuncs.com/images/123.webp",
                  "id": 123,
                  "categoryCode": "100010003",
                  "client": "flutter"
                });
                BytedeskKefu.startWorkGroupChatShop(context, _workGroupWid, "技能组客服-电商", custom);
              },
            ),
            ListTile(
              title: Text('技能组客服-附言'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                BytedeskKefu.startWorkGroupChatPostscript(context, _workGroupWid, "技能组客服-附言", "随便说点什么吧，我会自动发送给客服");
              },
            ),
            Container(
              height: 20,
            ),
            ListTile(
              title: Text('指定一对一客服'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                BytedeskKefu.startAppointedChat(context, _agentUid, "指定客服");
              },
            ),
            ListTile(
              title: Text('指定一对一客服-电商'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // 商品信息，type/title/content/price/url/imageUrl/id/categoryCode
                var custom = json.encode({
                  "type": BytedeskConstants.MESSAGE_TYPE_COMMODITY,
                  "title": "商品标题",
                  "content": "商品详情",
                  "price": "9.99",
                  "url": "https://item.m.jd.com/product/12172344.html",
                  "imageUrl": "https://bytedesk.oss-cn-shenzhen.aliyuncs.com/images/123.webp",
                  "id": 123,
                  "categoryCode": "100010003",
                  "client": "flutter"
                });
                BytedeskKefu.startAppointedChatShop(context, _agentUid, "指定客服", custom);
              },
            ),
            ListTile(
              title: Text('指定一对一客服-附言'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                BytedeskKefu.startAppointedChatPostscript(context, _agentUid, "指定客服", "随便说点什么吧，我会自动发送给客服");
              },
            ),
            Container(
              height: 20,
            ),
            ListTile(
              title: Text('H5网页会话'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                print('h5 chat');
                // 注意: 登录后台->客服管理->技能组(或客服账号)->获取客服代码 获取相应URL
                String url = "http://www.bytedesk.com/chat?sub=vip&uid=201808221551193&wid=201807171659201&type=workGroup&aid=&hidenav=1&ph=ph";
                String title = 'H5在线客服演示';
                BytedeskKefu.startH5Chat(context, url, title);
              },
            ),
          ]
        ).toList(),
      ),
    );
  }
}