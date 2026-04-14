import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/fcm_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();
  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/default.png';

  @override
  void initState() {
    super.initState();

    _fcmService.initialize(onData: (message) {
      setState(() {
        statusText = message.notification?.title ?? 'Payload received';
        imagePath = 'assets/${message.data['asset'] ?? 'default'}.png';
      });
    });

    _fcmService.getToken().then((token) {
      debugPrint('FCM Token: $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Messaging Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(statusText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Image.asset(imagePath, width: 200, height: 200),
          ],
        ),
      ),
    );
  }
}