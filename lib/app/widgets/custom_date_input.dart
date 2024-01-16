import 'package:flutter/material.dart';
import 'package:hetian_mobile/app/style/app_color.dart';

class CustomDateInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool disabled;
  final EdgeInsetsGeometry margin;
  final Widget? suffixIcon;
  final Function? onTap;
  final double width;

  const CustomDateInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.disabled = false,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.suffixIcon,
    required this.onTap,
    required this.width,
  });

  @override
  State<CustomDateInput> createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
        margin: widget.margin,
        decoration: BoxDecoration(
          color: (widget.disabled == false)
              ? Colors.transparent
              : AppColor.primaryExtraSoft,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: AppColor.secondaryExtraSoft),
        ),
        child: GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            }
            _focusNode.requestFocus();
          },
          child: AbsorbPointer(
            absorbing: widget.disabled,
            child: TextField(
              onTap: () => widget.onTap!(),
              readOnly: true,
              style: const TextStyle(fontSize: 14, fontFamily: 'poppins'),
              maxLines: 1,
              controller: widget.controller,
              decoration: InputDecoration(
                suffixIcon: widget.suffixIcon ?? const SizedBox(),
                label: Text(
                  widget.label,
                  style: TextStyle(
                    color: AppColor.secondarySoft,
                    fontSize: 14,
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w500,
                  color: AppColor.secondarySoft,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
