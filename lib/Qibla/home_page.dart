import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'qibla_compass_page.dart'; // Import de la page Qibla Compass

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Principale page'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FlutterQiblah.checkLocationStatus(),
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final locationStatus = snapshot.data;

          if (locationStatus?.enabled == true) {
            if (locationStatus?.status == LocationPermission.always ||
                locationStatus?.status == LocationPermission.whileInUse) {
              // Si la localisation est active, redirige vers la boussole
              Future.microtask(() {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const QiblaCompassPage()),
                );
              });
              return const Center(child: Text('Chargement...'));
            } else {
              return const Center(
                child: Text(
                  'Permission de localisation refusée.\nVeuillez activer les permissions dans les paramètres.',
                  textAlign: TextAlign.center,
                ),
              );
            }
          } else {
            return const Center(
              child: Text(
                'Activez votre service de localisation pour continuer.',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
