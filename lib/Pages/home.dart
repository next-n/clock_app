import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data={};
  String time="";
  DateTime? now;
  ImageProvider? image;
  void runClock(){
    setState(() {
      if (now!=null) {
        now = now!.add(const Duration(seconds: 1));
        time = DateFormat("hh:mm:ss").format(now!);
        // print("hello$time $now");
      }
      // print("outside");
;
    });
  }
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t){
      runClock();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty? data: ModalRoute.of(context)!.settings.arguments as Map;
    // print("country code ${data['country']}");
    if (data['country']!="") {
      // print("ma null bu lar ${data['country']}");
      if (data['isfromapi']) {
        now = data['time'];
        data['isfromapi'] = false;
        image = NetworkImage("https://countryflagsapi.com/png/${data['country']}");
      }
    }
    else{
      // print("null nay tr lr ${data}");
      setState(() {
        image = AssetImage("assets/mm.jpg");
        DateTime temp = DateTime.now();
        now = temp;
        data = {
          "location": 'Yangon',
          "country": 'mm',
          "time": temp,
          "isDaytime": temp.hour>=6 && temp.hour<22? true: false,
          "timezones": data['timezones'],
          "isfromapi": false
        };

      });
    }
    // print("type ${data.runtimeType}");
    // print("country${data['country']}");
    String bgimage = data['isDaytime']? "sunrise.jpg": "night4.jpg";
    Color? bgcolor = data['isDaytime']? Colors.blue: Colors.indigo[700];
    Color? txcolor =  data['isDaytime']? Colors.black: Colors.white70;

    // print("helllooo");
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Container(
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/$bgimage"),
              fit: BoxFit.cover,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120.0, 0, 0),
            child: Column(
              children: [
                TextButton.icon(
                  icon: Icon(
                    Icons.edit_location,
                    color: txcolor,
                  ),
                  onPressed: ()async{
                    dynamic result = await Navigator.pushNamed(context, "/location", arguments:{
                      "timezones": data['timezones'],

                    });
                    setState(() {
                      data = {
                        "location": result['location'],
                        "country": result['country'],
                        "time": result['time'],
                        "isDaytime": result['isDaytime'],
                        "timezones": data['timezones'],
                        "isfromapi": true
                      };
                    });
                  },
                  label: Text(
                      "Edit Location",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: txcolor,

                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(

                      backgroundImage: image,

                      radius: 35.0,

                    ),
                    SizedBox(width: 20.0,),
                    Text(
                      data["location"],
                      style: TextStyle(
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                        color: txcolor,
                        fontWeight: FontWeight.bold

                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0,),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 70.0,
                    color: txcolor,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
