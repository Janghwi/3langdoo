// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class FirstScreenWb1 extends StatefulWidget {
  @override
  State<FirstScreenWb1> createState() => _FirstScreenWb1State();
}

class _FirstScreenWb1State extends State<FirstScreenWb1> {
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
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/WbTbl1?maxRecords=500&view=Grid view",
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
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;

    return Scaffold(
        extendBodyBehindAppBar: false,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        // ignore: unnecessary_null_comparison
        body: Center(
          heightFactor: 2.0,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            Text(
              'IT뉴스',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            Expanded(
              child: FutureBuilder(
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
                      return GridView.count(
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        scrollDirection: Axis.vertical,
                        childAspectRatio: (itemWidth / itemHeight),
                        // ),
                        physics: const BouncingScrollPhysics(),
                        children: List.generate(
                            records.length,
                            (index) => InkWell(
                                  onTap: () => Get.to(() => const DetailPage(),
                                      arguments: [
                                        records[index]['fields']['title'],
                                        records[index]['fields']['url'],
                                        //this.records[index]['fields']['cat1'],
                                      ],
                                      transition: Transition.zoom),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            records[index]['fields']['title']
                                                .toString(),
                                            style: GoogleFonts.nanumGothic(
                                                // backgroundColor: Colors.white70,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2),
                                        //const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 4, 0, 0),
                                          child: Text(
                                              records[index]['fields']
                                                      ['content']
                                                  .toString(),
                                              style: GoogleFonts.nanumGothic(
                                                // backgroundColor: Colors.white70,
                                                // fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2),
                                        ),

                                        const Divider(
                                          thickness: 3.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      );
                    }
                  }),
            ),
          ]),
        ));
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var title = Get.arguments[0];
  var url = Get.arguments[1];
  late WebViewController controller;

  _goBack() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    }
  }

  _goForward() async {
    if (await controller.canGoForward()) {
      await controller.goForward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Get.arguments[0],
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(onPressed: _goBack, icon: Icon(Icons.arrow_back)),
            IconButton(onPressed: _goForward, icon: Icon(Icons.arrow_forward)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _goBack(),
          tooltip: 'Back Page',
          child: const Icon(Icons.arrow_back),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: url, // https://facebook.com
                onWebViewCreated: (controller) {
                  this.controller = controller;
                },
                onPageStarted: (url) {
                  print('New website: $url');

                  /// Hide Header & Footer
                  if (url.contains('translate.google.com')) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      controller.evaluateJavascript(
                          "document.getElementsByTagName('header')[0].style.display='none'");
                      controller.evaluateJavascript(
                          "document.getElementsByTagName('footer')[0].style.display='none'");
                    });
                  } else if (url.contains('englishcube')) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      controller.evaluateJavascript(
                          "document.getElementsByTagName('header')[0].style.display='none'");
                      controller.evaluateJavascript(
                          "document.getElementsByTagName('footer')[0].style.display='none'");
                    });
                  }
                }),
          ),
        ));
  }
}
