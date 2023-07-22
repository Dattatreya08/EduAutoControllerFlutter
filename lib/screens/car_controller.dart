import 'package:flutter/material.dart';
import 'package:ria_bluetooth_controller/helper/helper.dart';

class CarController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Center(
        child: ListView(
          children: [
            SizedBox(height: 150,),
            CircleAvatar(
              radius: 140,
              backgroundColor: Colors.white,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createCircularAvatar(30, "U", Icons.swipe_up_alt)
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createCircularAvatar(30, "L", Icons.swipe_left_alt),
                      SizedBox(width: 20),
                      createCircularAvatar(30, "S", Icons.circle),
                      SizedBox(width: 20),
                      createCircularAvatar(30, "R", Icons.swipe_right_alt)
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createCircularAvatar(30, "D", Icons.swipe_down_alt_rounded)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
