import 'package:flutter/material.dart';

class TicketSubmitPage extends StatefulWidget {
  TicketSubmitPage({Key? key}) : super(key: key);

  @override
  _TicketSubmitPageState createState() => _TicketSubmitPageState();
}

class _TicketSubmitPageState extends State<TicketSubmitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('提交工单'),
        centerTitle: true,
      ),
      body: Text('ticket'),
    );
  }
}
