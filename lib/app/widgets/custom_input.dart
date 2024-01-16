import 'package:flutter/material.dart';
import 'package:hetian_mobile/app/style/app_color.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool disabled;
  final EdgeInsetsGeometry margin;
  final bool obsecureText;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final int? maxLines;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.disabled = false,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.obsecureText = false,
    this.suffixIcon,
    required this.textInputAction,
    this.maxLines,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
        margin: widget.margin,
        decoration: BoxDecoration(
          color: (widget.disabled == false)
              ? Colors.transparent
              : AppColor.primaryExtraSoft,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: AppColor.secondaryExtraSoft),
        ),
        child: TextField(
          readOnly: widget.disabled,
          obscureText: widget.obsecureText,
          style: const TextStyle(fontSize: 14, fontFamily: 'poppins'),
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onSubmitted: widget.onSubmitted,
          textInputAction: widget.textInputAction,
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
    );
  }
}
