// @author Matthias Weigt 02.03.23
// All rights reserved ©2023

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:mind_base_manager/database/mind_base.dart';

class RenderedTex extends StatelessWidget {
  const RenderedTex({super.key, required this.text, this.textStyle});

  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return _compile(text, textStyle, context);
  }

  Widget _compile(String text, TextStyle? textStyle, BuildContext context) {
    // bool textStartsWithDolloar = text.startsWith("\$");

    print(text);

    TextStyle? defaultStyle = Theme.of(context).textTheme.bodyLarge;
    if (text.isEmpty) {
      return SizedBox();
    }
    List<String> elements = text.split("\$");

    // print(elements);

    List<InlineSpan> spans = [];

    for (int i = 0; i < elements.length; i++) {
      if (i.isEven) {
        if (elements[i].contains("![")) {
          print(elements[i]);
          String path = elements[i];
          path = path.split("![[")[1].split("]]")[0];
          // path = "/md_database/$path";
          // path = path.replaceAll("![[", "").replaceAll("]]", "");
          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: MindBase.instance.image(path),
          ));
          continue;
        }

        spans.add(TextSpan(
          text: elements[i],
          style: textStyle ?? defaultStyle,
        ));
      } else {
        spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              elements[i],
              textStyle: textStyle ?? defaultStyle,
              mathStyle: MathStyle.display,
            )));
      }
    }

    return RichText(text: TextSpan(children: spans));

    return Text(text);
  }
}
