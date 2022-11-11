import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({Key? key}) : super(key: key);

  @override
  _PixabayPageState createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List imageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            print(text);
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 横に並べる個数をここで決めます。今回は 3 にします。
          ),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> image = imageList[index];
            return InkWell(
              onTap: () async {
// まずは一時保存に使えるフォルダ情報を取得します。
                // Future 型なので await で待ちます
                Directory dir = await getTemporaryDirectory();

                Response response = await Dio().get(
                  // previewURL は荒いためより高解像度の webformatURL から画像をダウンロードします。
                  image['webformatURL'],
                  options: Options(
                    // 画像をダウンロードするときは ResponseType.bytes を指定します。
                    responseType: ResponseType.bytes,
                  ),
                );

                // フォルダの中に image.png という名前でファイルを作り、そこに画像データを書き込みます。
                File imageFile = await File('${dir.path}/image.png').writeAsBytes(response.data);

                await Share.shareFiles([imageFile.path]);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image['previewURL'],
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 14,
                          ),
                          Text('${image['likes']}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();

    fetchImages('花');
  }

  void fetchImages(String text) async {
    final response = await Dio().get(
      'https://pixabay.com/api/?key=31242290-4dd02e700fe9f03f56b948457&q=$text&per_page=200',
    );
    imageList = response.data['hits'];
    imageList.sort((a, b) {
      final int aLikes = a['likes'];
      final int bLikes = b['likes'];
      return bLikes.compareTo(aLikes);
    });
    setState(() {});
  }
}
