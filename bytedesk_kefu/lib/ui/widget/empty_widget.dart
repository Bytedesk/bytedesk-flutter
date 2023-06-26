import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String? tip;

  const EmptyWidget({Key? key, this.tip = '内容为空'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset('assets/images/common/nodata.png'),
          ),
          Text(
            tip!,
            style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
          ),
          const Expanded(
            flex: 3,
            child: SizedBox(),
          ),
        ],
      ),
    ));
  }
}
