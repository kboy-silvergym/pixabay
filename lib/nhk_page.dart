import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NHKPage extends StatefulWidget {
  const NHKPage({Key? key}) : super(key: key);

  @override
  _NHKPageState createState() => _NHKPageState();
}

class _NHKPageState extends State<NHKPage> {
  List programList = [];

  final apiKey = 'xEVAUSaU1SwgDRsqT9i8GKmm3cT4MeGW';
  final areaId = 130; // 130は東京 ..その他参考:https://api-portal.nhk.or.jp/doc-list-v2-con
  final serviceId = 'e1'; // e1はNHKEテレ ..その他参考:https://api-portal.nhk.or.jp/doc-list-v2-con

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('今日のNHK'),
      ),
      body: ListView(
        children: programList
            .map(
              (p) => ListTile(
                leading: Text(
                  dateToTimeString(DateTime.parse(p['start_time'])),
                ),
                title: Text(
                  p['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  p['subtitle'],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    fetchProgramList();
  }

  void fetchProgramList() async {
    final date = getTodayData();
    final response = await Dio().get(
      'https://api.nhk.or.jp/v2/pg/list/$areaId/$serviceId/$date.json?key=$apiKey',
    );
    programList = response.data['list']['e1'];
    programList.sort((a, b) {
      final String aDate = a['start_time'];
      final String bDate = b['start_time'];
      return aDate.compareTo(bDate);
    });
    print(programList);
    setState(() {});
  }

  String getTodayData() {
    DateTime now = DateTime.now();
    String date = dateToDateString(now);
    return date;
  }

  String dateToDateString(DateTime dateTime) {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(dateTime);
    return date;
  }

  String dateToTimeString(DateTime dateTime) {
    DateFormat outputFormat = DateFormat('MM月dd日 HH:mm');
    String date = outputFormat.format(dateTime);
    return date;
  }
}
