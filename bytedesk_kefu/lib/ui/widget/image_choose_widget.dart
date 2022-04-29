// import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:flutter/material.dart';

//选择头像底部弹出框
class ImageChooseWidget extends StatelessWidget {
  //
  final VoidCallback? pickImageCallBack;
  final VoidCallback? takeImageCallBack;
  final VoidCallback? pickVideoCallBack;
  final VoidCallback? captureVideoCallBack;

  ImageChooseWidget(
      {Key? key,
      this.pickImageCallBack,
      this.takeImageCallBack,
      this.pickVideoCallBack,
      this.captureVideoCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min, //wrap_content
      children: <Widget>[
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                //
                Navigator.pop(context);
                takeImageCallBack!();
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Center(
                  child: Text('立即拍照',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
              )),
        ),
        Container(
          height: 1,
          color: Color(0xffEFF1F0),
          //  margin: EdgeInsets.only(left: 60),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                //
                Navigator.pop(context);
                pickImageCallBack!();
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Center(
                  child: Text('从相册选择', style: TextStyle(fontSize: 16)),
                ),
              )),
        ),
        Container(
          height: 1,
          color: Color(0xffEFF1F0),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                //
                Navigator.pop(context);
                pickVideoCallBack!();
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Center(
                  child: Text('上传视频', style: TextStyle(fontSize: 16)),
                ),
              )),
        ),
        Container(
          height: 1,
          color: Color(0xffEFF1F0),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                //
                Navigator.pop(context);
                captureVideoCallBack!();
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Center(
                  child: Text('录制视频', style: TextStyle(fontSize: 16)),
                ),
              )),
        ),
        Container(
          height: 5,
          color: Color(0xffEFF1F0),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Center(
                  child: Text('取消', style: TextStyle(fontSize: 16)),
                ),
              )),
        ),
      ],
    ));
  }
}
