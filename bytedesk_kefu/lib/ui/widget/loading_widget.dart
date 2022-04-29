import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
          child: SizedBox(
        height: 200.0,
        width: 300.0,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                // child: SpinKitFadingCube(
                //   color: Theme.of(context).primaryColor,
                //   size: 25.0,
                // ),
              ),
              Container(
                child: Text('数据加载中，请稍后'),
              )
            ],
          ),
        ),
      )),
    ));
  }
}
