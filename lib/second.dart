import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:oembed_flutter/home.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

const address = "222.109.61.70";
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

Future<OEmbedMessage> request(http.Client client, String url) async {
  var uri = Uri(scheme: 'http', host: address, port: 8080, path: '/oembed/$url');
  log('get() url : $url, uri : $uri');

  final response = await client.get(uri);
  var json = jsonDecode(response.body); //TODO: FIX THIS HACK
  if (json["status"] != "OK") throw Exception(json["data"]);

  //별도의 isolate 에서 수행하여 버벅이는 현상을 없앤다.
  return compute(parseJson, response.body);
}

OEmbedMessage parseJson(String responseBody) {
  return OEmbedMessage.fromJson(json.decode(responseBody));
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key, required this.arg}) : super(key: key);
  final URLArguments arg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<OEmbedMessage>(
        future: request(http.Client(), arg.url),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            //log("${snapshot.error}");
            return AlertDialog(
              title: const Text('오류'),
              content: Text(snapshot.error.toString().substring(10)),
              actions: <Widget>[
                TextButton(
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text("돌아가기", textAlign: TextAlign.center,),
                  ),
                  onPressed: () { Navigator.pop(context); }, //closes popup
                ),
              ],
            );
          }
          return snapshot.hasData ? OEmbedView(data: snapshot.data.data)
              : const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}

//https://stackoverflow.com/questions/53001839/how-to-convert-response-json-to-object-in-flutter
//왜 simple nested json 구조를 파싱하지 못하는지 확인해야 함.
List<DataRow> getDataRow(OEmbedData data) {
  List<DataRow> res = [];

  res.add(DataRow(cells: [const DataCell(Text("type")), DataCell(Text(data.type.toString()))] ));
  res.add(DataRow(cells: [const DataCell(Text("version")), DataCell(Text(data.version.toString()))] ));
  if (data.providerName.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("provider_name")), DataCell(Text(data.providerName.toString()))] ));
  if (data.providerUrl.toString() != "null") {
    res.add(DataRow(cells: [const DataCell(Text("provider_url")), DataCell(GestureDetector(
        child: Text(data.providerUrl.toString(), style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
        onTap: () async {
          String url = data.providerUrl.toString();
          if(await canLaunchUrlString(url)) launchUrlString(url);
        },
      ))
    ]));
  }
  if (data.cacheAge.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("cacheAge")), DataCell(Text(data.cacheAge.toString()))] ));

  if (data.title.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("title")), DataCell(Text(data.title.toString()))] ));
  if (data.authorName.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("author_name")), DataCell(Text(data.authorName.toString()))] ));
  if (data.authorUrl.toString() != "null") {
    res.add(DataRow(cells: [const DataCell(Text("author_url")), DataCell(GestureDetector(
      child: Text(data.authorUrl.toString(), style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
      onTap: () async {
        String url = data.authorUrl.toString();
        if(await canLaunchUrlString(url)) launchUrlString(url);
      },
    ))
    ]));
  }
  if (data.thumbnailWidth.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("thumbnail_width")), DataCell(Text(data.thumbnailWidth.toString()))] ));
  if (data.thumbnailHeight.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("thumbnail_height")), DataCell(Text(data.thumbnailHeight.toString()))] ));

  if (data.url.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("url")), DataCell(Text(data.url.toString()))] ));
  if (data.width.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("width")), DataCell(Text(data.width.toString()))] ));
  if (data.height.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("height")), DataCell(Text(data.height.toString()))] ));
  if (data.html.toString() != "null") res.add(DataRow(cells: [const DataCell(Text("html")), DataCell(Text(data.html.toString()))] ));

  return res;
}

String getURL(String raw) {
  String url = "";
  var pattern = RegExp("src=\\\"(.*?]*)\"");
  if (pattern.hasMatch(raw)) {
    var f = pattern.stringMatch(raw).toString();
    var src = f.substring(5, f.length-1);

    url = Uri.dataFromString("<html><body><iframe frameborder='0' style='top:0;left:0;position:absolute;width:100%;height:100%' src=$src allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture' </iframe></body></html>", mimeType: 'text/html').toString();
  } else { //TODO: RichText Support
    url = Uri.dataFromString("<html><body>$raw</body></html>", mimeType: "text/html").toString();
  }

  return url;
}

SizedBox getEmbed(OEmbedData data) {
  final Completer<WebViewController> controller = Completer<WebViewController>();
  const minSize = 200.0;
  const maxSize = 480.0;
  var oEmbedHeight = data.height.toString() == "null" ? 200.0 : math.max(math.min(double.parse(data.height.toString()), maxSize), minSize);

  return SizedBox(
    height: oEmbedHeight,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        WebView( //TODO : 다크모드에 따른 webview 기본색 변경 css
          initialUrl: getURL(data.html.toString()),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            controller.complete(webViewController);
          },
          gestureNavigationEnabled: true,
        ),
      ]
    ),
  );
}

class OEmbedView extends StatefulWidget {
  final OEmbedData data;
  const OEmbedView({Key? key, required this.data}) : super(key: key);

  @override
  State<OEmbedView> createState() => _OEmbedViewState();
}

class _OEmbedViewState extends State<OEmbedView> {
  final ScrollController scrollController = ScrollController();
  bool isScrolling = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { //TODO: dispose correctly; 다크모드 전환하면 고장남
      scrollController.position.isScrollingNotifier.addListener(() =>
        setState(() {
          if (!scrollController.position.isScrollingNotifier.value) {
            isScrolling = true;
          } else {
            isScrolling = false;
          }
        })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text( widget.data.title.toString() == "null" ? widget.data.authorName.toString() : widget.data.title.toString())),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            getEmbed(widget.data),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            DataTable(
              headingRowHeight: 30,
              horizontalMargin: 10,
              columnSpacing: 10,
              dataRowHeight: 40,
              columns: const [
                DataColumn(label: Text('Field')),
                DataColumn(label: Text('Data')),
              ],
              rows: getDataRow(widget.data),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 30,
        height: 30,
        //child: const Icon(Icons.arrow_upward),
        child: AnimatedOpacity(
          opacity: isScrolling ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: FloatingActionButton(
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.zero
            ),
            onPressed: () {
              scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 200));
            },
            tooltip: 'Increment',
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
    );
  }
}