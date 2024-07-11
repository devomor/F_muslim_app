//
// import 'package:adhan/adhan.dart';
//
// class Prayers {
//   static Future<PrayerTimes> getPrayerTimes() async {
//     final coordinates = Coordinates(24.8614622, 67.0099388); // Dhaka, Bangladesh
//     final params = CalculationMethod.karachi.getParameters();
//     return PrayerTimes.today(coordinates, params);
//   }
// }

import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';

class Prayers {
  static Future<PrayerTimes> getPrayerTimes() async {
    try {
      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Use current coordinates
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.karachi.getParameters();
      return PrayerTimes.today(coordinates, params);
    } catch (e) {
      print('Error fetching location: $e');

      final coordinates = Coordinates(24.8614622, 67.0099388);
      final params = CalculationMethod.karachi.getParameters();
      return PrayerTimes.today(coordinates, params);

    }
  }
}