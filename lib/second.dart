import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:developer';
import 'package:http/http.dart' as http;

class OEmbedMessage {
  final String status;
  final Map data;
  //final data;

  OEmbedMessage({required this.status, required this.data});

  factory OEmbedMessage.fromJson(Map<String, dynamic> json) {
    return OEmbedMessage(
      status: json['status'],
      //data: OEmbedData.fromJson(json['data'])
      data: json['data'] as Map
    );
  }
}

class OEmbedData {
  final Map<String, dynamic> data;

  OEmbedData({required this.data});

  factory OEmbedData.fromJson(Map<String, dynamic> json) {
    return OEmbedData(
      data: json['data'] as Map<String, String>
    );
  }
}

const address = "222.109.61.70";
Future<Map<String, dynamic>> request(http.Client client, String url) async {
  var uri = Uri(scheme: 'http', host: address, port: 8080, path: '/oembed/$url');
  log('uri : $uri');

  final response = await client.get(uri);
  final json = jsonDecode(response.body) as Map;//compute(parseJson, response.body);
  final data = json['data'] as Map;

  //별도의 isolate 에서 수행하여 버벅이는 현상을 없앤다.
  return data;
}

Map parseJson(String responseBody) {
  return json.decode(responseBody) as Map;
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: request(http.Client(), "https://www.youtube.com/watch?v=FtutLA63Cp8"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) log("$snapshot.error");
          return snapshot.hasData ? OEmbedView(data: snapshot.data.data)
              : const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}

class OEmbedView extends StatelessWidget {
  final Map data;
  const OEmbedView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(data["data"].toString())),
        body: Container(
            child: Table(
                children: (data["data"] as List)
                    .map((item) => TableRow(children: [
                  Text(item['id'].toString()),
                  Text(item['report_id'].toString()),
                  Text(item['place']),
                ]))
                    .toList())));
  }
}