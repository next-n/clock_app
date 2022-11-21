
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:timezone/data/latest.dart';
class GetWorldTime{
  DateTime time=DateTime.now();
  String urlPath;
  String location="";

  String country="";
  bool isDaytime=false;
  // GetWorldTime();
  GetWorldTime(this.urlPath);
  Future<void> getTime() async{
    try{
      Response response = await get(Uri.http("worldtimeapi.org", "/api/timezone/$urlPath")).timeout(Duration(seconds: 7));
      Map mappedResponse = jsonDecode(response.body);
      String datetimestring = mappedResponse["datetime"].toString();
      var index = datetimestring.indexOf("+");
      String newdatetime = "${datetimestring.substring(0, index)}+00:00";
      DateTime now = DateTime.parse(newdatetime);
      int offset = mappedResponse['dst_offset'];
      now = now.add(Duration(hours: offset));
      time = now;
      location = mappedResponse['timezone'].toString().split("/").last;
      country = await getCountry(location).timeout(const Duration(seconds: 8));
      isDaytime = now.hour>=6 && now.hour<22 ? true: false;



    }catch(e){
      print("caught: $e");

    }
  }
  Future<void> getTimeByIp() async{
    try{
      Response response = await get(Uri.http("worldtimeapi.org", "api/ip")).timeout(Duration(seconds: 8));
      Map mappedResponse = jsonDecode(response.body);
      String datetimestring = mappedResponse["datetime"].toString();
      var index = datetimestring.indexOf("+");
      String newdatetime = "${datetimestring.substring(0, index)}+00:00";
      DateTime now = DateTime.parse(newdatetime);
      time = now;
      location = mappedResponse['timezone'].toString().split("/").last;
      country = await getCountry(location).timeout(Duration(seconds: 15));
      isDaytime = now.hour>=6 && now.hour<18 ? true: false;
      // print("gettime ${country} ${location}");
      // await getFlagimage(country);

    }
    catch(e){
      print("failed becoz $e");

    }

  }//getTimeByIP

  Future<String> getCountry(String city) async{
    // print("city $city");
    List<Place> countries = await Nominatim.searchByName(
      city: city,
      addressDetails: true
    );
    // print("hello");
    // print("address ${countries.first.address!["country_code"]}");
    return countries.first.address!["country_code"];
  }



}