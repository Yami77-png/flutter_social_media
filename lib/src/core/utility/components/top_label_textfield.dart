import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/features/auth/application/obscure_text_cubit/obscure_text_cubit.dart';

class TopLabelTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool showSuffixIcon;
  final VoidCallback? onTap;
  final int maxLength;

  const TopLabelTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.showSuffixIcon = true,
    this.onTap,
    this.maxLength = 255,
  });

  @override
  Widget build(BuildContext context) {
    if (!obscureText) {
      return _buildTextField(context, isObscured: false);
    }

    // If it's a password field
    return BlocBuilder<ObscureTextCubit, bool>(
      builder: (context, isObscured) {
        return _buildTextField(context, isObscured: isObscured);
      },
    );
  }

  Widget _buildTextField(BuildContext context, {required bool isObscured}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.60,
            letterSpacing: -0.24,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          maxLength: maxLength,
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: isObscured,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color(0xFF6C7278),
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixIcon: (obscureText && showSuffixIcon)
                ? GestureDetector(
                    onTap: () => context.read<ObscureTextCubit>().toggle(),
                    child: Icon(
                      isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                  )
                : null,
            counterText: "",
          ),
        ),
      ],
    );
  }
}
