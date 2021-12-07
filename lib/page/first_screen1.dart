import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;

class FirstScreen1 extends StatefulWidget {
  @override
  State<FirstScreen1> createState() => _FirstScreen1State();
}

class _FirstScreen1State extends State<FirstScreen1> {
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
      "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest?maxRecords=500&view=Grid view",
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
            print(this.records.length);

            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Colors.amber),
              ));
            else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: this.records.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          this.records[index]['fields']['title'].toString(),
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
                              this
                                  .records[index]['fields']['content']
                                  .toString(),
                              style: GoogleFonts.nanumGothic(
                                // backgroundColor: Colors.white70,
                                // fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                        ),
                        Card(
                          color: Colors.black54,
                          shadowColor: Colors.grey,
                          elevation: 8,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: Stack(alignment: Alignment.center, children: [
                            Ink.image(
                              // image: NetworkImage(
                              //   this.records[index]['fields']['image_url'].toString(),
                              // ),
                              image: AssetImage('assets/images/012.png'),
                              // colorFilter: ColorFilters.greyscale,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.dstATop),
                              child: InkWell(
                                // onTap: () {},
                                onTap: () => Get.to(() => DetailPage(),
                                    arguments: [
                                      this.records[index]['fields']['title'],
                                      this.records[index]['fields']['content'],
                                      //this.records[index]['fields']['cat1'],
                                    ],
                                    transition: Transition.zoom),
                              ),
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                            SingleChildScrollView(
                              child: Text(
                                this
                                    .records[index]['fields']['title']
                                    .toString(),
                                style: GoogleFonts.nanumGothic(
                                    // backgroundColor: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            ),
                          ]),
                        ),
                        const Divider(),
                      ],
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
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var title = Get.arguments[0];
  var content = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Get.arguments[0],
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Text(
                  Get.arguments[0],
                  style: GoogleFonts.nanumGothic(
                      // backgroundColor: Colors.white70,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    Get.arguments[1],
                    style: GoogleFonts.nanumGothic(
                        // backgroundColor: Colors.white70,
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
