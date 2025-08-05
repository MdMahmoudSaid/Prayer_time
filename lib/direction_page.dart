import 'package:flutter/material.dart';
import 'package:salat_app/prayer_time_screen.dart';
import 'package:salat_app/Qibla/home_page.dart';
import 'package:salat_app/masbaha.dart';





class DirectionPage extends StatefulWidget {
  const DirectionPage({super.key});
  
  @override
  _DirectionPageState createState() => _DirectionPageState();

}

class _DirectionPageState extends State<DirectionPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PrayerTimesScreen(),
    const HomePage(),
    const Masbaha()
  ];
  @override
  Widget build(Object context) {
    // TODO: implement build
    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        
        backgroundColor:  const Color.fromARGB(255, 37, 55, 127),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 130, 162, 178),
        selectedFontSize: 15,
        unselectedFontSize: 11,
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index ;
          });
        },
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home',),
        BottomNavigationBarItem(icon: Icon(Icons.explore),label: 'Qibla'),
        BottomNavigationBarItem(icon: Icon(Icons.circle_sharp),label: 'Masbaha'),
      ],),
    body: _pages[_currentIndex],
    );
  }
}