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
      authorName: json['author_name'].toString(),
      authorUrl: json['author_url'].toString(),
      providerName: json['provider_name'].toString(),
      providerUrl: json['provider_url'].toString(),
      cacheAge: json['cache_age'].toString(),
      thumbnailUrl: json['thumbnail_url'].toString(),
      thumbnailWidth: json['thumbnail_width'].toString(),
      thumbnailHeight: json['thumbnail_height'].toString(),
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

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
    );
  }
}

List<DataRow> getDataRow(OEmbedData data) {
  List<DataRow> res = [];

  res.add(DataRow(cells: [const DataCell(Text("type")), DataCell(Text(data.type.toString()))] ));
  res.add(DataRow(cells: [const DataCell(Text("version")), DataCell(Text(data.version.toString()))] ));
  if (data.providerName.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("providerName")), DataCell(Text(data.providerName.toString()))] ));
  if (data.providerUrl.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("providerUrl")), DataCell(Text(data.providerUrl.toString()))] ));
  if (data.cacheAge.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("cacheAge")), DataCell(Text(data.cacheAge.toString()))] ));

  if (data.title.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("title")), DataCell(Text(data.title.toString()))] ));
  if (data.authorName.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("author_name")), DataCell(Text(data.authorName.toString()))] ));
  if (data.authorUrl.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("author_url")), DataCell(Text(data.authorUrl.toString()))] ));

  if (data.thumbnailUrl.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("thumbnail_url")), DataCell(Text(data.thumbnailUrl.toString()))] ));
  if (data.thumbnailWidth.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("thumbnail_width")), DataCell(Text(data.thumbnailWidth.toString()))] ));
  if (data.thumbnailHeight.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("thumbnail_height")), DataCell(Text(data.thumbnailHeight.toString()))] ));

  if (data.url.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("url")), DataCell(Text(data.url.toString()))] ));
  if (data.html.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("html")), DataCell(Text(data.html.toString()))] ));
  if (data.width.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("width")), DataCell(Text(data.width.toString()))] ));
  if (data.height.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("height")), DataCell(Text(data.height.toString()))] ));

  return res;
}

class OEmbedView extends StatelessWidget {
  final OEmbedData data;
  const OEmbedView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(data.title.toString())),
        body: SingleChildScrollView(
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