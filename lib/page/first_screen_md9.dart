// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:like_button/like_button.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:todaylang/controllers/phrase_loader.dart';
import 'package:todaylang/widget/commentbox1.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

import 'commentlist.dart';

class FirstScreenMd9 extends StatefulWidget {
  late PageController pageController;
  double pageOffset = 0;
  double offset = 0;

  @override
  State<FirstScreenMd9> createState() => _FirstScreenMd9State();
}

class _FirstScreenMd9State extends State<FirstScreenMd9> {
  // const FirstScreenMd({Key? key}) : super(key: key);
  @override
  List records = [];

  bool hasBackground = false;

  // int likeCount = 0;
  // @override
  // void initState() {
  //   _fetchDatas();
  //   super.initState();
  // }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<List> _fetchDatas(
      //  String view,
      ) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest?maxRecords=500&view=Gridview",
        // "https://api.airtable.com/v0/app95nB2yi0WAYDyn/comments?maxRecords=200&view=Gridview",
        options: Options(contentType: 'Application/json', headers: {
          'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
          'Accept': 'Application/json',
        }),
      );

      Map<String, dynamic> result = (response.data);

      records = result['records'];
    } on DioError catch (e) {
      if (e.response != null) {
      } else {
        // if (loadRemoteDatatSucceed == false) retryFuture(_fetchDatas, 200);
      }
    }
    if (mounted) {
      setState(() {
        // Your state change code goes here
      });
    }
    return records;
  }

  _readRequest(String? currentId, int readCount) async {
    print('read clicked');
    final response = await Dio().patch(
      'https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest',
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
            "id": currentId,
            'fields': {
              'readCnt': readCount + 1,
              // 'likeCnt': likeController.text,
            }
          },
        ],
      },
    );
  }

  final ctr = Get.put(PhrasesLoader());

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    var offset = 0;
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));

    return Scaffold(
        extendBodyBehindAppBar: true,

        // ignore: unnecessary_null_comparison
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            setState(() {});
            await _fetchDatas();
            // await ctr.loadPhrasesFile();
          },
          child: FutureBuilder<List<dynamic>>(
              future: _fetchDatas(),
              builder: (context, snapshot) {
                // print('snapshot No.=>');
                // print(records.length);
                // print("get records:" "{}");
                // List<bool> isLiked = List.filled(records.length, false);
                // print('22 builder passed');
                if (!snapshot.hasData) {
                  return Center(
                      child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: 0.5,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey,
                      valueColor: const AlwaysStoppedAnimation(Colors.amber),
                    ),
                  ));
                } else {
                  return Column(
                    children: [
                      Tabs(),
                      Expanded(
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: records.length,
                            // itemCount: PhrasesLoader.to.records.length,
                            // itemCount: PhrasesLoader.to.records.length,
                            itemBuilder: (BuildContext context, int index) {
                              // List<bool> isLiked = List.filled(records.length, false);
                              // print('PhrasesLoader.to.records.length');
                              // print(snapshot);
                              // print(PhrasesLoader.to.records.length);
                              // print(records[index]['fields']['likeCnt']);
                              // int likeCount =
                              //     records[index]['fields']['likeCnt'];
                              // ctr.currentIdSave.value = ctr.records[index]['id'];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _readRequest(
                                            records[index]['id'],
                                            records[index]['fields']
                                                ['readCnt']);
                                        Get.to(() => DetailPage(),
                                            arguments: [
                                              records[index]['fields']['title'],
                                              records[index]['fields']
                                                  ['content'],
                                              records[index]['id'],
                                              records[index]['fields']
                                                  ['likeCnt'],
                                              //this.records[index]['fields']['cat1'],
                                            ],
                                            duration: Duration(seconds: 2),
                                            transition: Transition.fadeIn,
                                            preventDuplicates: false);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            records[index]['fields']['level']
                                                .toString(),

                                            // PhrasesLoader
                                            // .to.records[index]['fields']['title']
                                            // .toString(),
                                          ),
                                          ColorFiltered(
                                            colorFilter:
                                                ColorFilter.srgbToLinearGamma(),
                                            // Colors.grey, BlendMode.saturation),
                                            child: Card(
                                              color: Colors.black54,
                                              shadowColor: Colors.amber,
                                              elevation: 0,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                              child: Column(children: [
                                                ClipRRect(
                                                  child: CachedNetworkImage(
                                                    alignment:
                                                        Alignment(-1, -1.0),
                                                    fit: BoxFit.contain,
                                                    imageUrl: records[index]
                                                                    ['fields']
                                                                ['Attachments']
                                                            [0]['thumbnails']
                                                        ['large']['url'],
                                                    width: MediaQuery.maybeOf(
                                                                context)!
                                                            .size
                                                            .width *
                                                        0.97,
                                                    height: MediaQuery.maybeOf(
                                                                context)!
                                                            .size
                                                            .height *
                                                        0.10,
                                                  ),
                                                ),
                                                Text(
                                                  records[index]['fields']
                                                          ['title']
                                                      .toString(),
                                                  // style: GoogleFonts.aBeeZee(
                                                  // style: GoogleFonts.hiMelody(
                                                  // style: GoogleFonts.blackHanSans(
                                                  style: GoogleFonts.notoSans(
                                                      // backgroundColor: Colors.white70,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          // Divider(
                                          //   indent: 30,
                                          // ),
                                          IconButton(
                                            icon: Icon(Icons.speaker_notes,
                                                color: Colors.amber),
                                            onPressed: () {
                                              Get.to(() => CommentWrite());
                                            },
                                          ),
                                          // Divider(
                                          //   indent: 10,
                                          // ),
                                          Text(records[index]['fields']
                                                  ['cmtCnt']
                                              .toString()),
                                          Divider(
                                            indent: 30,
                                          ),
                                          //--------------------------------------------------------
                                          IconButton(
                                            icon: Icon(Icons.favorite_border,
                                                color: Colors.amber),
                                            onPressed: () {
                                              Get.to(() {
                                                return DetailPage();
                                              },
                                                  arguments: [
                                                    records[index]['fields']
                                                        ['title'],
                                                    records[index]['fields']
                                                        ['content'],
                                                    records[index]['id'],
                                                    records[index]['fields']
                                                        ['likeCnt'],
                                                    // records[index]['fields']
                                                    //         ['Attachments'][0]
                                                    //     ['thumbnails']['large']['url']
                                                    // records[index]['fields']
                                                    //     ['readCnt']
                                                    //this.records[index]['fields']['cat1'],
                                                  ],
                                                  transition: Transition.zoom,
                                                  preventDuplicates: true);
                                            },
                                          ),
                                          Text(records[index]['fields']
                                                  ['likeCnt']
                                              .toString()),
                                          // onPressed: () async {
                                          //   int likeCount = records[index]
                                          //       ['fields']['likeCnt'];
                                          //   int count = 0;
                                          //   if (!isLiked[index] && count == 0) {
                                          //     print("pressed 1setstate passed :");
                                          //     likeCount += 1;
                                          //     _postRequest(records[index]['id'],
                                          //         likeCount);
                                          //     count = 1;
                                          //     isLiked[index] = !isLiked[index];
                                          //     setState(() {});
                                          //   }
                                          // },

                                          Divider(
                                            indent: 10,
                                          ),
                                          // Text(records[index]['fields']['likeCnt']
                                          //     .toString()),

                                          // Divider(
                                          //   indent: 10,
                                          // ),
                                          // Icon(Icons.share),
                                          // Text('Share!'),
                                        ],
                                      ),
                                    ),
                                    // Divider(
                                    //   color: Colors.black12,
                                    //   thickness: 8.0,
                                    // ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }
              }),
        ));
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  // const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var title = Get.arguments[0];
  var content = Get.arguments[1];
  var id = Get.arguments[2];
  int likecount = Get.arguments[3];
  // var imageUrl = Get.arguments[4];

  int index = 0;
  String? currentIdSave;
  // int? likeCount = likecount ;

  Future<bool> onLikeButtonTapped(
    bool isLiked,
  ) async {
    {
      final response = Dio().patch(
        'https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest',
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
              "id": id,
              'fields': {
                'likeCnt': likecount + 1,
                // 'likeCnt': likeCount + 1,
                // 'likeCnt': likeController.text,
              }
            },
          ],
        },
      );
    }

    return !isLiked;
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    size: 20,
                  ),
                  color: Colors.grey,
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey[200],
                child: LikeButton(
                  onTap: onLikeButtonTapped,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: buildFAB(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // child: Image.network(imageUrl),
                // child: Image.network(Get.arguments[4]),
                child: Image(image: AssetImage('assets/images/woman.png')),
              )),
              Expanded(
                child: Markdown(
                    data: Get.arguments[1],
                    styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
                    physics: const BouncingScrollPhysics(),
                    styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(color: Colors.black),
                        h2: const TextStyle(color: Colors.black),
                        h3: const TextStyle(color: Colors.black),
                        h4: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w100),
                        h5: const TextStyle(
                          color: Colors.black87,
                        ),
                        h6: const TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.w600),
                        p: const TextStyle(
                          color: Colors.black54,
                        ),
                        strong: const TextStyle(color: Colors.black87),
                        blockSpacing: 10.0,
                        listIndent: 24.0,
                        horizontalRuleDecoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        blockquote: const TextStyle(color: Colors.red))),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: buildNavigationBar(),
    );
  }

  Widget buildNavigationBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        indicatorColor: Colors.blue.shade100,
      ),
      child: NavigationBar(
        height: 60,
        backgroundColor: Color(0xFFf1f5fb),
        selectedIndex: index,
        onDestinationSelected: (index) => setState(() => this.index = index),
        // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        // animationDuration: Duration(seconds: 3),
        // ignore: prefer_const_literals_to_create_immutables
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.share_outlined),
            selectedIcon: Icon(Icons.share),
            label: 'Share',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Translation',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Speak',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined, size: 30),
            selectedIcon: Icon(Icons.chat, size: 30),
            label: 'Comment',
          ),
        ],
      ),
    );
  }

  Widget? buildFAB() {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    switch (index) {
      case 0:
        return Container(
          height: 54,
          child: FloatingActionButton.extended(
            shape: shape,
            icon: Icon(Icons.share),
            label: Text('Services'),
            onPressed: () {},
          ),
        );
      case 1:
        return FloatingActionButton.extended(
          shape: shape,
          icon: Icon(Icons.chat_bubble_outline),
          label: Text('New Chat'),
          onPressed: () {},
        );
      case 2:
        return FloatingActionButton.extended(
          shape: shape,
          icon: Icon(Icons.add),
          label: Text('New Space'),
          onPressed: () {},
        );
      case 3:
        return FloatingActionButton.extended(
          shape: shape,
          icon: Icon(Icons.add),
          label: Text('View Comment'),
          onPressed: () => Get.to(() => CommentsList()),
        );
      default:
        return null;
    }
  }
}

// ignore: use_key_in_widget_constructors
class Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      // ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[
        SizedBox(width: 24),
        MyTab(text: 'Recent', isSelected: true),
        MyTab(text: 'Share', isSelected: false),
        MyTab(text: 'Notice', isSelected: false),
      ],
    );
  }
}

class MyTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const MyTab({Key? key, required this.isSelected, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: isSelected ? 16 : 14,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Container(
            height: 6,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected ? Color(0xFFFF5A1D) : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
