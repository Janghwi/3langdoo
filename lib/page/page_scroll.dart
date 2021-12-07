//** 페이지 스ㅌㅋ롤 태스트
// http 프로토콜
// */ page scroll 테스트

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;

class PageScroll extends StatefulWidget {
  @override
  State<PageScroll> createState() => _PageScrollState();
}

class _PageScrollState extends State<PageScroll> {
  List records = [];
  String offsetId = "";

  Future fetch() async {
    final url = Uri.parse(
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Gridview",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
      "https://api.airtable.com/v0/appd6UAEYNzI9kaVJ/word01?maxRecords=10&view=Gridview",
      // "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=10&view=Gridview",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?%3D1&maxRecords=500&filterByFormula=({cat1}='2')&fields[]=id",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?fields%5B%5D=&filterByFormula=%7Bcat1%7D+%3D+%222%22',
    );
    Map<String, String> header = {"Authorization": "Bearer keyyG7I9nxyG5SmTq"};
    try {
      final response = await http.get(url, headers: header);

      Map<String, dynamic> result = json.decode(response.body);
      final String _offsetId = result['offset'];
      print(_offsetId);
      print(response);

      final List _value = result['records'];
      offsetId = _offsetId;
      // ignore: avoid_function_literals_in_foreach_calls
      _value.forEach((element) {
        records.add(element);
      });
      return;
    } catch (e) {
      print("NULL HTTP1");
    }
  }

  Future nextFetch({String? offsetId}) async {
    final url = Uri.parse(
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Gridview",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
      "https://api.airtable.com/v0/appd6UAEYNzI9kaVJ/word01?maxRecords=10&view=Gridview&offset=$offsetId",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?%3D1&maxRecords=500&filterByFormula=({cat1}='2')&fields[]=id",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?fields%5B%5D=&filterByFormula=%7Bcat1%7D+%3D+%222%22',
    );
    Map<String, String> header = {"Authorization": "Bearer keyyG7I9nxyG5SmTq"};
    try {
      final response = await http.get(url, headers: header);
      Map<String, dynamic> result = json.decode(response.body);
      final String _offsetId = result['offset'];
      final List _value = result['records'];
      this.offsetId = _offsetId;
      // ignore: avoid_function_literals_in_foreach_calls
      _value.forEach((element) {
        // ignore: unnecessary_this
        this.records.add(element);
      });
      return;
    } catch (e) {
      print("NULL HTTP");
    }
  }

  late ScrollController controller;
  @override
  void initState() {
    controller = ScrollController()
      ..addListener(() async {
        if (controller.offset >= controller.position.maxScrollExtent) {
          // ignore: unnecessary_this
          await this.nextFetch(offsetId: this.offsetId);
          setState(() {});
        }
      });
    Future.microtask(() async {
      await fetch();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      // ignore: unnecessary_null_comparison
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: controller,
        itemCount: records.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.black54,
            shadowColor: Colors.grey,
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Stack(alignment: Alignment.center, children: [
              Ink.image(
                // image: NetworkImage(
                //   this.records[index]['fields']['image_url'].toString(),
                // ),
                image: AssetImage('assets/images/012.png'),
                // colorFilter: ColorFilters.greyscale,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.dstATop),
                child: InkWell(
                  onTap: () {},
                  // onTap: () => Get.to(() => TwoMenuPhraseVs(),
                  //     arguments: [
                  //       this.records[index]['fields']['go_tbl'],
                  //       this.records[index]['fields']['go_view'],
                  //       //this.records[index]['fields']['cat1'],
                  //       this.records[index]['fields']['eng']
                  //     ],
                  //     transition: Transition.zoom),
                ),
                height: 180,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 16,
                right: 16,
                left: 16,
                child: Text(
                  records[index]['fields']['title'].toString(),
                  style: GoogleFonts.nanumGothic(
                    // backgroundColor: Colors.white70,
                    // fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 5,
                // left: 16,
                child: Text(
                  records[index]['fields']['content'].toString(),
                  style: GoogleFonts.nanumGothic(
                    // backgroundColor: Colors.white70,
                    // fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
