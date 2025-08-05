import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salat_app/about_page.dart';
import '../Services/api_service.dart';
import '../Models/prayer_time_model.dart';
import 'dart:async';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final ApiService apiService = ApiService();
  PrayerTimes? prayerTimes;
  bool isLoading = true;

  String getCurrentDate() {
  final DateTime now = DateTime.now(); 
  final DateFormat formatter = DateFormat('dd-MMMM-yyyy'); 
  return formatter.format(now); 
}

List<Map<String, dynamic>> nextPrayers = []; 
late Timer _timer;


  
  String country = 'Mauritania'; 
  String city = 'Nouakchott'; 

  Map<String, bool> prayerNotifications = {
  "Fajr": true,
  "Dhuhr": true,
  "Asr": true,
  "Maghrib": true,
  "Isha": true,
};

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
    _loadNotificationPreferences();
  }

  Future<void> _loadNotificationPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    prayerNotifications = {
      "Fajr": prefs.getBool("Fajr") ?? true,
      "Dhuhr": prefs.getBool("Dhuhr") ?? true,
      "Asr": prefs.getBool("Asr") ?? true,
      "Maghrib": prefs.getBool("Maghrib") ?? true,
      "Isha": prefs.getBool("Isha") ?? true,
    };
  });
}

Future<void> _toggleNotification(String prayer) async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    prayerNotifications[prayer] = !(prayerNotifications[prayer] ?? true );
  });
  await prefs.setBool(prayer, prayerNotifications[prayer]!);
}

  Future<void> _fetchPrayerTimes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final times = await apiService.getPrayerTimesByCity(
        country: country,
        city: city,
      );

      setState(() {
        prayerTimes = times;
        isLoading = false;
        _calculateNextPrayers();
        _startTimer();
      });
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
        isLoading = false;
      });
      }
      
    }
  }

  void _calculateNextPrayers() {
    if (prayerTimes == null) return;

    DateTime now = DateTime.now();
    List<Map<String, dynamic>> allPrayers = [
      {"name": "Fajr", "time": prayerTimes!.fajr},
      {"name": "Dhuhr", "time": prayerTimes!.dhuhr},
      {"name": "Asr", "time": prayerTimes!.asr},
      {"name": "Maghrib", "time": prayerTimes!.maghrib},
      {"name": "Isha", "time": prayerTimes!.isha},
    ];

    List<Map<String, dynamic>> upcomingPrayers = [];

    for (var prayer in allPrayers) {
      DateTime prayerTime = _convertToDateTime(prayer["time"]);
      if (prayerTime.isAfter(now)) {
        upcomingPrayers.add({
          "name": prayer["name"],
          "time": prayerTime,
          "remaining": prayerTime.difference(now),
        });
      }
    }

    if (upcomingPrayers.length < 3) {
      upcomingPrayers.add({
        "name": "Fajr (Tomorrow)",
        "time": _convertToDateTime(prayerTimes!.fajr).add(Duration(days: 1)),
        "remaining": _convertToDateTime(prayerTimes!.fajr).add(Duration(days: 1)).difference(now),
      });
    }

    setState(() {
      nextPrayers = upcomingPrayers.take(3).toList();
  });
  }

  void _checkForPrayerNotifications() {
  DateTime now = DateTime.now();
  
  for (var prayer in nextPrayers) {
    String prayerName = prayer["name"];
    DateTime prayerTime = prayer["time"];

    if (prayerTime.difference(now).inSeconds == 0 && prayerNotifications[prayerName] == true) {
      _showNotification(prayerName);
    }
  }
}

void _showNotification(String prayerName) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'prayer_channel_id',
    'Prayer Notifications',
    channelDescription: 'Notifications for prayer times',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'وقت الصلاة',
    'حان الآن وقت صلاة $prayerName',
    platformChannelSpecifics,
  );

}
DateTime _convertToDateTime(String prayerTime) {
    List<String> parts = prayerTime.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
}
void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _calculateNextPrayers();
          _checkForPrayerNotifications();
        });
      }
    });
  }
  @override
void dispose() {
  _timer.cancel();  
  super.dispose();
}

  String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  return "$hoursStr:$minutesStr:$secondsStr";
}
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  Drawer(
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Row(
                children: [
                   Container(
                width: 60,
                height: 60,
                child: ClipRRect(borderRadius: BorderRadius.circular(60),
                child: Image.asset("images/es.jpg",fit: BoxFit.cover,)),
              ),
              const Expanded(child: ListTile(
                title: Text("Esprits Numeriques"),
                subtitle: Text("espritsn@gmail.com"),
              ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              
              ListTile(
                
                title: const Text("Change the country and city ",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.add,size: 30,),
                onTap: (){
                  _showCityInputDialog();
                },
              ),
              
              ListTile(
                
                title: const Text("About Us",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.info,size: 30,),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutPage()));
                },
              ),
             
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 34, 37, 95),
        title: (const Text("PRAYER TIMES ",style: TextStyle(color: Colors.white),)),
        titleTextStyle: const TextStyle(fontSize: 25.0,color: Colors.black,fontWeight: FontWeight.bold),
        centerTitle: true,
        
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : prayerTimes == null
              ? const Center(child: Text('Failed to load prayer times'))
              : Container(
                decoration:const BoxDecoration( 
                        image:DecorationImage(fit: BoxFit.fill,image:AssetImage("images/Setting.png") ) ,
                      ),
                child: ListView(
                   
                    children:  [
                     
                      Container(
                        
                        margin: const EdgeInsets.only(top: 15,bottom: 18),
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            Text("$country , $city ",style: const TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.w600,fontFamily:'Montserrat' ),),
                            Text("Hijri Date : ${prayerTimes!.hijriDate}",style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
                            Text("Date : ${getCurrentDate()}",style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
                            const SizedBox(width: 30,height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(decoration:const BoxDecoration (
                                  color: Color.fromARGB(111, 42, 41, 41),
                                  borderRadius: BorderRadius.all(Radius.circular(11))
                                
                                ),
                                alignment: Alignment.center,
                                width: 100,
                                height: 80,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(children: [
                                  const Text("Fajr", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                  Text(prayerTimes!.fajr, style:  const TextStyle(color: Color.fromARGB(255, 247, 236, 236),fontSize: 18,fontWeight: FontWeight.normal),)
                                ],),),
                            
                                Container(decoration:const BoxDecoration (
                                  color: Color.fromARGB(111, 42, 41, 41),
                                  borderRadius: BorderRadius.all(Radius.circular(11))
                                
                                ),
                                alignment: Alignment.center,
                                width: 100,
                                height: 80,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.only(top: 25),
                                child: Column(children: [
                                  const Text("Shoruk", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                  Text(prayerTimes!.shoruk,style: const TextStyle(color: Color.fromARGB(255, 247, 236, 236),fontSize: 18,fontWeight: FontWeight.normal),)
                                ],),),
                            
                                Container(decoration:const BoxDecoration (
                                  color: Color.fromARGB(111, 42, 41, 41),
                                  borderRadius: BorderRadius.all(Radius.circular(11))
                                
                                ),
                                alignment: Alignment.center,
                                width: 100,
                                height: 80,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.only(top: 25),
                                child: Column(children: [
                                  const Text("Dhuhr", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                  Text(prayerTimes!.dhuhr,style: const TextStyle(color: Color.fromARGB(255, 247, 236, 236),fontSize: 18,fontWeight: FontWeight.normal),)
                                ],),),
                              ],
                              
                            
                            ),
                          ],
                        ),
                      ),
                
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          
                          Container(decoration:const BoxDecoration (
                            color: Color.fromARGB(111, 42, 41, 41),
                            borderRadius: BorderRadius.all(Radius.circular(11))
                          
                          ),
                          alignment: Alignment.center,
                          width: 100,
                          height: 80,
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.only( left: 10),
                          
                          child: Column(children: [
                            const Text("Asr", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,),),
                            Text(prayerTimes!.asr,style: const TextStyle(color: Color.fromARGB(255, 247, 236, 236),fontSize: 18,fontWeight: FontWeight.normal),)
                          ],),),
                
                          Container(decoration:const BoxDecoration (
                            color: Color.fromARGB(111, 42, 41, 41),
                            borderRadius: BorderRadius.all(Radius.circular(11))
                          
                          ),
                          alignment: Alignment.center,
                          width: 100,
                          height: 80,
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(children: [
                            const Text("Maghrib", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                            Text(prayerTimes!.maghrib,style: const TextStyle(color: Color.fromARGB(255, 247, 236, 236),fontSize: 18,fontWeight: FontWeight.normal),)
                          ],),),
                
                          Container(decoration:const BoxDecoration (
                            color: Color.fromARGB(111, 42, 41, 41),
                            borderRadius: BorderRadius.all(Radius.circular(11))
                          
                          ),
                          alignment: Alignment.center,
                          width: 100,
                          height: 80,
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(children: [
                            const Text("Isha", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                            Text(prayerTimes!.isha,style: const TextStyle(color: Color.fromARGB(255, 247, 236, 236),fontSize: 18,fontWeight: FontWeight.normal),)
                          ],),),
                        ],
                      
                      ),
                      const SizedBox(height: 20),
                      
                      ListView.builder(
                        shrinkWrap: true,  
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: nextPrayers.length,
                        itemBuilder: (context, index) {
                          return _buildPrayerRow(nextPrayers[index]["name"], formatDuration(nextPrayers[index]["remaining"]));
                        },
                      ),
                      
                     
                    ],
                  ),
              ),
      
    );
  }

  Widget _buildPrayerRow(String name, String remainingTime) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(111, 42, 41, 41),
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      height: 80,
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(remainingTime, style: TextStyle(color: Colors.white, fontSize: 18)),
          IconButton(
            icon: Icon(
              (prayerNotifications[name]?? false)? Icons.notifications_active : Icons.notifications_off,
              color: Colors.white,
            ),
            onPressed: () {
              _toggleNotification(name);
            },
          ),
        ],
      ),
    ),
  );
}

  void _showCityInputDialog() {
    final TextEditingController cityController = TextEditingController();
    final TextEditingController countryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change the city and country'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'City (City)'),
            ),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(labelText: 'Country (Country)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                city = cityController.text.isNotEmpty ? cityController.text : city;
                country = countryController.text.isNotEmpty ? countryController.text : country;
              });
              Navigator.of(context).pop();
              _fetchPrayerTimes();
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
   );
  }
}