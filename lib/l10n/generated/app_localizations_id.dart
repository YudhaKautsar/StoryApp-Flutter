// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Ruang Cerita';

  @override
  String get brandName => 'ruang cerita';

  @override
  String get loginTitle => 'Senang melihatmu.';

  @override
  String get registerTitle => 'Mulai bercerita.';

  @override
  String get loginSubtitle =>
      'Masuk dan temukan cerita dari banyak sudut pandang.';

  @override
  String get registerSubtitle => 'Buat ruang untuk cerita-cerita kecilmu.';

  @override
  String get nameLabel => 'Nama';

  @override
  String get nameHint => 'Nama yang ingin ditampilkan';

  @override
  String get nameRequired => 'Nama wajib diisi.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'nama@email.com';

  @override
  String get emailInvalid => 'Masukkan alamat email yang valid.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Minimal 8 karakter';

  @override
  String get passwordTooShort => 'Password minimal 8 karakter.';

  @override
  String get showPassword => 'Tampilkan password';

  @override
  String get hidePassword => 'Sembunyikan password';

  @override
  String get signIn => 'Masuk';

  @override
  String get createAccount => 'Buat akun';

  @override
  String get switchToRegister => 'Belum punya akun? Daftar';

  @override
  String get switchToLogin => 'Sudah punya akun? Masuk';

  @override
  String get accountCreated => 'Akun berhasil dibuat. Silakan masuk.';

  @override
  String get connectionError => 'Tidak dapat terhubung ke server.';

  @override
  String get logout => 'Keluar';

  @override
  String get language => 'Bahasa';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get writeStory => 'Tulis cerita';

  @override
  String get feedEyebrow => 'CATATAN HARI INI';

  @override
  String get feedTitle => 'Cerita dari\nsekitar kita.';

  @override
  String get feedSubtitle => 'Momen sederhana, sudut pandang yang berbeda.';

  @override
  String storiesCount(int count) {
    return '$count cerita terbaru';
  }

  @override
  String get feedLoadError =>
      'Cerita belum dapat dimuat. Periksa koneksi lalu coba lagi.';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get emptyFeedTitle => 'Belum ada cerita di sini.';

  @override
  String get emptyFeedBody => 'Jadilah yang pertama membagikan momen.';

  @override
  String get storyDetail => 'Cerita';

  @override
  String get newStory => 'Cerita baru';

  @override
  String get photoPrompt => 'Pilih foto untuk ceritamu';

  @override
  String get galleryOrCamera => 'Galeri atau kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get camera => 'Kamera';

  @override
  String get replacePhoto => 'Ganti foto';

  @override
  String get descriptionTitle => 'Ceritakan momennya';

  @override
  String get descriptionHint => 'Apa yang ingin kamu bagikan tentang foto ini?';

  @override
  String get photoRequired => 'Pilih foto terlebih dahulu.';

  @override
  String get descriptionRequired => 'Tulis deskripsi singkat untuk foto.';

  @override
  String get shareStory => 'Bagikan cerita';

  @override
  String get sendingStory => 'Mengirim...';

  @override
  String get storyAdded => 'Cerita berhasil dibagikan.';

  @override
  String get storyUploadFailed => 'Cerita gagal dikirim. Periksa koneksi.';

  @override
  String get photoOpenFailed => 'Foto tidak dapat dibuka.';

  @override
  String get storyLoadFailed => 'Cerita tidak dapat dimuat.';

  @override
  String get back => 'Kembali';
}
