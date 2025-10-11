import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_media/src/core/utility/assets.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/phone_number_country_codes.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController phoneController;
  final String label;
  final String hintText;

  PhoneNumberField({super.key, required this.phoneController, required this.label, required this.hintText});

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  List<PhoneNumberCountryCodes> _countries = [];
  PhoneNumberCountryCodes? _selectedCountry;

  final TextEditingController _visibleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCountries();

    _visibleController.addListener(() {
      final dialCode = _selectedCountry?.dialCode ?? '';
      final localNumber = _visibleController.text.trim();

      // Combine dial code and number textfield
      widget.phoneController.text = '$dialCode$localNumber';
    });
  }

  @override
  void dispose() {
    _visibleController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final String response = await rootBundle.loadString(Assets.phoneNumberCountryCodes);
    final List<dynamic> data = json.decode(response);
    setState(() {
      _countries = data.map((json) => PhoneNumberCountryCodes.fromJson(json)).toList();
      _selectedCountry = _countries.firstWhere((c) => c.code.toUpperCase() == 'BD', orElse: () => _countries.first);
      ;
    });
  }

  void _onCountryChanged(PhoneNumberCountryCodes? newCountry) {
    if (newCountry == null) return;
    setState(() => _selectedCountry = newCountry);

    // update full controller with new dial code + number textfield
    final localNumber = _visibleController.text.trim();
    widget.phoneController.text = '${newCountry.dialCode}$localNumber';
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCountry == null) {
      return const CircularProgressIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.60,
            letterSpacing: -0.24,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFEDF1F3)),
            boxShadow: const [BoxShadow(color: Color(0x3DE4E5E7), blurRadius: 2, offset: Offset(0, 1))],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              DropdownButtonHideUnderline(
                child: DropdownButton<PhoneNumberCountryCodes>(
                  value: _selectedCountry,
                  onChanged: _onCountryChanged,
                  items: _countries.map((country) {
                    return DropdownMenuItem(value: country, child: Text('${country.code} ${country.dialCode}'));
                  }).toList(),
                ),
              ),
              const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFEDF1F3)),
              Expanded(
                child: TextFormField(
                  controller: _visibleController,
                  keyboardType: TextInputType.phone,
                  maxLength: _selectedCountry?.code == "BD" ? 10 : 15,
                  style: TextStyle(
                    color: Color(0xFF1A1C1E),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.40,
                    letterSpacing: -0.14,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: Color(0xFF6C7278),
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14),
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
