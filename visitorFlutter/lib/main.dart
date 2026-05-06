import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const VisitorFlutterApp());
}

const _prodChatBaseUrl = 'https://cdn.weiyuai.cn';
const _prodApiBaseUrl = 'https://api.weiyuai.cn';
const _messageBubbleClickEventName = 'MESSAGE_BUBBLE_CLICK';
const _goodsMessageType = 'GOODS';
const _orderMessageType = 'ORDER';
const _defaultChatProfile = ChatProfile(
  org: 'df_org_uid',
  type: '1',
  sid: 'df_wg_uid',
);

String _buildBubbleClickBridgeScript() {
  return '''
(function() {
  if (window.__bytedeskBubbleBridgeInstalled) {
    return;
  }
  window.__bytedeskBubbleBridgeInstalled = true;

  function sendToNative(payload) {
    try {
      var text = typeof payload === 'string' ? payload : JSON.stringify(payload);
      BytedeskBubbleBridge.postMessage(text);
    } catch (error) {}
  }

  function forward(packet) {
    if (packet === undefined || packet === null) {
      return;
    }
    sendToNative(packet);
  }

  function wrapUniBridge(bridge) {
    var uniBridge = bridge || {};
    var originalUniPostMessage = uniBridge.postMessage;
    uniBridge.postMessage = function(packet) {
      var payload = packet && packet.data !== undefined ? packet.data : packet;
      forward(payload);
      if (typeof originalUniPostMessage === 'function') {
        return originalUniPostMessage.apply(this, arguments);
      }
    };
    return uniBridge;
  }

  function wrapWxBridge(bridge) {
    var wxBridge = bridge || {};
    var miniProgramBridge = wxBridge.miniProgram || {};
    var originalMiniProgramPostMessage = miniProgramBridge.postMessage;
    miniProgramBridge.postMessage = function(packet) {
      var payload = packet && packet.data !== undefined ? packet.data : packet;
      forward(payload);
      if (typeof originalMiniProgramPostMessage === 'function') {
        return originalMiniProgramPostMessage.apply(this, arguments);
      }
    };
    wxBridge.miniProgram = miniProgramBridge;
    return wxBridge;
  }

  function installWindowBridgeProxy(propertyName, wrapper) {
    var currentValue = wrapper(window[propertyName]);
    try {
      Object.defineProperty(window, propertyName, {
        configurable: true,
        get: function() {
          return currentValue;
        },
        set: function(nextValue) {
          currentValue = wrapper(nextValue);
        }
      });
    } catch (error) {
      currentValue = wrapper(window[propertyName]);
    }
    window[propertyName] = currentValue;
  }

  function installHostBridges() {
    installWindowBridgeProxy('uni', wrapUniBridge);
    installWindowBridgeProxy('wx', wrapWxBridge);
  }

  window.addEventListener('message', function(event) {
    forward(event && event.data !== undefined ? event.data : event);
  }, false);

  var originalPostMessage = window.postMessage;
  window.postMessage = function(message, targetOrigin, transfer) {
    forward(message);
    if (typeof originalPostMessage === 'function') {
      return originalPostMessage.apply(this, arguments);
    }
  };

  installHostBridges();
})();
''';
}

const _demoUsers = <DemoUser>[
  DemoUser(
    key: 'user1',
    visitorUid: 'visitor_001',
    nickname: '用户小明',
    avatar: 'https://weiyuai.cn/assets/images/avatar/02.jpg',
    vipLevel: 0,
  ),
  DemoUser(
    key: 'user2',
    visitorUid: 'visitor_002',
    nickname: '用户小红',
    avatar: 'https://weiyuai.cn/assets/images/avatar/01.jpg',
    vipLevel: 1,
  ),
  DemoUser(
    key: 'user3',
    visitorUid: 'visitor_003',
    nickname: '用户小美',
    avatar: 'https://weiyuai.cn/assets/images/avatar/03.jpg',
    vipLevel: 2,
  ),
];

const _bizScenes = <BizScene>[
  BizScene(
    value: 'plain',
    label: '普通会话演示',
    description: '直接打开普通客服会话，不携带商品卡片和订单卡片参数。',
    icon: Icons.chat_bubble_outline_rounded,
  ),
  BizScene(
    value: 'goods',
    label: '商品消息演示',
    description: '打开商品场景客服会话，并自动发送商品卡片。',
    icon: Icons.shopping_bag_outlined,
    autoSendBizInfo: true,
  ),
  BizScene(
    value: 'goods-confirm',
    label: '商品消息演示（弹窗确认发送）',
    description: '打开商品场景客服会话，通过弹窗确认后再发送商品卡片。',
    icon: Icons.shopping_cart_checkout_rounded,
    autoSendBizInfo: false,
  ),
  BizScene(
    value: 'order',
    label: '订单消息演示',
    description: '打开订单场景客服会话，并自动发送订单卡片。',
    icon: Icons.receipt_long_outlined,
    autoSendBizInfo: true,
  ),
  BizScene(
    value: 'order-confirm',
    label: '订单消息演示（弹窗确认发送）',
    description: '打开订单场景客服会话，通过弹窗确认后再发送订单卡片。',
    icon: Icons.inventory_2_outlined,
    autoSendBizInfo: false,
  ),
];

const _goodsInfoDemo = {
  'uid': 'goods_uniapp_001',
  'title': '轻奢通勤双肩包',
  'image':
      'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=900&q=80',
  'description': '适合日常通勤和短途出差的多功能双肩包。',
  'price': 399,
  'url': 'https://www.weiyuai.cn',
  'tagList': ['新品', '包邮', '支持7天无理由'],
  'quantity': 1,
  'shopUid': 'shop_001',
};

const _orderInfoDemoBase = {
  'uid': 'order_uniapp_001',
  'shopUid': 'shop_001',
  'time': '2026-03-11 10:30:00',
  'status': 'paid',
  'statusText': '已付款，待发货',
  'goods': {
    'uid': 'goods_uniapp_001',
    'title': '轻奢通勤双肩包',
    'image':
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=900&q=80',
    'description': '适合日常通勤和短途出差的多功能双肩包。',
    'price': 399,
    'url': 'https://www.weiyuai.cn',
    'tagList': ['新品', '包邮'],
    'quantity': 1,
  },
  'totalAmount': 399,
  'shippingAddress': {
    'name': '张三',
    'phone': '13800000000',
    'address': '上海市浦东新区世纪大道 100 号',
  },
  'paymentMethod': '支付宝',
};

class VisitorFlutterApp extends StatelessWidget {
  const VisitorFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF1F6F54);
    return MaterialApp(
      title: 'Bytedesk Visitor Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF4F6F2),
        useMaterial3: true,
      ),
      home: const VisitorHomePage(),
    );
  }
}

class VisitorHomePage extends StatefulWidget {
  const VisitorHomePage({super.key});

  @override
  State<VisitorHomePage> createState() => _VisitorHomePageState();
}

class _VisitorHomePageState extends State<VisitorHomePage> {
  int _selectedIndex = 0;
  int _selectedUserIndex = 0;
  String _searchText = '';
  late Future<List<ThreadSummary>> _threadsFuture;

  DemoUser get _selectedUser => _demoUsers[_selectedUserIndex];

  @override
  void initState() {
    super.initState();
    _threadsFuture = _loadThreads();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeTab(
        onSceneTap: (scene) async {
          final chatUrl = _buildSceneChatUrl(scene, _selectedUser);
          if (!mounted) {
            return;
          }
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  ChatWebViewPage(title: _sceneTitle(scene), url: chatUrl),
            ),
          );
        },
      ),
      MessagesTab(
        searchText: _searchText,
        onSearchChanged: (value) {
          setState(() {
            _searchText = value;
            _threadsFuture = _loadThreads(searchText: value.trim());
          });
        },
        threadsFuture: _threadsFuture,
        onRetry: () {
          setState(() {
            _threadsFuture = _loadThreads(searchText: _searchText.trim());
          });
        },
        onThreadTap: (thread) async {
          final target = _resolveThreadRouteTarget(thread.raw);
          if (target.sid.isEmpty) {
            if (!mounted) {
              return;
            }
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('当前会话缺少 sid')));
            return;
          }
          final chatUrl = _buildChatUrl(
            chatProfile: ChatProfile(
              org: _defaultChatProfile.org,
              type: target.type,
              sid: target.sid,
            ),
            visitorProfile: _selectedUser,
          );
          if (!mounted) {
            return;
          }
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  ChatWebViewPage(title: thread.title, url: chatUrl),
            ),
          );
        },
      ),
      ProfileTab(
        users: _demoUsers,
        selectedIndex: _selectedUserIndex,
        onSelectUser: (index) {
          setState(() {
            _selectedUserIndex = index;
            _threadsFuture = _loadThreads(searchText: _searchText.trim());
          });
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForIndex(_selectedIndex)),
        centerTitle: true,
      ),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: '消息',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: '我的',
          ),
        ],
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Future<List<ThreadSummary>> _loadThreads({String searchText = ''}) async {
    return _requestVisitorThreads(
      visitorProfile: _selectedUser,
      searchText: searchText,
    );
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return '微语';
      case 1:
        return '历史会话';
      default:
        return '我的';
    }
  }

  String _sceneTitle(BizScene scene) {
    if (scene.value == 'plain') {
      return '普通客服会话';
    }
    return scene.value.startsWith('order') ? '订单客服会话' : '商品客服会话';
  }

  String _buildSceneChatUrl(BizScene scene, DemoUser user) {
    String? bizKey;
    Map<String, Object?>? bizPayload;
    String? autoSendBizInfo;

    if (scene.value.startsWith('goods')) {
      bizKey = 'goodsInfo';
      bizPayload = _goodsInfoDemo;
      autoSendBizInfo = scene.autoSendBizInfo == true ? '1' : '0';
    } else if (scene.value.startsWith('order')) {
      bizKey = 'orderInfo';
      bizPayload = {..._orderInfoDemoBase, 'visitorUid': user.visitorUid};
      autoSendBizInfo = scene.autoSendBizInfo == true ? '1' : '0';
    }

    return _buildChatUrl(
      visitorProfile: user,
      bizKey: bizKey,
      bizPayload: bizPayload,
      autoSendBizInfo: autoSendBizInfo,
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onSceneTap});

  final ValueChanged<BizScene> onSceneTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _SectionCard(
          child: Column(
            children: [
              for (var index = 0; index < _bizScenes.length; index++) ...[
                GestureDetector(
                  onTap: () => onSceneTap(_bizScenes[index]),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F3EC),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _bizScenes[index].icon,
                            color: const Color(0xFF1F6F54),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _bizScenes[index].label,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 6),
                              Text(_bizScenes[index].description),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ),
                if (index < _bizScenes.length - 1)
                  const Divider(height: 1, color: Color(0xFFE8EEEA)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class MessagesTab extends StatelessWidget {
  const MessagesTab({
    super.key,
    required this.searchText,
    required this.onSearchChanged,
    required this.threadsFuture,
    required this.onRetry,
    required this.onThreadTap,
  });

  final String searchText;
  final ValueChanged<String> onSearchChanged;
  final Future<List<ThreadSummary>> threadsFuture;
  final VoidCallback onRetry;
  final ValueChanged<ThreadSummary> onThreadTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _SectionCard(
          child: TextField(
            controller: TextEditingController(text: searchText)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: searchText.length),
              ),
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '搜索会话标题或消息内容',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<ThreadSummary>>(
          future: threadsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const _SectionCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('正在加载历史会话...'),
                ),
              );
            }

            if (snapshot.hasError) {
              return _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('加载历史会话失败：${snapshot.error}'),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: onRetry, child: const Text('重新加载')),
                  ],
                ),
              );
            }

            final threads = snapshot.data ?? const <ThreadSummary>[];
            if (threads.isEmpty) {
              return const _SectionCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('当前访客暂无历史会话'),
                ),
              );
            }

            return _SectionCard(
              child: Column(
                children: [
                  for (var index = 0; index < threads.length; index++) ...[
                    GestureDetector(
                      onTap: () => onThreadTap(threads[index]),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            if (threads[index].avatar.isNotEmpty)
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                  threads[index].avatar,
                                ),
                              )
                            else
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: threads[index].typeColor
                                    .withValues(alpha: 0.16),
                                child: Text(
                                  threads[index].title.substring(0, 1),
                                  style: TextStyle(
                                    color: threads[index].typeColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          threads[index].title,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                      ),
                                      Text(
                                        threads[index].updatedAt,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    threads[index].preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      if (threads[index].unreadCount > 0)
                                        CircleAvatar(
                                          radius: 11,
                                          backgroundColor: const Color(
                                            0xFFD94242,
                                          ),
                                          child: Text(
                                            '${threads[index].unreadCount}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index < threads.length - 1)
                      const Divider(height: 1, color: Color(0xFFE8EEEA)),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.users,
    required this.selectedIndex,
    required this.onSelectUser,
  });

  final List<DemoUser> users;
  final int selectedIndex;
  final ValueChanged<int> onSelectUser;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final selected = index == selectedIndex;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _SectionCard(
            onTap: () => onSelectUser(index),
            color: selected ? const Color(0xFFFFF8F2) : null,
            borderColor: selected
                ? const Color(0xFFB36A37)
                : Colors.transparent,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(user.avatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.nickname,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          Chip(label: Text('VIP ${user.vipLevel}')),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('visitorUid: ${user.visitorUid}'),
                      const SizedBox(height: 4),
                      Text(selected ? '当前身份，点击可切换到其他用户' : '点击切换到该访客身份'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatWebViewPage extends StatefulWidget {
  const ChatWebViewPage({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<ChatWebViewPage> createState() => _ChatWebViewPageState();
}

class _ChatWebViewPageState extends State<ChatWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _detailRouteInFlight = false;
  String? _lastOpenedDetailId;
  DateTime? _lastOpenedDetailAt;

  String _detailRouteId(DetailDestination detail) {
    return '${detail.kind}:${_stringValue(detail.payload['uid'])}:${_stringValue(detail.payload['value'])}';
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'BytedeskBubbleBridge',
        onMessageReceived: (message) async {
          final detail = _detailDestinationFromPacket(message.message);
          if (detail == null || !mounted) {
            return;
          }
          final routeId = _detailRouteId(detail);
          final now = DateTime.now();
          if (_detailRouteInFlight) {
            return;
          }
          if (_lastOpenedDetailId == routeId &&
              _lastOpenedDetailAt != null &&
              now.difference(_lastOpenedDetailAt!) < const Duration(seconds: 1)) {
            return;
          }

          _detailRouteInFlight = true;
          _lastOpenedDetailId = routeId;
          _lastOpenedDetailAt = now;

          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => detail.kind == _goodsMessageType
                  ? GoodsDetailPage(goods: detail.payload)
                  : OrderDetailPage(order: detail.payload),
            ),
          );

          _detailRouteInFlight = false;
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _loading = true;
              });
            }
          },
          onPageFinished: (_) {
            _controller.runJavaScript(_buildBubbleClickBridgeScript());
            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class GoodsDetailPage extends StatelessWidget {
  const GoodsDetailPage({super.key, required this.goods});

  final Map<String, dynamic> goods;

  @override
  Widget build(BuildContext context) {
    final tagList = goods['tagList'] is List
        ? (goods['tagList'] as List).map((item) => '$item').toList()
        : const <String>[];
    const pageBackground = Color(0xFFF4F7F2);
    const cardAccent = Color(0xFFE2ECE4);
    const codeBackground = Color(0xFFF5F7F5);

    return Scaffold(
      appBar: AppBar(title: const Text('商品详情')),
      backgroundColor: pageBackground,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            color: Colors.white,
            borderColor: cardAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '商品详情',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF173127),
                  ),
                ),
                const SizedBox(height: 12),
                if (_stringValue(goods['image']).isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      _stringValue(goods['image']),
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _DetailRow(label: '商品 UID', value: _stringValue(goods['uid'])),
                _DetailRow(label: '标题', value: _stringValue(goods['title'])),
                _DetailRow(label: '价格', value: _formatPrice(goods['price'])),
                _DetailRow(
                  label: '数量',
                  value: _stringValue(goods['quantity']).isEmpty
                      ? '1'
                      : _stringValue(goods['quantity']),
                ),
                _DetailRow(label: '店铺', value: _stringValue(goods['shopUid'])),
                _DetailRow(
                  label: '描述',
                  value: _stringValue(goods['description']),
                  multiline: true,
                ),
                _DetailRow(
                  label: '标签',
                  value: tagList.isEmpty ? '-' : tagList.join(' / '),
                  multiline: true,
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            color: Colors.white,
            borderColor: cardAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '原始载荷',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: codeBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SelectableText(
                    _formatPrettyJson(goods),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.5,
                      color: const Color(0xFF365244),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.order});

  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
    final goods = _parseJsonObject(order['goods']);
    final shipping = _parseJsonObject(order['shippingAddress']);
    const pageBackground = Color(0xFFF6F3EF);
    const cardAccent = Color(0xFFF0E6DA);
    const codeBackground = Color(0xFFFAF7F3);

    return Scaffold(
      appBar: AppBar(title: const Text('订单详情')),
      backgroundColor: pageBackground,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            color: Colors.white,
            borderColor: cardAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '订单详情',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3B2416),
                  ),
                ),
                const SizedBox(height: 12),
                _DetailRow(label: '订单 UID', value: _stringValue(order['uid'])),
                _DetailRow(
                  label: '访客 UID',
                  value: _stringValue(order['visitorUid']),
                ),
                _DetailRow(label: '店铺', value: _stringValue(order['shopUid'])),
                _DetailRow(
                  label: '状态',
                  value: _firstNonEmpty([
                    _stringValue(order['statusText']),
                    _stringValue(order['status']),
                  ]),
                ),
                _DetailRow(
                  label: '总金额',
                  value: _formatPrice(order['totalAmount']),
                ),
                _DetailRow(
                  label: '支付方式',
                  value: _stringValue(order['paymentMethod']),
                ),
                _DetailRow(
                  label: '商品',
                  value: _stringValue(goods['title']),
                  multiline: true,
                ),
                _DetailRow(
                  label: '收货地址',
                  value: _formatShippingAddress(shipping),
                  multiline: true,
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            color: Colors.white,
            borderColor: cardAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '原始载荷',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: codeBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SelectableText(
                    _formatPrettyJson(order),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.5,
                      color: const Color(0xFF694B35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.multiline = false,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool multiline;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: Color(0xFFE8EEEA), width: 1),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6A7B72)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF173127)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.onTap,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor ?? Colors.transparent),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14203B2B),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: content,
    );
  }
}

Future<List<ThreadSummary>> _requestVisitorThreads({
  required DemoUser visitorProfile,
  String searchText = '',
}) async {
  final uri =
      Uri.parse(
        '${_defaultApiBaseUrl().replaceAll(RegExp(r'/+$'), '')}/visitor/api/v1/threads',
      ).replace(
        queryParameters: {
          'orgUid': _defaultChatProfile.org,
          'visitorUid': visitorProfile.visitorUid,
          'pageNumber': '0',
          'pageSize': '10',
          'mergeByTopic': 'true',
          'searchText': searchText,
        },
      );

  final response = await http.get(uri);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('HTTP ${response.statusCode}');
  }

  final payload = jsonDecode(response.body);
  if (payload is! Map<String, dynamic>) {
    throw Exception('响应格式错误');
  }

  if (payload['code'] != 200) {
    throw Exception('${payload['message'] ?? '加载历史会话失败'}');
  }

  final data = payload['data'];
  if (data is! Map<String, dynamic>) {
    return const <ThreadSummary>[];
  }
  final content = data['content'];
  if (content is! List) {
    return const <ThreadSummary>[];
  }

  return content
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item.cast<String, dynamic>()))
      .map(ThreadSummary.fromMap)
      .toList();
}

String _defaultChatBaseUrl() {
  return _prodChatBaseUrl;
}

String _defaultApiBaseUrl() {
  return _prodApiBaseUrl;
}

String _buildChatUrl({
  ChatProfile chatProfile = _defaultChatProfile,
  required DemoUser visitorProfile,
  String? bizKey,
  Map<String, Object?>? bizPayload,
  String? autoSendBizInfo,
}) {
  final baseUrl = _normalizeBaseHtmlUrl(_defaultChatBaseUrl());
  final params = <String, String>{
    'org': chatProfile.org,
    't': chatProfile.type,
    'sid': chatProfile.sid,
    'lang': 'zh-cn',
    'navbar': '0',
    'visitorUid': visitorProfile.visitorUid,
    'nickname': visitorProfile.nickname,
    'avatar': visitorProfile.avatar,
  };

  if (autoSendBizInfo != null && autoSendBizInfo.trim().isNotEmpty) {
    params['autoSendBizInfo'] = autoSendBizInfo;
  }
  if (bizKey != null && bizKey.isNotEmpty && bizPayload != null) {
    params[bizKey] = jsonEncode(bizPayload);
  }

  return Uri.parse('$baseUrl/chat').replace(queryParameters: params).toString();
}

String _normalizeBaseHtmlUrl(String baseUrl) {
  return baseUrl.replaceAll(RegExp(r'/?chat(?:/thread)?/?$'), '');
}

ThreadRouteTarget _resolveThreadRouteTarget(Map<String, dynamic> thread) {
  final type = _normalizeThreadType(thread);

  if (type == '0') {
    final sid = _nestedString(thread, ['agentProtobuf', 'uid']);
    if (sid.isNotEmpty) {
      return ThreadRouteTarget(type: '0', sid: sid);
    }
  }
  if (type == '1') {
    final sid = _nestedString(thread, ['workgroupProtobuf', 'uid']);
    if (sid.isNotEmpty) {
      return ThreadRouteTarget(type: '1', sid: sid);
    }
  }
  if (type == '2') {
    final sid = _nestedString(thread, ['robotProtobuf', 'uid']);
    if (sid.isNotEmpty) {
      return ThreadRouteTarget(type: '2', sid: sid);
    }
  }

  return ThreadRouteTarget(type: '0', sid: _stringValue(thread['uid']));
}

String _normalizeThreadType(Map<String, dynamic> thread) {
  final rawType = _stringValue(thread['type']).toUpperCase();
  if (rawType == 'AGENT' || rawType == '0') {
    return '0';
  }
  if (rawType == 'WORKGROUP' || rawType == '1') {
    return '1';
  }
  if (rawType == 'ROBOT' || rawType == '2') {
    return '2';
  }
  return '';
}

String _resolveThreadPreview(Map<String, dynamic> thread) {
  final directPreview = _normalizeText(
    _nestedValue(thread, ['contentObject', 'preview']) ??
        thread['content'] ??
        thread['topic'],
  );
  if (directPreview.isNotEmpty) {
    return _translateThreadText(directPreview);
  }

  final payload = _parseJsonObject(thread['content']);
  final rawType = _stringValue(
    payload['type'] ?? payload['msgType'] ?? payload['messageType'],
  ).toUpperCase();
  if (rawType.isEmpty) {
    return '暂无消息';
  }

  final previewType = _threadPreviewLabels.firstWhere(
    (item) => rawType.contains(item.match),
    orElse: () => const PreviewLabel(match: '', fallback: ''),
  );
  final detail = _translateThreadText(_extractText(payload));
  if (previewType.match.isEmpty) {
    return detail.isNotEmpty ? detail : '暂无消息';
  }

  return detail.isNotEmpty
      ? '${previewType.fallback} · $detail'
      : previewType.fallback;
}

String _resolveThreadName(Map<String, dynamic> thread) {
  final type = _normalizeThreadType(thread);
  final isWorkgroup =
      type == '1' || _hasNestedDisplay(thread, 'workgroupProtobuf');
  final isRobot = type == '2' || _hasNestedDisplay(thread, 'robotProtobuf');

  final displayName = isWorkgroup
      ? _firstNonEmpty([
          _nestedString(thread, ['workgroupProtobuf', 'nickname']),
          _nestedString(thread, ['agentProtobuf', 'nickname']),
          _nestedString(thread, ['user', 'nickname']),
          _stringValue(thread['topic']),
        ])
      : isRobot
      ? _firstNonEmpty([
          _nestedString(thread, ['robotProtobuf', 'nickname']),
          _nestedString(thread, ['agentProtobuf', 'nickname']),
          _nestedString(thread, ['user', 'nickname']),
          _stringValue(thread['topic']),
        ])
      : _firstNonEmpty([
          _nestedString(thread, ['agentProtobuf', 'nickname']),
          _nestedString(thread, ['workgroupProtobuf', 'nickname']),
          _nestedString(thread, ['user', 'nickname']),
          _stringValue(thread['topic']),
        ]);

  final normalized = _normalizeText(displayName);
  return normalized.isNotEmpty ? _translateThreadText(normalized) : '未命名会话';
}

String _resolveThreadAvatar(Map<String, dynamic> thread) {
  final type = _normalizeThreadType(thread);
  final isWorkgroup =
      type == '1' || _hasNestedDisplay(thread, 'workgroupProtobuf');
  final isRobot = type == '2' || _hasNestedDisplay(thread, 'robotProtobuf');
  return isWorkgroup
      ? _firstNonEmpty([
          _nestedString(thread, ['workgroupProtobuf', 'avatar']),
          _nestedString(thread, ['agentProtobuf', 'avatar']),
          _nestedString(thread, ['user', 'avatar']),
        ])
      : isRobot
      ? _firstNonEmpty([
          _nestedString(thread, ['robotProtobuf', 'avatar']),
          _nestedString(thread, ['agentProtobuf', 'avatar']),
          _nestedString(thread, ['user', 'avatar']),
        ])
      : _firstNonEmpty([
          _nestedString(thread, ['agentProtobuf', 'avatar']),
          _nestedString(thread, ['workgroupProtobuf', 'avatar']),
          _nestedString(thread, ['user', 'avatar']),
        ]);
}

bool _hasNestedDisplay(Map<String, dynamic> thread, String key) {
  final value = thread[key];
  if (value is! Map) {
    return false;
  }
  return _stringValue(value['uid']).isNotEmpty ||
      _stringValue(value['nickname']).isNotEmpty;
}

Object? _nestedValue(Map<String, dynamic> map, List<String> keys) {
  Object? current = map;
  for (final key in keys) {
    if (current is Map) {
      current = current[key];
    } else {
      return null;
    }
  }
  return current;
}

String _nestedString(Map<String, dynamic> map, List<String> keys) {
  return _stringValue(_nestedValue(map, keys));
}

Map<String, dynamic> _parseJsonObject(Object? value) {
  if (value == null) {
    return const <String, dynamic>{};
  }
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value.cast<String, dynamic>());
  }
  if (value is! String) {
    return const <String, dynamic>{};
  }
  final text = value.trim();
  if (!((text.startsWith('{') && text.endsWith('}')) ||
      (text.startsWith('[') && text.endsWith(']')))) {
    return const <String, dynamic>{};
  }
  try {
    final parsed = jsonDecode(text);
    if (parsed is Map<String, dynamic>) {
      return parsed;
    }
    if (parsed is Map) {
      return Map<String, dynamic>.from(parsed.cast<String, dynamic>());
    }
  } catch (_) {
    return const <String, dynamic>{};
  }
  return const <String, dynamic>{};
}

String _normalizeText(Object? value) {
  if (value == null) {
    return '';
  }
  if (value is List) {
    for (final item in value) {
      final text = _normalizeText(item);
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }
  if (value is Map) {
    return _extractText(
      Map<String, dynamic>.from(value.cast<String, dynamic>()),
    );
  }
  var text = '$value'
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</(p|div|li|h[1-6])>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  if (text.isEmpty) {
    return '';
  }
  if ((text.startsWith('{') && text.endsWith('}')) ||
      (text.startsWith('[') && text.endsWith(']'))) {
    final parsed = _parseJsonObject(text);
    if (parsed.isNotEmpty) {
      text = _extractText(parsed);
    }
  }
  return text;
}

String _extractText(Map<String, dynamic> value) {
  const preferredKeys = [
    'label',
    'title',
    'name',
    'text',
    'content',
    'summary',
    'description',
    'address',
    'detail',
    'phoneNumber',
    'phone',
    'mobile',
    'emailAddress',
    'email',
    'wechatNumber',
    'wechat',
    'orderNo',
    'ticketNo',
    'uid',
  ];
  for (final key in preferredKeys) {
    final text = _normalizeText(value[key]);
    if (text.isNotEmpty) {
      return text;
    }
  }
  for (final entry in value.entries) {
    final text = _normalizeText(entry.value);
    if (text.isNotEmpty) {
      return text;
    }
  }
  return '';
}

String _translateThreadText(String value) {
  return _threadTranslations[value] ?? value;
}

Object? _parseMaybeJsonValue(Object? value) {
  if (value is! String) {
    return value;
  }
  final text = value.trim();
  if (!((text.startsWith('{') && text.endsWith('}')) ||
      (text.startsWith('[') && text.endsWith(']')))) {
    return value;
  }
  try {
    return jsonDecode(text);
  } catch (_) {
    return value;
  }
}

BubbleClickEvent? _normalizeBubbleClickEvent(Object? packet) {
  var candidate = packet;

  if (candidate == null) {
    return null;
  }
  if (candidate is String) {
    candidate = _parseMaybeJsonValue(candidate);
  }
  if (candidate is List) {
    for (final item in candidate) {
      final normalized = _normalizeBubbleClickEvent(item);
      if (normalized != null) {
        return normalized;
      }
    }
    return null;
  }
  if (candidate is Map) {
    final map = Map<String, dynamic>.from(candidate.cast<String, dynamic>());
    if (map['detail'] is Map && (map['detail'] as Map)['data'] != null) {
      return _normalizeBubbleClickEvent((map['detail'] as Map)['data']);
    }
    if (map['data'] != null && map['type'] == null) {
      return _normalizeBubbleClickEvent(map['data']);
    }
    if (_stringValue(map['type']) == _messageBubbleClickEventName) {
      return BubbleClickEvent(
        uid: _stringValue(map['uid']),
        type: _stringValue(map['clickedMessageType']),
        content: _parseMaybeJsonValue(map['content']),
        extra: _parseMaybeJsonValue(map['extra']),
      );
    }
    if (_stringValue(map['uid']).isNotEmpty &&
        _stringValue(map['type']).isNotEmpty) {
      return BubbleClickEvent(
        uid: _stringValue(map['uid']),
        type: _stringValue(map['type']),
        content: _parseMaybeJsonValue(map['content']),
        extra: _parseMaybeJsonValue(map['extra']),
      );
    }
  }
  return null;
}

Map<String, dynamic> _recordFromValue(Object? value) {
  final parsed = _parseMaybeJsonValue(value);
  if (parsed is Map<String, dynamic>) {
    return parsed;
  }
  if (parsed is Map) {
    return Map<String, dynamic>.from(parsed.cast<String, dynamic>());
  }
  return <String, dynamic>{'value': parsed};
}

DetailDestination? _detailDestinationFromPacket(Object? packet) {
  final event = _normalizeBubbleClickEvent(packet);
  if (event == null) {
    return null;
  }
  final messageType = event.type.toUpperCase();
  if (messageType == _goodsMessageType) {
    return DetailDestination(
      kind: _goodsMessageType,
      payload: _resolveBubbleDetailPayload(event),
    );
  }
  if (messageType == _orderMessageType) {
    return DetailDestination(
      kind: _orderMessageType,
      payload: _resolveBubbleDetailPayload(event),
    );
  }
  return null;
}

Map<String, dynamic> _resolveBubbleDetailPayload(BubbleClickEvent event) {
  final contentRecord = _recordFromValue(event.content);
  if (!contentRecord.containsKey('value') || contentRecord.length > 1) {
    return contentRecord;
  }

  final extraRecord = _recordFromValue(event.extra);
  if (!extraRecord.containsKey('value') || extraRecord.length > 1) {
    return extraRecord;
  }

  return contentRecord;
}

String _formatPrettyJson(Map<String, dynamic> value) {
  return const JsonEncoder.withIndent('  ').convert(value);
}

String _formatPrice(Object? value) {
  final numberValue = double.tryParse(_stringValue(value)) ?? 0;
  return '¥${numberValue.toStringAsFixed(2)}';
}

String _formatShippingAddress(Map<String, dynamic> shippingAddress) {
  if (shippingAddress.isEmpty) {
    return '-';
  }
  final values = [
    _stringValue(shippingAddress['name']),
    _stringValue(shippingAddress['phone']),
    _stringValue(shippingAddress['address']),
  ].where((value) => value.isNotEmpty).toList();
  return values.isEmpty ? '-' : values.join(' / ');
}

String _firstNonEmpty(List<String> values) {
  for (final value in values) {
    if (value.trim().isNotEmpty) {
      return value;
    }
  }
  return '';
}

String _stringValue(Object? value) => value == null ? '' : '$value'.trim();

class DemoUser {
  const DemoUser({
    required this.key,
    required this.visitorUid,
    required this.nickname,
    required this.avatar,
    required this.vipLevel,
  });

  final String key;
  final String visitorUid;
  final String nickname;
  final String avatar;
  final int vipLevel;
}

class BizScene {
  const BizScene({
    required this.value,
    required this.label,
    required this.description,
    required this.icon,
    this.autoSendBizInfo,
  });

  final String value;
  final String label;
  final String description;
  final IconData icon;
  final bool? autoSendBizInfo;
}

class ChatProfile {
  const ChatProfile({required this.org, required this.type, required this.sid});

  final String org;
  final String type;
  final String sid;
}

class DetailDestination {
  const DetailDestination({required this.kind, required this.payload});

  final String kind;
  final Map<String, dynamic> payload;
}

class BubbleClickEvent {
  const BubbleClickEvent({
    required this.uid,
    required this.type,
    this.content,
    this.extra,
  });

  final String uid;
  final String type;
  final Object? content;
  final Object? extra;
}

class ThreadRouteTarget {
  const ThreadRouteTarget({required this.type, required this.sid});

  final String type;
  final String sid;
}

class ThreadSummary {
  const ThreadSummary({
    required this.raw,
    required this.uid,
    required this.type,
    required this.title,
    required this.preview,
    required this.updatedAt,
    required this.unreadCount,
    required this.avatar,
  });

  final Map<String, dynamic> raw;
  final String uid;
  final String type;
  final String title;
  final String preview;
  final String updatedAt;
  final int unreadCount;
  final String avatar;

  factory ThreadSummary.fromMap(Map<String, dynamic> thread) {
    return ThreadSummary(
      raw: thread,
      uid: _stringValue(thread['uid']),
      type: _normalizeThreadType(thread),
      title: _resolveThreadName(thread),
      preview: _resolveThreadPreview(thread),
      updatedAt: _formatTime(thread['updatedAt'] ?? thread['createdAt']),
      unreadCount:
          int.tryParse(
            _stringValue(thread['visitorUnreadCount'] ?? thread['unreadCount']),
          ) ??
          0,
      avatar: _resolveThreadAvatar(thread),
    );
  }

  String get typeLabel {
    switch (type) {
      case '0':
        return '一对一';
      case '1':
        return '工作组';
      case '2':
        return '机器人';
      default:
        return '历史';
    }
  }

  Color get typeColor {
    switch (type) {
      case '0':
        return const Color(0xFF1F6F54);
      case '1':
        return const Color(0xFF2C5D9F);
      case '2':
        return const Color(0xFF9C6D14);
      default:
        return const Color(0xFF6D746C);
    }
  }
}

String _formatTime(Object? value) {
  final text = _stringValue(value);
  if (text.isEmpty) {
    return '';
  }
  final date = DateTime.tryParse(text);
  if (date == null) {
    return text;
  }
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$month-$day $hour:$minute';
}

class PreviewLabel {
  const PreviewLabel({required this.match, required this.fallback});

  final String match;
  final String fallback;
}

const _threadPreviewLabels = <PreviewLabel>[
  PreviewLabel(match: 'IMAGE', fallback: '[图片]'),
  PreviewLabel(match: 'VOICE', fallback: '[语音]'),
  PreviewLabel(match: 'AUDIO', fallback: '[语音]'),
  PreviewLabel(match: 'VIDEO', fallback: '[视频]'),
  PreviewLabel(match: 'FILE', fallback: '[文件]'),
  PreviewLabel(match: 'LOCATION', fallback: '[位置]'),
  PreviewLabel(match: 'PHONE', fallback: '[电话]'),
  PreviewLabel(match: 'EMAIL', fallback: '[邮箱]'),
  PreviewLabel(match: 'WECHAT', fallback: '[微信]'),
  PreviewLabel(match: 'GOODS', fallback: '[商品]'),
  PreviewLabel(match: 'ORDER', fallback: '[订单]'),
  PreviewLabel(match: 'ARTICLE', fallback: '[文章]'),
  PreviewLabel(match: 'FORM', fallback: '[表单]'),
  PreviewLabel(match: 'THREAD', fallback: '[会话]'),
  PreviewLabel(match: 'TICKET', fallback: '[工单]'),
];

const _threadTranslations = <String, String>{
  'i18n.agent.nickname': '默认客服',
  'i18n.welcome.tip': '您好，有什么可以帮您的?',
  'i18n.default.welcome.message': '您好，请问有什么可以帮助您？',
  'i18n.robot.nickname': '默认机器人',
  'i18n.robot.agent.assistant.nickname': '默认智能助手',
  'i18n.unified.nickname': '统一客服入口',
  'i18n.workgroup.nickname': '默认工作组',
  'i18n.workgroup.booking.nickname': 'Booking 工作组',
  'i18n.workgroup.before.nickname': '售前工作组',
  'i18n.workgroup.after.nickname': '售后工作组',
  'i18n.workgroup.ticket.nickname': '工单工作组',
};
