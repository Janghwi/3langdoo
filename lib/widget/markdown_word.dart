import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownWord extends StatelessWidget {
  final String content;

  const MarkdownWord({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
        data: content,
        // controller: controller,
        styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
        // physics: const BouncingScrollPhysics(),
        styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(color: Colors.black),
            h2: const TextStyle(color: Colors.black),
            h3: const TextStyle(color: Colors.black),
            h4: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w100),
            h5: const TextStyle(
              color: Colors.red,
            ),
            h6: const TextStyle(
                color: Colors.indigo, fontWeight: FontWeight.w600),
            p: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            //table property
            tableBody: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            tableHead: const TextStyle(
              color: Colors.lightBlue,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
            tableCellsPadding: const EdgeInsets.fromLTRB(3, 8, 8, 3),
            tableColumnWidth: const FlexColumnWidth(100.0),
            //table end
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
            blockquote: const TextStyle(color: Colors.red)));
  }
}
