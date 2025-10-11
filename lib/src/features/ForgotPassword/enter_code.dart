import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_media/src/features/ForgotPassword/submit_code.dart';

class EnterCode extends StatelessWidget {
  EnterCode({super.key});

  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  void nextField(String value, int index) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
  }

  void previousField(String value, int index) {
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildBackButton(context),
              const SizedBox(height: 32),
              _buildTitleAndDescription(),
              const SizedBox(height: 32),
              _buildVerifyButton(context),
              const SizedBox(height: 32),
              _buildCodeInputFields(),
              const Spacer(),
              _buildBottomSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(color: Color(0xFFFF675C), shape: BoxShape.circle),
        child: Icon(Icons.navigate_before, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forgot password',
          style: TextStyle(
            color: Color(0xFF131313),
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'We sent a reset link to abcd....@gmail.com\nEnter the 6-digit code mentioned in the email.',
          style: TextStyle(
            color: Color(0xFF898989),
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Add verification logic here
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SubmitCode()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF675C),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
        ),
        child: Text(
          'Verify Code',
          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCodeInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) => _buildCodeBox(index)),
    );
  }

  Widget _buildCodeBox(int index) {
    return SizedBox(
      width: 45,
      height: 46,
      child: TextFormField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFF675C), width: 1.5),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            nextField(value, index);
          } else if (value.isEmpty) {
            previousField(value, index);
          }
        },
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement code submission logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF675C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 2,
            ),
            child: Text(
              'Enter Code',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 15),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Haven`t got the email yet? ',
                style: TextStyle(
                  color: Color(0xFF131313),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Resend email.',
                style: TextStyle(
                  color: Color(0xFFFF675C),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
