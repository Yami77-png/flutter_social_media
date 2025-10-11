import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_snackbar.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/Profile/application/location_cubit/location_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_cubit/profile_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_update_cubit/profile_update_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/location_model.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/profile_update_dto.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/build_gender_dropdown.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/build_text_field.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/location_picker_field.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/business_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/content_creator_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/professional_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';

class ProfileUpdatePage extends StatefulWidget {
  static const String route = 'profile_update_page';
  const ProfileUpdatePage({
    super.key,
    required this.user,
    this.individual,
    this.business,
    this.professinal,
    this.contentCreator,
  });

  final Userx user;
  final IndividualProfileModel? individual;
  final BusinessProfileModel? business;
  final ProfessionalProfileModel? professinal;
  final ContentCreatorProfileModel? contentCreator;

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final nameTEC = TextEditingController();
  final phoneTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final bioTEC = TextEditingController();
  final dobTEC = TextEditingController();
  final List<String> genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  String _selectedGender = 'Male';

  final collegeTEC = TextEditingController();
  final subjectTEC = TextEditingController();
  final currentAddressTEC = TextEditingController();
  final homeTownTEC = TextEditingController();

  final ownerNameTEC = TextEditingController();
  final registrationNoTEC = TextEditingController();

  final categoryTEC = TextEditingController();
  final foundingDateTEC = TextEditingController();
  final teamCountTEC = TextEditingController();

  final companyTEC = TextEditingController();
  final designationTEC = TextEditingController();
  final industryTEC = TextEditingController();
  final professionalTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _addListenersToControllers();
  }

  void _initializeValues() {
    nameTEC.text = widget.user.name;
    phoneTEC.text = widget.user.phoneNumber ?? '';
    emailTEC.text = widget.user.email;

    switch (widget.user.userType) {
      case UserType.individual:
        bioTEC.text = widget.individual?.bio ?? '';
        dobTEC.text = widget.individual?.dob ?? '';
        _selectedGender = widget.individual?.gender ?? 'Male';
        currentAddressTEC.text = widget.individual?.currentAddress ?? '';
        collegeTEC.text = widget.individual?.collegeName ?? '';
        subjectTEC.text = widget.individual?.subject ?? '';
        homeTownTEC.text = widget.individual?.hometown ?? '';
        break;
      case UserType.business:
        ownerNameTEC.text = widget.business?.ownerName ?? '';
        registrationNoTEC.text = widget.business?.regiNumber ?? '';
        currentAddressTEC.text = widget.business?.currentAddress ?? '';
        break;
      case UserType.contentCreator:
        ownerNameTEC.text = widget.contentCreator?.ownerName ?? '';
        _selectedGender = widget.contentCreator?.gender ?? 'Male';
        categoryTEC.text = widget.contentCreator?.category ?? '';
        foundingDateTEC.text = widget.contentCreator?.foundingDate ?? '';
        teamCountTEC.text = '${widget.contentCreator?.teamCount}';
        currentAddressTEC.text = widget.contentCreator?.currentAddress ?? '';
        break;
      case UserType.professional:
        companyTEC.text = widget.professinal?.company ?? '';
        designationTEC.text = widget.professinal?.designation ?? '';
        industryTEC.text = widget.professinal?.industry ?? '';
        professionalTEC.text = widget.professinal?.professional ?? '';
        break;
    }
  }

  void _addListenersToControllers() {
    nameTEC.addListener(_checkChanges);
    phoneTEC.addListener(_checkChanges);
    bioTEC.addListener(_checkChanges);
    dobTEC.addListener(_checkChanges);
    collegeTEC.addListener(_checkChanges);
    subjectTEC.addListener(_checkChanges);
    currentAddressTEC.addListener(_checkChanges);
    homeTownTEC.addListener(_checkChanges);
    ownerNameTEC.addListener(_checkChanges);
    registrationNoTEC.addListener(_checkChanges);
    categoryTEC.addListener(_checkChanges);
    foundingDateTEC.addListener(_checkChanges);
    teamCountTEC.addListener(_checkChanges);
    companyTEC.addListener(_checkChanges);
    designationTEC.addListener(_checkChanges);
    industryTEC.addListener(_checkChanges);
    professionalTEC.addListener(_checkChanges);
  }

  bool _hasChanges = false;
  void _checkChanges() {
    bool hasChanged = false;

    if (nameTEC.text != widget.user.name) hasChanged = true;
    if (phoneTEC.text != (widget.user.phoneNumber ?? '')) hasChanged = true;

    switch (widget.user.userType) {
      case UserType.individual:
        if (bioTEC.text != (widget.individual?.bio ?? '')) hasChanged = true;
        if (dobTEC.text != (widget.individual?.dob ?? '')) hasChanged = true;
        if (_selectedGender != (widget.individual?.gender ?? 'Male')) hasChanged = true;
        if (currentAddressTEC.text != (widget.individual?.currentAddress ?? '')) hasChanged = true;
        if (collegeTEC.text != (widget.individual?.collegeName ?? '')) hasChanged = true;
        if (subjectTEC.text != (widget.individual?.subject ?? '')) hasChanged = true;
        if (homeTownTEC.text != (widget.individual?.hometown ?? '')) hasChanged = true;
        break;
      case UserType.business:
        if (ownerNameTEC.text != (widget.business?.ownerName ?? '')) hasChanged = true;
        if (registrationNoTEC.text != (widget.business?.regiNumber ?? '')) hasChanged = true;
        if (currentAddressTEC.text != (widget.business?.currentAddress ?? '')) hasChanged = true;
        break;
      case UserType.contentCreator:
        if (ownerNameTEC.text != (widget.contentCreator?.ownerName ?? '')) hasChanged = true;
        if (_selectedGender != (widget.contentCreator?.gender ?? 'Male')) hasChanged = true;
        if (dobTEC.text != (widget.individual?.dob ?? '')) hasChanged = true;
        if (categoryTEC.text != (widget.contentCreator?.category ?? '')) hasChanged = true;
        if (foundingDateTEC.text != (widget.contentCreator?.foundingDate ?? '')) hasChanged = true;
        if (teamCountTEC.text != (widget.contentCreator?.teamCount ?? '')) hasChanged = true;
        if (currentAddressTEC.text != (widget.contentCreator?.currentAddress ?? '')) hasChanged = true;
        break;
      case UserType.professional:
        if (companyTEC.text != (widget.professinal?.company ?? '')) hasChanged = true;
        if (designationTEC.text != (widget.professinal?.designation ?? '')) hasChanged = true;
        if (industryTEC.text != (widget.professinal?.industry ?? '')) hasChanged = true;
        if (professionalTEC.text != (widget.professinal?.professional ?? '')) hasChanged = true;
        break;
    }

    if (currentAddressTEC.text != (widget.business?.currentAddress ?? '')) hasChanged = true;

    if (hasChanged != _hasChanges) {
      setState(() {
        _hasChanges = hasChanged;
      });
    }
  }

  bool isLoading = false;
  _toggleIsLoading({bool? value}) {
    setState(() {
      isLoading = value ?? !isLoading;
    });
  }

  @override
  void dispose() {
    nameTEC.removeListener(_checkChanges);
    phoneTEC.removeListener(_checkChanges);
    emailTEC.removeListener(_checkChanges);
    bioTEC.removeListener(_checkChanges);
    dobTEC.removeListener(_checkChanges);
    collegeTEC.removeListener(_checkChanges);
    subjectTEC.removeListener(_checkChanges);
    currentAddressTEC.removeListener(_checkChanges);
    homeTownTEC.removeListener(_checkChanges);
    ownerNameTEC.removeListener(_checkChanges);
    registrationNoTEC.removeListener(_checkChanges);
    categoryTEC.removeListener(_checkChanges);
    foundingDateTEC.removeListener(_checkChanges);
    teamCountTEC.removeListener(_checkChanges);
    companyTEC.removeListener(_checkChanges);
    designationTEC.removeListener(_checkChanges);
    industryTEC.removeListener(_checkChanges);
    professionalTEC.removeListener(_checkChanges);

    nameTEC.dispose();
    phoneTEC.dispose();
    emailTEC.dispose();
    bioTEC.dispose();
    dobTEC.dispose();
    collegeTEC.dispose();
    subjectTEC.dispose();
    currentAddressTEC.dispose();
    homeTownTEC.dispose();
    ownerNameTEC.dispose();
    registrationNoTEC.dispose();
    categoryTEC.dispose();
    foundingDateTEC.dispose();
    teamCountTEC.dispose();
    companyTEC.dispose();
    designationTEC.dispose();
    industryTEC.dispose();
    professionalTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Update Profile'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 14,
          children: [
            _buildPersonalInformation(context),
            if (widget.user.userType == UserType.individual) _buildWorkAndEducation(context),
            if (widget.user.userType == UserType.business) _buildBusinessInfo(context),
            if (widget.user.userType == UserType.contentCreator) _buildContentCreatorInfo(context),
            if (widget.user.userType == UserType.professional) _buildProfessionalInfo(context),
            //update btn
            SizedBox(
              width: double.infinity,
              height: 60,
              child: BlocProvider(
                create: (context) => ProfileUpdateCubit(),
                child: BlocConsumer<ProfileUpdateCubit, ProfileUpdateState>(
                  listener: (context, state) {
                    state.mapOrNull(
                      loading: (_) => _toggleIsLoading(value: true),
                      success: (_) {
                        context.read<ProfileCubit>().getUserInfo();
                        context.pop();
                        context.pop();
                        AppSnackbar.show(
                          context,
                          message: 'Profile updated sucessfully',
                          backgroundColor: Colors.lightGreen,
                        );
                        _toggleIsLoading(value: false);
                      },
                      error: (value) {
                        _toggleIsLoading(value: false);
                        AppSnackbar.show(context, message: value.message);
                      },
                    );
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: (isLoading || !_hasChanges)
                          ? null
                          : () {
                              context.read<ProfileUpdateCubit>().updateUserProfile(
                                dto: ProfileUpdateDto(
                                  uuid: widget.user.uuid,
                                  refid: widget.user.refid,
                                  deviceId: widget.user.deviceId,
                                  userType: widget.user.userType,
                                  imageUrl: widget.user.imageUrl,
                                  coverImageUrl: widget.user.coverImageUrl,
                                  name: nameTEC.text.trim(),
                                  name_lower: nameTEC.text.trim().toLowerCase(),
                                  username: widget.user.username,
                                  email: widget.user.email,
                                  phoneNumber: phoneTEC.text.trim(),
                                  dob: dobTEC.text,
                                  gender: _selectedGender,
                                  bio: bioTEC.text.trim(),
                                  collegeName: collegeTEC.text.trim(),
                                  subject: subjectTEC.text.trim(),
                                  currentAddress: currentAddressTEC.text.trim(),
                                  hometown: homeTownTEC.text.trim(),
                                  ownerName: ownerNameTEC.text.trim(),
                                  regiNumber: registrationNoTEC.text.trim(),
                                  category: categoryTEC.text.trim(),
                                  foundingDate: foundingDateTEC.text.trim(),
                                  teamCount: int.tryParse(teamCountTEC.text.trim()) ?? 0,
                                  company: companyTEC.text.trim(),
                                  designation: designationTEC.text.trim(),
                                  industry: industryTEC.text.trim(),
                                  professional: professionalTEC.text.trim(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('Update', style: AppTextStyles.buttonText),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Container _buildWorkAndEducation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 6,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Work and Education', style: TextStyle(fontSize: 16.sp)),
              ),
              Icon(Icons.edit_outlined, color: Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          _textField(controller: collegeTEC, label: 'College Name'),
          _textField(controller: subjectTEC, label: 'Subject'),
          _textField(
            controller: currentAddressTEC,
            label: 'Current Address',
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showLocationBottomSheet(
                context: context,
                label: 'Current Address',
                onSelected: (location) {
                  // Update local variable
                  currentAddressTEC.text = location.address;
                  // Update cubit to trigger rebuild
                  context.read<LocationCubit>().select(location);
                },
              );
            },
          ),
          _textField(
            controller: homeTownTEC,
            label: 'Home Town',
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showLocationBottomSheet(
                context: context,
                label: 'Home Town',
                onSelected: (location) {
                  // Update local variable
                  homeTownTEC.text = location.address;
                  // Update cubit to trigger rebuild
                  context.read<LocationCubit>().select(location);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLocationBottomSheet({
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

  Container _buildBusinessInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 6,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('More Information', style: TextStyle(fontSize: 16.sp)),
              ),
              Icon(Icons.edit_outlined, color: Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          _textField(controller: ownerNameTEC, label: 'Owner Name'),
          _textField(controller: registrationNoTEC, label: 'Registration Number'),
          _textField(controller: currentAddressTEC, label: 'Current Address'),
        ],
      ),
    );
  }

  Container _buildContentCreatorInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 6,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('More Information', style: TextStyle(fontSize: 16.sp)),
              ),
              Icon(Icons.edit_outlined, color: Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          _textField(controller: ownerNameTEC, label: 'Owner Name'),
          _genderDropdown(),
          _textField(controller: categoryTEC, label: 'Category'),
          _textField(
            controller: foundingDateTEC,
            label: 'Founding Date',
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());

              DateTime pastYears({required int year}) => DateTime.now().subtract(Duration(days: year * 365));

              showDatePicker(
                context: context,
                firstDate: pastYears(year: 110),
                initialDate: pastYears(year: 12),
                lastDate: pastYears(year: 12),
              ).then((date) {
                if (date != null) {
                  setState(() {
                    dobTEC.text = date.toString().split(' ').first;
                  });
                }
              });
            },
          ),
          _textField(controller: teamCountTEC, label: 'Team Count'),
          _textField(controller: currentAddressTEC, label: 'Current Address'),
        ],
      ),
    );
  }

  Container _buildProfessionalInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 6,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('More Information', style: TextStyle(fontSize: 16.sp)),
              ),
              Icon(Icons.edit_outlined, color: Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          _textField(controller: companyTEC, label: 'Company'),
          _textField(controller: designationTEC, label: 'Designation'),
          _textField(controller: industryTEC, label: 'Industry'),
          _textField(controller: professionalTEC, label: 'Professional'),
        ],
      ),
    );
  }

  Container _buildPersonalInformation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 6,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Personal Information', style: TextStyle(fontSize: 16.sp)),
              ),
              Icon(Icons.edit_outlined, color: Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          _textField(controller: nameTEC, label: 'Name'),
          if (widget.user.userType == UserType.individual) _textField(controller: bioTEC, label: 'Insight'),
          if (widget.user.userType == UserType.individual || widget.user.userType == UserType.contentCreator) ...[
            _textField(
              controller: dobTEC,
              label: 'Date of Birth',
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                DateTime pastYears({required int year}) => DateTime.now().subtract(Duration(days: year * 365));

                showDatePicker(
                  context: context,
                  firstDate: pastYears(year: 110),
                  initialDate: pastYears(year: 12),
                  lastDate: pastYears(year: 12),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      dobTEC.text = date.toString().split(' ').first;
                    });
                  }
                });
              },
            ),
            _genderDropdown(),
          ],
          _textField(controller: phoneTEC, label: 'Phone'),
          _textField(controller: emailTEC, label: 'Email', readOnly: true),
        ],
      ),
    );
  }

  Widget _genderDropdown() {
    return Card(
      elevation: 2,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BuildGenderDropdown(
            isEditingPersonal: true,
            selectedGender: _selectedGender,
            onGenderChanged: (value) {
              if (value != null) {
                setState(() => _selectedGender = value);
                _checkChanges();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BuildTextField(label: label, controller: controller, readOnly: readOnly, onTap: onTap),
        ),
      ),
    );
  }
}
