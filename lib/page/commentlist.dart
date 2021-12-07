import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'comments.dart';

class CommentsList extends StatefulWidget {
  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  late FixedExtentScrollController controller;

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
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/comments?maxRecords=100&view=Grid view",
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

  final double itemHeight = 180;
  final int itemCount = 10;

  @override
  void initState() {
    super.initState();
    setState(() {});
    // new Timer.periodic(Duration(seconds: 3), (Timer t) => setState(() {}));

    controller = FixedExtentScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void refreshData() {
    setState(() {});
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  void commentsPage() {
    Route route = MaterialPageRoute(builder: (context) => CommentsPage());
    Navigator.push(context, route).then(onGoBack);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: commentsPage,
        // onPressed: () => Get.to(CommentsPage()),

        // onPressed: () => Get.to(CommentsPage()),
      ),
      // () {
      //   final nextIndex = controller.selectedItem + 1;

      //   controller.animateToItem(
      //     nextIndex,
      //     duration: Duration(seconds: 1),
      //     curve: Curves.easeInOut,
      //   );
      // },
      // );
      body: FutureBuilder(
          future: _fetchMenus(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Colors.amber),
              ));
            } else {
              return ClickableListWheelScrollView(
                scrollController: controller,
                itemHeight: itemHeight,
                itemCount: records.length,
                onItemTapCallback: (index) =>
                    showToast('Clicked Item: ${index + 1}'),
                child: ListWheelScrollView.useDelegate(
                  controller: controller,
                  itemExtent: itemHeight,
                  physics: FixedExtentScrollPhysics(),
                  // onSelectedItemChanged: (index) =>
                  //     showToast('Selected Item: ${index + 1}'),
                  //useMagnifier: true,
                  magnification: 1.4,

                  perspective: 0.002, // value between 0 --> 0.01
                  diameterRatio: 2.2, // default 2.0
                  //squeeze: 1.4, // default 1.0
                  //offAxisFraction: -1.5,
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: records.length,
                    builder: (context, index) => buildCard(index),
                  ),
                ),
              );
            }
          }));

  Widget buildCard(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              records[index]['fields']['name'].toString(),
              style: TextStyle(color: Colors.deepOrange.shade200, fontSize: 22),
            ),
            Divider(
              height: 20,
            ),
            Text(
              records[index]['fields']['comment'].toString(),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future showToast(String message) async {
    await Fluttertoast.cancel();

    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      fontSize: 24,
    );
  }
}
