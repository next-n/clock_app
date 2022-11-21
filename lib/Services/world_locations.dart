import 'dart:convert';

import 'package:http/http.dart';

class WorldLocations {
  List<String> timezones=[];
  WorldLocations();
  Future<void> getTimezones()async{
    Response response = await get(Uri.https("worldtimeapi.org", "/api/timezone"));
    List<dynamic> jsonResponse = jsonDecode(response.body);
    timezones = List<String>.from(jsonResponse);

  }

}