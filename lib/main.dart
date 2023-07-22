import 'package:flutter/material.dart';
import 'package:ria_bluetooth_controller/screens/splash.dart';

void main() {
  runApp(
    MaterialApp(
      home: Splash(),
      title: "Automation",
      theme: ThemeData(
        primarySwatch: createCustomSwatch(255, 39, 73, 110),
        fontFamily: "Poppins",
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

MaterialColor createCustomSwatch(int alpha, int red, int green, int blue) {
  Map<int, Color> swatch = {
    50: Color.fromARGB(alpha, red, green, blue),
    100: Color.fromARGB(alpha, red, green, blue),
    200: Color.fromARGB(alpha, red, green, blue),
    300: Color.fromARGB(alpha, red, green, blue),
    400: Color.fromARGB(alpha, red, green, blue),
    500: Color.fromARGB(alpha, red, green, blue),
    600: Color.fromARGB(alpha, red, green, blue),
    700: Color.fromARGB(alpha, red, green, blue),
    800: Color.fromARGB(alpha, red, green, blue),
    900: Color.fromARGB(alpha, red, green, blue),
  };

  return MaterialColor(Color.fromARGB(alpha, red, green, blue).value, swatch);
}
