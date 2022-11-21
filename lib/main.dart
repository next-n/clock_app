import 'package:clock_app/Pages/choose_location.dart';
import 'package:clock_app/Pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/Pages/home.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
void main() => runApp(MaterialApp(

  // initialRoute: "/home",
  routes: {
    "/": (context) => Loading(),
    "/home": (context) => const Home(),
    "/location": (context) => const ChooseLocation(),
  },
  builder: EasyLoading.init(),
)

);