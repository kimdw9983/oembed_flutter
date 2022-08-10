import 'package:flutter/material.dart';

import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

const address = "222.109.61.70";
Future<Map<String, dynamic>> oEmbed(String url) async {
  var uri = Uri(scheme: 'http', host: address, port: 8080, path: '/oembed/$url');
  log('get() url : $url, uri : $uri');
  final response = await http.get(uri);
  final Map<String, dynamic> test = jsonDecode(response.body);
  //log(test["data"]["title"]);
  final Future<Map<String, dynamic>> parsedResponse = jsonDecode(response.body);


  //_posts.clear();
  //_posts.addAll(parsedResponse);
  return await parsedResponse;
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: oEmbed("https://www.youtube.com/watch?v=FtutLA63Cp8"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
              return const Text("there is no connection");

            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              if (snapshot.data != null){
                log("not null");
                Map<String, dynamic> myMap = snapshot.data as Map<String, dynamic>;

                return TextButton(
                  onPressed: () {
                    myMap["data"];

                  },
                  child: const Text('Go Back'),
                );
              }
              return const Text("no data found!");
          }
        }
      ),
    );
  }
}