import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  static const Color primaryColor = Color(0xFFFF675C);
  static const Color textColor = Color(0xFF898989);
  static TextStyle hintStyle = TextStyle(
    color: textColor,
    fontSize: 14.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 20),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  child: Icon(Icons.navigate_before, color: Colors.white, size: 20),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set a new password',
                    style: TextStyle(
                      color: Color(0xFF131313),
                      fontSize: 18.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Create a new password. Ensure it differs from\nprevious ones for security.', style: hintStyle),
                  const SizedBox(height: 40),

                  // Password Fields
                  _buildPasswordField(
                    controller: newPasswordController,
                    label: 'Enter your new password',
                    isVisible: isNewPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => isNewPasswordVisible = !isNewPasswordVisible);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    controller: confirmPasswordController,
                    label: 'Re-enter password',
                    isVisible: isConfirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Update Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Validate passwords & call backend API before navigating
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Successful()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 4,
                        shadowColor: const Color(0x0C000000),
                      ),
                      child: Text(
                        'Update Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 15, offset: Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: hintStyle,
          prefixIcon: const Icon(Icons.lock_outline, color: textColor),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, color: textColor),
            onPressed: onToggleVisibility,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
