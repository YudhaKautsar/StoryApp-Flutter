// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ruang Stories';

  @override
  String get brandName => 'ruang cerita';

  @override
  String get loginTitle => 'Good to see you.';

  @override
  String get registerTitle => 'Start telling stories.';

  @override
  String get loginSubtitle =>
      'Sign in and discover stories from new perspectives.';

  @override
  String get registerSubtitle => 'Make room for your little everyday stories.';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Name shown to other readers';

  @override
  String get nameRequired => 'Please enter your name.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@email.com';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'At least 8 characters';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get switchToRegister => 'New here? Create an account';

  @override
  String get switchToLogin => 'Already have an account? Sign in';

  @override
  String get accountCreated => 'Account created. You can sign in now.';

  @override
  String get connectionError => 'Could not connect to the server.';

  @override
  String get logout => 'Sign out';

  @override
  String get language => 'Language';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get writeStory => 'Write a story';

  @override
  String get feedEyebrow => 'TODAY\'S NOTES';

  @override
  String get feedTitle => 'Stories from\naround us.';

  @override
  String get feedSubtitle => 'Small moments, different points of view.';

  @override
  String storiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# recent stories',
      one: '# recent story',
    );
    return '$_temp0';
  }

  @override
  String get feedLoadError =>
      'Stories could not be loaded. Check your connection and try again.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get emptyFeedTitle => 'No stories here yet.';

  @override
  String get emptyFeedBody => 'Be the first to share a moment.';

  @override
  String get storyDetail => 'Story';

  @override
  String get newStory => 'New story';

  @override
  String get photoPrompt => 'Choose a photo for your story';

  @override
  String get galleryOrCamera => 'Gallery or camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get replacePhoto => 'Change photo';

  @override
  String get descriptionTitle => 'Tell us about this moment';

  @override
  String get descriptionHint =>
      'What would you like to share about this photo?';

  @override
  String get photoRequired => 'Choose a photo first.';

  @override
  String get descriptionRequired => 'Add a short description for the photo.';

  @override
  String get shareStory => 'Share story';

  @override
  String get sendingStory => 'Sharing...';

  @override
  String get storyAdded => 'Story shared.';

  @override
  String get storyUploadFailed =>
      'Story could not be shared. Check your connection.';

  @override
  String get photoOpenFailed => 'Could not open the photo.';

  @override
  String get storyLoadFailed => 'This story could not be loaded.';

  @override
  String get back => 'Back';
}
