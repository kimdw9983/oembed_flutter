import 'dart:async';
import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:battery_plus/battery_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  var battery = Battery();
  int percentage = 0;
  late Timer timer;

  BatteryState batteryState = BatteryState.full;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    getBatteryState();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      getBatteryPerentage();
    });
  }

  void getBatteryState() {
    streamSubscription = battery.onBatteryStateChanged.listen((state) {
      batteryState = state;

      setState(() {});
    });
  }

  void getBatteryPerentage() async {
    final level = await battery.batteryLevel;
    percentage = level;

    setState(() {});
  }

  final address = "http://127.0.0.1";
  Future<Map<String, dynamic>> oEmbed(String url) async {
    var uri = Uri(scheme: 'http', host: '127.0.0.1', path: '/oembed/', fragment: url);
    log('get() url : $url, uri : $uri');
    final response = await http.get(uri);
    final Map<String, dynamic> parsedResponse = jsonDecode(response.body);

    //_posts.clear();
    //_posts.addAll(parsedResponse);
    return parsedResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('You have pushed the button this many times:', ),
            Text('$_counter', style: Theme.of(context).textTheme.headline4,),
            Text('Battery Percentage: $percentage', style: const TextStyle(fontSize: 24),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Material(
        color: const Color(0xffff8906),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SecondPage(title: 'SecondPage');
            }));
          },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                'Next',
                style: TextStyle(fontWeight: FontWeight.bold,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}