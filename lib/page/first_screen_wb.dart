// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:dio/dio.dart';

import 'package:google_fonts/google_fonts.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class FirstScreenWb extends StatefulWidget {
  @override
  State<FirstScreenWb> createState() => _FirstScreenWbState();
}

class _FirstScreenWbState extends State<FirstScreenWb> {
  List records = [];
  Future<List> _fetchMenus(
    String view,
  ) async {
    bool loadRemoteDatatSucceed = false;
    // Response response;
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/WbTbl?maxRecords=500&view=$view",
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
  // final style = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  // final style1 = const TextStyle(
  //   fontSize: 15,
  // );

  // Future _fetchMenus() async {
  //   bool loadRemoteDatatSucceed = false;
  //   final url = Uri.parse(
  //     //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&view=Gridview",
  //     //"https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/menus?maxRecords=500&cat2=2",
  //     "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/WbTbl?maxRecords=500&view=Gridview",
  //     //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?%3D1&maxRecords=500&filterByFormula=({cat1}='2')&fields[]=id",
  //     //"https://api.airtable.com/v0/%2FappgEJ6eE8ijZJtAp/menus?fields%5B%5D=&filterByFormula=%7Bcat1%7D+%3D+%222%22',
  //   );
  //   Map<String, String> header = {"Authorization": "Bearer keyyG7I9nxyG5SmTq"};
  //   try {
  //     final response = await http.get(url, headers: header);
  //     Map<String, dynamic> result = json.decode(response.body);
  //     records = result['records'];
  //   } catch (e) {
  //     if (loadRemoteDatatSucceed == false) retryFuture(_fetchMenus, 2000);
  //   }

  //   return records;
  // }

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
                  spacing: 5.0,
                  children: [
                    ElevatedButton(
                      // style: ElevatedButton.styleFrom(
                      //   shape: StadiumBorder(),
                      //   primary: Colors.deepPurpleAccent,
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                      // ),
                      style: ButtonStyle(
                        overlayColor: getColor(Colors.red, Colors.teal),
                        foregroundColor: getColor(Colors.red, Colors.white),
                        backgroundColor: getColor(Colors.white, Colors.red),
                        side: getBorder(Colors.blue, Colors.white),
                      ),
                      child: Text("전체",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () async {
                        // await _fetchMenus("Gridview");
                        setState(() {
                          _fetchMenus("Gridview");
                          currentView = "Gridview";
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: getColor(Colors.red, Colors.teal),
                        foregroundColor: getColor(Colors.red, Colors.white),
                        backgroundColor: getColor(Colors.white, Colors.red),
                        side: getBorder(Colors.blue, Colors.white),
                      ),
                      child: Text("IT",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () async {
                        // await _fetchMenus("quoteview");
                        setState(() {
                          _fetchMenus("itview");
                          currentView = "itview";
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: getColor(Colors.red, Colors.teal),
                        foregroundColor: getColor(Colors.red, Colors.white),
                        backgroundColor: getColor(Colors.white, Colors.red),
                        side: getBorder(Colors.blue, Colors.white),
                      ),
                      child: Text("언어",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () async {
                        // await _fetchMenus("itview");
                        setState(() {
                          _fetchMenus("langview");
                          currentView = "langview";
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: getColor(Colors.red, Colors.teal),
                        foregroundColor: getColor(Colors.red, Colors.white),
                        backgroundColor: getColor(Colors.white, Colors.red),
                        side: getBorder(Colors.blue, Colors.white),
                      ),
                      child: Text("마음심리",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () async {
                        // await _fetchMenus("golfview");
                        setState(() {
                          _fetchMenus("heartview");
                          currentView = "heartview";
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: getColor(Colors.red, Colors.teal),
                        foregroundColor: getColor(Colors.red, Colors.white),
                        backgroundColor: getColor(Colors.white, Colors.red),
                        side: getBorder(Colors.blue, Colors.white),
                      ),
                      child: Text("커뮤니티/맛집",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () async {
                        // await _fetchMenus("bookview");
                        setState(() {
                          _fetchMenus("comview");
                          currentView = "comview";
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: getColor(Colors.red, Colors.teal),
                        foregroundColor: getColor(Colors.red, Colors.white),
                        backgroundColor: getColor(Colors.white, Colors.red),
                        side: getBorder(Colors.blue, Colors.white),
                      ),
                      child: Text("기타",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
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
                                onTap: () {
                                  Get.to(const DetailPage(),
                                      arguments: [
                                        records[index]['fields']['title'],
                                        records[index]['fields']['url'],
                                        //this.records[index]['fields']['cat1'],
                                      ],
                                      transition: Transition.zoom);
                                },
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

  double progress = 0;

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
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();

          /// Stay in app
          return false;
        } else {
          /// Leave app
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                controller.clearCache();
                CookieManager().clearCookies();
              },
            ),
            title: Text(
              Get.arguments[0],
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              IconButton(onPressed: _goBack, icon: Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: _goForward, icon: Icon(Icons.arrow_forward)),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => controller.reload(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _goBack(),
            tooltip: 'Back Page',
            child: const Icon(Icons.arrow_back),
          ),
          body: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                color: Colors.blue,
                backgroundColor: Colors.black12,
              ),
              Expanded(
                child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    gestureNavigationEnabled: true,
                    initialUrl: url, // https://facebook.com
                    onWebViewCreated: (controller) {
                      this.controller = controller;
                    },
                    onProgress: (progress) =>
                        setState(() => this.progress = progress / 100),
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
                      } else if (url.contains('toyo')) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          controller.evaluateJavascript(
                              "document.getElementsByTagName('header')[0].style.display='none'");
                          controller.evaluateJavascript(
                              "document.getElementsByTagName('center')[0].style.display='none'");
                          controller.evaluateJavascript(
                              "document.getElementsByTagName('footer')[0].style.display='none'");
                        });
                      }
                    }),
              ),
            ],
          )),
    );
  }
}

MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
  // ignore: prefer_function_declarations_over_variables
  final getColor = (Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return colorPressed;
    } else {
      return color;
    }
  };

  return MaterialStateProperty.resolveWith(getColor);
}

MaterialStateProperty<BorderSide> getBorder(Color color, Color colorPressed) {
  // ignore: prefer_function_declarations_over_variables
  final getBorder = (Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return BorderSide(color: Colors.transparent);
    } else {
      return BorderSide(color: color, width: 0.1);
    }
  };

  return MaterialStateProperty.resolveWith(getBorder);
}
