import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:developer';
import 'package:http/http.dart' as http;

class OEmbedMessage {
  final String status;
  final OEmbedData data;

  OEmbedMessage({required this.status, required this.data});

  factory OEmbedMessage.fromJson(Map<String, dynamic> json) {
    return OEmbedMessage(
      status: json['status'],
      data: OEmbedData.fromJson(json['data'])
    );
  }
}

class OEmbedData {
  String a;
  String b;

  OEmbedData({
    required this.a,
    required this.b,
  });

  factory OEmbedData.fromJson(Map<String, dynamic> json) {
    return OEmbedData(
      a: json['title'].toString(),
      b: json['data'].toString(),
    );
  }
}

const address = "222.109.61.70";
Future<OEmbedMessage> request(http.Client client, String url) async {
  var uri = Uri(scheme: 'http', host: address, port: 8080, path: '/oembed/$url');
  log('get() url : $url, uri : $uri');

  final response = await client.get(uri);

  //별도의 isolate 에서 수행하여 버벅이는 현상을 없앤다.
  return compute(parseJson, response.body);
}

OEmbedMessage parseJson(String responseBody) {
  return OEmbedMessage.fromJson(json.decode(responseBody));
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
      body: FutureBuilder<OEmbedMessage>(
        future: request(http.Client(), "https://www.youtube.com/watch?v=FtutLA63Cp8"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            log("error found! $snapshot.error");
          }

          return snapshot.hasData
          ? TextButton(
            onPressed: () {
              log(snapshot.data.data.b);
            },
            child: const Text('Go Back'),
          ) : const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}