import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/utility/assets.dart';
import 'package:flutter_social_media/src/core/utility/components/primary_scaffold.dart';
import 'package:flutter_social_media/src/core/utility/components/top_label_textfield.dart';
import 'package:flutter_social_media/src/features/Profile/application/location_cubit/location_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/location_cubit/location_state.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/location_model.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/location_picker_field.dart';
import 'package:flutter_social_media/src/features/auth/application/obscure_text_cubit/obscure_text_cubit.dart';
import 'package:flutter_social_media/src/features/auth/application/sign_up_cubit/sign_up_cubit.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/signup_dto.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/avatar_picker.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/sign_in_sign_up_button.dart';
import 'package:flutter_social_media/src/features/auth/presentation/email_verification_page.dart';

class CreateProfilePage extends StatefulWidget {
  static const route = 'create_profile_page';
  String name;
  String email;
  String phoneNumber;
  String dob;
  String gender;
  String ownerName;
  String professional;
  String designation;
  UserType userType;

  CreateProfilePage({
    super.key,
    required this.dob,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.gender,
    required this.ownerName,
    required this.professional,
    required this.designation,
    required this.userType,
  });

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  Location? _homeTownLocation;
  Location? _currentLocation;

  final _setPasswordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  //business
  final _regiNumberController = TextEditingController();

  //content creator
  final _categoryController = TextEditingController();
  final _teamCountController = TextEditingController();
  String? _selectedCreatorGender;
  DateTime? selectedDate;
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

  //professional
  final _companyController = TextEditingController();
  final _industryController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedAvatar;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _getFirebaseDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    await messaging.requestPermission();

    // Get the token
    String? token = await messaging.getToken();
    return token;
  }

  void _showLocationPicker({
    required BuildContext context,
    required String label,
    required Function(Location) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<LocationCubit>(),
        child: LocationPickerField(label: label, onSelected: onSelected),
      ),
    );
  }

  @override
  void dispose() {
    _setPasswordController.dispose();
    _rePasswordController.dispose();
    _regiNumberController.dispose();
    _categoryController.dispose();
    _teamCountController.dispose();
    _companyController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  Widget _locationPicker({
    required String label,
    required String hint,
    required Location? selectedLocation,
    required VoidCallback onTap,
  }) {
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
        InkWell(
          onTap: onTap,
          child: Container(
            height: 46,
            padding: EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEDF1F3)),
              boxShadow: const [BoxShadow(color: Color(0x3DE4E5E7), blurRadius: 2, offset: Offset(0, 1))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedLocation != null ? "${selectedLocation.name}, ${selectedLocation.address}" : hint,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selectedLocation != null ? const Color(0xFF1A1C1E) : const Color(0xFF6C7278),
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(Icons.location_on_outlined, color: Color(0xFF6C7278), size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: Text('Localization not available')));
    }
    log(widget.gender);
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          loading: (_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          },
          success: (_) {
            context.pushReplacementNamed(EmailVerificationPage.route);
          },
          error: (e) {
            Navigator.of(context).pop(); // Dismiss loading dialog
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
          },
        );
      },

      child: PrimaryScaffold(
        appBarTitle: l10n.createAnAccount,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.yourProfilePicture,
                  style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 150 / 2,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(75), // same as radius
                            child: Image.asset(
                              widget.gender == 'Male' ? Assets.malePlaceholder1Png : Assets.femalePlaceholder10Png,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 150 * 0.25,
                        height: 150 * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              // Center(child: ProfileAvatarWithAddButton()),
              const SizedBox(height: 30),
              BlocBuilder<LocationCubit, LocationState>(
                builder: (context, locationState) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (widget.userType == UserType.individual)
                          AvatarPicker(
                            gender: widget.gender,
                            onAvatarSelected: (avatarPath) {
                              setState(() {
                                _selectedAvatar = avatarPath;
                              });
                            },
                          ),
                        if (widget.userType == UserType.individual)
                          _locationPicker(
                            label: l10n.homeTown,
                            hint: l10n.enterYourHomeTown,
                            selectedLocation: _homeTownLocation,
                            onTap: () => _showLocationPicker(
                              context: context,
                              label: l10n.homeTown,
                              onSelected: (location) {
                                // Update local variable
                                _homeTownLocation = location;
                                // Update cubit to trigger rebuild
                                context.read<LocationCubit>().select(location);
                              },
                            ),
                          ),
                        if (widget.userType == UserType.business)
                          TopLabelTextField(
                            controller: _regiNumberController,
                            hintText: l10n.enterYourRegistrationNumber,
                            label: l10n.registrationNumber,
                          ),
                        if (widget.userType == UserType.contentCreator)
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
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                          color: selectedDate != null
                                              ? const Color(0xFF1A1C1E)
                                              : const Color(0xFF6C7278),
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
                        if (widget.userType != UserType.professional)
                          _locationPicker(
                            label: l10n.currentAddress,
                            hint: l10n.enterYourCurrentAddress,
                            selectedLocation: _currentLocation,
                            onTap: () => _showLocationPicker(
                              context: context,
                              label: l10n.currentAddress,
                              onSelected: (location) {
                                // Update local variable
                                _currentLocation = location;
                                // Update cubit to trigger rebuild
                                context.read<LocationCubit>().select(location);
                              },
                            ),
                          ),
                        if (widget.userType == UserType.contentCreator) ...[
                          TopLabelTextField(
                            controller: _categoryController,
                            hintText: l10n.enterCategory,
                            label: l10n.category,
                          ),
                          TopLabelTextField(
                            controller: _teamCountController,
                            hintText: l10n.enterTeamSize,
                            label: l10n.teamCount,
                          ),
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
                                value: _selectedCreatorGender,
                                hint: Text(l10n.selectGender),
                                items: [
                                  DropdownMenuItem(value: 'Male', child: Text(l10n.male)),
                                  DropdownMenuItem(value: 'Female', child: Text(l10n.female)),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    _selectedCreatorGender = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (widget.userType == UserType.professional) ...[
                          TopLabelTextField(
                            controller: _companyController,
                            hintText: l10n.enterYourCompany,
                            label: l10n.company,
                          ),
                          TopLabelTextField(
                            controller: _industryController,
                            hintText: l10n.enterYourIndustry,
                            label: l10n.industry,
                          ),
                        ],
                        BlocProvider(
                          create: (_) => ObscureTextCubit(),
                          child: Builder(
                            builder: (context) {
                              return TopLabelTextField(
                                controller: _setPasswordController,
                                hintText: '******',
                                label: l10n.password,
                                obscureText: true,
                                showSuffixIcon: true,
                              );
                            },
                          ),
                        ),
                        TopLabelTextField(
                          controller: _rePasswordController,
                          hintText: '******',
                          label: l10n.rePassword,
                          obscureText: true,
                          showSuffixIcon: false,
                        ),
                      ].map((e) => Padding(padding: EdgeInsets.only(bottom: 16), child: e)).toList(),
                    ),
                  );
                },
              ),
              SignInSignUpButton(
                onTap: () async {
                  final hometownAddress = "${_homeTownLocation?.name}, ${_homeTownLocation?.address}";
                  final currentAddress = "${_currentLocation?.name}, ${_currentLocation?.address}";
                  final regiNumber = _regiNumberController.text.trim();
                  final category = _categoryController.text.trim();
                  final foundingDate = selectedDate.toString();
                  final teamCount = int.tryParse(_teamCountController.text.trim());
                  final company = _companyController.text.trim();
                  final industry = _industryController.text.trim();

                  bool isInvalidForm() {
                    switch (widget.userType) {
                      case UserType.individual:
                        // Avatar validation
                        if (_selectedAvatar == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.pleaseSelectAnAvatar), behavior: SnackBarBehavior.floating),
                          );
                          return true;
                        }
                        return _homeTownLocation == null || _currentLocation == null;
                      case UserType.business:
                        return regiNumber.isEmpty || _currentLocation == null;
                      case UserType.contentCreator:
                        return selectedDate == null ||
                            _currentLocation == null ||
                            category.isEmpty ||
                            teamCount == null;
                      case UserType.professional:
                        return company.isEmpty || industry.isEmpty;
                    }
                  }

                  if (isInvalidForm()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.fillAllRequiredFields), behavior: SnackBarBehavior.floating),
                    );
                    return;
                  }

                  final password = _setPasswordController.text.trim();
                  final confirmPassword = _rePasswordController.text.trim();

                  if (password.isEmpty || confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.passwordCannotBeEmpty)));
                    return;
                  }

                  if (password.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.passwordTooShort)));
                    return;
                  }

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.passwordsDoNotMatch)));
                    return;
                  }

                  String deviceId = await _getFirebaseDeviceToken() ?? '';
                  String _fallbackAvatar = widget.gender == 'Male'
                      ? Assets.malePlaceholder1Png
                      : Assets.femalePlaceholder1Png;

                  context.read<SignUpCubit>().signUp(
                    dto: SignupDto(
                      uuid: '',
                      refid: '',
                      isProfileCompleted: false,
                      isVerifed: false,
                      email: widget.email,
                      password: password,
                      dob: widget.dob,
                      gender: widget.gender,
                      name: widget.name,
                      phoneNumber: widget.phoneNumber,
                      imageUrl: _imageFile?.path,
                      publicAvatar: _selectedAvatar ?? _fallbackAvatar,
                      deviceId: deviceId,
                      userType: widget.userType,
                      homeAddress: hometownAddress,
                      currentAddress: currentAddress,
                      ownerName: widget.ownerName,
                      regiNumber: regiNumber,
                      foundingDate: foundingDate,
                      category: category,
                      teamCount: teamCount,
                      creatorGender: _selectedCreatorGender,
                      availability: '',
                      designation: widget.designation,
                      professional: widget.professional,
                      company: company,
                      industry: industry,
                    ),
                  );
                },
                text: l10n.signUp,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
