import 'package:flutter/material.dart';

import 'second.dart';

class URLArguments {
  final String title;
  final String url;

  URLArguments(this.title, this.url);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController urlField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text('oEmbed Interface',
            style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold
            ),),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'oEmbed는 여러 사이트의 컨텐츠가 포함된 url을\n내장된 표현으로 보여주게 하는 형식입니다.',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 65.0)),
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                  const Text(
                    '사용해보기',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                  const Text(
                    "URL",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black
                    ),
                  ),
                  TextFormField(
                    controller: urlField,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(10),
                      hintText: "https://youtu.be/FtutLA63Cp8",
                      hintStyle: TextStyle(
                        color: Colors.black26,
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  const Text(
                    '여러분이 자주 사용하시는 사이트의 주소를 입력해보세요',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],),
      ),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SecondPage(arg: URLArguments("TEST", urlField.text));
            }));
          },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                '검색',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}