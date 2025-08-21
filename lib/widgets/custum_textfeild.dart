import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/adm_colors.dart';
import '../adm_theme/adm_theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? isPassword;
  final Function(String)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final String? errorText;
  final void Function(String?)? onSaved;
  final AutovalidateMode? autovalidateMode;
  final GlobalKey<FormState>? formKey;
  final void Function(String)? onFieldSubmitted;
  final bool? autofocus;

  const CustomTextField(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      required this.obscureText,
      this.isPassword,
      this.validator,
      this.keyboardType,
      this.textInputAction,
      this.focusNode,
      this.onTap,
      this.onChanged,
      this.errorText,
      this.onSaved,
      this.autovalidateMode,
      this.formKey,
      this.onFieldSubmitted,
      this.autofocus})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: widget.onFieldSubmitted,

      autofocus: false,
      autovalidateMode: widget.autovalidateMode,
      onSaved: widget.onSaved,

      onTap: widget.onTap,
      onChanged: widget.onChanged,
      //autofocus: true,

      focusNode: widget.focusNode,
      style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode ? admWhiteColor : admTextColor),

      controller: widget.textEditingController,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      validator: widget.validator != null
          ? (value) => widget.validator!(value!)
          : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red)),
        //border: InputBorder.none,
        fillColor: Get.isDarkMode ? admDarkBorderColor : lightGreyColor,
        filled: true,
        isDense: true,
        errorText: widget.errorText,
        errorStyle:  theme.textTheme.bodySmall?.copyWith(
      color: Colors.red,
      ),
        hintStyle: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: Get.isDarkMode ? admDarkColorGrey : darkGreyColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: admColorPrimary)),

        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent)),

        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        hintText: widget.hintText,
        labelText: widget.labelText,
      ),
    );
  }
}
