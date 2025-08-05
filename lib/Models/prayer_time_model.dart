class PrayerTimes {
  final String fajr;
  final String shoruk;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String hijriDate;

  PrayerTimes({
    required this.fajr,
    required this.shoruk,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.hijriDate,
  });

  
  factory PrayerTimes.fromJson(Map<String, dynamic> timings , String hijriDate) {
    return PrayerTimes(
      fajr: timings['Fajr'] as String,
      shoruk: timings['Sunrise'] as String,
      dhuhr: timings['Dhuhr'] as String,
      asr: timings['Asr'] as String,
      maghrib: timings['Maghrib'] as String,
      isha: timings['Isha'] as String,
      hijriDate: hijriDate,
    );
  }
}