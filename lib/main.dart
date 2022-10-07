import 'dart:js';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

enum AppState {NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String key = 'ef0f78f151c685f37bc843a251e79a10';
  late WeatherFactory ws;
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double? lat, long;

  @override
  void initState(){
    super.initState();
    ws = new WeatherFactory(key);
  }

  void queryTemperature() async{
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByLocation(lat!, long!);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget finished() {
    return Center(
      child: Expanded(
        child: ListView.separated(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_data[index].toString()),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
      )
    );
  }

  Widget downloading() {
    return Container(
      margin: EdgeInsets.all(25.0),
      child: Column(
        children: [
          Text(
            'Fetching Temperature',
            style: TextStyle(fontSize: 30),
          ),
          Container(
            margin: EdgeInsets.only(top:50.0),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 10),
            )
          )
        ]
      ),
    );
  }

  Widget notDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press the button to continue',
          )
        ],
      ),
    );
  }

  void _latitude(String input){
    lat = double.tryParse(input);
    print(lat);
  }

  void _longitude(String input){
    long = double.tryParse(input);
    print(long);
  }

  Widget _inputCoordinate() {
    return Row(
      children: <Widget>[
        Expanded(
        child:
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter Latitude'),
              keyboardType: TextInputType.number,
              onChanged: _latitude,
              onSubmitted: _latitude,
            ),
          )
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                 border: OutlineInputBorder(), hintText: 'Enter Longitude'),
             keyboardType: TextInputType.number,
             onChanged: _longitude,
             onSubmitted: _longitude,
            ),
          )
        )
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      child: TextButton(
        child: Text('Get Temperature'),
        onPressed: queryTemperature,
      ),
    );
  }

  Widget _result() {
    return _state == AppState.FINISHED_DOWNLOADING?
        finished() : _state == AppState.DOWNLOADING?
            downloading():
            notDownloaded();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Temperature Checker'),
        ),
        body: Column(
          children: <Widget>[
            _inputCoordinate(),
            _submitButton(),
            Divider(height: 50),
            Expanded(child: _result())
          ],
        ),
      ),
    );
  }
}
