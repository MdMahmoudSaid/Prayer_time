import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage ({super.key});

  @override
  _AboutPageState createState() {
    return _AboutPageState();
  }

}

class _AboutPageState extends State<AboutPage> {
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 34, 37, 95),
        title: (const Text("About Us ",style: TextStyle(color: Colors.white),)),
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
              Row(
                children: [
                   Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 60),
                width: 80,
                height: 80,
                child: ClipRRect(borderRadius: BorderRadius.circular(80),
                child: Image.asset("images/es.jpg",fit: BoxFit.cover,)),
              ),
              const Expanded(child: ListTile(
                title: Text("Esprits Numeriques",style: TextStyle(color: Colors.white,fontSize: 15),),
                subtitle: Text("espritsn@gmail.com",style: TextStyle(color: Color.fromARGB(255, 185, 169, 169),fontSize: 15),),
              ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin:const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text("We are Esprites Technique, a team of passionate developers creating innovative solutions. We're currently developing a prayer time app to offer a simple, precise, and user-friendly experience. Stay tuned—great things are coming soon!",style: TextStyle(color: Colors.white,fontSize: 17),),
              )
            
  ]
            
    ,),
      )
    );
  }}