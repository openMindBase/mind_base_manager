// @author Matthias Weigt 23.03.23

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_text_field.dart';

import 'app_page.dart';

class ChooseMindBasePage extends StatelessWidget {
  ChooseMindBasePage({super.key, required this.onMindBasePathChoose});

  final TextEditingController pathController = TextEditingController();

  final void Function(String mindBasePath) onMindBasePathChoose;

  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> files = Directory("mind_bases/uni").listSync();
    List<String> folderNames = [];
    for (var v in files) {
      String s = v.path.split("uni").last;
      if (!s.contains(".obsidian")) {
        folderNames.add(s);
      }
    }

    List<Widget> buttons = [];
    for (var v in folderNames) {
      buttons.add(ElevatedButton(
          onPressed: () => onMindBasePathChoose("mind_bases/uni$v"),
          child: Text(v)));
    }

    return AppPage(title: "Choose the folder path of your mindbase", children: [
      const Text(
          "submitting with an empty path will lead to mind_bases/germany_school_math"),
      SizedBox(
        width: 750,
        child: LeanTextField(
          controller: pathController,
          hintText: "path",
        ),
      ),
      Wrap(
        children: buttons,
      ),
      ElevatedButton(
          onPressed: () => _onClickSubmit(context), child: const Text("submit"))
    ]);
  }

  void _onClickSubmit(BuildContext context) {
    onMindBasePathChoose(
      pathController.text.isEmpty
          ? "mind_bases/germany_school_math"
          : pathController.text,
    );
  }
}

