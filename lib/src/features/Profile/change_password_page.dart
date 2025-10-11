import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    InputDecoration buildInputDecoration(String hintText, bool obscureText, VoidCallback toggleVisibility) {
      return InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.black54),
          onPressed: toggleVisibility,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.red),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Change Password",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Current Password
              const Text("Current Password"),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscureCurrent,
                decoration: buildInputDecoration("Enter your password", _obscureCurrent, () {
                  setState(() => _obscureCurrent = !_obscureCurrent);
                }),
              ),
              const SizedBox(height: 16),

              // New Password
              const Text("New Password"),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscureNew,
                decoration: buildInputDecoration("Enter new password", _obscureNew, () {
                  setState(() => _obscureNew = !_obscureNew);
                }),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              const Text("Password"),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscureConfirm,
                decoration: buildInputDecoration("Enter new password", _obscureConfirm, () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                }),
              ),
              const SizedBox(height: 16),

              // Forgot password text
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Forgot password action
                  },
                  child: const Text("Forgot password?", style: TextStyle(color: Colors.black87)),
                ),
              ),

              const Spacer(),

              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle update
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF675C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
