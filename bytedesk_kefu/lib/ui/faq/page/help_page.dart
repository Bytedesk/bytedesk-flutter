import 'package:bytedesk_kefu/blocs/help_bloc/bloc.dart';
import 'package:bytedesk_kefu/model/helpCategory.dart';
import 'package:bytedesk_kefu/ui/faq/provider/help_article_list_provider.dart';
import 'package:bytedesk_kefu/ui/widget/empty_widget.dart';
import 'package:bytedesk_kefu/ui/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
// import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:bytedesk_kefu/util/bytedesk_utils.dart';

class HelpPage extends StatefulWidget {
  final String? uid;
  HelpPage({Key? key, @required this.uid}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage>
    with AutomaticKeepAliveClientMixin<HelpPage> {
  //
  // int _currentPage = 0;
  Set<HelpCategory>? _categoryList;
  HelpBloc? _courseBloc;

  @override
  void initState() {
    super.initState();
    //
    _categoryList = Set.from([]);
    _courseBloc = BlocProvider.of<HelpBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text("常见问题"),
        centerTitle: true,
      ),
      body: BlocConsumer<HelpBloc, HelpState>(listener: (context, state) {
        // do stuff here based on BlocA's state
        if (state is HelpCategoryState) {
          BytedeskUtils.printLog('help category load success length: ' +
              state.categoryList.length.toString());
          if (state.categoryList.length == 0) {
            // Toast.show('没有更多了哦');
          } else {
            // TODO: 加载下来的数据本地缓存
            _categoryList!.addAll(state.categoryList);
          }
        }
      }, builder: (context, state) {
        // return widget here based on BlocA's state

        return EasyRefresh.custom(
          controller: EasyRefreshController(),
          header: PhoenixHeader(),
          firstRefresh: true,
          firstRefreshWidget: LoadingWidget(),
          emptyWidget: _categoryList!.length == 0
              ? EmptyWidget(
                  tip: '未找到相关数据',
                )
              : null,
          onRefresh: () async {
            _courseBloc!.add(GetHelpCategoryEvent(uid: widget.uid));
          },
          onLoad: () async {
            _courseBloc!.add(GetHelpCategoryEvent(uid: widget.uid));
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return new ListTile(
                    // leading: new Icon(Icons.message),
                    title: new Text(_categoryList!.elementAt(index).name!),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      //
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new HelpArticleListProvider(
                          helpCategory: _categoryList!.elementAt(index),
                        );
                      }));
                    },
                  );
                },
                childCount: _categoryList!.length,
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
