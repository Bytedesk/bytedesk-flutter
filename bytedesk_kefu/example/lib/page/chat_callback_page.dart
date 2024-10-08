import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatCallbackPage extends StatefulWidget {
  String value;
  ChatCallbackPage({super.key, required this.value});

  @override
  State<ChatCallbackPage> createState() => _ChatCallbackPageState();
}

class _ChatCallbackPageState extends State<ChatCallbackPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('回调演示页面'),
      ),
      body: Center(
        child: Text(widget.value),
      ),
    );
  }
}
