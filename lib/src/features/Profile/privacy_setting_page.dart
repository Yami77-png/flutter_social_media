import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'change_password_page.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsOptions = [
      {'icon': Icons.groups_2_outlined, 'label': 'Default Audience'},
      {'icon': Icons.person_outline, 'label': 'Profile Control'},
      {'icon': Icons.devices_outlined, 'label': 'Devices'},
      {'icon': Icons.lock_outline, 'label': 'Change Password'},
      {'icon': Icons.verified_user_outlined, 'label': '2 Step Verification'},
      {'icon': Icons.policy_outlined, 'label': 'Policy'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with back button
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.red),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Privacy",
                    style: TextStyle(fontSize: 18.sp, color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Settings List
              Expanded(
                child: ListView.separated(
                  itemCount: settingsOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = settingsOptions[index];
                    return Container(
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Icon(item['icon'], color: Colors.black54),
                        title: Text(
                          item['label'],
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          if (item['icon'] == Icons.lock_outline) {
                            // Get.to(() => const ChangePasswordPage()); // TODO: Fix navigation
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
