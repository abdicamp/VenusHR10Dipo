import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';

class GetVersion {
  String? versiString;

  Future<bool> getCekVersions() async {
    try {
      final response = await http.get(Uri.parse(
          "${Variables.baseUrl}/getVersion/${Variables.name_package}"));

      if (response.statusCode == 200) {
        final getData = jsonDecode(response.body);
        print(
            "AppVersion : ${getData[0]['AppVersion']} < version : ${Variables.version} = ${getData[0]['AppVersion'] < Variables.version} , dan ${getData[0]['ForseUpdate'] == true}");
        print(
            "${getData[0]['AppVersion'] < Variables.version && getData[0]['ForseUpdate'] == true}");
        versiString = '${getData[0]['AppVersion']}';
        if (getData[0]['AppVersion'] <= Variables.version) {
          if (getData[0]['ForseUpdate'] == false) {
            return true;
          } else if (getData[0]['ForseUpdate'] == true) {
            return true;
          } else {
            return false;
          }
        } else {
          if (getData[0]['ForseUpdate'] == false) {
            return true;
          } else {
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> Function() version = () async {
  //   try {
  //     return false;
  //   } catch (e) {
  //     print("Error: $e");
  //     return false;
  //   }
  // };
}
