import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TestLocation extends StatefulWidget {
  const TestLocation({super.key});

  @override
  State<TestLocation> createState() => _TestLocationState();
}

class _TestLocationState extends State<TestLocation> {
  final double referenceLatitude =
      -6.158676936461941; // Koordinat referensi (contoh: Jakarta)
  final double referenceLongitude = 106.852289661351;
  final double radiusInMeters = 5000; // Radius dalam meter
  String result = "";

  Future<void> checkLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    double distance = Geolocator.distanceBetween(
      referenceLatitude,
      referenceLongitude,
      position.latitude,
      position.longitude,
    );

    setState(() {
      result = distance <= radiusInMeters ? "Dalam radius" : "Di luar radius";
      print("result : ${result}");
    });
  }

  Future<void> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        return;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cek Radius")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkLocation,
              child: Text("Cek Lokasi"),
            ),
          ],
        ),
      ),
    );
  }
}
