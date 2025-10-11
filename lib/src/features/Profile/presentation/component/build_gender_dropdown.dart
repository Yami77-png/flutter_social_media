import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class BuildGenderDropdown extends StatelessWidget {
  final bool isEditingPersonal;
  final String selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final List<String> genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];

  BuildGenderDropdown({
    super.key,
    required this.isEditingPersonal,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: "Gender",
        labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        // prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryColor),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedGender,
          // icon: isEditingPersonal ? Icon(Icons.arrow_drop_down, color: AppColors.primaryColor) : SizedBox.shrink(),
          onChanged: isEditingPersonal ? onGenderChanged : null,
          items: genderOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          style: TextStyle(
            color: isEditingPersonal || genderOptions.contains(selectedGender) ? AppColors.black : AppColors.gray,
            fontSize: 16.sp,
          ),
          dropdownColor: AppColors.white,
        ),
      ),
    );
  }
}
