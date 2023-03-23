// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022

import 'package:flutter/material.dart';
import 'package:knowledge_dependency_graph_manager/presentation/widgets/pages/rendered_tex.dart';

/// This class converts latex code into a [Widget].
class LeanTex extends StatefulWidget {
  const LeanTex({Key? key, required this.texData,this.fontSize=25,this.height=200,this.left=false, this.color}) : super(key: key);

  /// The latex code.
  final String texData;
  final int fontSize;
  final int height;
  final bool left;
  final Color? color;

  @override
  State<LeanTex> createState() => _LeanTexState();
}

class _LeanTexState extends State<LeanTex> {



  @override
  Widget build(BuildContext context) {

    return RenderedTex(
        text: widget.texData
            .replaceAll("\\(", "\$")
            .replaceAll("\\)", "\$")
            .replaceAll("<br>", "\n"),
        textStyle: Theme.of(context).textTheme.headlineSmall);
  }

}
