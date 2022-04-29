import 'package:bytedesk_kefu/blocs/help_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpArticle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';

class HelpArticleDetailPage extends StatefulWidget {
  final HelpArticle? helpArticle;
  HelpArticleDetailPage({Key? key, this.helpArticle}) : super(key: key);

  @override
  _HelpArticleDetailPageState createState() => _HelpArticleDetailPageState();
}

class _HelpArticleDetailPageState extends State<HelpArticleDetailPage>
    with AutomaticKeepAliveClientMixin<HelpArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.helpArticle!.title!),
          centerTitle: true,
        ),
        body: BlocConsumer<HelpBloc, HelpState>(listener: (context, state) {
          // do stuff here based on BlocA's state
        }, builder: (context, state) {
          // return widget here based on BlocA's state
          return Container(
              // padding: EdgeInsets.only(
              //   top: 5.0,
              // ),
              // child: Column(
              //   children: <Widget>[
              //     Html(data: widget.helpArticle.content)
              //     // TODO: 增加有帮助、无帮助按钮
              //     // TODO: 增加联系客服按钮
              //   ],
              // )
              );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}
