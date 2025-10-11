import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('ja'),
    Locale('mr'),
    Locale('ms'),
    Locale('ne'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
  ];

  /// No description provided for @accountTypes.
  ///
  /// In en, this message translates to:
  /// **'Account Types'**
  String get accountTypes;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get title;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @theBestAppForConnectsWithYourKnots.
  ///
  /// In en, this message translates to:
  /// **'The best app for connects with your friends.'**
  String get theBestAppForConnectsWithYourKnots;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @helloAgainYouveBeenMissed.
  ///
  /// In en, this message translates to:
  /// **'Hello again, you\'ve been missed!'**
  String get helloAgainYouveBeenMissed;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your E-Mail'**
  String get emailPlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordPlaceholder;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgotPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @contentCreator.
  ///
  /// In en, this message translates to:
  /// **'Content Creator'**
  String get contentCreator;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectYourBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Select your birth date'**
  String get selectYourBirthDate;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerName;

  /// No description provided for @ottName.
  ///
  /// In en, this message translates to:
  /// **'OTT Name'**
  String get ottName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @founderName.
  ///
  /// In en, this message translates to:
  /// **'Founder Name'**
  String get founderName;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @enterYourProfession.
  ///
  /// In en, this message translates to:
  /// **'Enter your profession'**
  String get enterYourProfession;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get designation;

  /// No description provided for @invalidEmailAddressError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailAddressError;

  /// No description provided for @fillAllFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in both email and password'**
  String get fillAllFieldsError;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @homeTown.
  ///
  /// In en, this message translates to:
  /// **'Home town'**
  String get homeTown;

  /// No description provided for @enterYourHomeTown.
  ///
  /// In en, this message translates to:
  /// **'Enter your home town'**
  String get enterYourHomeTown;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration Numer'**
  String get registrationNumber;

  /// No description provided for @enterYourRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your registration number'**
  String get enterYourRegistrationNumber;

  /// No description provided for @currentAddress.
  ///
  /// In en, this message translates to:
  /// **'Current Address'**
  String get currentAddress;

  /// No description provided for @enterYourCurrentAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your Current Address...'**
  String get enterYourCurrentAddress;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @enterCategory.
  ///
  /// In en, this message translates to:
  /// **'Enter category'**
  String get enterCategory;

  /// No description provided for @teamCount.
  ///
  /// In en, this message translates to:
  /// **'Team Count'**
  String get teamCount;

  /// No description provided for @enterTeamSize.
  ///
  /// In en, this message translates to:
  /// **'Enter teams size'**
  String get enterTeamSize;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @enterYourCompany.
  ///
  /// In en, this message translates to:
  /// **'Enter your company'**
  String get enterYourCompany;

  /// No description provided for @industry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get industry;

  /// No description provided for @enterYourIndustry.
  ///
  /// In en, this message translates to:
  /// **'Enter your industry'**
  String get enterYourIndustry;

  /// No description provided for @rePassword.
  ///
  /// In en, this message translates to:
  /// **'Re-Enter Password'**
  String get rePassword;

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get fillAllRequiredFields;

  /// No description provided for @passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password fields cannot be empty'**
  String get passwordCannotBeEmpty;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterYourDesignation.
  ///
  /// In en, this message translates to:
  /// **'Enter your designation'**
  String get enterYourDesignation;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon!'**
  String get comingSoon;

  /// No description provided for @letsConnect.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Connect'**
  String get letsConnect;

  /// No description provided for @yourProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Your Profile Picture'**
  String get yourProfilePicture;

  /// No description provided for @yourAvatar.
  ///
  /// In en, this message translates to:
  /// **'Your Avatar'**
  String get yourAvatar;

  /// No description provided for @pleaseSelectAnAvatar.
  ///
  /// In en, this message translates to:
  /// **'Please select an avatar!'**
  String get pleaseSelectAnAvatar;

  /// No description provided for @profilePicturePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture Privacy'**
  String get profilePicturePrivacy;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @publicDescription.
  ///
  /// In en, this message translates to:
  /// **'Everyone can see your profile picture.'**
  String get publicDescription;

  /// No description provided for @knots.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get knots;

  /// No description provided for @knotsDescription.
  ///
  /// In en, this message translates to:
  /// **'Only your Friends can see your profile picture.'**
  String get knotsDescription;

  /// No description provided for @onlyMe.
  ///
  /// In en, this message translates to:
  /// **'Only Me'**
  String get onlyMe;

  /// No description provided for @onlyMeDescription.
  ///
  /// In en, this message translates to:
  /// **'Your profile picture will be private.'**
  String get onlyMeDescription;

  /// No description provided for @privacyUpdatedTo.
  ///
  /// In en, this message translates to:
  /// **'Privacy updated to:'**
  String get privacyUpdatedTo;

  /// No description provided for @errorLoadingLocale.
  ///
  /// In en, this message translates to:
  /// **'Error loading locale:'**
  String get errorLoadingLocale;

  /// No description provided for @screenshotPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Chat Screenshot Privacy'**
  String get screenshotPrivacy;

  /// No description provided for @screenshotAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get screenshotAllow;

  /// No description provided for @screenshotAllowDescription.
  ///
  /// In en, this message translates to:
  /// **'Anyone can take screenshots of your chats.'**
  String get screenshotAllowDescription;

  /// No description provided for @screenshotDisallow.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Allow'**
  String get screenshotDisallow;

  /// No description provided for @screenshotDisallowDescription.
  ///
  /// In en, this message translates to:
  /// **'Screenshots of your chats are blocked.'**
  String get screenshotDisallowDescription;

  /// No description provided for @screenshotNotify.
  ///
  /// In en, this message translates to:
  /// **'Notify Me'**
  String get screenshotNotify;

  /// No description provided for @screenshotNotifyDescription.
  ///
  /// In en, this message translates to:
  /// **'You’ll be notified if someone takes a screenshot.'**
  String get screenshotNotifyDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'gu',
    'hi',
    'ja',
    'mr',
    'ms',
    'ne',
    'ta',
    'te',
    'th',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'ne':
      return AppLocalizationsNe();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
