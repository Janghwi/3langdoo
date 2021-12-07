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
import 'package:flutter_markdown/flutter_markdown.dart';

class FirstScreenAd extends StatefulWidget {
  @override
  State<FirstScreenAd> createState() => _FirstScreenAdState();
}

class _FirstScreenAdState extends State<FirstScreenAd> {
  List records = [];
  // final style = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  // final style1 = const TextStyle(
  //   fontSize: 15,
  // );

  Future _fetchMenus() async {
    bool loadRemoteDatatSucceed = false;
    final url = Uri.parse(
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Gridview",
      //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/acrdTbl?maxRecords=500&view=Grid view",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?%3D1&maxRecords=500&filterByFormula=({cat1}='2')&fields[]=id",
      //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?fields%5B%5D=&filterByFormula=%7Bcat1%7D+%3D+%222%22',
    );
    Map<String, String> header = {"Authorization": "Bearer keyyG7I9nxyG5SmTq"};
    try {
      final response = await http.get(url, headers: header);
      Map<String, dynamic> result = json.decode(response.body);
      records = result['records'];
    } catch (e) {
      if (loadRemoteDatatSucceed == false) retryFuture(_fetchMenus, 2000);
    }

    return records;
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }

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
      body: FutureBuilder(
          future: _fetchMenus(),
          builder: (context, snapshot) {
            print('snapshot No.=>');
            print(records.length);

            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Colors.amber),
              ));
            } else {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Get.to(() => DetailPage(),
                          arguments: [
                            records[index]['fields']['menu'],
                            records[index]['fields']['title'],
                            records[index]['fields']['title1'],
                            records[index]['fields']['title2'],
                            records[index]['fields']['content'],
                            records[index]['fields']['content1'],
                            records[index]['fields']['content2'],
                            //this.records[index]['fields']['cat1'],
                          ],
                          transition: Transition.zoom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            records[index]['fields']['menu'].toString(),
                            style: GoogleFonts.nanumGothic(
                                // backgroundColor: Colors.white70,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.justify,
                          ),
                          //const Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: Text(
                                records[index]['fields']['menuExp'].toString(),
                                style: GoogleFonts.nanumGothic(
                                  // backgroundColor: Colors.white70,
                                  // fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2),
                          ),
                          // Card(
                          //   color: Colors.black54,
                          //   shadowColor: Colors.grey,
                          //   elevation: 8,
                          //   clipBehavior: Clip.antiAlias,
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(14)),
                          //   child: Stack(alignment: Alignment.center, children: [
                          //     Ink.image(
                          //       // image: NetworkImage(
                          //       //   this.records[index]['fields']['image_url'].toString(),
                          //       // ),
                          //       image: const AssetImage('assets/images/012.png'),
                          //       // colorFilter: ColorFilters.greyscale,
                          //       colorFilter: ColorFilter.mode(
                          //           Colors.black.withOpacity(0.3),
                          //           BlendMode.dstATop),
                          //       child: InkWell(
                          //         // onTap: () {},
                          //         onTap: () => Get.to(const DetailPage(),
                          //             arguments: [
                          //               records[index]['fields']['title'],
                          //               records[index]['fields']['content'],
                          //               //this.records[index]['fields']['cat1'],
                          //             ],
                          //             transition: Transition.zoom),
                          //       ),
                          //       height: 180,
                          //       fit: BoxFit.cover,
                          //     ),
                          //     Text(
                          //       records[index]['fields']['title'].toString(),
                          //       style: GoogleFonts.nanumGothic(
                          //           // backgroundColor: Colors.white70,
                          //           fontStyle: FontStyle.italic,
                          //           color: Colors.white,
                          //           fontSize: 18),
                          //     ),
                          //   ]),
                          // ),
                          const Divider(),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var menu = Get.arguments[0];
  var title = Get.arguments[1];
  var title1 = Get.arguments[2];
  var title2 = Get.arguments[3];
  var content = Get.arguments[4];
  var content1 = Get.arguments[5];
  var content2 = Get.arguments[6];

  final TextStyle _titleStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );
  late bool check = false;
  late bool check1 = false;
  late bool check2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          menu,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {}),
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          child: Container(
                            height: 50.0,
                            color: check ? Colors.grey : Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title,
                                  style: _titleStyle,
                                ),
                                Icon(!check ? Icons.add : Icons.minimize)
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              check = !check;
                            });
                          }),
                      check
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(content))
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          child: Container(
                            height: 50.0,
                            color: check1 ? Colors.grey : Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title1,
                                  style: _titleStyle,
                                ),
                                Icon(!check1 ? Icons.add : Icons.minimize)
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              check1 = !check1;
                            });
                          }),
                      check1
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(content1))
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          child: Container(
                            height: 50.0,
                            color: check2 ? Colors.grey : Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title2,
                                  style: _titleStyle,
                                ),
                                Icon(!check2 ? Icons.add : Icons.minimize)
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              check2 = !check2;
                            });
                          }),
                      check2
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(content2))
                          : Container(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
