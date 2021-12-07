// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PostPage extends StatefulWidget {
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // final style = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  // final style1 = const TextStyle(
  //   fontSize: 15,
  // );

  _postRequest() async {
    final response = await Dio().post(
      'https://api.airtable.com/v0/app95nB2yi0WAYDyn/YtTbl',
      options: Options(
        contentType: 'Application/json',
        headers: {
          'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
          'Accept': 'Application/json',
        },
      ),
      data: {
        'records': [
          {
            'fields': {
              'cat': 'it',
              'title': 'getx 미들웨어1',
              'content': 'getx미들웨어1',
              'details': '말\n',
              'vid': 'Ism-kh-PXP8',
              'min': '0',
              'sec': '10',
            }
          },
        ],
      },
    );

//   // TODO: Whatever you want to do with the response. A good practice is to transform it into models and than work with them
//   print(response);
// } on DioError; catch (e) {
//   // TODO: Error handling
//   if (e.response != null) {
//     print(e.response.data);
//   } else {
//     print(e.request);
//     print(e.message);
//   }
  }

  // _postRequest() async {
  //   var url = Uri.parse('https://api.airtable.com/v0/app95nB2yi0WAYDyn/YtTbl');

  //   http.Response response = await http.post(
  //     url,
  //     headers: {
  //       "Authorization": "Bearer keyyG7I9nxyG5SmTq",
  //       "Content-Type": "application/json",
  //     },
  //     body: {
  //       "fields": {
  //         "cat": "it",
  //         "title": "getx 미들웨어1",
  //         "content": "getx미들웨어1",
  //         "details": "말\n",
  //         "vid": "Ism-kh-PXP8",
  //         "min": "0",
  //         "sec": "10",
  //         // "creator": "janhw01@gmail.com"
  //       },
  //       // "typecast": true
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.list),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.speaker_notes),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.nature_people),
              color: Colors.black,
            )
          ],
        ),
        // ignore: unnecessary_null_comparison
        body: Center(
            child:
                ElevatedButton(child: Text('submit'), onPressed: _postRequest))
        // onPressed: () async {
        //   setState(() {
        //     _postRequest;
        //   });
        );
  }
}
