import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomScrollbar extends SingleChildRenderObjectWidget {
  final ScrollController controller;
  final Widget child;
  final double? strokeWidth;
  final EdgeInsets? padding;
  final Color? trackColor;
  final Color? thumbColor;
  final double? crossaxis;
  final double? length;
  final double? mainaxis;

  const CustomScrollbar({
    Key? key,
    required this.controller,
    required this.child,
    this.strokeWidth,
    this.padding,
    this.trackColor,
    this.thumbColor,
    this.crossaxis,
    this.length,
    this.mainaxis,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomScrollbar(
      controller: controller,
      strokeWidth: strokeWidth ?? 16,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      trackColor: trackColor ?? Colors.purpleAccent.withOpacity(0.3),
      thumbColor: thumbColor ?? Colors.purpleAccent,
      mainaxis: mainaxis ?? 0,
      crossaxis: crossaxis ?? 0,
      length: length ?? 0,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomScrollbar renderObject) {
    if (strokeWidth != null) {
      renderObject.strokeWidth = strokeWidth!;
    }
    if (padding != null) {
      renderObject.padding = padding!;
    }
    if (trackColor != null) {
      renderObject.trackColor = trackColor!;
    }
    if (thumbColor != null) {
      renderObject.thumbColor = thumbColor!;
    }
    if (mainaxis != null) {
      renderObject.mainaxis = mainaxis!;
    }
    if (crossaxis != null) {
      renderObject.crossaxis = crossaxis!;
    }
    if (length != null) {
      renderObject.length = length!;
    }
  }
}

class RenderCustomScrollbar extends RenderShiftedBox {
  final ScrollController controller;
  Offset _thumbPoint = const Offset(0, 0);
  EdgeInsets padding;
  double strokeWidth;
  Color trackColor;
  Color thumbColor;
  double mainaxis;
  double crossaxis;
  double length;

  RenderCustomScrollbar({
    RenderBox? child,
    required this.padding,
    required this.controller,
    required this.strokeWidth,
    required this.trackColor,
    required this.thumbColor,
    required this.crossaxis,
    required this.mainaxis,
    required this.length,
  }) : super(child) {
    controller.addListener(_updateThumbPoint);
  }

  void _updateThumbPoint() {
    _thumbPoint = Offset(_getHorizontalOffset(), _getThumbVerticalOffset());
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  double _getHorizontalOffset() {
    return size.width - padding.right - strokeWidth / 2;
  }

  double _getThumbVerticalOffset() {
    var scrollExtent = _getScrollExtent();
    var scrollPosition = controller.position;
    var scrollOffset =
        ((scrollPosition.pixels - scrollPosition.minScrollExtent) /
                scrollExtent)
            .clamp(0.0, 1.0);
    return (_getHeightWithPadding() - _getThumbHeight()) * scrollOffset;
  }

  double _getHeightWithPadding() {
    return size.height - padding.vertical - length;
  }

  double _getScrollExtent() {
    return controller.position.maxScrollExtent;
  }

  double _getThumbHeight() {
    var scrollExtent = _getScrollExtent();
    var height = _getHeightWithPadding();
    if (scrollExtent == 0) {
      return height;
    }
    return (height / (scrollExtent / height + 1));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    context.paintChild(child!, offset);
    _resetThumbStartPointIfNeeded();
    _trackPaint(context, offset);
    _thumbPaint(context, offset);
  }

  void _resetThumbStartPointIfNeeded() {
    var scrollMaxExtent = _getScrollExtent();
    if (scrollMaxExtent == 0) {
      _thumbPoint = Offset(_getHorizontalOffset() - mainaxis, 0);
    }
  }

  void _trackPaint(PaintingContext context, Offset offset) {
    var width = _getHorizontalOffset() - mainaxis;
    final trackPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = trackColor
      ..strokeWidth = strokeWidth;
    final startPoint = Offset(width, offset.dy + padding.top + crossaxis);
    final endPoint = Offset(width, startPoint.dy + _getHeightWithPadding());
    context.canvas.drawLine(startPoint, endPoint, trackPaint);
  }

  void _thumbPaint(PaintingContext context, Offset offset) {
    var width = _getHorizontalOffset() - mainaxis;
    final paintThumb = Paint()
      ..strokeWidth = strokeWidth
      ..color = thumbColor
      ..strokeCap = StrokeCap.round;
    final startPoint =
        Offset(width, (_thumbPoint.dy + offset.dy + padding.top + crossaxis));
    final endPoint = Offset(
        width,
        startPoint.dy +
            min(_getHeightWithPadding(), max(10, _getThumbHeight())));
    context.canvas.drawLine(startPoint, endPoint, paintThumb);
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    if (child == null) return;
    child!.layout(constraints.copyWith(maxWidth: _getChildMaxWidth()),
        parentUsesSize: !constraints.isTight);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset.zero;
  }

  double _getChildMaxWidth() {
    return constraints.maxWidth;
  }
}
