import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salat_app/direction_page.dart';


class QiblaCompassPage extends StatelessWidget {
  const QiblaCompassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DirectionPage()));
        }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
        shadowColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 34, 37, 95),
        title: (const Text("Qibla   🕋 ",style: TextStyle(color: Colors.white),)),
        titleTextStyle: const TextStyle(fontSize: 25.0,color: Colors.black,fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: StreamBuilder<QiblahDirection>(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final qiblahDirection = snapshot.data;

          return Container(
            decoration:const BoxDecoration( 
                        image:DecorationImage(fit: BoxFit.fill,image:AssetImage("images/Setting.png") ) ,
                      ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                
                children: [

                  
            
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      boxShadow: const [
                       BoxShadow(
                          color: Colors.black26,
                          blurRadius: 40,
                        ),
                      ],
                    ),
                  ),
            
                  SvgPicture.asset(
                    'images/qibla_compass.svg', // Image SVG pour le fond
                    width: 300,
                    height: 300,
                  ),
                  Transform.rotate(
                    angle: (qiblahDirection?.qiblah ?? 0) * (3.14159265359 / 180) * -1,
                    child: SvgPicture.asset(
                      'images/needle.svg', // Aiguille qui pointe vers la Qibla
                      width: 150,
                      height: 150,
                    ),
                  ),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
