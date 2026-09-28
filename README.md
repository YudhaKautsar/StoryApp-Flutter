# Ruang Cerita

Aplikasi berbagi cerita dengan autentikasi, daftar dan detail cerita, serta unggah foto.

Bahasa antarmuka tersedia dalam Bahasa Indonesia dan English. Pilihan bahasa tersimpan di perangkat.

## Menjalankan aplikasi

```sh
flutter pub get
flutter run
```

Secara default aplikasi memakai Story API Dicoding di `https://story-api.dicoding.dev/v1`. Untuk memakai alamat API lain:

```sh
flutter run --dart-define=API_BASE_URL=https://alamat-api-anda/v1
```

API perlu mendukung endpoint `/register`, `/login`, `/stories`, dan `/stories/{id}` dengan format Story API Dicoding.
