import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:flutter_timeline_calendar/timeline/provider/instance_provider.dart';
import 'package:flutter_timeline_calendar/timeline/utils/datetime_extension.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:venushr_10_dipo_mobile/data/datasource/auth_remote_datasource.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/variables.dart';
import '../../core/helper/radius_calculate.dart';
import '../../data/datasource/auth_local_datasource.dart';
import 'absen_result.dart';

class MainHomeViewmodel extends FutureViewModel {
  BuildContext? ctx;
  String? namaJalan;
  double? latitude;
  double? longitude;
  num? getTimeZone;
  late Position position;
  late LatLng currentLocation;
  String? address;
  late CalendarDateTime selectedDateTime;
  late DateTime? weekStart;
  late DateTime? weekEnd;
  bool? isLoading;
  List<dynamic> dataSaldo = [];

  MainHomeViewmodel({this.ctx});

  getLatestWeek() {
    weekStart = selectedDateTime.toDateTime().findFirstDateOfTheWeek();
    weekEnd = selectedDateTime.toDateTime().findLastDateOfTheWeek();

    notifyListeners();
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

    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
      notifyListeners();
    } on PlatformException catch (e) {
      print("Platform Exception: ${e.message}");
    } catch (e) {
      print("Error: $e");
    }
  }

  bool? isLoadingLoc = false;

  Future<void> getAddressLocation() async {
    try {
      setBusy(true);
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocation = LatLng(position.latitude, position.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);
      Placemark placemark = placemarks[0];
      address =
          "${placemark.street}, ${placemark.name}, ${placemark.subLocality}, ${placemark.postalCode}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
      namaJalan = "${placemark.street}";
      setBusy(false);
      notifyListeners();
    } on PlatformException catch (e) {
      namaJalan = e.toString();

      setBusy(false);
      notifyListeners();
    } catch (e) {
      namaJalan = e.toString();
      setBusy(false);
    }
  }

  List<dynamic> listdatalokasi = [];

  bool foundInRange = false; // Variabel untuk mengecek apakah distanceKm <= 0.1

  getLokasi(String? typeAbsen) async {
    try {
      setBusy(true);
      await getAddressLocation();
      await getCurrentLocation();
      final prefEmployee = await AuthLocalDatasource().getAuthData();
      final url = Uri.parse(
          '${Variables.baseUrl}/getDataMAssignMentLocation/${prefEmployee?.employeeID}');
      final response = await http.get(url);

      print("response lokasi : ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> datalist = jsonDecode(response.body);
        if (datalist.isEmpty) {
          ScaffoldMessenger.of(ctx!).showSnackBar(
            const SnackBar(
              content: Text('Location not set yet'),
              backgroundColor: AppColors.red,
            ),
          );
          setBusy(false);
          notifyListeners();
        } else {
          final hasilCekLocation = await checkLocationRange(datalist);
          print("hasilCekLocation : ${hasilCekLocation}");

          print("data list : ${datalist}");
          if (hasilCekLocation == true) {
            AbsenResult results = await AuthRemoteDatasource().postAbsen(
              typeAbsen,
              '',
              '${latitude}, ${longitude}',
              address,
              getTimeZone,
            );
            if (results.success == true) {
              ScaffoldMessenger.of(ctx!).showSnackBar(
                SnackBar(
                  content: Text(results.message!),
                  backgroundColor: AppColors.green,
                ),
              );
              setBusy(false);
              notifyListeners();
            } else {
              ScaffoldMessenger.of(ctx!).showSnackBar(
                SnackBar(
                  content: Text(results.message!),
                  backgroundColor: AppColors.red,
                ),
              );
              setBusy(false);
              notifyListeners();
            }
          } else {
            ScaffoldMessenger.of(ctx!).showSnackBar(
              SnackBar(
                content: Text("You are out of location range"),
                backgroundColor: AppColors.red,
              ),
            );

            setBusy(false);
            notifyListeners();
          }
          notifyListeners();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx!).showSnackBar(
        SnackBar(
          content: Text("${e}"),
          backgroundColor: AppColors.red,
        ),
      );

      setBusy(false);
      notifyListeners();
    }
  }

  // Future<void> _initializeFaceEmbedding() async {
  //   try {
  //     final authData = await AuthLocalDatasource().getAuthData();
  //     setState(() {
  //       faceEmbedding = authData?.refBio1;
  //     });
  //   } catch (e) {
  //     print('Error fetching auth data: $e');
  //     setState(() {
  //       faceEmbedding = null; // Atur faceEmbedding ke null jika ada kesalahan
  //     });
  //   }
  // }

  final double radiusInMeters = 500;

  Future<bool> checkLocationRange(List<dynamic> data) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    int perulangan = 0;
    for (var location in data) {
      String? coordinate = location['Coordinates'];

      double latitude = double.parse(coordinate!.split(',')[0]);
      double longitude = double.parse(coordinate.split(',')[1]);

      double distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        position.latitude,
        position.longitude,
      );
      print(
          "distance in radius : ${distance} , loc : ${coordinate} , my lokasi ${position.latitude},${position.longitude}");
      if (distance <= 500) {
        getTimeZone = location['TimeZone'];
        notifyListeners();
        return true;
      } else {
        print(
            "distance out radius : ${distance} , loc : ${coordinate} , my lokasi ${position.latitude},${position.longitude}");
        print("perulangan : ${perulangan++}");
      }
    }
    notifyListeners();
    return false;
  }

  getLevaeSaldo() async {
    try {
      AbsenResult result = await AuthRemoteDatasource().getLeaveSaldo();

      if (result.success == true) {
        dataSaldo = List.from(result.data!);
        notifyListeners();
      } else {
        dataSaldo = List.from(result.data!);
        notifyListeners();
      }
    } catch (e) {
      dataSaldo = [];
      notifyListeners();
    }
  }

  @override
  Future futureToRun() async {
    TimelineCalendar.calendarProvider = createInstance();
    selectedDateTime = TimelineCalendar.calendarProvider.getDateTime();
    await checkLocationPermission();
    await getAddressLocation();
    await getLatestWeek();
    await getLevaeSaldo();
  }
}
