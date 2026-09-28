import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ruang Stories'**
  String get appTitle;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'ruang cerita'**
  String get brandName;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Good to see you.'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Start telling stories.'**
  String get registerTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in and discover stories from new perspectives.'**
  String get loginSubtitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make room for your little everyday stories.'**
  String get registerSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Name shown to other readers'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get nameRequired;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@email.com'**
  String get emailHint;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordHint;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @switchToRegister.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get switchToRegister;

  /// No description provided for @switchToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get switchToLogin;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created. You can sign in now.'**
  String get accountCreated;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server.'**
  String get connectionError;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @writeStory.
  ///
  /// In en, this message translates to:
  /// **'Write a story'**
  String get writeStory;

  /// No description provided for @feedEyebrow.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S NOTES'**
  String get feedEyebrow;

  /// No description provided for @feedTitle.
  ///
  /// In en, this message translates to:
  /// **'Stories from\naround us.'**
  String get feedTitle;

  /// No description provided for @feedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Small moments, different points of view.'**
  String get feedSubtitle;

  /// No description provided for @storiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{# recent story} other{# recent stories}}'**
  String storiesCount(int count);

  /// No description provided for @feedLoadError.
  ///
  /// In en, this message translates to:
  /// **'Stories could not be loaded. Check your connection and try again.'**
  String get feedLoadError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @emptyFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'No stories here yet.'**
  String get emptyFeedTitle;

  /// No description provided for @emptyFeedBody.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share a moment.'**
  String get emptyFeedBody;

  /// No description provided for @storyDetail.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get storyDetail;

  /// No description provided for @newStory.
  ///
  /// In en, this message translates to:
  /// **'New story'**
  String get newStory;

  /// No description provided for @photoPrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo for your story'**
  String get photoPrompt;

  /// No description provided for @galleryOrCamera.
  ///
  /// In en, this message translates to:
  /// **'Gallery or camera'**
  String get galleryOrCamera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @replacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get replacePhoto;

  /// No description provided for @descriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about this moment'**
  String get descriptionTitle;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to share about this photo?'**
  String get descriptionHint;

  /// No description provided for @photoRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo first.'**
  String get photoRequired;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a short description for the photo.'**
  String get descriptionRequired;

  /// No description provided for @shareStory.
  ///
  /// In en, this message translates to:
  /// **'Share story'**
  String get shareStory;

  /// No description provided for @sendingStory.
  ///
  /// In en, this message translates to:
  /// **'Sharing...'**
  String get sendingStory;

  /// No description provided for @storyAdded.
  ///
  /// In en, this message translates to:
  /// **'Story shared.'**
  String get storyAdded;

  /// No description provided for @storyUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Story could not be shared. Check your connection.'**
  String get storyUploadFailed;

  /// No description provided for @photoOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the photo.'**
  String get photoOpenFailed;

  /// No description provided for @storyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'This story could not be loaded.'**
  String get storyLoadFailed;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
