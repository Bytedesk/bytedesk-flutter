import 'package:bytedesk_kefu/blocs/help_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpArticle.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/ui/faq/provider/help_article_detail_provider.dart';
import 'package:bytedesk_kefu/ui/widget/empty_widget.dart';
import 'package:bytedesk_kefu/ui/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';
// import 'package:flutter_easyrefresh/phoenix_header.dart';

class HelpArticleListPage extends StatefulWidget {
  //
  final HelpCategory? helpCategory;
  HelpArticleListPage({Key? key, this.helpCategory}) : super(key: key);

  @override
  _HelpArticleListPageState createState() => _HelpArticleListPageState();
}

class _HelpArticleListPageState extends State<HelpArticleListPage>
    with AutomaticKeepAliveClientMixin<HelpArticleListPage> {
  //
  Set<HelpArticle>? _articleList;
  HelpBloc? _helpBloc;

  @override
  void initState() {
    super.initState();
    //
    _articleList = Set.from([]);
    _helpBloc = BlocProvider.of<HelpBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.helpCategory!.name!),
        centerTitle: true,
      ),
      body: BlocConsumer<HelpBloc, HelpState>(listener: (context, state) {
        // do stuff here based on BlocA's state
        if (state is HelpArticleState) {
          BytedeskUtils.printLog('help article load success length: ' +
              state.articleList.length.toString());
          if (state.articleList.length == 0) {
            // Toast.show('没有更多了哦');
          } else {
            // TODO: 加载下来的数据本地缓存
            _articleList!.addAll(state.articleList);
          }
        }
      }, builder: (context, state) {
        // return widget here based on BlocA's state

        return EasyRefresh.custom(
          controller: EasyRefreshController(),
          header: PhoenixHeader(),
          firstRefresh: true,
          firstRefreshWidget: LoadingWidget(),
          emptyWidget: _articleList!.length == 0
              ? EmptyWidget(
                  tip: '未找到相关数据',
                )
              : null,
          onRefresh: () async {
            _helpBloc!
                .add(GetHelpArticleEvent(categoryId: widget.helpCategory!.id));
          },
          onLoad: () async {
            _helpBloc!
                .add(GetHelpArticleEvent(categoryId: widget.helpCategory!.id));
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return new ListTile(
                    // leading: new Icon(Icons.message),
                    title: new Text(_articleList!.elementAt(index).title!),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      //
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new HelpArticleDetailProvider(
                          helpArticle: _articleList!.elementAt(index),
                        );
                      }));
                    },
                  );
                },
                childCount: _articleList!.length,
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
