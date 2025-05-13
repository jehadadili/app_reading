import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomWidgetLoading extends StatelessWidget {
  const CustomWidgetLoading(
      {super.key, required this.size, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.progressiveDots(
      color: color,
      size: size,
    );
  }
}
