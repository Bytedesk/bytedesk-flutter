//
//  Generated code. Do not modify.
//  source: thread.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use threadDescriptor instead')
const Thread$json = {
  '1': 'Thread',
  '2': [
    {'1': 'uid', '3': 1, '4': 1, '5': 9, '10': 'uid'},
    {'1': 'topic', '3': 2, '4': 1, '5': 9, '10': 'topic'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'status', '3': 4, '4': 1, '5': 9, '10': 'status'},
    {'1': 'user', '3': 5, '4': 1, '5': 11, '6': '.User', '10': 'user'},
    {'1': 'extra', '3': 6, '4': 1, '5': 9, '10': 'extra'},
  ],
};

/// Descriptor for `Thread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadDescriptor = $convert.base64Decode(
    'CgZUaHJlYWQSEAoDdWlkGAEgASgJUgN1aWQSFAoFdG9waWMYAiABKAlSBXRvcGljEhIKBHR5cG'
    'UYAyABKAlSBHR5cGUSFgoGc3RhdHVzGAQgASgJUgZzdGF0dXMSGQoEdXNlchgFIAEoCzIFLlVz'
    'ZXJSBHVzZXISFAoFZXh0cmEYBiABKAlSBWV4dHJh');

