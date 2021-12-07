// ignore_for_file: file_names
//** 언어별로  만든다 */
// ignore: constant_identifier_names
import 'package:get/get.dart';

class LangTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': {
          'appbar_title1': '단어',
          'appbar_title2': '문장',
          'appbar_title3': '패턴',
          'appbar_title4': '문법',
        },
        'en_US': {
          'appbar_title1': 'words',
          'appbar_title2': 'phrases',
          'appbar_title3': 'Pattern',
          'appbar_title4': 'good words',
        },
        'ja_JP': {
          'appbar_title1': '単語',
          'appbar_title2': '文章',
          'appbar_title3': 'お気に入り',
          'appbar_title4': '良い文章',
        },
        'zh_CN': {
          'appbar_title1': '词',
          'appbar_title2': '句子',
          'appbar_title3': '材料',
          'appbar_title4': '收藏夹',
        },
      };
}
