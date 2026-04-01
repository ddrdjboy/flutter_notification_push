import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_push/push_notification.dart';
import 'package:http/http.dart' as http;

void main() {
  final uri = Uri.parse('https://www.baidu.com');
  http.post(uri, headers: {'Content-Type': 'application/json'});
  runApp(const MyApp());
}

Future<void> _registerDevice(String token) async {}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String push_token = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      await Push.register();
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    Push.onToken.listen((token) {
      setState(() {
        push_token = token;
      });
      print("🔥 token: $token");
      _registerDevice(token);
    });

    Push.onMessage.listen((msg) {
      print("📩 message: ${msg.title}");
    });

    Push.onClick.listen((msg) {
      print("👆 click: ${msg.data}");
    });
  }

  Future<void> _registerDevice(String token) async {
    final uri = Uri.parse('http://192.168.1.29:8080/api/devices/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': 'user001',
        'token': token,
        'platform': defaultTargetPlatform == TargetPlatform.iOS
            ? 'IOS'
            : 'ANDROID',
      }),
    );
    print("📡 register response: ${response.statusCode} ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Running on: $push_token\n')),
      ),
    );
  }
}
