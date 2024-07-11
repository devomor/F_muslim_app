import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qibla_package_testing/controller/get_prayer_time.dart';
import 'package:flutter_qibla_package_testing/shared_service/service_notification.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<PrayerTimes>? _prayerTimesFuture;
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _prayerTimesFuture = Prayers.getPrayerTimes();
    NotificationService().backgroundTask;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body:Column(
        children: [
          SizedBox(height: 10,),
          OutlinedButton(onPressed: (){
            notificationService.schedulePrayerTimeNotification(DateTime.now(), 'test');
          }, child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.ads_click),
            Text("Test Notification")
          ],)),
          SizedBox(height: 10,),
          Expanded(
            child: FutureBuilder<PrayerTimes>(
              future: _prayerTimesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final prayerTimes = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        PrayerTimeRow('Fajr', _formatTime(prayerTimes.fajr!)),
                        PrayerTimeRow('Dhuhr', _formatTime(prayerTimes.dhuhr!)),
                        PrayerTimeRow('Asr', _formatTime(prayerTimes.asr!)),
                        PrayerTimeRow('Maghrib', _formatTime(prayerTimes.maghrib!)),
                        PrayerTimeRow('Isha', _formatTime(prayerTimes.isha!)),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class PrayerTimeRow extends StatelessWidget {
  final String prayerName;
  final String prayerTime;

  PrayerTimeRow(this.prayerName, this.prayerTime);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayerName,
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            prayerTime,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}