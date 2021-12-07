import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class PhrasesLoader extends GetxController {
  static PhrasesLoader get to => Get.find();

  var records = [].obs;
  var isFavorite = 'false'.obs;
  // var temprecords = [...,isFavorite].obs;
  final record = ''.obs;
  final uniqueId = ''.obs;

  var currentIdSave = ''.obs;
  int get count => records.length;

  var favList = [].obs;
  var list = [].obs;
  RxBool isClicked = true.obs;
  RxBool isTest = false.obs;

  // RxList<dynamic> records = [].obs;
  // RxList records = <Map<String, dynamic>>[].obs;
  @override
  void onInit() async {
    super.onInit();
    // fetchList();
    loadPhrasesFile();
  }

  void idSave() async {}

  Future<RxList> loadPhrasesFile() async {
    if (Get.context != null) {
      Dio dio = Dio();
      var response = await dio.get(
        "https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest?maxRecords=500&view=Gridview",
        options: Options(contentType: 'Application/json', headers: {
          'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
          'Accept': 'Application/json',
        }),
      );
      // print(response.data);
      // Map<String, dynamic> result = (response.data);

      RxMap<String, dynamic> result =
          RxMap<String, dynamic>.from(response.data);
      // RxMap<String, dynamic> result = (response.data);
      // print('this passed');
      // print(result);

      records = RxList.from(result['records']);
      isTest.value = true;

      return records;

      // String data = await DefaultAssetBundle.of(Get.context!)
      //     .loadString("assets/json/post.json");
      // records(json.decode(data).cast<Map<String, dynamic>>().torecords());
    } else {
      Future.delayed(Duration(milliseconds: 200), loadPhrasesFile);
    }
    return records;
  }

  //화면갱신
  // void updateFavoriteData() {
  //   favList.clear();
  //   favList.addAll(list
  //     .where((element) => element.parentGroup == Get.arguments['id'])
  //     .list(e) {
  //     e.setFavorite(PhFavController.to.favList.contains(e));
  //     return e;
  //   }).toList());
  // }

  // void updateFavorite() {
  //   PhFavController.to.updateFavorite(uidInfo)  ;
  //   updateFavoriteData();
  // }

  // Future updatePhraseFile() async {
  //   // Future updatePhrasesFile(String? currentId, int likeCount) async {
  //   var response = Dio().patch(
  //     'https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest',
  //     options: Options(
  //       contentType: 'Application/json',
  //       headers: {
  //         'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
  //         'Accept': 'Application/json',
  //       },
  //     ),
  //     data: {
  //       'records': [
  //         {
  //           "id": id,
  //           'fields': {
  //             'likeCnt': likeCount,
  //             // 'likeCnt': likeController.text,
  //           }
  //         },
  //       ],
  //     },
  //   );
  //   return !isLikedRx;
  // }

  // RxBool isLiked = false.obs;
  // Future updatePhrasesFile(bool isLikedRx) async {
  //   // Future updatePhrasesFile(String? currentId, int likeCount) async {
  //   var response = Dio().patch(
  //     'https://api.airtable.com/v0/appgEJ6eE8ijZJtAp/goodTest',
  //     options: Options(
  //       contentType: 'Application/json',
  //       headers: {
  //         'Authorization': 'Bearer keyyG7I9nxyG5SmTq',
  //         'Accept': 'Application/json',
  //       },
  //     ),
  //     data: {
  //       'records': [
  //         {
  //           "id": "rech3HAyhyRoVnsOC",
  //           'fields': {
  //             'likeCnt': 671,
  //             // 'likeCnt': likeController.text,
  //           }
  //         },
  //       ],
  //     },
  //   );
  //   return !isLikedRx;
  // }
}
