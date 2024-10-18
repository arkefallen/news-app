# News App

News App adalah aplikasi sederhana untuk membaca dan mengakses berita terkini yang berada di negara Amerika Serikat. Aplikasi ini terdapat konten berita dari berbagai kategori seperti Umum, Bisnis, Teknologi, Olahraga, dan Politik.

News App dibangun menggunakan bahasa pemrograman Dart dengan framework Flutter untuk memberikan aksesibilitas aplikasi pada banyak platform seperti Android, iOS, Web, dan Desktop. Aplikasi ini dibuat menggunakan arsitektur Clean Architecture dengan state management BLoC pattern. News App juga terdapat unit test yang menguji fungsionalitas pada komponen Use Case di Domain Layer.

## Fitur
1. Melihat daftar berita terkini
2. Eksplor berita berdasarkan kategori
3. Melihat berita secara detail
4. Mengubah tema menjadi gelap (Dark Mode)
5. Memberikan notifikasi berita terbaru secara acak setiap jam 10 pagi

Note: fitur Berita Terkini / Top Headlines hanya akan muncul ketika berita tersebut memiliki data gambar (urlToImage). Apabila semua data yang diambil tidak memiliki gambar sama sekali, maka tidak ada Top Headline yang ditampilkan

## Cara Memakai Aplikasi Ini

1. Fork projek ini
2. Pada folder lib/core/ , buat file bernama 'constants.dart'
3. Isi file tersebut dengan kode yang menyimpan API Key dari NewsAPI 
```dart
const String apiKey = "YOUR_API_KEY";
```
4. Sekarang bisa jalankan aplikasi melalui emulator

## Showcase

Lihat preview projeknya disini https://drive.google.com/file/d/1mskCTSm8LKC8eVeJzwlrz5kw82rdgD7q/view?usp=sharing
