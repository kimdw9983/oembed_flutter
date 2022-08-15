import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';
import 'second.dart';

const raw = '''oEmbed는 여러 사이트의 컨텐츠가 포함된 url을 내장된 표현으로 보여주게 하는 형식입니다. 
              
가령 Youtube 영상을 커뮤니티 게시판에 공유하거나, SNS의 친구들에게 공유를 하고 싶다면 링크를 올리거나 <iframe>으로 이루어진 소스 코드를 넣어줘야 합니다. 하지만 대부분의 커뮤니티나 SNS에서는 보안상 태그 입력을 허용하고 있지 않습니다.

결국은 Youtube 영상의 링크를 공유할 수 밖에 없는데 예를 들어 FaceBook에 Youtube 링크를 입력하게 되면 아래와 같이 자동으로 Youtube 영상이 붙습니다.

어떻게 이런 것이 가능할까요? 단순하게 생각해본다면 Youtube 영상의 ID 값을 주소에서 파싱하여 Youtube에서 제공해주는 소스코드 양식에 맞게 <iframe>태그를 생성해 넣어줄 수 있습니다.

하지만 이런 방식은 별로 좋지 않습니다. Youtube에서 제공해주는 링크나 소스코드의 양식이 언제든 바뀔 수 있는데 그럴 때 마다 코드를 수정해야합니다. 게다가 이런 컨텐츠를 제공해주는 사이트는 Youtube 말고도 수없이 많은데 이 모든 사이트들을 지원해준다는 것은 정말 힘든 일입니다.

이를 타개하기 위해 oEmbed란 포맷이 제안되었고, 현재 FaceBook은 oEmbed를 활용하고 있습니다.

oEmbed는 2008년 Slack의 공동 창업자인 Cal Henderson 이 제안한 Open Format 입니다. 공식적인 Format은 아니지만 영향력 있는 서비스들( ex: Youtube, Facebook, Slideshare, WorkPress 등) 이 참여하여 상당히 대중화 되었습니다.

간단히 oEmbed를 사용하는 예를 들어보면,
consumer( 위에서 언급했던 Facebook 과 같은 SNS 혹은 커뮤니티) 는 아래와 같은 HTTP Request를 생성합니다.

http://www.youtube.com/oembed?url=http%3A//youtube.com/watch%3Fv%3DM3r2XDceM6A&format=json

그때 Provider( Youtube ) 는 oEmbed response를 돌려줍니다.''';

const String sampleURL = "https://youtu.be/FtutLA63Cp8";
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
            const Padding(padding: EdgeInsets.symmetric(vertical: 12.0)),
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
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: sampleURL,
                hintStyle: const TextStyle(
                  color: Colors.black26,
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                  child: Icon(Icons.search),
                ),
                suffixIcon: IconButton(
                  onPressed: widget.url.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            const Text(
              '여러분이 자주 사용하시는 사이트의 주소를 입력해보세요',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
            const Text(
              'Vimeo, Facebook, Instagram 주소도 됩니다!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(raw,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        ],
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 80,
            child: DrawerHeader(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              margin: const EdgeInsets.only(),
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              child: Text('사이드 메뉴',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.toggle_off),
            title: const Text('다크 모드'),
            onTap: () => {
              MyApp.of(context).changeTheme(ThemeMode.dark),
            },
          ),
          ListTile(
            leading: const Icon(Icons.toggle_on),
            title: const Text('리버스 다크 모드'),
            onTap: () => {
              MyApp.of(context).changeTheme(ThemeMode.light),
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('피드백 보내기'),
            onTap: () => {
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('About Me'),
            onTap: () => {
              Navigator.of(context).pop()
            },
          ),
        ],
      ),
    );
  }
}

class MyHomePage  extends StatelessWidget {
  final TextEditingController urlField = TextEditingController();

  MyHomePage({Key? key}) : super(key: key);

  void openBottomSheet() {
    Get.bottomSheet(
      Stack(
        children: [
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.blue,
              child: InkWell(
                onTap: () {
                  Get.to(() => SecondPage(arg: URLArguments("TEST", urlField.text.isNotEmpty ? urlField.text : sampleURL)));
                },
                child: const SizedBox(
                  height: kToolbarHeight,
                  child: Center(
                    child: Text(
                      '검색',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      enableDrag: true,
      enterBottomSheetDuration: const Duration(milliseconds: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55.0),
        child: AppBar(
          title: Text('oEmbed Interface',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
      body: Stack(
        children: const [
          BackContent(),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.blue,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)
        ),
        child: InkWell(
          onTap: () {
            openBottomSheet();
          },
          child: const SizedBox(
            height: kToolbarHeight,
            child: Center(
              child: Text(
                '사용해보기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}