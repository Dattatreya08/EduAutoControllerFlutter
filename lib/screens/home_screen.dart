import 'package:flutter/material.dart';
import 'package:ria_bluetooth_controller/helper/helper.dart';
import 'package:ria_bluetooth_controller/screens/appliances_control.dart';
import 'package:ria_bluetooth_controller/screens/bluetooth_connectivity.dart';
import 'package:ria_bluetooth_controller/screens/car_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(onTap: (){

        },splashColor: Colors.transparent,
          highlightColor: Colors.transparent,child: const CircleAvatar(
            child: CreateImage('images/texohamIconDarkBackground.png',width:28,height:28),
          ),
        ),
        title: Text("Automation",style: TextStyle(fontSize: 24),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(CustomPageRoute(builder: (context){
              return BluetoothConnectivity();
            }));
          },
              icon: const Icon(Icons.connect_without_contact_outlined))
        ],bottom: TabBar(
        controller: _tabController,
        indicatorColor: const Color.fromARGB(255, 251, 183, 38),
        indicatorWeight: 4.0,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Home automation'),
          Tab(text: 'Car controller'),
        ],
        labelColor: const Color.fromARGB(255, 251, 183, 38),
      ),
      ),body:TabBarView(
      controller: _tabController,
      children:  [
        // Content for Tab 1
        RoomLayout(),
        // Content for Tab 2
        CarController(),
      ],
    ),
    );
  }
}


class CustomPageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  CustomPageRoute({required this.builder})
      : super(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) =>
        builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeIn,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}