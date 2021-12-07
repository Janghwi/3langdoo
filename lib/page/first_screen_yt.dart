// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
//import '2menutwolevel_page2.dart';
//import '2menutwolevel_page_p.dart';
import 'package:http/http.dart' as http;
import 'package:todaylang/widget/youtube_widget.dart';

class FirstScreenYt extends StatefulWidget {
  const FirstScreenYt({Key? key}) : super(key: key);

  @override
  State<FirstScreenYt> createState() => _FirstScreenYtState();
}

class _FirstScreenYtState extends State<FirstScreenYt> {
  List records = [];

  // final style = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  // final style1 = const TextStyle(
  //   fontSize: 15,
  // );

  Future<List> _fetchMenus(
    String view,
  ) async {
    bool loadRemoteDatatSucceed = false;
    // Response response;
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/app95nB2yi0WAYDyn/YtTbl?maxRecords=500&view=$view",
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

  late String currentView = "Gridview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                SizedBox.fromSize(
                  size: Size(52, 52), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange, // button color
                      child: InkWell(
                        splashColor: Colors.green, // splash color
                        onTap: () async {
                          // await _fetchMenus("quoteview");
                          setState(() {
                            _fetchMenus("Gridview");
                            currentView = "Gridview";
                          });
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.call), // icon
                            Text("전체"), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: Size(52, 52), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange, // button color
                      child: InkWell(
                        splashColor: Colors.green, // splash color
                        onTap: () async {
                          // await _fetchMenus("quoteview");
                          setState(() {
                            _fetchMenus("quoteview");
                            currentView = "quoteview";
                          });
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.call), // icon
                            Text("명언"), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    // shape: OutlinedBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  ),
                  child: Text("IT지식", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    // await _fetchMenus("itview");
                    setState(() {
                      _fetchMenus("itview");
                      currentView = "itview";
                    });
                  },
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  ),
                  child: Text("골프", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    // await _fetchMenus("golfview");
                    setState(() {
                      _fetchMenus("golfview");
                      currentView = "golfview";
                    });
                  },
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  ),
                  child: Text("도서", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    // await _fetchMenus("bookview");
                    setState(() {
                      _fetchMenus("bookview");
                      currentView = "bookview";
                    });
                  },
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  ),
                  child: Text("음악", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    // await _fetchMenus("musicview");
                    setState(() {
                      _fetchMenus("musicview");
                      currentView = "musicview";
                    });
                  },
                ),
              ],
            ),
            Divider(
              height: 2,
            ),
            Expanded(
              child: FutureBuilder(
                  future: _fetchMenus(currentView),
                  builder: (context, snapshot) {
                    // print('snapshot No.=>');
                    // print(records.length);

                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation(Colors.amber),
                      ));
                    } else {
                      return ListView.builder(
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //   crossAxisCount: 2,
                        // ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: records.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () => Get.to(() => const YoutubePage(),
                                arguments: [
                                  records[index]['fields']['content']
                                      .toString(),
                                  records[index]['fields']['vid'],
                                  records[index]['fields']['details'],
                                  //this.records[index]['fields']['cat1'],
                                ],
                                transition: Transition.zoom),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
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

                                  const Divider(),
                                ],
                              ),
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
    );
  }
}

// class YoutubePage extends StatefulWidget {
//   const YoutubePage({Key? key}) : super(key: key);

//   @override
//   _YoutubePageState createState() => _YoutubePageState();
// }

// class _YoutubePageState extends State<YoutubePage> {
//   var content = Get.arguments[0];
//   var vid = Get.arguments[1];
//   var details = Get.arguments[2];

//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: vid,
//       params: const YoutubePlayerParams(
//         // playlist: [
//         //   'tQjAgEU8Ww0',
//         //   'K18cpp_-gP8',
//         //   'iLnmTe5Q2Qw',
//         //   '_WoCV4c6XOE',
//         //   'KmzdUe0RSJo',
//         //   '6jZDSSZZxjQ',
//         //   'p2lYr3vM_1w',
//         //   '7QUtEmBT_-w',
//         //   '34_PXCzGw1M',
//         // ],
//         startAt: Duration(minutes: 0, seconds: 10),
//         showControls: true,
//         showFullscreenButton: true,
//         desktopMode: false,
//         privacyEnhanced: true,
//         useHybridComposition: true,
//         color: 'Colors.blue',
//       ),
//     );
//     YoutubePlayerIFrame(
//       controller: _controller,
//       aspectRatio: 16 / 9,
//     );

//     _controller.onEnterFullscreen = () {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//       log('Entered Fullscreen');
//     };
//     _controller.onExitFullscreen = () {
//       log('Exited Fullscreen');
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     const player = YoutubePlayerIFrame();

//     return Scaffold(
//         extendBodyBehindAppBar: false,
//         appBar: AppBar(
//           title: Text(
//             Get.arguments[0],
//             style: const TextStyle(color: Colors.black, fontSize: 16),
//           ),
//           backgroundColor: Colors.grey,
//           elevation: 0,
//           // actions: [

//           // IconButton(
//           //   onPressed: () {},
//           //   icon: const Icon(Icons.list),
//           //   color: Colors.black,
//           // ),
//           // IconButton(
//           //   onPressed: () {},
//           //   icon: const Icon(Icons.speaker_notes),
//           //   color: Colors.black,
//           // ),
//           // IconButton(
//           //   onPressed: () {},
//           //   icon: const Icon(Icons.nature_people),
//           //   color: Colors.black,
//           // )
//           // ],
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             FloatingActionButton(
//               heroTag: "backward",
//               // onPressed: () {},
//               //onPressed: () => deactivate(),
//               onPressed: () {
//                 // Wrap the play or pause in a call to `setState`. This ensures the
//                 // correct icon is shown.
//                 setState(() {
//                   // If the video is playing, pause it.
//                   int currentPosition = _controller.value.position.inSeconds;
//                   _controller.seekTo(Duration(seconds: currentPosition - 10));
//                 });
//               },
//               // Display the correct icon depending on the state of the player.
//               child: Transform.rotate(
//                 angle: 180 * math.pi / 180,
//                 // transform: Matrix4.rotationY(math.pi),
//                 child: Icon(_controller.value.playerState == PlayerState.playing
//                     ? Icons.forward_10
//                     : Icons.forward_10_outlined),
//               ),
//             ),
//             FloatingActionButton(
//               heroTag: "pause",

//               // onPressed: () {},
//               //onPressed: () => deactivate(),
//               onPressed: () {
//                 // Wrap the play or pause in a call to `setState`. This ensures the
//                 // correct icon is shown.
//                 setState(() {
//                   // If the video is playing, pause it.
//                   if (_controller.value.playerState == PlayerState.playing) {
//                     _controller.pause();
//                   } else {
//                     // If the video is paused, play it.
//                     _controller.play();
//                   }
//                 });
//               },
//               // Display the correct icon depending on the state of the player.
//               child: Icon(
//                 _controller.value.playerState == PlayerState.playing
//                     ? Icons.play_arrow
//                     : Icons.pause,
//               ),
//             ),
//             FloatingActionButton(
//               heroTag: "forward",
//               // onPressed: () {},
//               //onPressed: () => deactivate(),
//               onPressed: () {
//                 // Wrap the play or pause in a call to `setState`. This ensures the
//                 // correct icon is shown.
//                 setState(() {
//                   // If the video is playing, pause it.
//                   int currentPosition = _controller.value.position.inSeconds;
//                   _controller.seekTo(Duration(seconds: currentPosition + 10));
//                 });
//               },
//               // Display the correct icon depending on the state of the player.
//               child: Icon(_controller.value.playerState == PlayerState.playing
//                   ? Icons.forward_10
//                   : Icons.forward_10_outlined),
//             ),
//             //   FloatingActionButton(
//             //     heroTag: "loop",
//             //     // onPressed: () {},
//             //     //onPressed: () => deactivate(),
//             //     onPressed: () {
//             //       // Wrap the play or pause in a call to `setState`. This ensures the
//             //       // correct icon is shown.
//             //       setState(() {
//             //         // If the video is playing, pause it.
//             //         int currentPosition = _controller.value.position.inSeconds;
//             //         _controller.load(Get.arguments[0],startAt: Duration(seconds: currentPosition -5 , endAt: Duration(seconds:currentPosition + 5 ));
//             //       });
//             //     },
//             //     // Display the correct icon depending on the state of the player.
//             //     child: Icon(_controller.value.playerState == PlayerState.playing
//             //         ? Icons.loop
//             //         : Icons.loop_outlined),
//             //   ),
//           ],
//         ),

//         // ignore: unnecessary_null_comparison
//         body: YoutubePlayerControllerProvider(
//           // Passing controller to widgets below.
//           controller: _controller,
//           child: Column(
//             children: [
//               player,
//               YoutubeValueBuilder(
//                 controller: _controller,
//                 builder: (context, value) {
//                   return AnimatedCrossFade(
//                     firstChild: const SizedBox.shrink(),
//                     secondChild: Material(
//                       child: DecoratedBox(
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage(
//                               YoutubePlayerController.getThumbnail(
//                                 videoId: vid,
//                                 quality: ThumbnailQuality.medium,
//                               ),
//                             ),
//                             fit: BoxFit.fitWidth,
//                           ),
//                         ),
//                         child: const Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                     ),
//                     crossFadeState: value.isReady
//                         ? CrossFadeState.showFirst
//                         : CrossFadeState.showSecond,
//                     duration: const Duration(milliseconds: 300),
//                   );
//                 },
//               ),
//               // Expanded(
//               //   child: ListView(
//               //     children: [
//               //       Divider(
//               //         thickness: 2,
//               //       ),
//               //       Padding(
//               //         padding: const EdgeInsets.all(8.0),
//               //         child: Text(
//               //           details.toString(),
//               //           style: GoogleFonts.lato(
//               //               // backgroundColor: Colors.white70,
//               //               fontStyle: FontStyle.normal,
//               //               color: Colors.black,
//               //               fontWeight: FontWeight.w300,
//               //               fontSize: 17),
//               //           textAlign: TextAlign.justify,
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               Expanded(
//                 child: Markdown(
//                     data: details.toString(),
//                     styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
//                     physics: const BouncingScrollPhysics(),
//                     styleSheet: MarkdownStyleSheet(
//                         h1: const TextStyle(color: Colors.blue),
//                         h2: const TextStyle(color: Colors.blue),
//                         h3: const TextStyle(color: Colors.blue),
//                         h4: const TextStyle(
//                             color: Colors.indigo, fontWeight: FontWeight.w100),
//                         h5: const TextStyle(
//                           color: Colors.black87,
//                         ),
//                         h6: const TextStyle(
//                             color: Colors.indigo, fontWeight: FontWeight.w600),
//                         p: const TextStyle(
//                           color: Colors.black45,
//                         ),
//                         strong: const TextStyle(color: Colors.lightBlueAccent),
//                         blockSpacing: 10.0,
//                         listIndent: 24.0,
//                         horizontalRuleDecoration: BoxDecoration(
//                           border: Border(
//                             top: BorderSide(
//                               width: 3.0,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                         blockquote: const TextStyle(color: Colors.red))),
//               ),
//             ],
//           ),
//         ));
//   }

//   @override
//   void dispose() {
//     _controller.close();
//     super.dispose();
//   }
// }
