import Flutter
import UIKit
import UserNotifications

public class FlutterNotificationPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {

    private var channel: FlutterMethodChannel?
    var token: String?

    // MARK: - 注册插件
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.isamanthena/push", binaryMessenger: registrar.messenger())
        let instance = FlutterNotificationPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)  // ← 加这一行！
        // 设置 UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = instance
    }

    // MARK: - Flutter 调用入口
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "register":
            registerPushNotifications(result: result)
        case "getToken":
            result(self.token ?? nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - 注册推送
    private func registerPushNotifications(result: @escaping FlutterResult) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            result("OK")
        }
    }

    // MARK: - 获取 deviceToken
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.token = token
        channel?.invokeMethod("onToken", arguments: token)
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        channel?.invokeMethod("onError", arguments: error.localizedDescription)
    }

    // MARK: - 接收消息（前台/后台）
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        channel?.invokeMethod("onMessage", arguments: userInfo)
        completionHandler(.newData)
    }

    // MARK: - UNUserNotificationCenterDelegate 前台通知显示
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        channel?.invokeMethod("onMessage", arguments: notification.request.content.userInfo)
        // 前台也显示通知
        completionHandler([.sound])
    }

    // MARK: - 点击通知
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {

        channel?.invokeMethod("onNotificationClick", arguments: response.notification.request.content.userInfo)
        completionHandler()
    }
}
