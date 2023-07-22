import 'package:flutter/material.dart';
import 'package:ria_bluetooth_controller/helper/helper.dart';
class RoomLayout extends StatefulWidget {
  const RoomLayout({Key? key}) : super(key: key);

  @override
  State<RoomLayout> createState() => _RoomLayoutState();
}

class _RoomLayoutState extends State<RoomLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            children:const [
              CreateCardButton(Icons.lightbulb_outline,"Light","1","2"),
              CreateCardButton(Icons.wind_power_outlined,"Fan","3","4"),
              CreateCardButton(Icons.tv_outlined,"Television","5","6"),
              CreateCardButton(Icons.ac_unit_outlined,"AC","7","8"),
              CreateCardButton(Icons.power_outlined,"Appliance","10","11"),
              CreateCardButton(Icons.power_settings_new_outlined,"All On","9","0"),
            ]
        ),
      ),
    );
  }
}
