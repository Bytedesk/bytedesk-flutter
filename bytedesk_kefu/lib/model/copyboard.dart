// import 'package:bytedesk_kefu/model/user.dart';
// // import 'package:equatable/equatable.dart';

// class CopyBoard {
//   //
//   String? cid;
//   String? content;
//   String? nickname;
//   String? avatar;
//   String? type;
//   String? timestamp;
//   String? status;
//   int? isSend;
//   String? client;
//   //
//   User? user;

//   CopyBoard(
//       {this.cid,
//       this.content,
//       this.nickname,
//       this.avatar,
//       this.type,
//       this.timestamp,
//       this.isSend,
//       this.user,
//       this.status,
//       this.client,})
//       : super();

//   //
//   static CopyBoard fromJson(dynamic json) {
//     //
//     return CopyBoard(
//         cid: json['cid'],
//         content: json['content'],
//         nickname: json['user']['nickname'],
//         avatar: json['user']['avatar'],
//         type: json['type'],
//         timestamp: json['createdAt'],
//         status: 'stored',
//         isSend: 0,
//         client: json['client'],
//         user: User.fromJson(json['user']),);
//   }

//   // @override
//   // List<Object> get props => [mid];

//   //
//   Map<String, dynamic> toMap() {
//     return {
//       'cid': cid,
//       'content': content,
//       'nickname': nickname,
//       'avatar': avatar,
//       'type': type,
//       'status': status,
//       'timestamp': timestamp,
//       'isSend': isSend,
//       'client': client,
//     };
//   }

// }
