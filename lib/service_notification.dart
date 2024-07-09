import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_qibla_package_testing/getprayertime.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_settings/app_settings.dart';
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();



  Future<void> initializenotification() async {
    // Android Platform configuration required to send notifications
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> saveScheduledPrayerTime(
      DateTime prayerTime, String prayerName) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('scheduled_prayers') ?? [];

    final formattedTime = DateFormat('h:mm a').format(prayerTime);
    final notificationData = '$prayerName - $formattedTime';

    notifications.add(notificationData);
    await prefs.setStringList('scheduled_prayers', notifications);
  }



  Future<List<String>> getScheduledPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('scheduled_prayers') ?? [];
  }




  backgroundTask() async {
    Prayers.getPrayerTimes().then((value) {
      final currentTime = DateTime.now();
      print("value checker ${value.fajr.toLocal()}");
      if (value.fajr.toLocal().isAfter(currentTime)) {
        schedulePrayerTimeNotification(value.fajr.toLocal(), 'Fajr');
        saveScheduledPrayerTime(value.fajr.toLocal(), 'Fajr');
      }
      if (value.dhuhr.toLocal().isAfter(currentTime)) {
        schedulePrayerTimeNotification(value.dhuhr.toLocal(), 'Dhuhr');
        saveScheduledPrayerTime(value.dhuhr.toLocal(), 'Dhuhr');
      }
      if (value.asr.toLocal().isAfter(currentTime)) {
        schedulePrayerTimeNotification(value.asr.toLocal(), 'Asr');
        saveScheduledPrayerTime(value.asr.toLocal(), 'Asr');
      }
      if (value.maghrib.toLocal().isAfter(currentTime)) {
        schedulePrayerTimeNotification(value.maghrib.toLocal(), 'Maghrib');
        saveScheduledPrayerTime(value.maghrib.toLocal(), 'Maghrib');
      }
      if (value.isha.toLocal().isAfter(currentTime)) {
        schedulePrayerTimeNotification(value.isha.toLocal(), 'Isha');
        saveScheduledPrayerTime(value.isha.toLocal(), 'Isha');
      }
    });
  }

  Future<void> schedulePrayerTimeNotification(
      DateTime prayerTime, String prayerName) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'main_channel 2',
      'Main Channel',
      channelDescription: "omor",
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.max,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    // Ensure the prayerTime is in the future
    if (prayerTime.isBefore(DateTime.now())) {
      prayerTime = prayerTime.add(Duration(seconds: 1));
      print("check the prayer time ${prayerTime}");
    }

    final formattedTime = DateFormat('h:mm a').format(prayerTime);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      prayerName.hashCode,
      'Prayer Time',
      'It\'s time for $prayerName prayer at $formattedTime.',
      tz.TZDateTime.from(prayerTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true, // to show notification when the app is closed
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
