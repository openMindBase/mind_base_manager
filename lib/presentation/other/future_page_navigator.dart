// @author Matthias Weigt 05.04.23

import 'package:flutter/cupertino.dart';
import 'package:lean_ui_kit/other/lean_navigator.dart';

import '../app_pages/future_page.dart';

/// A [FuturePageNavigator] is a helper class to navigate to a [FuturePage].
class FuturePageNavigator<T> {
  FuturePageNavigator();

  /// Navigates to a [FuturePage] with the given [future] and [targetPage].
  /// The [targetPage] is called with the resolved data of the [future].
  void push(
      {required Future<T> future,
      required BuildContext context,
      required Widget Function(BuildContext context, T data) builder}) {
    LeanNavigator.pushPage(
        context,
        FuturePage<T>(
          future: future,
          builder: (context, data) {
            return builder(context, data);
          },
        ));
  }
}
