import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/adm_colors.dart';
class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
      begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
      end: widget.value ? Alignment.centerLeft : Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        final alignment = widget.value
            ? (Directionality.of(context) == TextDirection.rtl
            ? Alignment.centerLeft
            : Alignment.centerRight)
            : (Directionality.of(context) == TextDirection.rtl
            ? Alignment.centerRight
            : Alignment.centerLeft);
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.onChanged(!widget.value);
          },
          child: Container(
            width: 45.0,
            height: 28.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: _circleAnimation!.value == Alignment.centerLeft
                  ? Get.isDarkMode?admDarkLightColor:admBorderColor
                  : admColorPrimary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                alignment: alignment,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
