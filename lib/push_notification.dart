import 'push_platform_interface.dart';
import 'push_model.dart';

class Push {
  static Future<void> register() {
    return PushPlatform.instance.register();
  }

  static Future<String?> getToken() {
    return PushPlatform.instance.getToken();
  }

  static Stream<PushMessage> get onMessage {
    return PushPlatform.instance.onMessage;
  }

  static Stream<String> get onToken {
    return PushPlatform.instance.onToken;
  }

  static Stream<PushMessage> get onClick {
    return PushPlatform.instance.onNotificationClick;
  }
}
