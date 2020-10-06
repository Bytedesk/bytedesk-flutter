# 萝卜丝客服SDK

萝卜丝(bytedesk) flutter 客服SDK

## Getting Started

### 第一步

- [注册账号](https://www.bytedesk.com/antv/user/login)
- 获取appkey，登录后台->客服管理->渠道管理->添加应用->appkey
- 获取subDomain，也即企业号：登录后台->客服管理->客服账号->企业号
- 获取技能组workGroupWid

### 第二步：匿名登录

- BytedeskKefu.anonymousLogin(_androidKey, _iOSKey, _subDomain);

### 第三步：联系客服

- BytedeskKefu.startWorkGroupChat(context, workGroupWid, "技能组客服");

### 集成完毕

<img src="./home.jpeg" width="25%" height="25%"/>
<img src="./chat.jpeg" width="25%" height="25%"/>