import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String? tip;

  const EmptyWidget({Key? key, this.tip = '未找到相关学校或课程，请尝试其他类别'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset('assets/images/nodata.png'),
          ),
          Text(
            tip!,
            style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
          ),
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
        ],
      ),
    ));
  }
}
