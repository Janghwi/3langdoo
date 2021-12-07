//**2021.11.30 pixel overflow수정완료 */
//**2021.11.30 MD94에서 copy하여 future builder를 gridview로 바굼
//그러나 circularprogress는 안나옴 이유는 fetch가 없기 때문이다 다시 md94로 감 */
//**2021.11.30 다국어 적용함 메뉴및 내용도 같이 적용함 */
//**2021. 11.25 ** TTS적용함 */

//**단어 화면은 메뉴로 들어가야 하기에 메뉴를 둠
//togglebutton을 새롭게 적용함. 색갈지정등
//secone menu로 변경하고 두번재 메뉴를 둠
//** ㅣListview.builder로 만듬 */
//캡쳐&쉐어를 적용함
//단어부문의 모듈 첫페이지 */
// ignore_for_file: sized_box_for_whitespace

import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:like_button/like_button.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todaylang/controllers/lang_controller.dart';
import 'package:todaylang/widget/commentbox1.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum MenuType { first, second, third }

const kBackgroundColor = Color(0xFFF1EFF1);
const kPrimaryColor = Color(0xFF035AA6);
const kSecondaryColor = Color(0xFFEDFDFD);
// const kSecondaryColor = Color(0xFFFFA41B);
const kTextColor = Color(0xFF000839);
const kTextLightColor = Color(0xFF747474);
const evenColor = Color(0xFFE6E9E9);
// const evenColor = Color(0xFF40BAD5);

const kDefaultPadding = 20.0;

// var gooHi = GoogleFonts.hiMelody(
var gooHi = GoogleFonts.doHyeon(
    // backgroundColor: Colors.white70,
    fontStyle: FontStyle.normal,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16);

// our default Shadow
const kDefaultShadow = BoxShadow(
  offset: Offset(0, 10),
  blurRadius: 27,
  color: Colors.black12, // Black color with 12% opacity
);

class FirstScreenMd95 extends StatefulWidget {
  @override
  State<FirstScreenMd95> createState() => _FirstScreenMd95State();
}

class _FirstScreenMd95State extends State<FirstScreenMd95> {
  // const FirstScreenMd({Key? key}) : super(key: key);
  @override
  List records = [];

  bool hasBackground = false;

  // int likeCount = 0;
  // @override
  // void initState() {
  //   _fetchDatas("Gridview");
  //   super.initState();
  // }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<List> _fetchDatas(
    String view,
  ) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/wordsmenu01?maxRecords=500&view=$view",
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
        // 화면 백 했을때 refresh가 된다. 좋아요 버튼의 숫자가 증가한것을 반영
      });
    }
    return records;
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }

  _readRequest(String? currentId, int readCount) async {
    // print('read clicked');
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

  // final ctr = Get.put(PhrasesLoader());
  LangController c = Get.put(LangController());

  bool isLiked = false;
  late String currentView = "Gridview";
  Color mColor = Color(0xFF6200EE),
      mColor0 = Color(0xFF6200EE),
      mColor1 = Color(0xFF6200EE);
  final isSelected = <bool>[true, false, false];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,

        // ignore: unnecessary_null_comparison
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            if (mounted) {
              setState(() {});
              await _fetchDatas(currentView);
              // await ctr.loadPhrasesFile();
            }
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  // alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Container(
                      color: Colors.green.withOpacity(0.5),
                      child: ToggleButtons(
                        color: Colors.black.withOpacity(0.9),
                        selectedColor: Colors.white,
                        renderBorder: false,
                        selectedBorderColor: mColor0,
                        fillColor: Colors.lightBlue.shade900,
                        highlightColor: Colors.orange,
                        // splashColor: Colors.grey.withOpacity(0.12),
                        // hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                        // borderRadius: BorderRadius.circular(4.0),
                        constraints: BoxConstraints(minHeight: 36.0),
                        isSelected: isSelected,
                        onPressed: (int newIndex) {
                          // Respond to button selection
                          if (mounted) {
                            setState(() {
                              for (int index = 0;
                                  index < isSelected.length;
                                  index++) {
                                if (index == newIndex) {
                                  if (index == 0) {
                                    _fetchDatas("Gridview");
                                    currentView = "Gridview";
                                  }
                                  if (index == 1) {
                                    _fetchDatas("basicview");
                                    currentView = "basicview";
                                  }
                                  if (index == 2) {
                                    _fetchDatas("advancedview");
                                    currentView = "advancedview";
                                  }
                                  isSelected[index] = true;
                                } else {
                                  isSelected[index] = false;
                                }
                              }
                            });
                          }
                        },
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Recent',
                              style: TextStyle(fontSize: 12),

                              // isSelected ? 16 : 14
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Basic',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Advanced',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: records.length,
                        // itemCount: PhrasesLoader.to.records.length,
                        // itemCount: PhrasesLoader.to.records.length,
                        itemBuilder: (BuildContext context, int index) {
                          // if (index == records.length)
                          //   return CircularProgressIndicator();
                          // List<bool> isLiked = List.filled(records.length, false);
                          // print('PhrasesLoader.to.records.length');
                          // print(snapshot);
                          // print(PhrasesLoader.to.records.length);
                          // print(records[index]['fields']['likeCnt']);
                          // ctr.currentIdSave.value = ctr.records[index]['id'];

                          // int likeCount =
                          //     records[index]['fields']['likeCnt'];

                          return GestureDetector(
                            onTap: () {
                              // _readRequest(records[index]['id'],
                              //     records[index]['fields']['readCnt']);
                              Get.to(() => SecondmenuPage(),
                                  arguments: [
                                    records[index]['fields']['go_tbl'],
                                    records[index]['fields']['go_view'],
                                    records[index]['fields']['token_name'],
                                    // records[index]['fields']['content'],
                                    // records[index]['id'],
                                    // records[index]['fields']['likeCnt'],
                                    // records[index]['fields']['Attachments']
                                    //     [0]['thumbnails']['large']['url'],
                                    // records[index]['fields']
                                    //     ['content_copy'],

                                    //this.records[index]['fields']['cat1'],
                                  ],
                                  duration: Duration(seconds: 1),
                                  transition: Transition.fadeIn,
                                  preventDuplicates: false);
                            },
                            child: Column(
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.srgbToLinearGamma(),
                                  // Colors.grey, BlendMode.saturation),
                                  child: Container(
                                    height: size.height * 0.2,
                                    // height: 150,
                                    width: size.width * 0.4,
                                    // width: 260,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: index.isEven
                                          ? evenColor
                                          : kSecondaryColor,
                                      // color: index.isEven
                                      // ? evenColor
                                      // : kSecondaryColor,
                                      boxShadow: const [kDefaultShadow],
                                    ),
                                    // color: Colors.amber,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 20 / 2,
                                    ),
                                    child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Container(
                                            height: 160,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: index.isEven
                                                  ? evenColor
                                                  : kSecondaryColor,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              boxShadow: [kDefaultShadow],
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 0,
                                            child: Hero(
                                              tag: records[index]['id'],
                                              //카드안 이미지
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                height: 70,
                                                width: 100,
                                                child: Opacity(
                                                  opacity: 0.3,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: CachedNetworkImage(
                                                      imageUrl: records[index]
                                                                      ['fields']
                                                                  [
                                                                  'Attachments']
                                                              [0]['thumbnails']
                                                          ['large']['url'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            //* 카드안 카운트 정보

                                            child: SizedBox(
                                              width: size.width - 100,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Spacer(),
                                                  // Spacer(),
                                                  // Spacer(),
                                                  Transform.rotate(
                                                    angle: -math.pi / 120,
                                                    child: Column(
                                                      children: [
                                                        Obx(
                                                          () => Text(
                                                            records[index][
                                                                        'fields']
                                                                    [c.setLang
                                                                        .value]
                                                                .toString(),
                                                            // style: GoogleFonts.aBeeZee(
                                                            // style: GoogleFonts.hiMelody(
                                                            // style: GoogleFonts.blackHanSans(
                                                            style: GoogleFonts
                                                                .blackHanSans(
                                                                    letterSpacing:
                                                                        0.2,
                                                                    // backgroundColor: Colors.white70,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade200,
                                                                    fontSize:
                                                                        18),
                                                            // overflow:
                                                            //     TextOverflow
                                                            //         .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          // Text(
                                                          //   records[index][
                                                          //               'fields']
                                                          //           ['jap']
                                                          //       .toString(),
                                                          //   // style: GoogleFonts.aBeeZee(
                                                          //   // style: GoogleFonts.hiMelody(
                                                          //   // style: GoogleFonts.blackHanSans(
                                                          //   style: GoogleFonts
                                                          //       .blackHanSans(
                                                          //           letterSpacing:
                                                          //               0.2,
                                                          //           // backgroundColor: Colors.white70,
                                                          //           fontStyle:
                                                          //               FontStyle
                                                          //                   .normal,
                                                          //           fontWeight:
                                                          //               FontWeight
                                                          //                   .w500,
                                                          //           color: Colors
                                                          //               .black38,
                                                          //           fontSize:
                                                          //               16),
                                                          //   overflow:
                                                          //       TextOverflow
                                                          //           .ellipsis,
                                                          //   maxLines: 2,
                                                          // ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  // Spacer(),
                                                  //레벨과 좋아요 들어가는 부분
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              kDefaultPadding *
                                                                  0.8, // 30 padding
                                                          vertical:
                                                              kDefaultPadding /
                                                                  8, // 5 top and bottom
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    22),
                                                            topRight:
                                                                Radius.circular(
                                                                    22),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          records[index]
                                                                  ['fields']
                                                              ['level'],
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  // backgroundColor: Colors.white70,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }))
              ]),
        ));
  }
}

//**
//
//
//
//
//** SECOND MENU */         //**SECOND MENU */
//** SECOND MENU */         //**SECOND MENU */
//
//
//
//
//
//
//
// */
class SecondmenuPage extends StatefulWidget {
  const SecondmenuPage({Key? key}) : super(key: key);

  // const SecondmenuPage({Key? key}) : super(key: key);

  @override
  _SecondmenuPageState createState() => _SecondmenuPageState();
}

class _SecondmenuPageState extends State<SecondmenuPage> {
  var tableName = Get.arguments[0];
  var viewName = Get.arguments[1];
  var token = Get.arguments[2];
  // var content = Get.arguments[1];
  // var content1 = Get.arguments[5];
  // var id = Get.arguments[2];
  // int likecount = Get.arguments[3];
  // var imageUrl = Get.arguments[4];
  int index = 0;
  String? currentIdSave;
  List _records = [];

  @override
  void initState() {
    _fetchDatas(tableName, viewName, token);
    super.initState();
  }

  Future<List> _fetchDatas(
    String tableName,
    String viewName,
    String token,
  ) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/$token/$tableName?maxRecords=500&view=$viewName",
        // "https://api.airtable.com/v0/app95nB2yi0WAYDyn/comments?maxRecords=200&view=Gridview",
        options: Options(contentType: 'Application/json', headers: {
          'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
          'Accept': 'Application/json',
        }),
      );

      Map<String, dynamic> result = (response.data);

      _records = result['records'];
    } on DioError catch (e) {
      if (e.response != null) {
      } else {
        // if (loadRemoteDatatSucceed == false) retryFuture(_fetchDatas, 200);
      }
    }
    if (mounted) {
      setState(() {
        // 화면 백 했을때 refresh가 된다. 좋아요 버튼의 숫자가 증가한것을 반영
      });
    }
    // print(_records);

    return _records;
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }
  // int? likeCount = likecount ;

  // Future<bool> onLikeButtonTapped(
  //   bool isLiked,
  // ) async {
  //   {
  //     final response = Dio().patch(
  //       'https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest',
  //       options: Options(
  //         contentType: 'Application/json',
  //         headers: {
  //           'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
  //           'Accept': 'Application/json',
  //         },
  //       ),
  //       data: {
  //         'records': [
  //           {
  //             "id": id,
  //             'fields': {
  //               'likeCnt': likecount + 1,
  //               // 'likeCnt': likeCount + 1,
  //               // 'likeCnt': likeController.text,
  //             }
  //           },
  //         ],
  //       },
  //     );
  //   }
  // if (mounted) {

  //   setState(() {});
  // }
  //   return !isLiked;
  //   // ignore: dead_code
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  final controller = ScreenshotController();
  Color mColor = Color(0xFF6200EE),
      mColor0 = Color(0xFF6200EE),
      mColor1 = Color(0xFF6200EE);
  final isSelected = <bool>[true, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // print(content);

    return Screenshot(
      controller: controller,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              Get.arguments[0],
              style: const TextStyle(color: Colors.black, fontSize: 14),
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(8),
              //     child: Container(
              //       color: Colors.grey[200],
              //       child: LikeButton(
              //         // bubblesSize: 25.0,
              //         onTap: onLikeButtonTapped,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          floatingActionButton: buildFAB(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    children: [
                      Container(
                        color: Colors.green.withOpacity(0.5),
                        child: ToggleButtons(
                          color: Colors.black.withOpacity(0.9),
                          selectedColor: Colors.white,
                          renderBorder: false,
                          selectedBorderColor: mColor0,
                          fillColor: Colors.lightBlue.shade900,
                          highlightColor: Colors.orange,
                          // splashColor: Colors.grey.withOpacity(0.12),
                          // hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                          // borderRadius: BorderRadius.circular(4.0),
                          // constraints: BoxConstraints(minHeight: 36.0),
                          isSelected: isSelected,
                          onPressed: (int newIndex) {
                            // Respond to button selection
                            if (mounted) {
                              setState(() {
                                for (int index = 0;
                                    index < isSelected.length;
                                    index++) {
                                  if (index == newIndex) {
                                    isSelected[index] = true;
                                  } else {
                                    isSelected[index] = false;
                                  }
                                }
                              });
                            }
                          },

                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '본문',
                                style: TextStyle(fontSize: 16),

                                // isSelected ? 16 : 14
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '단어',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '스피킹',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '겸양어',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '설명',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: AnimationLimiter(
                      child: ListView.builder(
                          itemCount: _records.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: Duration(milliseconds: 2000),
                                child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                        delay: Duration(milliseconds: 100),
                                        child: listItem(index))));
                          }),
                    ),
                  )),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: buildNavigationBar1(),
        ),
      ),
    );
  }

  Widget listItem(int index) {
    return GestureDetector(
      onTap: () {
        // _readRequest(records[index]['id'],
        //     records[index]['fields']['readCnt']);
        Get.to(() => DetailPage(),
            arguments: [
              _records[index]['fields']['go_tbl'],
              _records[index]['fields']['go_view'],
              _records[index]['fields']['token_name'],

              //this.records[index]['fields']['cat1'],
            ],
            duration: Duration(seconds: 1),
            transition: Transition.fadeIn,
            preventDuplicates: false);
      },
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                padding: EdgeInsets.all(16),
                child: CachedNetworkImage(
                  imageUrl: _records[index]['fields']['Attachments'][0]
                      ['thumbnails']['large']['url'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  _records[index]['fields']['jap'],
                  style: GoogleFonts.nanumGothicCoding(
                      // letterSpacing: 0.2,
                      // backgroundColor: Colors.white70,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              )
            ],
          )),
    );
  }

  // Widget buildNavigationBar1() {
  //   return NavigationBarTheme(
  //     data: NavigationBarThemeData(
  //       labelTextStyle: MaterialStateProperty.all(
  //         TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //       ),
  //       indicatorColor: Colors.blue.shade100,
  //     ),
  //     child: NavigationBar(
  //       height: 60,
  //       backgroundColor: Color(0xFFf1f5fb),
  //       selectedIndex: index,
  //       onDestinationSelected: (index) => setState(() => this.index = index),
  //       // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
  //       // animationDuration: Duration(seconds: 3),
  //       // ignore: prefer_const_literals_to_create_immutables
  //       destinations: [
  //         NavigationDestination(
  //           icon: Icon(Icons.share_outlined),
  //           selectedIcon: Icon(Icons.share),
  //           label: 'Share',
  //         ),
  //         NavigationDestination(
  //           icon: Icon(Icons.chat_bubble_outline),
  //           selectedIcon: Icon(Icons.chat_bubble),
  //           label: 'Translation',
  //         ),
  //         NavigationDestination(
  //           icon: Icon(Icons.group_outlined),
  //           selectedIcon: Icon(Icons.group),
  //           label: 'Speak',
  //         ),
  //         NavigationDestination(
  //           icon: Icon(Icons.chat_outlined, size: 30),
  //           selectedIcon: Icon(Icons.chat, size: 30),
  //           label: 'Comment',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget? buildFAB() {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    switch (index) {
      case 0:
        return Container(
          height: 30,
          child: FloatingActionButton.extended(
            shape: shape,
            icon: Icon(Icons.share),
            label: Text('Capture & Share'),
            backgroundColor: Colors.yellow[400],
            foregroundColor: Colors.black54,
            onPressed: () async {
              final image = await controller.capture();
              // final image = await controller.captureFromWidget(MarkdownWidget());
              // ignore: unnecessary_null_comparison
              if (image == null) return;
              saveAndShare(image);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Screenshot Completed...',
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Colors.blueGrey,
              ));
            },
            // final = image await controller.capture();
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
          label: Text('View & Comment Write'),
          onPressed: () => Get.to(() => CommentWrite()),
        );
      default:
        return null;
    }
  }
}

Future saveAndShare(Uint8List bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final image = File('${directory.path}/flutter.png');
  image.writeAsBytesSync(bytes);

  const text = 'Shared From Enkornese';
  await Share.shareFiles([image.path], text: text);
}

Future<String> saveImage(Uint8List bytes) async {
  await [Permission.storage].request();

  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');
  final name = 'screenshot_$time';
  final result = await ImageGallerySaver.saveImage(bytes, name: name);

  return result['filePath'];
}

//***
//
//
//
//
//** DETAIL PAGE */   //**DETAIL PAGE *///** DETAIL PAGE */
//** DETAIL PAGE */   //**DETAIL PAGE *///** DETAIL PAGE */
//** DETAIL PAGE */   //**DETAIL PAGE *///** DETAIL PAGE */
//
//
//
//
//
//
// */
// detail page
class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  // const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var tableName = Get.arguments[0];
  var viewName = Get.arguments[1];
  var token = Get.arguments[2];
  // int likecount = Get.arguments[3];
  // var imageUrl = Get.arguments[4];
  int index = 0;
  String? currentIdSave;
  List _records = [];
  // int? likeCount = likecount ;

  Future<List> _fetchDatas(
    String tableName,
    String viewName,
    String token,
  ) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/$token/$tableName?maxRecords=500&view=$viewName",
        // "https://api.airtable.com/v0/app95nB2yi0WAYDyn/comments?maxRecords=200&view=Gridview",
        options: Options(contentType: 'Application/json', headers: {
          'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
          'Accept': 'Application/json',
        }),
      );

      Map<String, dynamic> result = (response.data);

      _records = result['records'];
    } on DioError catch (e) {
      if (e.error is SocketException) {
        print('socket exception occured ');
      } else {
        //  if (loadRemoteDatatSucceed == false) retryFuture(_fetchDatas, 200);
      }
    }
    if (mounted) {
      setState(() {
        // 화면 백 했을때 refresh가 된다. 좋아요 버튼의 숫자가 증가한것을 반영
      });
    }
    // print(_records);

    return _records;
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }

  // Future<bool> onLikeButtonTapped(
  //   bool isLiked,
  // ) async {
  //   {
  //     final response = Dio().patch(
  //       'https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest',
  //       options: Options(
  //         contentType: 'Application/json',
  //         headers: {
  //           'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
  //           'Accept': 'Application/json',
  //         },
  //       ),
  //       data: {
  //         'records': [
  //           {
  //             "id": id,
  //             'fields': {
  //               'likeCnt': likecount + 1,
  //               // 'likeCnt': likeCount + 1,
  //               // 'likeCnt': likeController.text,
  //             }
  //           },
  //         ],
  //       },
  //     );
  //   }
  //   // if (mounted) {

  //   //   setState(() {});
  //   // }
  //   return !isLiked;
  //   // ignore: dead_code
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  final controller = ScreenshotController();
  Color mColor = Color(0xFF6200EE),
      mColor0 = Color(0xFF6200EE),
      mColor1 = Color(0xFF6200EE);
  final isSelected = <bool>[true, false, false, false, false, false];
  bool isVisible = true;
  bool engisVisible = true;
  bool korisVisible = true;
  bool japisVisible = true;
  bool prnisVisible = true;
  bool isTransparent = false;

  late String currentView = "Gridview";

  Future<void> phraseSpeech(String langCode, String phrase) async {
    FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage(langCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(phrase);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // print(content);

    return Screenshot(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Get.arguments[0],
            style: const TextStyle(color: Colors.black, fontSize: 14),
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
                      // bubblesSize: 25.0,
                      // onTap: onLikeButtonTapped,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: [
                    ToggleButtons(
                      color: Colors.black.withOpacity(0.9),
                      selectedColor: mColor,
                      selectedBorderColor: mColor0,
                      fillColor: mColor1.withOpacity(0.2),
                      splashColor: Colors.grey.withOpacity(0.12),
                      hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                      borderRadius: BorderRadius.circular(4.0),
                      constraints: BoxConstraints(minHeight: 36.0),
                      isSelected: isSelected,
                      onPressed: (index) {
                        // Respond to button selection
                        if (mounted) {
                          setState(() {
                            isSelected[0] = false;
                            isSelected[1] = false;
                            isSelected[2] = false;
                            isSelected[3] = false;
                            isSelected[4] = false;
                            isSelected[5] = false;
                            if (index == 0) {
                              mColor = Colors.blue;
                              mColor0 = Colors.blue;
                              mColor1 = Colors.blue;
                              setState(() {
                                engisVisible = true;
                                korisVisible = true;
                                japisVisible = true;
                              });
                              // content = Get.arguments[1];
                              // print(content);
                            }

                            if (index == 1) {
                              mColor = Colors.blue;
                              mColor0 = Colors.blue;
                              mColor1 = Colors.blue;
                              setState(() {
                                engisVisible = true;
                                korisVisible = false;
                                japisVisible = false;
                              });
                              // content = Get.arguments[5];
                            }
                            if (index == 2) {
                              mColor = Colors.blue;
                              mColor0 = Colors.blue;
                              mColor1 = Colors.blue;
                              setState(() {
                                engisVisible = false;
                                korisVisible = true;
                                japisVisible = false;
                              });
                              // content = Get.arguments[5];
                            }
                            if (index == 3) {
                              mColor = Colors.blue;
                              mColor0 = Colors.blue;
                              mColor1 = Colors.blue;
                              setState(() {
                                engisVisible = false;
                                korisVisible = false;
                                japisVisible = true;
                              });
                              // content = Get.arguments[5];
                            }
                            if (index == 4) {
                              mColor = Colors.blue;
                              mColor0 = Colors.blue;
                              mColor1 = Colors.blue;
                              setState(() {
                                prnisVisible = !prnisVisible;
                              });
                              // content = Get.arguments[5];
                            }

                            isSelected[index] = !isSelected[index];
                          });
                        }
                      },

                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '모두',
                            style: TextStyle(fontSize: 16),

                            // isSelected ? 16 : 14
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '영어',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '한국어',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '일본어',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '발음제거',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '패턴',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                      future: _fetchDatas(tableName, viewName, token),
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
                              // value: 0.5,
                              strokeWidth: 6,
                              // backgroundColor: Colors.amber,
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.amber),
                            ),
                          ));
                        } else {
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.black),
                            itemCount: _records.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: engisVisible,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        leading: GestureDetector(
                                          onTap: () => phraseSpeech('en-US',
                                              _records[index]['fields']['eng']),
                                          child: Icon(Icons.volume_up_outlined,
                                              color: Colors.black),
                                        ),
                                        trailing: Text(
                                          'us',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                        ),

                                        title: SubstringHighlight(
                                          text: _records[index]['fields']['eng']
                                              .toString(),
                                          term: _records[index]['fields']
                                              ['engh'],
                                          textStyleHighlight: TextStyle(
                                              fontFamily: "NotoSansCJKkr",
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          textStyle: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        // subtitle: Text(_records[index]['fields']
                                        //         ['jap']
                                        //     .toString()),
                                      ),
                                    ),
                                    Visibility(
                                      visible: korisVisible,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        leading: GestureDetector(
                                          onTap: () => phraseSpeech('ko-KR',
                                              _records[index]['fields']['kor']),
                                          child: Icon(Icons.volume_up_outlined,
                                              color: Colors.black),
                                        ),
                                        trailing: Text(
                                          'kr',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                        ),
                                        title: SubstringHighlight(
                                          text: _records[index]['fields']['kor']
                                              .toString(),
                                          term: _records[index]['fields']
                                              ['korh'],
                                          textStyleHighlight: TextStyle(
                                              fontFamily: "NotoSansCJKkr",
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          textStyle: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        subtitle: Visibility(
                                          visible: prnisVisible,
                                          child: SubstringHighlight(
                                            text: _records[index]['fields']
                                                    ['korprn']
                                                .toString(),
                                            term: _records[index]['fields']
                                                ['korprnh'],
                                            textStyleHighlight: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textStyle: TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: japisVisible,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        leading: GestureDetector(
                                          onTap: () => phraseSpeech('ja-JP',
                                              _records[index]['fields']['jap']),
                                          child: Icon(Icons.volume_up_outlined,
                                              color: Colors.black),
                                        ),
                                        trailing: Text(
                                          'jp',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                        ),
                                        title: SubstringHighlight(
                                          text: _records[index]['fields']['jap']
                                              .toString(),
                                          term: _records[index]['fields']
                                              ['japh'],
                                          textStyleHighlight: TextStyle(
                                              fontFamily: "NotoSansCJKkr",
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          textStyle: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        subtitle: Visibility(
                                          visible: prnisVisible,
                                          child: SubstringHighlight(
                                            text: _records[index]['fields']
                                                    ['japprn']
                                                .toString(),
                                            term: _records[index]['fields']
                                                ['japprnh'],
                                            textStyleHighlight: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textStyle: TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: buildNavigationBar(),
      ),
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
          height: 30,
          child: FloatingActionButton.extended(
            shape: shape,
            icon: Icon(Icons.share),
            label: Text('Capture & Share'),
            backgroundColor: Colors.yellow[400],
            foregroundColor: Colors.black54,
            onPressed: () async {
              final image = await controller.capture();
              // final image = await controller.captureFromWidget(MarkdownWidget());
              // ignore: unnecessary_null_comparison
              if (image == null) return;
              saveAndShare(image);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Screenshot Completed...',
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Colors.blueGrey,
              ));
            },
            // final = image await controller.capture();
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
          label: Text('View & Comment Write'),
          onPressed: () => Get.to(() => CommentWrite()),
        );
      default:
        return null;
    }
  }
}
