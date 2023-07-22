import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ria_bluetooth_controller/helper/helper.dart';
import 'package:ria_bluetooth_controller/screens/home_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
        return const Home();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 39, 73, 110),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment:Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CreateImage("images/finalAppIcon.png",width: 100,height: 100,),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Text("IOT Smart Control",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text("powered by",style: TextStyle(fontSize: 14,color: Colors.white),),
            Padding(
              padding: EdgeInsets.only(bottom: 32.0,top: 8.0),
              child: CreateImage("images/texohamLogoDarkBackground.png",width: 120,),
            )
          ],
        ),
      ),
    );
  }
}
