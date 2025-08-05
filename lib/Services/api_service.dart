import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/prayer_time_model.dart';

class ApiService {
  final String baseUrl = 'https://api.aladhan.com/v1';

  
  Future<PrayerTimes> getPrayerTimesByCity({
    required String country,
    required String city,
  }) async {
    final response = await http.get(Uri.parse('$baseUrl/timingsByCity?country=$country&city=$city'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      final hijriDate = data['data']['date']['hijri']['date'] as String;
      
      final timings = data['data']['timings'];
      

      return PrayerTimes.fromJson(timings , hijriDate);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}