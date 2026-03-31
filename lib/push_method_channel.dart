import 'dart:async';
import 'package:flutter/services.dart';
import 'push_platform_interface.dart';
import 'push_model.dart';

class MethodChannelPush extends PushPlatform {
  final MethodChannel _channel = const MethodChannel('com.isamanthena/push');

  final _messageController = StreamController<PushMessage>.broadcast();
  final _tokenController = StreamController<String>.broadcast();
  final _clickController = StreamController<PushMessage>.broadcast();

  MethodChannelPush() {
    _channel.setMethodCallHandler(_handleCall);
  }

  @override
  Future<void> register() async {
    await _channel.invokeMethod('register');
  }

  @override
  Future<String?> getToken() async {
    final token = await _channel.invokeMethod<String>('getToken');
    return token;
  }

  @override
  Stream<PushMessage> get onMessage => _messageController.stream;

  @override
  Stream<String> get onToken => _tokenController.stream;

  @override
  Stream<PushMessage> get onNotificationClick => _clickController.stream;

  Future<void> _handleCall(MethodCall call) async {
    switch (call.method) {
      case 'onMessage':
        _messageController.add(PushMessage.fromMap(call.arguments));
        break;

      case 'onToken':
        _tokenController.add(call.arguments as String);
        break;

      case 'onNotificationClick':
        _clickController.add(PushMessage.fromMap(call.arguments));
        break;
    }
  }
}
