import 'package:flutter/material.dart';
import 'package:temperature/path/secrets.dart';
import 'package:weather/weather.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String key = API_KEY;
  late WeatherFactory ws;
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double? lat, long;

  @override
  void initState() {
    super.initState();
    ws = WeatherFactory(key);
  }

  void queryTemperature() async {
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
          return const Divider();
        },
      ),
    ));
  }

  Widget downloading() {
    return Container(
      margin: const EdgeInsets.all(25.0),
      child: Column(children: [
        const Text(
          'Fetching Temperature',
          style: TextStyle(fontSize: 36),
        ),
        Container(
            margin: const EdgeInsets.only(top: 50.0),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 10),
            ))
      ]),
    );
  }

  Widget notDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Press the button to continue',
          )
        ],
      ),
    );
  }

  void _latitude(String input) {
    lat = double.tryParse(input);
    print(lat);
  }

  void _longitude(String input) {
    long = double.tryParse(input);
    print(long);
  }

  Widget _inputCoordinate() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter Latitude'),
            keyboardType: TextInputType.number,
            onChanged: _latitude,
            onSubmitted: _latitude,
          ),
        )),
        Expanded(
            child: Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter Longitude'),
            keyboardType: TextInputType.number,
            onChanged: _longitude,
            onSubmitted: _longitude,
          ),
        ))
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      child: TextButton(
        onPressed: queryTemperature,
        child: const Text('Get Temperature'),
      ),
    );
  }

  Widget _result() {
    return _state == AppState.FINISHED_DOWNLOADING
        ? finished()
        : _state == AppState.DOWNLOADING
            ? downloading()
            : notDownloaded();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Temperature Checker'),
        ),
        body: Column(
          children: <Widget>[
            _inputCoordinate(),
            _submitButton(),
            const Divider(height: 50),
            Expanded(child: _result())
          ],
        ),
      ),
    );
  }
}
