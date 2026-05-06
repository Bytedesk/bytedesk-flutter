# Visitor Flutter

Visitor Flutter 是 Bytedesk 访客端的 Flutter 实现，首页、消息、我的三个 tab 的交互与 Visitor UniApp 保持一致。

## 功能说明

- Flutter 三 tab 访客演示应用。
- 首页支持普通会话、商品会话、订单会话入口。
- 消息页从线上接口拉取访客历史会话。
- 我的页面支持切换预置演示用户。
- 聊天内容通过 webview_flutter 加载。

## 默认线上地址

- Chat 页面：https://cdn.weiyuai.cn
- API 地址：https://api.weiyuai.cn

## 关键文件

- lib/main.dart：tab 布局、接口加载、聊天跳转、WebView 页面
- pubspec.yaml：Flutter 依赖定义
- android/app/src/main/AndroidManifest.xml：Android 网络权限配置
- ios/Runner/Info.plist：iOS Web 访问配置

## 环境要求

- Flutter SDK 3.10.7 或更高版本
- 与 pubspec.yaml 兼容的 Dart SDK
- iOS 构建需要 Xcode，Android 构建需要 Android SDK

## 使用步骤

1. 进入 frontend/apps/visitorFlutter。
2. 安装依赖。
3. 运行到目标设备或模拟器。

```bash
cd frontend/apps/visitorFlutter
flutter pub get
flutter run
```

校验命令可使用：

```bash
cd frontend/apps/visitorFlutter
flutter analyze lib/main.dart
```

## 体验流程

1. 进入首页，点击场景卡片直接进入客服会话。
2. 进入消息页，从线上接口拉取历史会话。
3. 点击某条会话继续沟通。
4. 进入我的页切换当前演示用户。

## 说明

- 当前默认使用线上地址。
- Android 和 iOS 端嵌入 Web 内容所需权限已配置完成。
