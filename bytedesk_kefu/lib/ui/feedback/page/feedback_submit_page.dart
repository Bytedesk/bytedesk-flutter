import 'dart:io';
import 'package:bytedesk_kefu/blocs/feedback_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/ui/widget/image_choose_widget.dart';
import 'package:bytedesk_kefu/ui/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';

class FeedbackSubmitPage extends StatefulWidget {
  final HelpCategory? helpCategory;
  FeedbackSubmitPage({Key? key, this.helpCategory}) : super(key: key);

  @override
  _FeedbackSubmitPageState createState() => _FeedbackSubmitPageState();
}

class _FeedbackSubmitPageState extends State<FeedbackSubmitPage> {
  //
  ScrollController _scrollController = new ScrollController(); // 滚动监听
  TextEditingController _textEditController = new TextEditingController();
  ImagePicker picker = ImagePicker();
  List<String> _imageUrls = [];
  List<File> _fileList = [];
  File? _selectedImageFile;
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
    BytedeskUtils.printLog('fileList的内容: $_fileList');
    if (_selectedImageFile != null) {
      _fileList.add(_selectedImageFile!);
    }
    _selectedImageFile = null;
    //
    // TODO: 右上角增加：我的反馈，查看反馈记录及回复
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.helpCategory!.name!),
          centerTitle: true,
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    BytedeskUtils.printLog('submit');
                    // TODO: 提交
                    BlocProvider.of<FeedbackBloc>(context)
                      ..add(SubmitFeedbackEvent(
                          imageUrls: _imageUrls,
                          content: _textEditController.text));
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
        body: BlocConsumer<FeedbackBloc, FeedbackState>(
            listener: (context, state) {
          // do stuff here based on BlocA's state
          if (state is ImageUploading) {
            Fluttertoast.showToast(msg: '上传图片中');
          } else if (state is UploadImageSuccess) {
            // 图片url
            if (!_imageUrls.contains(state.url)) {
              _imageUrls.add(state.url);
            }
          } else if (state is UpLoadImageError) {
            Fluttertoast.showToast(msg: '上传图片失败');
          } else if (state is FeedbackSubmiting) {
            Fluttertoast.showToast(msg: '提交反馈中');
          } else if (state is FeedbackSubmitSuccess) {
            Fluttertoast.showToast(msg: '提交反馈成功');
          } else if (state is FeedbackSubmitError) {
            Fluttertoast.showToast(msg: '提交反馈失败');
          }
        }, builder: (context, state) {
          // return widget here based on BlocA's state
          return SingleChildScrollView(
            controller: _scrollController,
            child: Container(
                padding: EdgeInsets.only(top: 5.0, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 150,
                      ),
                      // color: Color(0xffffffff),
                      margin: EdgeInsets.only(top: 15),
                      child: TextField(
                        controller: _textEditController,
                        maxLines: 5,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: "快说点儿什么吧......",
                          hintStyle:
                              TextStyle(color: Color(0xff999999), fontSize: 16),
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      crossAxisCount: 3,
                      children: List.generate(_fileList.length + 1, (index) {
                        // 这个方法体用于生成GridView中的一个item
                        var content;
                        if (index == _fileList.length) {
                          // 添加图片按钮
                          var addCell = Center(
                              child: Image.asset(
                            'assets/images/feedback/mine_feedback_add_image.png',
                            width: double.infinity,
                            height: double.infinity,
                          ));
                          content = GestureDetector(
                            onTap: () {
                              // 添加图片
                              // pickImage(context);
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return ImageChooseWidget(
                                      pickImageCallBack: () {
                                        _pickImage();
                                      },
                                      takeImageCallBack: () {
                                        _takeImage();
                                      },
                                    );
                                  });
                            },
                            child: addCell,
                          );
                        } else {
                          // 被选中的图片
                          content = Stack(
                            children: <Widget>[
                              Center(
                                child: Image.file(
                                  _fileList[index],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    _fileList.removeAt(index);
                                    _selectedImageFile = null;
                                    setState(() {});
                                  },
                                  child: Image.asset(
                                    'assets/images/feedback/mine_feedback_ic_del.png',
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 80.0,
                          height: 80.0,
                          color: const Color(0xFFffffff),
                          child: content,
                        );
                      }),
                    ),
                    MyButton(
                      onPressed: () {
                        //
                        BlocProvider.of<FeedbackBloc>(context)
                          ..add(SubmitFeedbackEvent(
                              imageUrls: _imageUrls,
                              content: _textEditController.text));
                      },
                      text: '提交',
                    )
                  ],
                )),
          );
        }));
  }

  // 选择图片
  Future<void> _pickImage() async {
    if (_fileList.length >= 9) {
      Fluttertoast.showToast(msg: "最多选取9张图片");
      return;
    }
    try {
      XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery, maxWidth: 800, imageQuality: 95);
      BytedeskUtils.printLog('pick image path: ${pickedFile!.path}');
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
      //
      BlocProvider.of<FeedbackBloc>(context)
        ..add(UploadImageEvent(filePath: pickedFile.path));
    } catch (e) {
      BytedeskUtils.printLog('pick image error ${e.toString()}');
      Fluttertoast.showToast(msg: "未选取图片");
    }
  }

  // 拍照
  Future<void> _takeImage() async {
    if (_fileList.length >= 9) {
      Fluttertoast.showToast(msg: "最多选取9张图片");
      return;
    }
    try {
      XFile? pickedFile = await picker.pickImage(
          source: ImageSource.camera, maxWidth: 800, imageQuality: 95);
      BytedeskUtils.printLog('take image path: ${pickedFile!.path}');
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
      //
      BlocProvider.of<FeedbackBloc>(context)
        ..add(UploadImageEvent(filePath: pickedFile.path));
    } catch (e) {
      BytedeskUtils.printLog('take image error ${e.toString()}');
      Fluttertoast.showToast(msg: "未选取图片");
    }
  }

  // //相机拍照或图库选择照片布局
  // _renderBottomMenuItem(title, ImageSource source) {
  //   var item = Container(
  //     height: 60.0,
  //     child: Center(child: Text(title)),
  //   );
  //   return InkWell(
  //     child: item,
  //     onTap: () {
  //       Navigator.of(context).pop();
  //       ImagePicker.pickImage(source: source).then((result) {
  //         setState(() {
  //           _selectedImageFile = result;
  //           BytedeskUtils.printLog("执行刷新:");
  //         });
  //       });
  //     },
  //   );
  // }

  // //弹出底部选择图片方式弹出框
  // Widget _bottomSheetBuilder(BuildContext context) {
  //   return Container(
  //     height: 182.0,
  //     child: Padding(
  //       padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
  //       child: Column(
  //         children: <Widget>[
  //           _renderBottomMenuItem("相机拍照", ImageSource.camera),
  //           Divider(
  //             height: 2.0,
  //           ),
  //           _renderBottomMenuItem("图库选择照片", ImageSource.gallery)
  //         ],
  //       ),
  //     ));
  // }

  // // 选择弹出相机拍照或者从图库选择图片
  // pickImage(ctx) {
  //   // 如果已添加了9张图片，则提示不允许添加更多
  //   num size = _fileList.length;
  //   if (size >= 9) {
  //     Scaffold.of(ctx).showSnackBar(SnackBar(
  //       content: Text("最多只能添加9张图片！"),
  //     ));
  //     return;
  //   }
  //   showModalBottomSheet<void>(context: context, builder: _bottomSheetBuilder);
  // }

}
