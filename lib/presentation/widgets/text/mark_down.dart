// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022

import 'package:flutter/material.dart';
import 'package:mind_base_manager/presentation/old_widgets/rendered_tex.dart';

/// This class converts markdown text into a [Widget].
/// + It renders formula.
class Markdown extends StatefulWidget {
  const Markdown({Key? key, required this.texData,this.fontSize=25,this.height=200,this.left=false, this.color}) : super(key: key);

  /// The latex code.
  final String texData;
  final int fontSize;
  final int height;
  final bool left;
  final Color? color;
  @override
  State<Markdown> createState() => _MarkdownState();
}

class _MarkdownState extends State<Markdown> {



  @override
  Widget build(BuildContext context) {
    // print("123");
    return RenderedTex(
        text: widget.texData
            .replaceAll("\\(", "\$")
            .replaceAll("\\)", "\$")
            .replaceAll("<br>", "\n"),
        textStyle: Theme.of(context).textTheme.headlineSmall);
  }

}
