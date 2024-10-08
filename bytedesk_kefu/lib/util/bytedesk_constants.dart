// import 'dart:io';
// ignore_for_file: constant_identifier_names

class BytedeskConstants {
  //
  // 本地
  // static const bool isDebug = true;
  // static const bool isSecure = false;
  // static const bool isWebSocketWss = false;
  // static const String mqttHost = '127.0.0.1';
  // static const String httpBaseUrl = '$mqttHost:9003';
  // static const String stompWsUrl = 'ws://$httpBaseUrl/stomp';

  // 线上
  static const bool isDebug = false;
  static const bool isSecure = true;
  static const bool isWebSocketWss = true;
  static const String mqttHost = 'api.weiyuai.cn';
  static const String httpBaseUrl = mqttHost;
  static const String stompWsUrl = 'wss://$httpBaseUrl/stomp';

  //
  static const String webSocketWssUrl = 'wss://$mqttHost/websocket';
  static const int mqttPort = 9883;
  //
  static const String HTTP_CLIENT = 'uniapp';
  static const String PLATFORM = "weiyuai";
  static const String LOCALE = "locale";
  static const String VISITOR_UID = "visitor_uid";
  static const String VISITOR_NICKNAME = "visitor_nickname";
  static const String VISITOR_AVATAR = "visitor_avatar";
  static const String VISITOR_ORGUID = "visitor_orguid";
  static const String VISITOR_DEVICEUID = "visitor_deviceuid";
  static const String I18N_PREFIX = "i18n.";
// 登录超时
  static const String EVENT_BUS_LOGIN_TIMEOUT = "EVENT_BUS_LOGIN_TIMEOUT";
// 用户名或密码错误
  static const String EVENT_BUS_LOGIN_ERROR_400 = "EVENT_BUS_LOGIN_ERROR_400";
// 服务器错误500
  static const String EVENT_BUS_SERVER_ERROR_500 = "EVENT_BUS_SERVER_ERROR_500";
// token失效
  static const String EVENT_BUS_TOKEN_INVALID = "EVENT_BUS_TOKEN_INVALID";
  static const String EVENT_BUS_SWITCH_THEME = "EVENT_BUS_SWITCH_THEME";
//
  static const String EVENT_BUS_MESSAGE_TYPE_STATUS =
      "EVENT_BUS_MESSAGE_TYPE_STATUS";
  static const String EVENT_BUS_MESSAGE_TYPE_TYPING =
      "EVENT_BUS_MESSAGE_TYPE_TYPING";
  static const String EVENT_BUS_MESSAGE_TYPE_PROCESSING =
      "EVENT_BUS_MESSAGE_TYPE_PROCESSING";
  static const String EVENT_BUS_MESSAGE_TYPE_STREAM =
      "EVENT_BUS_MESSAGE_TYPE_STREAM";
  static const String EVENT_BUS_MESSAGE_TYPE_PREVIEW =
      "EVENT_BUS_MESSAGE_TYPE_PREVIEW";
  static const String EVENT_BUS_MESSAGE_TYPE_CONTENT =
      "EVENT_BUS_MESSAGE_TYPE_CONTENT";
//
  static const String THEME_MODE_TYPE = "THEME_MODE_TYPE";
  static const String THEME_MODE_TYPE_LIGHT = "light";
  static const String THEME_MODE_TYPE_DARK = "dark";
  static const String THEME_MODE_TYPE_SYSTEM = "system";
//
  static const String THEME_NAME_TYPE = "THEME_NAME_TYPE";
  static const String THEME_NAME_TYPE_DARK = "dark";
  static const String THEME_NAME_TYPE_LIGHT = "light";
//
  static const String PLAY_AUDIO = "PLAY_AUDIO";
//
  static const String CONFIG_ENABLED = "CONFIG_ENABLED";
  static const String CONFIG_API_HOST = "CONFIG_API_HOST";
  static const String CONFIG_HTML_HTML = "CONFIG_HTML_HOST";
//
  static const String USER_TYPE_AGENT = "AGENT";
  static const String USER_TYPE_SYSTEM = "SYSTEM";
  static const String USER_TYPE_VISITOR = "VISITOR";
  static const String USER_TYPE_ROBOT = "ROBOT";
  static const String USER_TYPE_MEMBER = "MEMBER";
  static const String USER_TYPE_ASSISTANT = "ASSISTANT";
  static const String USER_TYPE_CHANNEL = "CHANNEL";
  static const String USER_TYPE_LOCAL = "LOCAL";
  static const String USER_TYPE_USER = "USER";
//
// 会话类型 = 工作组会话、访客跟客服一对一、同事一对一、群组会话
  static const String THREAD_TYPE_AGENT = "AGENT";
  static const String THREAD_TYPE_WORKGROUP = "WORKGROUP";
  static const String THREAD_TYPE_KB = "KB";
  static const String THREAD_TYPE_LLM = "LLM";
  static const String THREAD_TYPE_MEMBER = "MEMBER";
  static const String THREAD_TYPE_GROUP = "GROUP";
  static const String THREAD_TYPE_LEAVEMSG = "LEAVEMSG";
  static const String THREAD_TYPE_FEEDBACK = "FEEDBACK";
  static const String THREAD_TYPE_ASISTANT = "ASISTANT";
  static const String THREAD_TYPE_CHANNEL = "CHANNEL";
  static const String THREAD_TYPE_LOCAL = "LOCAL";
//
  static const String THREAD_STATUS_QUEUING = "QUEUING"; // 排队中
  static const String THREAD_STATUS_NORMAL = "NORMAL"; // 正常
  static const String THREAD_STATUS_REENTER =
      "REENTER"; // 会话进行中，访客关闭会话页面之后，重新进入
  static const String THREAD_STATUS_REOPEN = "REOPEN"; // 会话关闭之后，重新进入
  static const String THREAD_STATUS_OFFLINE = "OFFLINE"; // 客服不在线
  static const String THREAD_STATUS_RATED =
      "RATED"; // rated, prevent repeated rate
  static const String THREAD_STATUS_AUTO_CLOSED = "AUTO_CLOSED";
  static const String THREAD_STATUS_AGENT_CLOSED = "AGENT_CLOSED";
  static const String THREAD_STATUS_DISMISSED = "DISMISSED"; // 会话解散
  static const String THREAD_STATUS_MUTED = "MUTED"; // 会话静音
  static const String THREAD_STATUS_FORBIDDEN = "FORBIDDEN"; // 会话禁言
  static const String THREAD_STATUS_MONITORED = "MONITORED"; // 会话监控
// 消息发送状态
// 发送中
  static const String MESSAGE_STATUS_SENDING = "SENDING"; // sending
  static const String MESSAGE_STATUS_TIMEOUT = "TIMEOUT"; // network send failed
  static const String MESSAGE_STATUS_BLOCKED = "BLOCKED"; // in black list
  static const String MESSAGE_STATUS_NOTFRIEND = "NOTFRIEND"; // not friend
  static const String MESSAGE_STATUS_ERROR = "ERROR"; // other send error
  static const String MESSAGE_STATUS_SUCCESS = "SUCCESS"; // send success
  static const String MESSAGE_STATUS_RECALL = "RECALL"; // recall back
  static const String MESSAGE_STATUS_DELIVERED =
      "DELIVERED"; // send to the other client
  static const String MESSAGE_STATUS_READ = "READ"; // read by the other client
  static const String MESSAGE_STATUS_DESTROYED =
      "DESTROYED"; // destroyed after read
  static const String MESSAGE_STATUS_UNPRECESSED =
      "UNPRECESSED"; // not processed
  static const String MESSAGE_STATUS_PROCESSED =
      "PROCESSED"; // leave message processed
  static const String MESSAGE_STATUS_LEAVE_MSG_SUBMIT =
      "LEAVE_MSG_SUBMIT"; // 提交留言
  static const String MESSAGE_STATUS_RATE_SUBMIT = "RATE_SUBMIT"; // 提交会话评价
  static const String MESSAGE_STATUS_RATE_CANCEL = "RATE_CANCEL"; // 取消评价会话
  static const String MESSAGE_STATUS_RATE_UP = "RATE_UP"; // 评价消息up
  static const String MESSAGE_STATUS_RATE_DOWN = "RATE_DOWN"; // 评价消息down
//
// 消息类型
  static const String MESSAGE_TYPE_WELCOME = "WELCOME";
  static const String MESSAGE_TYPE_CONTINUE = "CONTINUE";
  static const String MESSAGE_TYPE_SYSTEM = "SYSTEM";
  static const String MESSAGE_TYPE_TEXT = "TEXT"; // 文本消息类型
  static const String MESSAGE_TYPE_IMAGE = "IMAGE"; // 图片消息类型
  static const String MESSAGE_TYPE_FILE = "FILE"; // 文件消息类型
  static const String MESSAGE_TYPE_AUDIO = "AUDIO"; // 语音消息类型
  static const String MESSAGE_TYPE_VIDEO = "VIDEO"; // 视频消息类型
  static const String MESSAGE_TYPE_MUSIC = "MUSIC";
  static const String MESSAGE_TYPE_LOCATION = "LOCATION";
  static const String MESSAGE_TYPE_GOODS = "GOODS";
  static const String MESSAGE_TYPE_CARD = "CARD";
  static const String MESSAGE_TYPE_EVENT = "EVENT";
//
  static const String MESSAGE_TYPE_GUESS = "GUESS"; // 猜你想问
  static const String MESSAGE_TYPE_HOT = "HOT"; // 热门问题
  static const String MESSAGE_TYPE_SHORTCUT = "SHORTCUT"; // 快捷路径
  static const String MESSAGE_TYPE_ORDER = "ORDER"; // 订单
  static const String MESSAGE_TYPE_POLL = "POLL"; // 投票
  static const String MESSAGE_TYPE_FORM = "FORM"; // 表单：询前表单
  static const String MESSAGE_TYPE_LEAVE_MSG = "LEAVE_MSG"; // 留言
  static const String MESSAGE_TYPE_LEAVE_MSG_SUBMIT =
      "LEAVE_MSG_SUBMIT"; // 留言提交
  static const String MESSAGE_TYPE_TICKET = "TICKET"; // 客服工单
  static const String MESSAGE_TYPE_TYPING = "TYPING"; // 正在输入
  static const String MESSAGE_TYPE_PROCESSING = "PROCESSING"; // 正在处理，等待大模型回复中
  static const String MESSAGE_TYPE_STREAM = "STREAM"; // 流式消息TEXT，大模型回复
  static const String MESSAGE_TYPE_PREVIEW = "PREVIEW"; // 消息预知
  static const String MESSAGE_TYPE_RECALL = "RECALL"; // 撤回
  static const String MESSAGE_TYPE_DELIVERED = "DELIVERED"; // 回执: 已送达
  static const String MESSAGE_TYPE_READ = "READ"; // 回执: 已读
  static const String MESSAGE_TYPE_QUOTATION = "QUOTATION"; // qoute message
  static const String MESSAGE_TYPE_KICKOFF = "KICKOFF"; // kickoff other clients
  static const String MESSAGE_TYPE_SHAKE = "SHAKE"; // shake window
//
  static const String MESSAGE_TYPE_FAQ = "FAQ"; // 常见问题FAQ
  static const String MESSAGE_TYPE_FAQ_Q = "FAQ_Q"; // 常见问题FAQ-问题
  static const String MESSAGE_TYPE_FAQ_A = "FAQ_A"; // 常见问题FAQ-答案
  static const String MESSAGE_TYPE_FAQ_UP = "FAQ_UP"; // 常见问题答案评价:UP
  static const String MESSAGE_TYPE_FAQ_DOWN = "FAQ_DOWN"; // 常见问题答案评价:DOWN
  static const String MESSAGE_TYPE_ROBOT = "ROBOT"; // 机器人
  static const String MESSAGE_TYPE_ROBOT_UP = "ROBOT_UP"; // 机器人答案评价:UP
  static const String MESSAGE_TYPE_ROBOT_DOWN = "ROBOT_DOWN"; // 机器人答案评价:DOWN
//
  static const String MESSAGE_TYPE_RATE = "RATE"; // 访客主动评价
  static const String MESSAGE_TYPE_RATE_INVITE = "RATE_INVITE"; // 客服邀请评价
  static const String MESSAGE_TYPE_RATE_SUBMIT = "RATE_SUBMIT"; // 访客提交评价
  static const String MESSAGE_TYPE_RATE_CANCEL = "RATE_CANCEL"; // 访客取消评价
//
  static const String MESSAGE_TYPE_AUTO_CLOSED = "AUTO_CLOSED"; // 自动关闭
  static const String MESSAGE_TYPE_AGENT_CLOSED = "AGENT_CLOSED"; // 客服关闭
//
  static const String MESSAGE_TYPE_TRANSFER = "TRANSFER"; // 转接
  static const String MESSAGE_TYPE_TRANSFER_ACCEPT = "TRANSFER_ACCEPT"; // 转接-接受
  static const String MESSAGE_TYPE_TRANSFER_REJECT = "TRANSFER_REJECT"; // 转接-拒绝
//
  static const String MESSAGE_TYPE_INVITE = "INVITE"; // 邀请
  static const String MESSAGE_TYPE_INVITE_ACCEPT = "INVITE_ACCEPT"; // 邀请-接受
  static const String MESSAGE_TYPE_INVITE_REJECT = "INVITE_REJECT"; // 邀请-拒绝
//
  static const String TOPIC_FILE_ASISTANT = "file";
  static const String TOPIC_SYSTEM_NOTIFICATION = "system";
// 注意：没有 '/' 开头，防止stomp主题中奖 '/' 替换为 '.'之后，在最前面多余一个 '.'
  static const String TOPIC_USER_PREFIX = "user/";
// static const String TOPIC_PRIVATE_PREFIX = "private/";
// static const String TOPIC_GROUP_PREFIX = "group/";
  static const String TOPIC_FILE_PREFIX = "file/";
  static const String TOPIC_SYSTEM_PREFIX = "system/";
// static const String TOPIC_ROBOT_PREFIX = "robot/";
//
  static const String TOPIC_ORGNIZATION_PREFIX = "org/";
  static const String TOPIC_ORG_MEMBER_PREFIX = "org/member/";
  static const String TOPIC_ORG_DEPARTMENT_PREFIX = "org/department/";
  static const String TOPIC_ORG_GROUP_PREFIX = "org/group/";
  static const String TOPIC_ORG_PRIVATE_PREFIX = "org/private/";
  static const String TOPIC_ORG_ROBOT_PREFIX = "org/robot/";
  static const String TOPIC_ORG_AGENT_PREFIX = "org/agent/";
  static const String TOPIC_ORG_WORKGROUP_PREFIX = "org/workgroup/";
  static const String TOPIC_ORG_KB_PREFIX = "org/kb/";
  static const String TOPIC_ORG_KBDOC_PREFIX = "org/kbdoc/";
//
  static const String KB_TYPE_ASISTANT = "ASISTANT";
  static const String KB_TYPE_HELPDOC = "HELPDOC";
  static const String KB_TYPE_LLM = "LLM";
  static const String KB_TYPE_KEYWORD = "KEYWORD";
  static const String KB_TYPE_FAQ = "FAQ";
  static const String KB_TYPE_QUICKREPLY = "QUICKREPLY";
  static const String KB_TYPE_AUTOREPLY = "AUTOREPLY";
  static const String KB_TYPE_BLOG = "BLOG";
  static const String KB_TYPE_EMAIL = "EMAIL";
  static const String KB_TYPE_TABOO = "TABOO";
//
  static const String UPLOAD_TYPE_CHAT = "CHAT";
//
  static const String AUTO_REPLY_TYPE_FIXED = "FIXED";
  static const String AUTO_REPLY_TYPE_KEYWORD = "KEYWORD";
  static const String AUTO_REPLY_TYPE_LLM = "LLM";
//
  static const String EVENT_BUS_MESSAGE = 'BYTEDESK_EVENT_BUS_MESSAGE';
// stomp连接中
  static const String CONNECTION_STATUS_CONNECTING = 'connecting';
// stomp连接成功
  static const String CONNECTION_STATUS_CONNECTED = 'connected';
// stomp连接断开
  static const String CONNECTION_STATUS_DISCONNECTED = 'disconnncted';
// 长连接状态
  static const String EVENT_BUS_CONNECTION_STATUS =
      'EVENT_BUS_CONNECTION_STATUS';

// 微语
  static const String PLATFORM_BYTEDESK = "bytedesk";
  // 良师宝
  static const String PLATFORM_LIANGSHIBAO = "liangshibao";
  // 招投标
  static const String PLATFORM_ZHAOBIAO = "zhaobiao";
  // 今日美语
  static const String PLATFORM_MEIYU = "meiyu";
  // 微语题库
  static const String PLATFORM_TIKU = "tiku";

  //
  static const String SEND_MOBILE_CODE_TYPE_LOGIN = "login";
  static const String SEND_MOBILE_CODE_TYPE_REGISTER = "register";
  static const String SEND_MOBILE_CODE_TYPE_FORGET = "forget";
  static const String SEND_MOBILE_CODE_TYPE_VERIFY = "verify";

  // //
  // static const String WORKGROUP_WID_LIANGSHIBAO = '201808101819291';
  // static const String CHAT_TYPE_WORKGROUP = 'workGroup';
  // static const String CHAT_TYPE_APPOINTED = 'appointed';

  // static const String exist = 'bytedesk_exist';
  // static const String code = 'bytedesk_code';

  // // 含是否匿名登录
  // static const String isLogin = 'bytedesk_isLogin';
  // // 此用户是否绑定手机号
  // static const String isAuthenticated = 'bytedesk_isAuthenticated';
  // static const String isCurrentChatKfPage = 'bytedesk_isCurrentChatKfPage';
  // static const String isExitLogin = 'bytedesk_isExitLogin';
  // //
  // static const String accessToken = 'bytedesk_accessToken';
  // static const String refreshToken = 'bytedesk_refreshToken';
  // //
  // static const String appkey = 'bytedesk_appkey';
  // static const String subdomain = 'bytedesk_subdomain';
  // //
  // static const String user = 'bytedesk_user';
  // static const String uid = 'bytedesk_uid';
  // static const String username = 'bytedesk_username';
  // static const String password = 'bytedesk_password';
  // static const String nickname = 'bytedesk_nickname';
  // static const String avatar = 'bytedesk_avatar';
  // static const String description = 'bytedesk_description';
  // static const String sex = 'bytedesk_sex';
  // static const String location = 'bytedesk_location';
  // static const String birthday = 'bytedesk_birthday';
  // static const String subDomain = 'bytedesk_subDomain';
  // static const String role = 'bytedesk_role';
  // static const String mobile = 'bytedesk_mobile';
  // static const String unionid = 'bytedesk_unionid';
  // static const String openid = 'bytedesk_openid';
  // // rest client
  // // static const String client = 'flutter';
  // // static const String clientSchool = 'flutter_school';
  // //
  // static const String latitude = 'latitude';
  // static const String longtitude = 'longtitude';
  // //
  // static const String build = 'release';
  // //
  // static const String PLAY_AUDIO_ON_SEND_MESSAGE = 'playAudioOnSendMessage';
  // static const String PLAY_AUDIO_ON_RECEIVE_MESSAGE =
  //     'playAudioOnReceiveMessage';
  // static const String VIBRATE_ON_RECEIVE_MESSAGE = 'vibrateOnReceiveMessage';
  //
  static const String DEFAULT_AVATA =
      "https://chainsnow.oss-cn-shenzhen.aliyuncs.com/avatars/admin_default_avatar.png";
  static const String VIDEO_PLAY =
      "https://bytedesk.oss-cn-shenzhen.aliyuncs.com/images/video_play.png";
  // // 连接中
  // static const String USER_STATUS_CONNECTING = "connecting";
  // // 跟服务器建立长连接
  // static const String USER_STATUS_CONNECTED = "connected";
  // // 断开长连接
  // static const String USER_STATUS_DISCONNECTED = "disconnected";
  // //
  // // 访客
  // static const String ROLE_VISITOR = "ROLE_VISITOR";
  // // 注册管理员：注册用户默认角色
  // static const String ROLE_ADMIN = "ROLE_ADMIN";
  // //
  // // 文本消息类型
  // static const String MESSAGE_TYPE_TEXT = 'text';
  // // 图片消息类型
  // static const String MESSAGE_TYPE_IMAGE = 'image';
  // // 文件消息类型
  // static const String MESSAGE_TYPE_FILE = 'file';
  // // 语音消息类型
  // static const String MESSAGE_TYPE_VOICE = 'voice';
  // // 视频消息类型
  // static const String MESSAGE_TYPE_VIDEO = 'video';
  // // 自定义消息类型
  // static const String MESSAGE_TYPE_CUSTOM = 'custom';
  // // 红包
  // static const String MESSAGE_TYPE_RED_PACKET = 'red_packet';
  // // 商品
  // static const String MESSAGE_TYPE_COMMODITY = 'commodity';
  // // 短视频消息类型
  // static const String MESSAGE_TYPE_SHORT_VIDEO = 'shortvideo';
  // // 位置消息类型
  // static const String MESSAGE_TYPE_LOCATION = 'location';
  // // 链接消息类型
  // static const String MESSAGE_TYPE_LINK = 'link';
  // // 事件消息类型
  // static const String MESSAGE_TYPE_EVENT = 'event';
  // // 机器人 自动回复
  // static const String MESSAGE_TYPE_ROBOT = 'robot';
  // //
  // static const String MESSAGE_TYPE_ROBOT_V2 = 'robotv2';
  // // 机器人欢迎语
  // static const String MESSAGE_TYPE_ROBOT_WELCOME = 'robot_welcome';
  // // 提示语 promot list
  // static const String MESSAGE_TYPE_ROBOT_PROMOT = 'robot_promot';
  // //
  // static const String MESSAGE_TYPE_ROBOT_RESULT = 'robot_result';
  // // 问卷
  // static const String MESSAGE_TYPE_QUESTIONNAIRE = 'questionnaire';
  // // 分公司，方便提取分公司所包含的国家，金吉列大学长
  // static const String MESSAGE_TYPE_COMPANY = 'company';
  // // 选择工作组
  // static const String MESSAGE_TYPE_WORK_GROUP = 'workGroup';
  // // 通知消息类型
  // static const String MESSAGE_TYPE_NOTIFICATION = 'notification';
  // // 非工作时间
  // static const String MESSAGE_TYPE_NOTIFICATION_NON_WORKING_TIME =
  //     'notification_non_working_time';
  // // 客服离线，当前无客服在线
  // static const String MESSAGE_TYPE_NOTIFICATION_OFFLINE =
  //     'notification_offline';
  // // 访客开始网页浏览
  // static const String MESSAGE_TYPE_NOTIFICATION_BROWSE_START =
  //     'notification_browse_start';
  // // 访客关闭网页
  // static const String MESSAGE_TYPE_NOTIFICATION_BROWSE_END =
  //     'notification_browse_end';
  // // 邀请访客
  // static const String MESSAGE_TYPE_NOTIFICATION_BROWSE_INVITE =
  //     'notification_browse_invite';
  // // 访客接受邀请
  // static const String MESSAGE_TYPE_NOTIFICATION_BROWSE_INVITE_ACCEPT =
  //     'notification_browse_invite_accept';
  // // 访客拒绝邀请
  // static const String MESSAGE_TYPE_NOTIFICATION_BROWSE_INVITE_REJECT =
  //     'notification_browse_invite_reject';
  // // 新会话thread
  // static const String MESSAGE_TYPE_NOTIFICATION_THREAD = 'notification_thread';
  // // 重新进入会话
  // static const String MESSAGE_TYPE_NOTIFICATION_THREAD_REENTRY =
  //     'notification_thread_reentry';
  // // 新建工单
  // static const String MESSAGE_TYPE_NOTIFICATION_TICKET = 'notification_ticket';
  // // 意见反馈
  // static const String MESSAGE_TYPE_NOTIFICATION_FEEDBACK =
  //     'notification_feedback';
  // // 排队通知类型
  // static const String MESSAGE_TYPE_NOTIFICATION_QUEUE = 'notification_queue';
  // // 排队中离开
  // static const String MESSAGE_TYPE_NOTIFICATION_QUEUE_LEAVE =
  //     'notification_queue_leave';
  // // 接入队列访客
  // static const String MESSAGE_TYPE_NOTIFICATION_QUEUE_ACCEPT =
  //     'notification_queue_accept';
  // // 忽略队列访客
  // static const String MESSAGE_TYPE_NOTIFICATION_QUEUE_IGNORE =
  //     "notification_queue_ignore";
  // // 超时队列访客
  // static const String MESSAGE_TYPE_NOTIFICATION_QUEUE_TIMEOUT =
  //     "notification_queue_timeout";
  // // 自动接入会话
  // static const String MESSAGE_TYPE_NOTIFICATION_ACCEPT_AUTO =
  //     'notification_accept_auto';
  // // 手动接入
  // static const String MESSAGE_TYPE_NOTIFICATION_ACCEPT_MANUAL =
  //     'notification_accept_manual';
  // // 上线
  // static const String MESSAGE_TYPE_NOTIFICATION_CONNECT =
  //     'notification_connect';
  // // 离线
  // static const String MESSAGE_TYPE_NOTIFICATION_DISCONNECT =
  //     'notification_disconnect';
  // // 离开会话页面
  // static const String MESSAGE_TYPE_NOTIFICATION_LEAVE = 'notification_leave';
  // // 客服关闭会话
  // static const String MESSAGE_TYPE_NOTIFICATION_AGENT_CLOSE =
  //     'notification_agent_close';
  // // 访客关闭会话
  // static const String MESSAGE_TYPE_NOTIFICATION_VISITOR_CLOSE =
  //     'notification_visitor_close';
  // // 自动关闭会话
  // static const String MESSAGE_TYPE_NOTIFICATION_AUTO_CLOSE =
  //     'notification_auto_close';
  // // 邀请评价
  // static const String MESSAGE_TYPE_NOTIFICATION_INVITE_RATE =
  //     'notification_invite_rate';
  // // 评价结果
  // static const String MESSAGE_TYPE_NOTIFICATION_RATE_RESULT =
  //     'notification_rate_result';
  // // 邀请会话
  // static const String MESSAGE_TYPE_NOTIFICATION_INVITE = 'notification_invite';
  // // 接受邀请
  // static const String MESSAGE_TYPE_NOTIFICATION_INVITE_ACCEPT =
  //     'notification_invite_accept';
  // // 拒绝邀请
  // static const String MESSAGE_TYPE_NOTIFICATION_INVITE_REJECT =
  //     'notification_invite_reject';
  // // 转接会话
  // static const String MESSAGE_TYPE_NOTIFICATION_TRANSFER =
  //     'notification_transfer';
  // // 接受转接
  // static const String MESSAGE_TYPE_NOTIFICATION_TRANSFER_ACCEPT =
  //     'notification_transfer_accept';
  // // 拒绝转接
  // static const String MESSAGE_TYPE_NOTIFICATION_TRANSFER_REJECT =
  //     'notification_transfer_reject';
  // // 满意度请求
  // static const String MESSAGE_TYPE_NOTIFICATION_RATE_REQUEST =
  //     'notification_rate_request';
  // // 评价
  // static const String MESSAGE_TYPE_NOTIFICATION_RATE = 'notification_rate';
  // // 连接状态
  // static const String MESSAGE_TYPE_NOTIFICATION_CONNECTION_STATUS =
  //     'notification_connection_status';
  // // 接待状态
  // static const String MESSAGE_TYPE_NOTIFICATION_ACCEPT_STATUS =
  //     'notification_accept_status';
  // // 消息预知
  // static const String MESSAGE_TYPE_NOTIFICATION_PREVIEW =
  //     'notification_preview';
  // // 消息撤回
  // static const String MESSAGE_TYPE_NOTIFICATION_RECALL = 'notification_recall';
  // // 浏览
  // static const String MESSAGE_TYPE_NOTIFICATION_BROWSE = 'notification_browse';
  // // 非会话类消息通知
  // static const String MESSAGE_TYPE_NOTIFICATION_NOTICE = 'notification_notice';
  // // 频道通知
  // static const String MESSAGE_TYPE_NOTIFICATION_CHANNEL =
  //     'notification_channel';
  // // 消息回执
  // static const String MESSAGE_TYPE_NOTIFICATION_RECEIPT =
  //     'notification_receipt';
  // // 踢掉其他客户端
  // static const String MESSAGE_TYPE_NOTIFICATION_KICKOFF =
  //     'notification_kickoff';
  // // 发送表单请求
  // static const String MESSAGE_TYPE_NOTIFICATION_FORM = 'notification_form';
  // // 表单内嵌类型
  // static const String MESSAGE_TYPE_NOTIFICATION_FORM_REQUEST =
  //     "notification_form_request";
  // static const String MESSAGE_TYPE_NOTIFICATION_FORM_RESULT =
  //     "notification_form_result";
  // // 通知初始化localStream
  // // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_INVITE = 'notification_webrtc_invite'
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_INVITE_VIDEO =
  //     'notification_webrtc_invite_video';
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_INVITE_AUDIO =
  //     'notification_webrtc_invite_audio';
  // // webrtc取消邀请
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_CANCEL =
  //     'notification_webrtc_cancel';
  // // webrtc邀请视频会话
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_OFFER_VIDEO =
  //     'notification_webrtc_offer_video';
  // // webrtc邀请音频会话
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_OFFER_AUDIO =
  //     'notification_webrtc_offer_audio';
  // // 接受webrtc邀请
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_ANSWER =
  //     'notification_webrtc_answer';
  // // webrtccandidate信息
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_CANDIDATE =
  //     'notification_webrtc_candidate';
  // // 接受webrtc邀请
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_ACCEPT =
  //     'notification_webrtc_accept';
  // // 拒绝webrtc邀请
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_REJECT =
  //     'notification_webrtc_reject';
  // // 被邀请方视频设备 + peeConnection已经就绪
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_READY =
  //     'notification_webrtc_ready';
  // // webrtc忙线
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_BUSY =
  //     'notification_webrtc_busy';
  // // 结束webrtc会话
  // static const String MESSAGE_TYPE_NOTIFICATION_WEBRTC_CLOSE =
  //     'notification_webrtc_close';
  // // 创建群组
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_CREATE =
  //     'notification_group_create';
  // // 更新群名称、简介等
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_UPDATE =
  //     'notification_group_update';
  // // 群公告
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_ANNOUNCEMENT =
  //     'notification_group_announcement';
  // // 邀请多人加入群
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_INVITE =
  //     'notification_group_invite';
  // // 受邀请：同意
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_INVITE_ACCEPT =
  //     'notification_group_invite_accept';
  // // 受邀请：拒绝
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_INVITE_REJECT =
  //     'notification_group_invite_reject';
  // // 不需要审核加入群组
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_JOIN =
  //     'notification_group_join';
  // // 主动申请加入群组
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_APPLY =
  //     'notification_group_apply';
  // // 同意：主动申请加群
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_APPLY_APPROVE =
  //     'notification_group_apply_approve';
  // // 拒绝：主动申请加群
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_APPLY_DENY =
  //     'notification_group_apply_deny';
  // // 踢人
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_KICK =
  //     'notification_group_kick';
  // // 禁言
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_MUTE =
  //     'notification_group_mute';
  // // 移交群组
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_TRANSFER =
  //     'notification_group_transfer';
  // // 移交群组：同意、接受
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_TRANSFER_ACCEPT =
  //     'notification_group_transfer_accept';
  // // 移交群组：拒绝
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_TRANSFER_REJECT =
  //     'notification_group_transfer_reject';
  // // 退出群组
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_WITHDRAW =
  //     'notification_group_withdraw';
  // // 解散群组
  // static const String MESSAGE_TYPE_NOTIFICATION_GROUP_DISMISS =
  //     'notification_group_dismiss';

  // // 消息发送状态:
  // // 1. 发送中
  // static const String MESSAGE_STATUS_SENDING = "sending";
  // // 2. 已经存储到服务器
  // static const String MESSAGE_STATUS_STORED = "stored";
  // // 3. 对方已收到
  // static const String MESSAGE_STATUS_RECEIVED = "received";
  // // 4. 对方已读
  // static const String MESSAGE_STATUS_READ = "read";
  // // 5. 发送错误
  // static const String MESSAGE_STATUS_ERROR = "error";
  // // 6. 阅后即焚已销毁
  // static const String MESSAGE_STATUS_DESTROYED = "destroyed";
  // // 7. 消息撤回
  // static const String MESSAGE_STATUS_RECALL = "recall";

  // // 工作组请求会话
  // static const String THREAD_REQUEST_TYPE_WORK_GROUP = "workGroup";
  // // 指定客服会话
  // static const String THREAD_REQUEST_TYPE_APPOINTED = "appointed";

  // // 会话类型: 工作组会话、访客跟客服一对一
  // // THREAD_TYPE_THREAD 修改为 workGroup，并同步修改 安卓+iOS+web
  // static const String THREAD_TYPE_WORKGROUP = "workgroup";
  // static const String THREAD_TYPE_APPOINTED = "appointed";
  // static const String THREAD_TYPE_CONTACT = "contact";
  // static const String THREAD_TYPE_GROUP = "group";
  // static const String THREAD_TYPE_ROBOT = "robot";
  // static const String THREAD_TYPE_LEAVEMSG = "leavemsg";
  // static const String THREAD_TYPE_FEEDBACK = "feedback";
  // // 渠道会话
  // static const String THREAD_TYPE_CHANNEL = "channel";
  // // 机器人转人工
  // static const String THREAD_TYPE_ROBOT_TO_AGENT = "robot_to_agent";
  // // 工单
  // static const String THREAD_TYPE_TICKET_WORKGROUP = "ticket_workgroup";
  // static const String THREAD_TYPE_TICKET_APPOINTED = "ticket_appointed";
  // // 文件助手
  // static const String THREAD_TYPE_FILEHELPER = "filehelper";
  // // 智谱AI
  // static const String THREAD_TYPE_ZHIPUAI = "zhipuai";

  // // 访客会话、同事一对一、群组会话
  // static const String MESSAGE_SESSION_TYPE_WORKGROUP = THREAD_TYPE_WORKGROUP;
  // static const String MESSAGE_SESSION_TYPE_APPOINTED = THREAD_TYPE_APPOINTED;
  // static const String MESSAGE_SESSION_TYPE_CONTACT = THREAD_TYPE_CONTACT;
  // static const String MESSAGE_SESSION_TYPE_GROUP = THREAD_TYPE_GROUP;
  // static const String MESSAGE_SESSION_TYPE_ROBOT = THREAD_TYPE_ROBOT;
  // static const String MESSAGE_SESSION_TYPE_LEAVEMSG = THREAD_TYPE_LEAVEMSG;
  // static const String MESSAGE_SESSION_TYPE_FEEDBACK = THREAD_TYPE_FEEDBACK;
  // static const String MESSAGE_SESSION_TYPE_ROBOT_TO_AGENT =
  //     THREAD_TYPE_ROBOT_TO_AGENT;
  // //
  // static const String MESSAGE_SESSION_TYPE_TICKET_WORKGROUP =
  //     THREAD_TYPE_TICKET_WORKGROUP;
  // static const String MESSAGE_SESSION_TYPE_TICKET_APPOINTED =
  //     THREAD_TYPE_TICKET_APPOINTED;

  // // 会话关闭类型：客服关闭、访客关闭、超时自动关闭、非工作时间关闭、客服离线无效会话关闭
  // static const String THREAD_CLOSE_TYPE_AGENT = "agent";
  // static const String THREAD_CLOSE_TYPE_VISITOR = "visitor";
  // static const String THREAD_CLOSE_TYPE_TIMEOUT = "timeout";
  // static const String THREAD_CLOSE_TYPE_NON_WORKING_TIME = "non_working_time";
  // static const String THREAD_CLOSE_TYPE_OFFLINE = "offline";
  // static const String THREAD_CLOSE_TYPE_ROBOT_TO_AGENT = "robot_to_agent";
  // static const String THREAD_CLOSE_TYPE_TICKET_IGNORE = "ticket_ignore";
  // static const String THREAD_CLOSE_TYPE_TICKET_DONE = "ticket_done";
}
