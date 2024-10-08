/*
 * @Author: jackning 270580156@qq.com
 * @Date: 2024-08-13 20:10:26
 * @LastEditors: jackning 270580156@qq.com
 * @LastEditTime: 2024-08-13 21:53:58
 * @Description: bytedesk.com https://github.com/Bytedesk/bytedesk
 *   Please be aware of the BSL license restrictions before installing Bytedesk IM – 
 *  selling, reselling, or hosting Bytedesk IM as a service is a breach of the terms and automatically terminates your rights under the license. 
 *  仅支持企业内部员工自用，严禁私自用于销售、二次销售或者部署SaaS方式销售 
 *  Business Source License 1.1: https://github.com/Bytedesk/bytedesk/blob/main/LICENSE 
 *  contact: 270580156@qq.com 
 *  联系：270580156@qq.com
 * Copyright (c) 2024 by bytedesk.com, All Rights Reserved. 
 */
/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 18/04/2018
 * Copyright :  S.Hamblett
 */
import 'dart:typed_data';

import 'package:typed_data/typed_data.dart' as typed;

/// Utility class to assist with the building of message topic payloads.
/// Implements the builder pattern, i.e. returns itself to allow chaining.
class PayloadBuilder {
  /// Construction
  PayloadBuilder() {
    _payload = typed.Uint8Buffer();
  }

  typed.Uint8Buffer? _payload;

  /// Payload
  typed.Uint8Buffer? get payload => _payload;

  /// Length
  int get length => _payload!.length;

  // added by jackning, 2019/12/03
  void addProtobuf(Uint8List val) {
    _payload!.addAll(val);
  }
}
