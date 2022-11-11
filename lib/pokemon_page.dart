import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({Key? key}) : super(key: key);

  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  List imageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ポケモン'),
        ),
        body: ListView(
          children: imageList
              .map(
                (data) => ListTile(
                  title: Text(data['name']),
                ),
              )
              .toList(),
        ));
  }

  @override
  void initState() {
    super.initState();

    fetchImages();
  }

  void fetchImages() async {
    final response = await Dio().get(
      'https://pokeapi.co/api/v2/pokemon?limit=10000',
    );
    imageList = response.data['results'];
    print(imageList);
    setState(() {});
  }
}
