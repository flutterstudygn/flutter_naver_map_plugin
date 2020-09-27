import 'package:flutter/material.dart';
import 'package:flutter_naver_map_plugin/flutter_naver_map_plugin.dart';

import '../routes/example_route.dart';

class LayoutBorderLayer extends StatefulWidget {
  final NMap map;
  final GlobalKey<NMapState> mapKey;

  LayoutBorderLayer(this.map, this.mapKey, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LayoutBorderLayerState();
}

class LayoutBorderLayerState extends State<LayoutBorderLayer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NaverMapController>(
      future: widget.mapKey.currentState.controller.future,
      builder: (_, snapshot) {
        return CustomPaint(
          foregroundPainter:
              snapshot.hasData ? _InfoPainter(snapshot.data) : null,
          child: widget.map,
          size: Size.infinite,
        );
      },
    );
  }
}

class _InfoPainter extends CustomPainter {
  final NaverMapController controller;

  _InfoPainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    final contentPadding = controller.contentPadding;
    final width = controller.width;
    final height = controller.height;
    final contentWidth = controller.contentWidth;
    final contentHeight = controller.contentHeight;

    canvas
      ..drawRect(
        Rect.fromLTWH(0, 0, width, height),
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      )
      ..drawRect(
        Rect.fromLTWH(
          contentPadding.left,
          contentPadding.top,
          contentWidth,
          contentHeight,
        ),
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      )
      ..drawLine(
        Offset(0, contentPadding.top + contentHeight / 2),
        Offset(contentPadding.left, contentPadding.top + contentHeight / 2),
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = 4,
      )
      ..drawLine(
        Offset(contentPadding.left + contentWidth / 2, 0),
        Offset(contentPadding.left + contentWidth / 2, contentPadding.top),
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = 4,
      )
      ..drawLine(
        Offset(
          contentPadding.left + contentWidth,
          contentPadding.top + contentHeight / 2,
        ),
        Offset(
          contentPadding.horizontal + contentWidth,
          contentPadding.top + contentHeight / 2,
        ),
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = 4,
      )
      ..drawLine(
        Offset(
          contentPadding.left + contentWidth / 2,
          contentPadding.top + contentHeight,
        ),
        Offset(
          contentPadding.left + contentWidth / 2,
          contentPadding.vertical + contentHeight,
        ),
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = 4,
      );
  }

  @override
  bool shouldRepaint(_InfoPainter oldDelegate) =>
      oldDelegate.controller.width != controller.width ||
      oldDelegate.controller.height != controller.height ||
      oldDelegate.controller.contentPadding != controller.contentPadding;
}
