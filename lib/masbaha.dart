import 'package:flutter/material.dart';

class Masbaha extends StatefulWidget {
  const Masbaha ({super.key});

  @override
  _MasbahaState createState() {
    return _MasbahaState();
  }

}

class _MasbahaState extends State<Masbaha> {
  int _counter = 0;

  void _incrementCounter (){
    setState(() {
      _counter++ ;
    });
  }

  void _resetCounter(){
    setState(() {
      _counter = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 34, 37, 95),
        title: (const Text("Masbha ",style: TextStyle(color: Colors.white),)),
        titleTextStyle: const TextStyle(fontSize: 25.0,color: Colors.black,fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Container(
        decoration:const BoxDecoration( 
                        image:DecorationImage(fit: BoxFit.fill,image:AssetImage("images/Setting.png") ) ,
                      ),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: const Text("MY TESBIH  📿",style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.w600),)),
            Container(
              alignment: Alignment.center,
              width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      boxShadow: const [
                       BoxShadow(
                          color: Color.fromARGB(170, 24, 23, 23),
                          blurRadius: 30,
                        ),
                      ],
                    ),
              child: Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 75,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 37, 95),
                ),
              ),
            ),
            const SizedBox(height: 20),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouton d'incrémentation
                ElevatedButton(
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child:const Icon(Icons.add,size: 40,color:Colors.white,),
                ),
                const SizedBox(width: 20),
                // Bouton de réinitialisation
                ElevatedButton(
                  onPressed: _resetCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Icon(Icons.restart_alt,size: 40,color:Colors.white,),
                ),
              ],
            ),
        ],),
      )
    );
  }}