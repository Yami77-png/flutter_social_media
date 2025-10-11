import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'enter_code.dart';

class EnterEmail extends StatefulWidget {
  const EnterEmail({super.key});

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    final email = emailController.text.trim();
    // TODO: Add email validation logic here
    // TODO: Implement API call to send reset link

    Navigator.push(context, MaterialPageRoute(builder: (_) => EnterCode()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),
              const SizedBox(height: 40),
              _buildTitleSection(),
              const SizedBox(height: 48),
              _buildEmailInput(),
              const SizedBox(height: 20),
              _buildSendButton(),
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

  Widget _buildTitleSection() {
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
        SizedBox(height: 5),
        Text(
          'Please enter your email to reset the password',
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

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your email',
          style: TextStyle(
            color: Color(0xFF131313),
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 15, offset: Offset(0, 4))],
          ),
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: TextStyle(
                color: Color(0xFF898989),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _sendResetLink,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF675C),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
        ),
        child: Text(
          'Send Reset Link',
          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
