import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/main.dart';
import 'package:smart_event/resources/colors.dart';

class CustomToggleButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const CustomToggleButton({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.activeColor = AppColors.primaryColor,
    this.inactiveColor = AppColors.backgroundLightColor,
  }) : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
        widget.onChanged(isActive);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 32,
        height: 20,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isActive ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
