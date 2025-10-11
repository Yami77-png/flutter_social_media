import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppDropDown extends StatelessWidget {
  const AppDropDown({
    super.key,
    required this.value,
    this.hintText = 'Select an option',
    this.validator,
    required this.onChanged,
    required this.items,
    this.bgColor = Colors.white,
    this.iconSize = 15.0,
    this.padding,
    this.valueStyle,
    this.hintStyle,
    this.buttonPadding,
    this.buttonHeight,
    this.buttonWidth,
    this.iconColor = Colors.grey,
    this.dropdownColor = Colors.white,
    this.borderColor,
  });

  final dynamic value;
  final String hintText;
  final String? Function(dynamic)? validator;
  final void Function(dynamic)? onChanged;
  final List<DropdownMenuItem<dynamic>>? items;
  final EdgeInsetsGeometry? padding;
  final Color bgColor;
  final double iconSize;
  final TextStyle? valueStyle, hintStyle;
  final EdgeInsetsGeometry? buttonPadding;
  final double? buttonHeight, buttonWidth;
  final Color iconColor, dropdownColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final menuWidth = screenWidth * 0.4;
    final horizontalOffset = screenWidth - menuWidth;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor ?? Colors.grey.shade300, width: 1.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(hintText, style: hintStyle),
          items: items,
          value: value,
          style: valueStyle,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            padding: buttonPadding ?? EdgeInsets.symmetric(horizontal: 16),
            height: buttonHeight ?? 50,
            width: buttonWidth ?? double.infinity,
          ),
          iconStyleData: IconStyleData(icon: Icon(Icons.expand_more, color: iconColor), iconSize: iconSize),
          dropdownStyleData: DropdownStyleData(
            offset: Offset(horizontalOffset, 0),
            width: menuWidth,
            decoration: BoxDecoration(color: dropdownColor),
          ),
          // menuItemStyleData: const MenuItemStyleData(height: 10),
        ),
      ),
    );
    // child: DropdownButtonHideUnderline(
    //   child: DropdownButton(
    //     padding: padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    //     value: value,
    //     hint: Text(hintText),
    //     dropdownColor: Colors.white,
    //     icon: Icon(Icons.keyboard_arrow_down, size: iconSize),
    //     isExpanded: true,
    //     // decoration: const InputDecoration(hintText: ''),
    //     // validator: validator,
    //     onChanged: onChanged,
    //     items: items,
    //     menuWidth: MediaQuery.sizeOf(context).width * 0.5,
    //   ),
    // ),
    // );
  }
}
