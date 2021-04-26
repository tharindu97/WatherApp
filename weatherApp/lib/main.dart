import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NasaApp(),
  ));
}

class NasaApp extends StatefulWidget {
  @override
  _NasaAppState createState() => _NasaAppState();
}

class _NasaAppState extends State<NasaApp> {

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget ListItem(String sol, int min, int max) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
                child: Text(
              "Sol $sol",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )),
            SizedBox(
              width: 120,
            ),
            Expanded(
                child: Text(
              "High: $max°C",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ))
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
                child: Text(
              "Today ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )),
            SizedBox(
              width: 120.0,
            ),
            Expanded(
                child: Text(
              "Low: $min°C",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ))
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 3.0,
          width: double.infinity,
          color: Colors.white,
        ),
      ],
    );
  }

  String url = "https://api.nasa.gov/insight_weather/?api_key=DEMO_KEY&feedtype=json&ver=1.0";
  var solKey;
  var data;
  List weatherData = [];

   getData() async {
    http.Response response = await http.get(
      Uri.encodeFull(url),
      headers: {
        "Accept" : "application/json"
      }
    );
    setState(() {
      data = json.decode(response.body);
      print(data);
      solKey = data["sol_keys"];
      solKey = solKey.reversed.toList();
      print(data[solKey[0]]["PRE"]);
      for(int i=0; i < solKey.length; i++){
        weatherData.add(data[solKey[i]]["PRE"]);
      }
      print(weatherData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
                colorFilter:
                    ColorFilter.mode(Colors.black54, BlendMode.darken))),
        child: Padding(
          padding: EdgeInsets.only(top: 50, bottom: 15, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Latest Weather\nat Elysium planitia',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Sol ${solKey[0]}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    "High: ${(weatherData[0]['mx']).ceil()}°C",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.0,
                        fontWeight: FontWeight.w300),
                  ))
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Today ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    "Low: ${(weatherData[0]['mn']).ceil()}°C",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.0,
                        fontWeight: FontWeight.w300),
                  ))
                ],
              ),
              SizedBox(
                height: 60.0,
              ),
              Text(
                "previous Days",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 28.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 3.0,
                width: double.infinity,
                color: Colors.white,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: solKey.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListItem(solKey[index], (weatherData[index]["mn"]).ceil(), (weatherData[index]["mx"]).ceil());
                  }
                ) 
              )
            ],
          ),
        ),
      ),
    );
  }
}
