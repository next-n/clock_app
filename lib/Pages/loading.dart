import 'dart:convert';

import 'package:clock_app/Services/world_locations.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/Services/get_worldtime.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading extends StatefulWidget {

  Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => LoadingState();
}



class LoadingState extends State<Loading> {
  dynamic data;

  Future<List<String>> get_local() async{
    try{
      Response response = await get(Uri.http("ip-api.com", "/json/")).timeout(const Duration(seconds: 12));;
      Map mappedResponse = jsonDecode(response.body);
      String local = mappedResponse["timezone"];
      local.replaceAll("_", " ");
      return [local, mappedResponse["city"], mappedResponse["country"]];
    }
    catch(e){
      return ["Asia/Yangon", "Yangon", "Myanmar"];
    }

  }

  void start() async{
    // List<String> local = await get_local();

    GetWorldTime localtime = GetWorldTime("");
    WorldLocations wl = WorldLocations();
    await wl.getTimezones();

    // await localtime.getTimeByIp();
    // print("country ${localtime.country}");
    // print("loaaaa");
    Navigator.pushReplacementNamed(context, "/home", arguments: {
      "location": localtime.location,
      "country": localtime.country,
      "time": localtime.time,
      "isDaytime": localtime.isDaytime,
      "timezones": wl.timezones,
      "isfromapi": true
    });
  } //start
  // void updateTime(String path, List<String>timezones) async{
  //   GetWorldTime update = GetWorldTime(path);
  //   await update.getTime();
  //
  //   Navigator.pushReplacementNamed(context, "/home", arguments: {
  //     "location": update.location,
  //     "country": update.country,
  //     "time": update.time,
  //     "isDaytime": update.isDaytime,
  //     "timezones": timezones,
  //   });
  //
  //
  // }

  @override
  void initState() {
    start();

    // TODO: implement initState
    super.initState();

  } //initState
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: SpinKitSpinningLines(
          color: Colors.purple,
          size: 60.0,
        ),
      ),
    );
  }
}
