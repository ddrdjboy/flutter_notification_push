import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'push_model.dart';
import 'push_method_channel.dart';

abstract class PushPlatform extends PlatformInterface {
  PushPlatform() : super(token: _token);

  static final Object _token = Object();

  static PushPlatform _instance = MethodChannelPush();

  static PushPlatform get instance => _instance;

  static set instance(PushPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // ===== 必须实现的方法 =====

  Future<void> register();

  Future<String?> getToken();

  Stream<PushMessage> get onMessage;

  Stream<String> get onToken;

  Stream<PushMessage> get onNotificationClick;
}
