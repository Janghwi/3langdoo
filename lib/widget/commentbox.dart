import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CommentWrite extends StatefulWidget {
  @override
  _CommentWriteState createState() => _CommentWriteState();
}

class _CommentWriteState extends State<CommentWrite> {
  var eng = Get.arguments[0];
  var kor = Get.arguments[1];
  var jap = Get.arguments[2];

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  List records = [];
  String offsetId = "";

  List filedata = [
    {
      'name': 'Adeleye Ayodeji',
      'pic': 'https://picsum.photos/300/30',
      'message': 'I love to code',
      'src': '10 sentense',
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool',
      'src': '10 sentense',
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool',
      'src': '10 sentense',
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool',
      'src': '10 sentense',
    },
  ];

  Future<List> _fetchComments(
      // String view,
      ) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/comments?&view=Gridview",
        // "https://api.airtable.com/v0/app95nB2yi0WAYDyn/comments?maxRecords=200&view=Gridview",
        options: Options(contentType: 'Application/json', headers: {
          'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
          'Accept': 'Application/json',
        }),
      );

      Map<String, dynamic> result = (response.data);
      final String _offsetId = result['offset'];
      final List _value = result['records'];

      offsetId = _offsetId;
      for (var element in _value) {
        records.add(element);
      }
      print("fetch passed:" "{$records}");

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

  Future<List> _fetchNextComments({required String offsetId}
      // String view,
      ) async {
    // bool loadRemoteDatatSucceed = false;
    // Response response;
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/comments?&view=Gridview&offset=$offsetId",
        // "https://api.airtable.com/v0/app95nB2yi0WAYDyn/comments?maxRecords=200&view=Gridview",
        options: Options(contentType: 'Application/json', headers: {
          'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
          'Accept': 'Application/json',
        }),
      );

      Map<String, dynamic> result = (response.data);
      final String? _offsetId = result['offset'];
      final List _value = result['records'];
      if (this.offsetId == _offsetId) {
        print(records);

        return records;
      }
      this.offsetId = _offsetId!;
      for (var element in _value) {
        records.add(element);
      }
      print(records);

      return records;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        // if (loadRemoteDatatSucceed == false) retryFuture(_fetchMenus, 200);
      }
    }
    return records;
  }

  late final ScrollController controller;
  @override
  void initState() {
    controller = ScrollController()
      ..addListener(() async {
        if (controller.offset >= controller.position.maxScrollExtent) {
          await _fetchNextComments(offsetId: offsetId);
          setState(() {});
        }
      });
    Future.microtask(() async {
      await _fetchComments();
      setState(() {});
    });
    super.initState();
  }

  _postRequest() async {
    final response = await Dio().post(
      'https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/comments',
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
            'fields': {
              'name': 'name',
              'comment': commentController.text,
              'src': Get.arguments[0],
            }
          },
        ],
      },
    );
  }

  Widget commentChild(data) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        controller: controller,
        itemCount: records.length,
        itemBuilder: (BuildContext context, int index) {
          return
              // for (var i = 0; i < data.length; i++)
              Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              isThreeLine: true,
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data[0]['pic'])),
                ),
              ),
              title: Text(
                records[index]['fields']['name'].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(records[index]['fields']['comment'].toString() +
                  "   \n 👋" +
                  Get.arguments[0]),
              // subtitle: Text(records[index]['fields']['comment'].toString() +
              // "      \n       👋" +
              // Get.arguments[0]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment Page"),
        backgroundColor: Colors.pink,
      ),
      body: CommentBox(
        header: Container(
          height: 30,
          child: Text(
            "your name",
            textScaleFactor: 1.3,
          ),
        ),
        userImage:
            "https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400",
        child: commentChild(filedata),
        labelText: 'Write a comment...',
        withBorder: false,
        errorText: 'Comment cannot be blank',
        sendButtonMethod: () {
          if (formKey.currentState!.validate()) {
            print(commentController.text);
            setState(() {
              var value = {
                'janghwi': '장휘',
                'pic':
                    'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                'message': commentController.text,
                'src': Get.arguments[0],
              };
              _postRequest();
              setState(() {
                // _fetchComments();
              });

              filedata.insert(0, value);
            });
            commentController.clear();
            FocusScope.of(context).unfocus();
          } else {
            print("Not validated");
          }
        },
        formKey: formKey,
        commentController: commentController,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
