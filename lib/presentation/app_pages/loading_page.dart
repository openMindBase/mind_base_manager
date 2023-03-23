// @author Matthias Weigt 23.02.23
// All rights reserved ©2023

import 'package:flutter/material.dart';

import 'app_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(
        showBackButton: true,
        title: "loading...",
        children: [CircularProgressIndicator()]);
  }
}
