/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2022-03-10 14:55:08
 * @LastEditors: jack ning github@bytedesk.com
 * @LastEditTime: 2024-10-13 23:41:08
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
import 'package:bytedesk_kefu/model/message.dart';
import 'package:event_bus/event_bus.dart';

EventBus bytedeskEventBus = EventBus();

class ReceiveMessageEventBus {
  Message message;
  ReceiveMessageEventBus(this.message);
}

class ReceiveMessageReceiptEventBus {
  String uid;
  String status;
  ReceiveMessageReceiptEventBus(this.uid, this.status);
}

// class ReceiveMessagePreviewEventBus {
//   String content;
//   ReceiveMessagePreviewEventBus(this.content);
// }

class ReceiveMessagePreviewEventBus {
  Message message;
  ReceiveMessagePreviewEventBus(this.message);
}

class ReceiveMessageRecallEventBus {
  String uid;
  ReceiveMessageRecallEventBus(this.uid);
}

class ConnectionEventBus {
  String content;
  ConnectionEventBus(this.content);
}

class DeleteMessageEventBus {
  String uid;
  DeleteMessageEventBus(this.uid);
}

// token过期
class InvalidTokenEventBus {
  InvalidTokenEventBus();
}

// class QueryAnswerEventBus {
//   String aid;
//   String question;
//   String answer;
//   QueryAnswerEventBus(this.aid, this.question, this.answer);
// }

// class QueryCategoryEventBus {
//   String cid;
//   String name;
//   QueryCategoryEventBus(this.cid, this.name);
// }

// class QueryRobotEventBus {
//   String cid;
//   String name;
//   QueryRobotEventBus(this.cid, this.name);
// }

class RequestAgentThreadEventBus {
  RequestAgentThreadEventBus();
}

// class ChooseRobotEventBus {
//   Robot robot;
//   ChooseRobotEventBus(this.robot);
// }

// class SmsLoginSuccessEventBus {
//   String mobile;
//   SmsLoginSuccessEventBus(this.mobile);
// }
