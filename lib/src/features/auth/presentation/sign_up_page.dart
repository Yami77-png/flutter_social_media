import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/utility/components/primary_scaffold.dart';
import 'package:flutter_social_media/src/core/utility/components/top_label_textfield.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/phone_number_field.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/sign_in_sign_up_button.dart';
import 'package:flutter_social_media/src/features/auth/presentation/create_profile.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  final UserType userType;
  const SignUpPage({super.key, required this.userType});
  static const String route = 'sign_up_page';
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;
  DateTime? selectedDate;
  final _professionalController = TextEditingController();
  final _designationController = TextEditingController();

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: Text('Localization not available')));
    }

    return PrimaryScaffold(
      appBarTitle: "Sign Up",
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      const SizedBox(height: 32),
                      TopLabelTextField(
                        controller: _nameController,
                        label: widget.userType == UserType.business
                            ? l10n.businessName
                            : widget.userType == UserType.contentCreator
                            ? l10n.ottName
                            : l10n.name,
                        hintText: l10n.enterYourFullName,
                        maxLength: 100,
                      ),
                      if (widget.userType == UserType.business || widget.userType == UserType.contentCreator)
                        TopLabelTextField(
                          controller: _ownerNameController,
                          label: widget.userType == UserType.business ? l10n.ownerName : l10n.founderName,
                          hintText: l10n.ownerName,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      if (widget.userType == UserType.professional) ...[
                        TopLabelTextField(
                          controller: _professionalController,
                          label: l10n.profession,
                          hintText: l10n.enterYourProfession,
                        ),
                        TopLabelTextField(
                          controller: _designationController,
                          label: l10n.designation,
                          hintText: l10n.enterYourDesignation,
                        ),
                      ],
                      TopLabelTextField(
                        controller: _emailController,
                        label: l10n.email,
                        hintText: l10n.enterYourEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      PhoneNumberField(
                        phoneController: _phoneController,
                        label: l10n.phoneNumber,
                        hintText: l10n.enterYourPhoneNumber,
                      ),
                      if (widget.userType == UserType.individual) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.gender,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.60,
                                letterSpacing: -0.24,
                              ),
                            ),
                            const SizedBox(height: 5),
                            DropdownButtonFormField(
                              value: _selectedGender,
                              hint: Text(l10n.selectGender),
                              items: [
                                DropdownMenuItem(value: 'Male', child: Text(l10n.male)),
                                DropdownMenuItem(value: 'Female', child: Text(l10n.female)),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _selectedGender = val;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0xFFEDF1F3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0xFFEDF1F3)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dateOfBirth,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.60,
                                letterSpacing: -0.24,
                              ),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: Container(
                                height: 46,
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFEDF1F3)),
                                  boxShadow: const [
                                    BoxShadow(color: Color(0x3DE4E5E7), blurRadius: 2, offset: Offset(0, 1)),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedDate != null
                                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                          : l10n.selectYourBirthDate,
                                      style: TextStyle(
                                        color: selectedDate != null ? const Color(0xFF1A1C1E) : const Color(0xFF6C7278),
                                        fontSize: 14.sp,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.calendar_today_outlined, color: Color(0xFF6C7278), size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SignInSignUpButton(
              onTap: () {
                final email = _emailController.text.trim();
                final phoneNo = _phoneController.text.trim();
                final name = _nameController.text.trim();
                final dob = selectedDate;
                final gender = _selectedGender;
                final ownerName = _ownerNameController.text.trim();
                final professional = _professionalController.text.trim();
                final designation = _designationController.text.trim();

                final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                bool isInvalidForm() {
                  switch (widget.userType) {
                    case UserType.individual:
                      return email.isEmpty || name.isEmpty || dob == null || gender == null;
                    case UserType.business:
                    case UserType.contentCreator:
                      return email.isEmpty || name.isEmpty || ownerName.isEmpty;
                    case UserType.professional:
                      return email.isEmpty || name.isEmpty || professional.isEmpty || designation.isEmpty;
                  }
                }

                if (isInvalidForm()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.fillAllRequiredFields), behavior: SnackBarBehavior.floating),
                  );
                } else if (!emailRegex.hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.invalidEmailAddressError), behavior: SnackBarBehavior.floating),
                  );
                } else {
                  context.pushNamed(
                    CreateProfilePage.route,
                    extra: (
                      name: name,
                      email: email,
                      phoneNumber: phoneNo,
                      dob: dob.toString(),
                      gender: gender.toString(),
                      ownerName: ownerName,
                      professional: professional,
                      designation: designation,
                      userType: widget.userType,
                    ),
                  );
                }
              },
              text: l10n.next,
            ),
            const SizedBox(height: 16),
            _buildLoginRedirect(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAnAccount,
          style: TextStyle(
            color: Color(0xFF6C7278),
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.pushReplacementNamed(SigninPage.route);
          },
          child: Text(
            l10n.login,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
