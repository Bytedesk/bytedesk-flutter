// import 'dart:io';

import 'package:bytedesk_kefu/blocs/leavemsg_bloc/bloc.dart';
// import 'package:bytedesk_kefu/ui/widget/image_choose_widget.dart';
import 'package:bytedesk_kefu/ui/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';

class LeaveMsgPage extends StatefulWidget {
  //
  final String? wid;
  final String? aid;
  final String? type;
  final String? tip;
  //
  // String? mobile;
  // String? email;
  // String? content;
  //
  LeaveMsgPage(
      {Key? key,
      @required this.wid,
      @required this.aid,
      @required this.type,
      @required this.tip})
      : super(key: key);

  @override
  _LeaveMsgPageState createState() => _LeaveMsgPageState();
}

class _LeaveMsgPageState extends State<LeaveMsgPage> {
  //
  ScrollController _scrollController = new ScrollController(); // 滚动监听
  // TextEditingController _nameEditController = new TextEditingController();
  TextEditingController _mobileEditController = new TextEditingController();
  TextEditingController _contentEditController = new TextEditingController();
  // ImagePicker picker = ImagePicker();
  // List<String> _imageUrls = [];
  // List<File> _fileList = [];
  // File? _selectedImageFile;
  // List<MultipartFile> mSubmitFileList = [];

  @override
  void initState() {
    // 滚动监听, https://learnku.com/articles/30338
    _scrollController.addListener(() {
      // 隐藏软键盘
      FocusScope.of(context).requestFocus(FocusNode());
      // 如果滑动到底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // BytedeskUtils.printLog('scroll to bottom');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    // BytedeskUtils.printLog('fileList的内容: $_fileList');
    // if (_selectedImageFile != null) {
    //   _fileList.add(_selectedImageFile!);
    // }
    // _selectedImageFile = null;
    //
    // TODO: 右上角增加：我的留言，查看留言记录及回复
    return Scaffold(
        appBar: AppBar(
          title: Text('留言'),
          centerTitle: true,
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    // 提交
                    // BlocProvider.of<LeaveMsgBloc>(context)
                    //   ..add(SubmitLeaveMsgEvent(
                    //       imageUrls: _imageUrls,
                    //       content: _contentEditController.text));
                  },
                  child: Text(
                    '提交',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
        body: BlocConsumer<LeaveMsgBloc, LeaveMsgState>(
            listener: (context, state) {
          // do stuff here based on BlocA's state
          if (state is ImageUploading) {
            Fluttertoast.showToast(msg: '上传图片中');
          } else if (state is UploadImageSuccess) {
            // 图片url
            // if (!_imageUrls.contains(state.url)) {
            //   _imageUrls.add(state.url);
            // }
          } else if (state is LeaveMsgSubmiting) {
            Fluttertoast.showToast(msg: '提交留言中');
          } else if (state is LeaveMsgSubmitSuccessState) {
            Fluttertoast.showToast(msg: '留言成功');
          } else if (state is LeaveMsgSubmitError) {
            Fluttertoast.showToast(msg: '留言失败');
          }
        }, builder: (context, state) {
          // return widget here based on BlocA's state
          return SingleChildScrollView(
            controller: _scrollController,
            child: Container(
                padding: EdgeInsets.only(top: 5.0, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    // Container(
                    //   // constraints: BoxConstraints(
                    //   //   minHeight: 150,
                    //   // ),
                    //   // color: Color(0xffffffff),
                    //   margin: EdgeInsets.only(top: 15),
                    //   child: TextField(
                    //     controller: _nameEditController,
                    //     // maxLines: 5,
                    //     // maxLength: 500,
                    //     decoration: InputDecoration(
                    //       hintText: "称呼",
                    //       hintStyle:
                    //           TextStyle(color: Color(0xff999999), fontSize: 16),
                    //       contentPadding: EdgeInsets.only(left: 15, right: 15),
                    //       border: InputBorder.none,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      // constraints: BoxConstraints(
                      //   minHeight: 150,
                      // ),
                      // color: Color(0xffffffff),
                      margin: EdgeInsets.only(top: 15),
                      child: TextField(
                        controller: _mobileEditController,
                        // maxLines: 5,
                        // maxLength: 500,
                        decoration: InputDecoration(
                          hintText: "手机号",
                          hintStyle:
                              TextStyle(color: Color(0xff999999), fontSize: 16),
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 150,
                      ),
                      // color: Color(0xffffffff),
                      margin: EdgeInsets.only(top: 15),
                      child: TextField(
                        controller: _contentEditController,
                        maxLines: 5,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: "留言内容",
                          hintStyle:
                              TextStyle(color: Color(0xff999999), fontSize: 16),
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // GridView.count(
                    //   shrinkWrap: true,
                    //   primary: false,
                    //   crossAxisCount: 3,
                    //   children: List.generate(_fileList.length + 1, (index) {
                    //     // 这个方法体用于生成GridView中的一个item
                    //     var content;
                    //     if (index == _fileList.length) {
                    //       // 添加图片按钮
                    //       var addCell = Center(
                    //           child: Image.asset(
                    //         'assets/images/feedback/mine_feedback_add_image.png',
                    //         width: double.infinity,
                    //         height: double.infinity,
                    //       ));
                    //       content = GestureDetector(
                    //         onTap: () {
                    //           // 添加图片
                    //           // pickImage(context);
                    //           showModalBottomSheet(
                    //               context: context,
                    //               builder: (context) {
                    //                 return ImageChooseWidget(
                    //                   pickImageCallBack: () {
                    //                     _pickImage();
                    //                   },
                    //                   takeImageCallBack: () {
                    //                     _takeImage();
                    //                   },
                    //                 );
                    //               });
                    //         },
                    //         child: addCell,
                    //       );
                    //     } else {
                    //       // 被选中的图片
                    //       content = Stack(
                    //         children: <Widget>[
                    //           Center(
                    //             child: Image.file(
                    //               _fileList[index],
                    //               width: double.infinity,
                    //               height: double.infinity,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //           Align(
                    //             alignment: Alignment.topRight,
                    //             child: InkWell(
                    //               onTap: () {
                    //                 _fileList.removeAt(index);
                    //                 _selectedImageFile = null;
                    //                 setState(() {});
                    //               },
                    //               child: Image.asset(
                    //                 'assets/images/feedback/mine_feedback_ic_del.png',
                    //                 width: 20.0,
                    //                 height: 20.0,
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       );
                    //     }
                    //     return Container(
                    //       margin: const EdgeInsets.all(10.0),
                    //       width: 80.0,
                    //       height: 80.0,
                    //       color: const Color(0xFFffffff),
                    //       child: content,
                    //     );
                    //   }),
                    // ),
                    MyButton(
                      onPressed: () {
                        //
                        // BlocProvider.of<LeaveMsgBloc>(context)
                        //   ..add(SubmitLeaveMsgEvent(
                        //       imageUrls: _imageUrls,
                        //       content: _contentEditController.text));
                        BlocProvider.of<LeaveMsgBloc>(context)
                          ..add(SubmitLeaveMsgEvent(
                              wid: widget.wid,
                              aid: widget.aid,
                              type: widget.type,
                              mobile: _mobileEditController.text,
                              email: "",
                              content: _contentEditController.text));
                      },
                      text: '提交',
                    )
                  ],
                )),
          );
        }));
  }

  // 选择图片
  // Future<void> _pickImage() async {
  //   if (_fileList.length >= 9) {
  //     Fluttertoast.showToast(msg: "最多选取9张图片");
  //     return;
  //   }
  //   try {
  //     XFile? pickedFile = await picker.pickImage(
  //         source: ImageSource.gallery, maxWidth: 800, imageQuality: 95);
  //     BytedeskUtils.printLog('pick image path: ${pickedFile!.path}');
  //     setState(() {
  //       _selectedImageFile = File(pickedFile.path);
  //     });
  //     //
  //     BlocProvider.of<LeaveMsgBloc>(context)
  //       ..add(UploadImageEvent(filePath: pickedFile.path));
  //   } catch (e) {
  //     BytedeskUtils.printLog('pick image error ${e.toString()}');
  //     Fluttertoast.showToast(msg: "未选取图片");
  //   }
  // }

  // 拍照
  // Future<void> _takeImage() async {
  //   if (_fileList.length >= 9) {
  //     Fluttertoast.showToast(msg: "最多选取9张图片");
  //     return;
  //   }
  //   try {
  //     XFile? pickedFile = await picker.pickImage(
  //         source: ImageSource.camera, maxWidth: 800, imageQuality: 95);
  //     BytedeskUtils.printLog('take image path: ${pickedFile!.path}');
  //     setState(() {
  //       _selectedImageFile = File(pickedFile.path);
  //     });
  //     //
  //     BlocProvider.of<LeaveMsgBloc>(context)
  //       ..add(UploadImageEvent(filePath: pickedFile.path));
  //   } catch (e) {
  //     BytedeskUtils.printLog('take image error ${e.toString()}');
  //     Fluttertoast.showToast(msg: "未选取图片");
  //   }
  // }
}
