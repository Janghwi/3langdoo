import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:todaylang/page/first_screen_ad.dart';
import 'package:todaylang/page/first_screen_ai.dart';
import 'package:todaylang/page/first_screen_cm.dart';
import 'package:todaylang/page/first_screen_dt.dart';
import 'package:todaylang/page/first_screen_md5.dart';
import 'package:todaylang/page/first_screen_md6.dart';
import 'package:todaylang/page/first_screen_md7.dart';
import 'package:todaylang/page/first_screen_md8.dart';
import 'package:todaylang/page/first_screen_md81.dart';
import 'package:todaylang/page/first_screen_md82.dart';
import 'package:todaylang/page/first_screen_md9.dart';
import 'package:todaylang/page/first_screen_md92.dart';
import 'package:todaylang/page/first_screen_md93.dart';
import 'package:todaylang/page/first_screen_md94.dart';
import 'package:todaylang/page/first_screen_md95.dart';
import 'package:todaylang/page/first_screen_of.dart';
import 'package:todaylang/page/first_screen_ph.dart';
import 'package:todaylang/page/first_screen_wb.dart';
import 'package:todaylang/page/first_screen_wb1.dart';
import 'package:todaylang/page/first_screen_yt.dart';
import 'package:todaylang/page/first_screen_ytCre.dart';
import 'package:todaylang/page/first_screen_ytLan.dart';
import 'package:todaylang/page/page_scroll.dart';
import 'package:todaylang/page/translation/langtranslate.dart';
// import 'package:todaylang/page/translation/langtext.dart';
import 'package:todaylang/widget/sortable.dart';

import 'tabbar_widget.dart';
import 'todoapp.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String title = "ENKORNESE";

  // final List<Map<String, dynamic>> locales = [
  //   {'name': 'English', 'locale': (Locale('en', 'US'))},
  //   {'name': 'Korean', 'locale': (Locale('ko', 'KR'))},
  //   {'name': 'Japanese', 'locale': (Locale('ja', 'JP'))},
  //   {'name': 'Chinese', 'locale': (Locale('zh', 'CN'))},
  // ];

  // showLocalDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             title: Text("Choose your language"),
  //             content: Container(
  //               // color: Colors.black26,
  //               width: double.maxFinite,
  //               child: ListView.separated(
  //                 shrinkWrap: true,
  //                 itemBuilder: (context, index) => InkWell(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(locales[index]['name'].toString()),
  //                   ),
  //                   onTap: () => updateLocale(
  //                     locales[index]['locale'],
  //                     context,
  //                   ),
  //                 ),
  //                 separatorBuilder: (context, index) => Divider(
  //                   color: Colors.black,
  //                 ),
  //                 itemCount: 4,
  //               ),
  //             ),
  //           ));
  // }

  // updateLocale(Locale locale, BuildContext context) {
  //   Navigator.of(context).pop();
  //   Get.updateLocale(locale);
  //   print('passed');
  // }

  // ignore: use_key_in_widget_constructors
  int currentIndex = 0;
  // List<Widget> _widgetOptions = [
  //   HomePage(),
  //   CommentBox(),
  //   CommentBox(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  String apptitle1 = "appbar_title1";
  String apptitle2 = "appbar_title2";
  String apptitle3 = "appbar_title3";
  String apptitle4 = "appbar_title4";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xfff0e5d6),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
              ),
              ListTile(
                title: Text('회원정보 보기'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('로그아웃'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        // appBar: AppBar(
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.language),
        //       onPressed: () {},
        //     ),
        //   ],
        // ),
        body: TabBarWidget(
          title: title,
          // title: 'appbar_title1'.tr,
          tabs: [
            Tab(
              text: apptitle1.tr,
              // text: 'appbar_title1'.tr,
              // text: LangText(text:'appbar_title1'),
              // icon: Icon(Icons.feed_outlined),
            ),
            // Tab(
            //   text: '단어',
            //   // icon: Icon(Icons.feed_outlined),
            // ),
            Tab(
              text: apptitle2.tr,
              // text: '문장',
              // icon: Icon(Icons.feed_outlined),
            ),
            Tab(
              text: apptitle3.tr,
              // text: '패턴',
              // icon: Icon(Icons.feed_outlined),
            ),
            Tab(
              text: apptitle4.tr,
              // text: '문장',
              // icon: Icon(Icons.feed_outlined),
            ),
            Tab(
              text: '아코디언',
              // icon: Icon(Icons.dynamic_feed),
            ),
            Tab(
              text: 'Ai',
              // icon: Icon(Icons.dynamic_form_sharp),
            ),
            Tab(
              text: '디지털트윈',
              // icon: Icon(Icons.dynamic_form_sharp),
            ),
            Tab(
              text: '웹뷰',
              // icon: Icon(Icons.dynamic_form_sharp),
            ),
            Tab(
              text: '웹뷰1',
              // icon: Icon(Icons.dynamic_form_sharp),
            ),
            Tab(
              text: '유투브언어',
              // icon: Icon(Icons.favorite_border),
            ),
            Tab(
              text: '유투브',
              // icon: Icon(Icons.favorite_border),
            ),
            Tab(
              text: '유투브크리에이터',
              // icon: Icon(Icons.favorite_border),
            ),
            Tab(
              text: '오픈파일',
              // icon: Icon(Icons.favorite_border),
            ),
            Tab(
              text: 'Comic',
              // icon: Icon(Icons.favorite_border),
            ),
            Tab(
              text: 'Sort',
              // icon: Icon(Icons.favorite_border),
            ),
          ],
          children: [
            FirstScreenMd94(),
            FirstScreenMd82(),
            // FirstScreenMd93(), //단어 300개 테스트 버전
            // PageScroll(),
            FirstScreenPh(),
            FirstScreenMd82(),
            FirstScreenAd(),
            FirstScreenAi(),
            FirstScreenDt(),
            FirstScreenWb(),
            FirstScreenWb1(),
            // const BarMenu(),
            FirstScreenYtLan(),
            FirstScreenYt(),
            FirstScreenYtCre(),
            OpenPage(),
            FirstScreenCm(),
            SortablePage(),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   backgroundColor: Colors.blue,
        //   selectedItemColor: Colors.white,
        //   unselectedItemColor: Colors.white70,
        //   iconSize: 20,
        //   selectedFontSize: 16,
        //   unselectedFontSize: 14,
        //   currentIndex: currentIndex,
        //   onTap: (index) => setState(() => currentIndex = index),
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //         label: "Home",
        //         backgroundColor: Colors.blue),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.mail),
        //         label: "Translate",
        //         backgroundColor: Colors.red),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.person),
        //         label: "Comments",
        //         backgroundColor: Colors.blue),
        //   ],
        // ),
      );
}
