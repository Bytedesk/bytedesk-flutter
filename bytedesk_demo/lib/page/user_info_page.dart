import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 需要首先调用anonymousLogin之后，再调用此接口
// 自定义用户信息接口-对接APP用户信息
class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String _nickname = '';
  String _avatar = BytedeskConstants.DEFAULT_AVATA;
  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户信息'),
        elevation: 0,
      ),
      body: ListView(
          children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            title: Text('设置昵称(见代码)'),
            subtitle: Text(_nickname ?? ''),
            onTap: () {
              //
              _setNickname();
            },
          ),
          ListTile(
            leading: Image.network(
              _avatar ?? BytedeskConstants.DEFAULT_AVATA,
              height: 30,
              width: 30,
            ),
            title: Text('设置头像(见代码)'),
            onTap: () {
              //
              _setAvatar();
            },
          ),
        ],
      ).toList()),
    );
  }

  void _getProfile() {
    // 查询当前用户信息：昵称、头像
    BytedeskKefu.getProfile().then((user) => {
      setState(() {
        _nickname = user.nickname;
        _avatar = user.avatar;
      })
    });
  }

  void _setNickname() {
    // 可自定义用户昵称-客服端可见
    String mynickname = '自定义APP昵称flutter';
    BytedeskKefu.updateNickname(mynickname).then((user) => {
      setState(() {
        _nickname = mynickname;
      }),
      Fluttertoast.showToast(msg: "设置昵称成功")
    });
  }

  void _setAvatar() {
    // 可自定义用户头像url-客服端可见
    String myavatarurl = 'https://chainsnow.oss-cn-shenzhen.aliyuncs.com/avatars/visitor_default_avatar.png'; // 头像网址url
    BytedeskKefu.updateAvatar(myavatarurl).then((user) => {
      setState(() {
        _avatar = myavatarurl;
      }),
      Fluttertoast.showToast(msg: "设置头像成功")
    });
  }
}
