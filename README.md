# bytedesk helpdesk system

- [萝卜丝->请切换此分支](https://gitee.com/270580156/bytedesk-flutter/tree/luobosi/)

bytedesk flutter helpdesk sdk

- [Website](https://www.kefux.com)
- [Web Demo](https://cdn.bytedesk.com/flutter/)
- [Download Gitee Demo](https://git.oschina.net/270580156/bytedesk-flutter)
- [Download Github Demo](https://github.com/Bytedesk/bytedesk-flutter)
<!-- - [Download ApkDemo](https://bytedesk.oss-cn-shenzhen.aliyuncs.com/apk/bytedesk-android-sdk-demo.apk) -->

## Features

- support andorid/ios/web
- chat with agent
- shopping chat, send commodity info
- send post script message
- check online status
- get history thread
- message voice && vibrate setting
- chat with robot
- send and play video message
- chat notification
  <!-- - support faq list -->
  <!-- - support feedback -->

## Getting Started

### Zero Step: Copy assets dir from bytedesk_demo and add to pubspec.yaml

```dart
//
bytedesk_kefu: ^1.6.0
//
assets:
    - assets/audio/
    - assets/images/chat/
    - assets/images/feedback/
```

### iOS

Add the following keys to your **Info.plist** file, located in **ios/Runner/Info.plist**:

```dart
<key>NSLocalNetworkUsageDescription</key>
<string>Looking for local tcp Bonjour service</string>
<key>NSBonjourServices</key>
<array>
  <string>mqtt.tcp</string>
</array>
```

### Android

Add the following Android permissions to the **AndroidManifest.xml** file, located in **android/app/src/main/AndroidManifest.xml**:

```dart
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### First Step: Register Account

- [Register](https://www.bytedesk.com/admin)
- [Docs](https://github.com/pengjinning/bytedesk-android)

### Second Step：Login

```dart
// 获取企业uid，登录后台->客服->渠道->flutter
// http://www.weiyuai.cn/admin/cs/channel
String orgUid = "df_org_uid";
// 第一步：初始化
BytedeskKefu.init(orgUid);
```

### Third Step：Contact

```dart
BytedeskKefu.startWorkGroupChat(context, workGroupWid, "title");
```

### Completed

|                                                image1                                                 |                                                 image2                                                  |                                                  image3                                                  |
| :---------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: |
|  <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/home.jpeg?raw=true" width="250">  |  <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/robot1.jpeg?raw=true" width="250">   |  <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/robot2.jpeg?raw=true" width="250">   |
|  <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/chat.png?raw=true" width="250">   |   <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/shop.png?raw=true" width="250">    | <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/postscript.png?raw=true" width="250"> |
| <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/status.jpeg?raw=true" width="250"> | <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/userinfo.jpeg?raw=true" width="250"> |  <img src="https://github.com/Bytedesk/bytedesk-flutter/blob/master/notice.jpeg?raw=true" width="250"> |

### Change UI

- create new folder: vendors
- [Download](https://pub.dev/packages/bytedesk_kefu/versions) latest source code, put into vendors folder
- integrate source in pubspect.yaml

```dart
bytedesk_kefu:
    path: ./vendors/bytedesk_kefu
```

## 对话SDK

<!-- - [iOS-oc](./visitor/oc)
- [iOS-swift](./visitor/swift)
- [Android](./visitor/android)
- [Flutter](./visitor/flutter)
- [React](./visitor/react)
- [React-native](./visitor/react-native)
- [UniApp](./visitor/uniapp)
- [Web](./visitor/web) -->
<!-- - [iOS-oc](https://github.com/Bytedesk/bytedesk-oc) -->
<!-- - [React-native](https://github.com/bytedesk/bytedesk-react-native) -->
<!-- - [Vue](https://github.com/bytedesk/bytedesk-vue) -->
<!-- - [Browser-Extension](https://github.com/Bytedesk/bytedesk-browser-extention) -->
<!-- - [Vscode-plugin](https://github.com/bytedesk/bytedesk-vscode-plugin) -->
- [iOS-swift](https://github.com/Bytedesk/bytedesk-swift)
- [Android](https://github.com/bytedesk/bytedesk-android)
- [Flutter](https://github.com/bytedesk/bytedesk-flutter)
- [React](https://github.com/bytedesk/bytedesk-react)
- [UniApp](https://github.com/bytedesk/bytedesk-uniapp)
- [Web](https://github.com/bytedesk/bytedesk-web)

## 客户端

- [Windows](https://www.weiyuai.cn/download.html)
- [Mac](https://www.weiyuai.cn/download.html)
- [Linux](https://www.weiyuai.cn/download.html)
- [Android](https://www.weiyuai.cn/download.html)
- [IOS](https://www.weiyuai.cn/download.html)

## 技术栈

<!-- - [sofaboot](https://github.com/sofastack/sofa-boot/blob/master/README_ZH.md) for im server 基于金融级云原生架构-->
- [springboot-3.x for 后端](https://github.com/Bytedesk/bytedesk)
- [python for ai](https://github.com/Bytedesk/bytedesk-ai)
- [react for web前端](https://github.com/Bytedesk/bytedesk-react)
- [flutter for 移动客户端(ios&android)](https://github.com/Bytedesk/bytedesk-mobile)
- [electron for 桌面客户端(windows&mac&linux)](https://github.com/Bytedesk/bytedesk-desktop)

## 联系

- [Email](mailto:270580156@qq.com)
- [微信](./images/wechat.png)
