import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);
const MaterialColor black = const MaterialColor(
  0x00000000,
  const <int, Color>{
    50: const Color(0x00000000),
    100: const Color(0x00000000),
    200: const Color(0x00000000),
    300: const Color(0x00000000),
    400: const Color(0x00000000),
    500: const Color(0x00000000),
    600: const Color(0x00000000),
    700: const Color(0x00000000),
    800: const Color(0x00000000),
    900: const Color(0x00000000),
  },
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Widget',
      theme: ThemeData(
        // black
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      home: const MainPage(title: 'Fiat 500e'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  int _counter = 0;
  Position? _currentPosition;
  Position? _lastPosition;  

  // init 2 string
  double Speed = 0;
  
  
@override
void initState() {
  super.initState();
  // call the function
  _handleLocationPermission();

  // Set up a location change listener
  Geolocator.getPositionStream().listen((Position position) {
    _calculateSpeed(position);
  });
}

void _calculateSpeed(Position newPosition) {
  if (_lastPosition != null) {
    final distance = Geolocator.distanceBetween(
            _lastPosition!.latitude, _lastPosition!.longitude,
            newPosition.latitude, newPosition.longitude) /
        1000; // Convert distance to kilometers

    final timeDifference = newPosition.timestamp!.difference(_lastPosition!.timestamp!).inSeconds;

    if (distance > 0 && timeDifference > 0) {
      final speed = (distance / timeDifference) * 3600; // Speed in km/h
      setState(() {
        Speed = speed;
        _currentPosition = newPosition;
      });
    }
  }

  _lastPosition = newPosition;
}




 


  // get phone location latitude and longitude
  Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {   
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}





 

  void _incrementCounter() {
    setState(() {
      _counter += 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        // crop the onglet bar
        toolbarHeight: 0,
      ),
      backgroundColor: Color.fromARGB(255, 209, 209, 209),
      body: Stack(
        children: [
          // container for the main page with a white background and a border radius
          Container(
            margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 134, 134, 134),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _currentPosition?.latitude.toString() ?? '0',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                    
                  ),
                  Text(
                    _currentPosition?.longitude.toString() ?? '0',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _lastPosition?.latitude.toString() ?? '0',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                    
                  ),
                  Text(
                    _lastPosition?.longitude.toString() ?? '0',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    Speed.toString() ?? '0',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
