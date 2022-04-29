import 'package:bytedesk_kefu/model/message.dart';
import 'package:flutter/material.dart';

class ChannelDetailPage extends StatefulWidget {
  //
  final Message? message;
  ChannelDetailPage({Key? key, @required this.message}) : super(key: key);

  @override
  _ChannelDetailPageState createState() => _ChannelDetailPageState();
}

class _ChannelDetailPageState extends State<ChannelDetailPage> {
  //
  String? _title = '';
  String? _content = '';

  @override
  void initState() {
    _title = widget.message!.channelTitle();
    _content = widget.message!.channelContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title!),
      ),
      body: Container(
        child: Text(_content!),
      ),
    );
  }
}
