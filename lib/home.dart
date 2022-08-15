import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'second.dart';

class URLArguments {
  final String title;
  final String url;

  URLArguments(this.title, this.url);
}

class InputForm extends StatefulWidget {
  const InputForm({Key? key, required this.url}) : super(key: key);
  final TextEditingController url;

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            const Text(
              '사용해보기',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            const Text(
              "URL",
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black
              ),
            ),
            TextFormField(
              controller: widget.url,
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
          ],
        ),
      ),
    );
  }
}


class BackContent extends StatelessWidget {
  const BackContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text('oEmbed Interface',
            style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'oEmbed는 여러 사이트의 컨텐츠가 포함된 url을\n내장된 표현으로 보여주게 하는 형식입니다.',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
          ),
        ),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final TextEditingController urlField = TextEditingController();

  void openBottomSheet() {
    Get.bottomSheet(
      Column(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InputForm(url: urlField),
            ),
          ),
        ],
      ),
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          const BackContent(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bottom sheet example'),
                OutlinedButton(
                  onPressed: openBottomSheet,
                  child: const Text('Open'),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SecondPage(arg: URLArguments("TEST", urlField.text.isNotEmpty ? urlField.text : "http"));
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