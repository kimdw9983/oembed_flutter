import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode, // 2) ← ← ← use "state" field here //////////////
      home: MyHomePage(),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

/*

class _MyHomePage extends StatelessWidget {
  final String title;

  const _MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Choose your theme:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// //////////////////////////////////////////////////////
                /// Change theme & rebuild to show it using these buttons
                /// to find our State object and call changeTheme()
                ElevatedButton(
                    onPressed: () => MyApp.of(context).changeTheme(ThemeMode.light),
                    child: const Text('Light')),
                ElevatedButton(
                    onPressed: () => MyApp.of(context).changeTheme(ThemeMode.dark),
                    child: const Text('Dark')),
                /// //////////////////////////////////////////////////////
              ],
            ),
          ],
        ),
      ),
    );
  }
}


 */