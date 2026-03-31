// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_notification/push_notification.dart';
// import 'package:flutter_notification/flutter_notification_platform_interface.dart';
// import 'package:flutter_notification/push_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockFlutterNotificationPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterNotificationPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final FlutterNotificationPlatform initialPlatform = FlutterNotificationPlatform.instance;

//   test('$MethodChannelFlutterNotification is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterNotification>());
//   });

//   test('getPlatformVersion', () async {
//     FlutterNotification flutterNotificationPlugin = FlutterNotification();
//     MockFlutterNotificationPlatform fakePlatform = MockFlutterNotificationPlatform();
//     FlutterNotificationPlatform.instance = fakePlatform;

//     expect(await flutterNotificationPlugin.getPlatformVersion(), '42');
//   });
// }
