import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'source_toggle_button.dart';

class OpenfilePage extends StatefulWidget {
  @override
  _OpenfilePageState createState() => _OpenfilePageState();
}

class _OpenfilePageState extends State<OpenfilePage> {
  var title = Get.arguments[0];
  var content = Get.arguments[1];
  var url = Get.arguments[2];

  bool isDownloading = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.orange.shade300,
        body: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(size: 132),
              const SizedBox(height: 16),
              Text(
                'Download And Open ANY File',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              SourceToggleButtons(
                onChanged: (index) => isDownloading = index == 0,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: Text('Open Image'),
                onPressed: () => openFile(
                  url: Get.arguments[2],
                  // 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1172&q=80',
                  // fileName: 'fox.jpeg', // mandatory for this url!
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: Text('Open Video'),
                onPressed: () => openFile(
                  url:
                      'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4',
                  // opt. fileName: 'video.mp4',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: Text('Open PDF'),
                onPressed: () => openFile(
                  url:
                      'https://file-examples-com.github.io/uploads/2017/10/file-example_PDF_1MB.pdf',
                  // opt. fileName: file.pdf
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: Text('Open Music'),
                onPressed: () => openFile(
                  url:
                      'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_2MG.mp3',
                  // opt. fileName: 'sound.mp3',
                ),
              ),
            ],
          ),
        ),
      );

  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;
    final file = await (isDownloading ? downloadFile(url, name) : pickFile());
    if (file == null) return;

    print('Path: ${file.path}');
    print('Length: ${file.lengthSync()}');

    OpenFile.open(file.path);
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;

    return File(result.files.first.path!);
  }

  /// Download file into private folder not visible to user
  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }
}
