// ignore_for_file: sized_box_for_whitespace, avoid_print
// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:dio/dio.dart';

import 'package:google_fonts/google_fonts.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FirstScreenYtCre extends StatefulWidget {
  @override
  State<FirstScreenYtCre> createState() => _FirstScreenYtCreState();
}

class _FirstScreenYtCreState extends State<FirstScreenYtCre> {
  List records = [];
  Future<List> _fetchMenus(
    String view,
  ) async {
    // Response response;
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/CreTbl?maxRecords=500&view=$view",
        options: Options(contentType: 'Application/json', headers: {
          'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
          'Accept': 'Application/json',
        }),
      );

      Map<String, dynamic> result = (response.data);

      records = result['records'];
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        // if (loadRemoteDatatSucceed == false) retryFuture(_fetchMenus, 200);
      }
    }
    return records;
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }

  late String currentView = "Gridview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 4.0,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.deepPurpleAccent,
                        // padding:
                        // EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      ),
                      child: Text("전체",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                      onPressed: () async {
                        // await _fetchMenus("Gridview");
                        setState(() {
                          _fetchMenus("Gridview");
                          currentView = "Gridview";
                        });
                      },
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.deepPurpleAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      ),
                      child: Text("IT",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                      onPressed: () async {
                        // await _fetchMenus("quoteview");
                        setState(() {
                          _fetchMenus("itview");
                          currentView = "itview";
                        });
                      },
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.deepPurpleAccent,
                        // shape: OutlinedBorder(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      ),
                      child: Text("언어",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                      onPressed: () async {
                        // await _fetchMenus("itview");
                        setState(() {
                          _fetchMenus("langview");
                          currentView = "langview";
                        });
                      },
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.deepPurpleAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      ),
                      child: Text("마음심리",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                      onPressed: () async {
                        // await _fetchMenus("golfview");
                        setState(() {
                          _fetchMenus("heartview");
                          currentView = "heartview";
                        });
                      },
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.deepPurpleAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      ),
                      child: Text("커뮤니티/맛집",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                      onPressed: () async {
                        // await _fetchMenus("bookview");
                        setState(() {
                          _fetchMenus("comview");
                          currentView = "comview";
                        });
                      },
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.deepPurpleAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      ),
                      child: Text("경제",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                      onPressed: () async {
                        // await _fetchMenus("bookview");
                        setState(() {
                          _fetchMenus("stockview");
                          currentView = "stockview";
                        });
                      },
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.deepPurpleAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      ),
                      child: Text("기타",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                      onPressed: () async {
                        // await _fetchMenus("musicview");
                        setState(() {
                          _fetchMenus("gitaview");
                          currentView = "gitaview";
                        });
                      },
                    ),
                  ],
                ),
                Divider(
                  thickness: 3.0,
                  color: Colors.grey,
                ),
                Expanded(
                  child: FutureBuilder(
                      future: _fetchMenus(currentView),
                      builder: (context, snapshot) {
                        print('snapshot No.=>');
                        print(records.length);

                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.amber),
                          ));
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: records.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () => Get.to(() => const DetailPage(),
                                    arguments: [
                                      records[index]['fields']['title'],
                                      records[index]['fields']['url'],
                                      //this.records[index]['fields']['cat1'],
                                    ],
                                    transition: Transition.zoom),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            fontSize: 16),
                                        textAlign: TextAlign.start,
                                      ),
                                      //const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 4, 0, 0),
                                        child: Text(
                                            records[index]['fields']['content']
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
                              );
                            },
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
            padding: const EdgeInsets.all(2.0),
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
