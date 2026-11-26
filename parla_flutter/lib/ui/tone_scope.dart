import 'package:flutter/widgets.dart';

import 'brand.dart';

/// Sets [Tone.dark] before the app below builds, and when it changes
/// rebuilds and repaints every widget, so colours read from the tokens
/// switch at once while every screen keeps its state (the route, scroll
/// positions, text being typed).
class ToneScope extends StatefulWidget {
  const ToneScope({super.key, required this.dark, required this.builder});

  final bool dark;
  final WidgetBuilder builder;

  @override
  State<ToneScope> createState() => _ToneScopeState();
}

class _ToneScopeState extends State<ToneScope> {
  @override
  void didUpdateWidget(ToneScope old) {
    super.didUpdateWidget(old);
    if (old.dark != widget.dark) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _refresh(context as Element);
      });
    }
  }

  static void _refresh(Element element) {
    element.markNeedsBuild();
    element.renderObject?.markNeedsPaint();
    element.visitChildren(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    Tone.dark = widget.dark;
    return widget.builder(context);
  }
}
