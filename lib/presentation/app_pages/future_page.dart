// @author Matthias Weigt 04.04.23

import 'package:flutter/material.dart';
import 'package:mind_base_manager/presentation/app_pages/loading_page.dart';

/// A [FuturePage] is a [StatelessWidget] that shows a [LoadingPage] when the future is not yet resolved.
/// When the future is resolved, the [builder] is called with the resolved data.
class FuturePage<T> extends StatelessWidget {
  const FuturePage({super.key, required this.future, required this.builder});

  /// The future to be resolved.
  final Future<T> future;

  /// The builder to be called when the future is resolved.
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          if (!snapshot.hasData) {
            return const LoadingPage();
          }
          var data = snapshot.data as T;
          return builder(context, data);
        });
  }
}
