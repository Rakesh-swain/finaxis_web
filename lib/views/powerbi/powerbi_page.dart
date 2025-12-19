import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:html' as html;

class PowerBIEmbedView extends StatefulWidget {
  final double? width;
  final double? height;

  const PowerBIEmbedView({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<PowerBIEmbedView> createState() => _PowerBIEmbedViewState();
}

class _PowerBIEmbedViewState extends State<PowerBIEmbedView> {
  final String viewId = "powerbi-view-${DateTime.now().millisecondsSinceEpoch}";

  @override
  void initState() {
    super.initState();

    platformViewRegistry.registerViewFactory(
      viewId,
      (int _) {
        final iframe = html.IFrameElement()
          ..src = 'powerbi_embed.html'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';

        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: 700,
      child: HtmlElementView(viewType: viewId),
    );
  }
}
