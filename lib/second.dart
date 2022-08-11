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
  String type;
  String version;
  String title;
  String authorName;
  String authorUrl;
  String providerName;
  String providerUrl;
  String cacheAge;
  String thumbnailUrl;
  String thumbnailWidth;
  String thumbnailHeight;

  String url;
  String html;
  String width;
  String height;

  OEmbedData({
    required this.type,
    required this.version,
    required this.title,
    required this.authorName,
    required this.authorUrl,
    required this.providerName,
    required this.providerUrl,
    required this.cacheAge,
    required this.thumbnailUrl,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
    required this.url,
    required this.html,
    required this.width,
    required this.height,
  });

  factory OEmbedData.fromJson(Map<String, dynamic> json) {
    return OEmbedData(
      type: json['type'].toString(),
      version: json['version'].toString(),
      title: json['title'].toString(),
      authorName: json['authorName'].toString(),
      authorUrl: json['authorUrl'].toString(),
      providerName: json['providerName'].toString(),
      providerUrl: json['providerUrl'].toString(),
      cacheAge: json['cacheAge'].toString(),
      thumbnailUrl: json['thumbnailUrl'].toString(),
      thumbnailWidth: json['thumbnailWidth'].toString(),
      thumbnailHeight: json['thumbnailHeight'].toString(),
      url: json['url'].toString(),
      html: json['html'].toString(),
      width: json['width'].toString(),
      height: json['height'].toString(),
    );
  }
}

const address = "10.0.2.2";
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
          if (snapshot.hasError) log("$snapshot.error");
          return snapshot.hasData ? OEmbedView(data: snapshot.data.data)
              : const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}

List<DataRow> getDataRow(OEmbedData data) {
  List<DataRow> res;

  DataRow(cells: [DataCell(Text(data.authorName.toString())), DataCell(Text(data.authorName.toString()))]);
  return [];
}

class OEmbedView extends StatelessWidget {
  final OEmbedData data;
  const OEmbedView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(data.title.toString())),
        body: Container(
          child: DataTable(
          columns: const <DataColumn>[
            DataColumn(label: Text('Field')),
            DataColumn(label: Text('Data')),
          ],
          rows: getDataRow(data),
          ),
        ),
    );
  }
}