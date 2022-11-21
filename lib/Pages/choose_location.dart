import 'package:clock_app/Services/get_worldtime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  dynamic data = {};
  List<String>timezones = [];
  void update(String path)async{
    EasyLoading.show(
      status: "Getting Data From api"
    );

    GetWorldTime updateTime = GetWorldTime(path);
    await updateTime.getTime();
    if (updateTime.country!=""){
      EasyLoading.showSuccess('Great!');
    }
    else{
      EasyLoading.showError("Can't access to api, Return to default", duration: const Duration(seconds: 3));
    }

    EasyLoading.dismiss();
    Navigator.pop(context, {
      "location": updateTime.location,
      "country": updateTime.country,
      "time": updateTime.time,
      "isDaytime": updateTime.isDaytime,

    });
  }
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments;
    timezones = data['timezones'];
    // print("build trigger");
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Locations"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: timezones.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              onTap: (){

                update(timezones[index]);
              },
              title: Text(timezones[index]),
              leading: Icon(
                Icons.access_time_filled,
                size: 40.0,
                color: Colors.indigo[500],
              ),
            ),
          );
        }
      )
    );
  }
}
