import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider with ChangeNotifier {
  static final FlutterLocalNotificationsPlugin local = FlutterLocalNotificationsPlugin();
  
  Future<void> initializeNotifications() async {
    // Android 채널 설정
    if (Platform.isAndroid) {
      await _setupAndroidChannel();
    }
    
    // iOS 권한 요청 및 설정
    if (Platform.isIOS) {
      await _setupIOS();
    }
    
    // 초기화 설정
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('ic_stat_notification');
        
    const DarwinInitializationSettings darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );
    
    // 알림 초기화
    await local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('알림 탭: ${response.payload}');
      },
    );
    
    // 권한 상태 확인
    if (Platform.isIOS) {
      final bool? granted = await local.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('iOS 알림 권한 상태: $granted');
    }
  }

  Future<void> _setupAndroidChannel() async {
    // 기존 채널 설정 코드
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'todo_channel',
        '할 일 알림',
        description: '진행 중인 할 일에 대한 알림',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
        sound: RawResourceAndroidNotificationSound('notification_sound'),  // res/raw 폴더에 사운드 파일 필요
      );
    
    // Android 13 이상에서 권한 요청
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        // Android 13 이상인 경우에만 권한 요청
        final bool? granted = await androidImplementation.requestNotificationsPermission();
        debugPrint('Android 알림 권한 상태: $granted');
      }
    }
    
    await local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _setupIOS() async {
    final bool? result = await local.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
      critical: true,
    );
    debugPrint('iOS 권한 요청 결과: $result');
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'todo_channel',
      '할 일 알림',
      channelDescription: '진행 중인 할 일에 대한 알림',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      fullScreenIntent: true,  // 화면이 꺼져있을 때도 알림 표시
      icon: '@android:drawable/ic_dialog_info',
      largeIcon: const DrawableResourceAndroidBitmap('ic_stat_notification')
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    try {
      final int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      await local.show(
        id,
        title,
        body,
        details,
        payload: 'default',
      );
      debugPrint('알림 발송 시도: $body');
    } catch (e) {
      debugPrint('알림 발송 실패: $e');
    }
  }
}