import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OpenAPIPage extends StatefulWidget {
  const OpenAPIPage({Key? key}) : super(key: key);

  @override
  _OpenAPIPageState createState() => _OpenAPIPageState();
}

class _OpenAPIPageState extends State<OpenAPIPage> {
  String answerText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'テキストを入力',
          ),
          onFieldSubmitted: (text) {
            print(text);
            requestChatGPT(text);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(answerText),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void requestChatGPT(String text) async {
    String apiKey = "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";
    String model = "text-davinci-002";
    Dio dio = Dio();
    dio.options.headers = {"Content-Type": "application/json", "Authorization": "Bearer $apiKey"};

    try {
      // Make a request to the GPT API
      Response response = await dio.post(
        "https://api.openai.com/v1/completions",
        data: {
          "model": model,
          "prompt": text,
          "max_tokens": 1024,
          "n": 1,
          "stop": null,
          "temperature": 0.5,
        },
      );

      // Parse the response
      String message = response.data["choices"][0]["text"];
      print(message);
      setState(() {
        answerText = message;
      });
    } catch (e) {
      print(e);
    }
  }
}
