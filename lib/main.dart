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
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        backgroundColor: Colors.white,
        canvasColor: Colors.white,
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white), //제목 + 버튼
          headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline3: TextStyle(fontSize: 18.0, color: Colors.black87),
          headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.grey),
          caption: TextStyle(color: Colors.black26, fontSize: 16.0, fontStyle: FontStyle.italic),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black54,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.black54,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white), //제목 + 버튼
          headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline3: TextStyle(fontSize: 18.0, color: Colors.white),
          headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(fontSize: 16.0, color: Colors.white70),
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.white70),
        ),
      ),
      themeMode: _themeMode,
      home: const MyHomePage(),
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