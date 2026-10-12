# Praktikum Pertemuan 3 - E-Money

Nama: Muhamad Husni Al Muhjiri  
NIM: 152023088  
Kelas: isi kolom kelas pada PDF sebelum pengumpulan.

## Hasil implementasi

Project yang semula dibuka adalah aplikasi perpustakaan, bukan E-Money. Tidak ada `MenuPage` atau baris pertama E-Money yang dapat dipertahankan. Karena itu, aplikasi E-Money memakai susunan menu yang diberikan pada tugas. Kode perpustakaan awal disimpan utuh di `lib/legacy/perpustakaan_app.dart`, dapat dibuka melalui Drawer, dan tetap memiliki pencarian serta menu sebelumnya.

`MenuPage` menggunakan `Scaffold`, `AppBar`, `Drawer`, `SafeArea`, body yang bisa digulir, `FloatingActionButton`, serta `BottomNavigationBar`. Nama lengkap dan NIM ditampilkan pada AppBar, Drawer, dan Profil. Saldo adalah data demo untuk praktikum; halaman tujuan berisi tampilan dan keterangan navigasi sesuai lingkup tugas.

| Baris | Menu | Halaman tujuan |
| --- | --- | --- |
| 1 | Transfer | `TransferPage` |
| 1 | Top Up | `TopUpPage` |
| 1 | Bayar | `PaymentPage` |
| 2 | Pulsa | `PulsaPage` |
| 2 | Paket Data | `DataPackagePage` |
| 2 | Tagihan | `BillPage` |
| 3 | Riwayat | `HistoryPage` |
| 3 | Promo | `PromoPage` |
| 3 | Profil | `ProfilePage` |

Kesembilan menu ditulis langsung dengan `Row`, `Expanded`, `Material`, `InkWell`, `Container`, `Column`, `Icon`, `Text`, dan `SizedBox`. Tidak ada class `MenuItem`, method pembuat menu, atau `GridView` dalam `MenuPage`. `KartuMenu` dan `GridView` pada file legacy hanya bagian dari aplikasi perpustakaan lama.

## Cara kerja navigasi

Ketukan pada `InkWell` menjalankan `onTap`. `Navigator.push()` menambahkan `MaterialPageRoute` ke tumpukan halaman. `builder` membuat halaman tujuan, misalnya `TransferPage`. `MenuPage` tetap ada di bawahnya, sehingga `Navigator.pop()` atau tombol kembali cukup menutup halaman tujuan dan menampilkan menu lagi.

```dart
Navigator.push<void>(
  context,
  MaterialPageRoute<void>(
    builder: (context) => const TransferPage(),
  ),
);
```

`<void>` berarti halaman tidak mengembalikan data hasil. Setiap menu memiliki tujuan berbeda. Tombol `+` membuka `TopUpPage`. Drawer Beranda hanya memanggil `pop()` untuk menutup Drawer, sedangkan Drawer Profil menutup Drawer kemudian melakukan `push()` ke Profil.

Navigasi bawah menggunakan `StatefulWidget`, `_currentIndex`, dan `setState()` untuk membedakan warna item aktif. Beranda tidak menambah route. Riwayat dan Profil melakukan `push()`. `await` menunggu halaman ditutup, kemudian indeks dikembalikan ke Beranda. Pemeriksaan `mounted` memastikan `setState()` hanya dipanggil ketika widget masih terpasang.

## Fungsi komponen dan jawaban refleksi

1. **Scaffold** menyediakan kerangka halaman Material dan menempatkan AppBar, body, Drawer, tombol aksi melayang, serta navigasi bawah.
2. **AppBar dan body**: AppBar adalah bilah atas untuk judul, identitas, dan akses navigasi; body menampilkan konten utama seperti saldo dan menu.
3. **Drawer** menyediakan navigasi samping. Pada aplikasi ini tersedia Beranda, Profil, dan akses ke praktikum perpustakaan sebelumnya.
4. **FloatingActionButton** menonjolkan aksi utama yang sering dipakai. Tombol tambah pada aplikasi ini membuka Top Up.
5. **BottomNavigationBar** memberikan akses cepat ke bagian utama aplikasi: Beranda, Riwayat, dan Profil.
6. **SafeArea** menambahkan jarak sesuai area sistem agar konten tidak tertutup notch, status bar, atau area navigasi perangkat. SafeArea tidak menggantikan kebutuhan scrolling untuk konten yang panjang.
7. **Tanpa mempertimbangkan area aman**, teks atau tombol dapat tertutup elemen sistem dan sulit dibaca atau ditekan. `SingleChildScrollView` membantu menjangkau konten saat tinggi layar terbatas, termasuk saat teks diperbesar.

## Menjalankan dan memeriksa

Dari folder project:

```sh
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Kode awal perpustakaan juga dapat dijalankan terpisah tanpa mengubah aplikasi utama:

```sh
flutter run -d chrome -t lib/legacy/perpustakaan_app.dart
```

Hasil pemeriksaan tanggal 10 Oktober 2026:

- `dart format`: 12 file implementasi dan pengujian diperiksa.
- `flutter analyze`: **No issues found!**
- `flutter test`: **7 pengujian lulus**. Cakupan: sembilan menu, tumpukan kembali, Drawer, FAB, indeks navigasi bawah, viewport 320 x 568 pada skala teks 1 dan 2, serta landscape 844 x 390.
- Aplikasi berhasil dijalankan melalui `flutter run -d chrome`.
- Pemeriksaan browser: **14 alur berhasil**, tanpa error browser yang tercatat. Rincian ada di `docs/screenshots/browser_checks.json`.
- Screenshot diambil dari aplikasi yang benar-benar berjalan di Chrome pada viewport 390 x 844. Screenshot ini merupakan bukti web, bukan bukti emulator Android/iOS. Tambahkan screenshot emulator/perangkat apabila diwajibkan pengajar.
- File legacy tidak diubah, dengan SHA-256 `3766471562c2b21c0eecabc1d78c16b9de8d1846943455c4e31e9aeb372dc7c9`.

## Screenshot laporan

Screenshot tersedia pada `docs/screenshots`:

1. `01_menu_page.png`: tiga baris menu, nama, NIM, AppBar, FAB, dan BottomNavigationBar dalam satu tampilan.
2. `02_drawer.png`: Drawer terbuka.
3. `03_transfer.png`: halaman Transfer.
4. `04_top_up.png`: halaman Top Up.
5. `06_pulsa.png` dan `11_profil.png`: contoh halaman baris kedua dan ketiga.
6. `12_navigator_push.png`: potongan kode navigasi yang diambil dari source project.
7. Screenshot tambahan tersedia untuk semua halaman tujuan lainnya.

Laporan PDF ada di `output/pdf/laporan_pertemuan_3_152023088.pdf`. Formatnya mengikuti PDF contoh: empat halaman berukuran Letter, dengan cover, logo ITENAS, tabel identitas, font, margin, caption gambar, dan nomor halaman yang disesuaikan. Kolom kelas pada halaman terakhir dapat diisi langsung di pembaca PDF. Nilai identitas juga tersimpan di `docs/identitas.json`; `tools/build_report.py` dapat membangun ulang laporan setelah nilai kelas diisi. Tool dokumentasi memakai Python `reportlab`, `pypdf`, font Calibri dari Microsoft Word atau lokasi `REPORT_FONT_DIR`, serta cover pada `docs/report_assets/cover_template.pdf`; aplikasi Flutter tidak membutuhkan package baru. Laporan sebelum penyesuaian format disimpan di `output/pdf/arsip/`.

## Latihan asesmen

1. Buka `lib/main.dart` dan jelaskan alur `main()` -> `runApp()` -> `MaterialApp` -> `MenuPage`.
2. Tunjukkan setiap slot `Scaffold` dan jelaskan fungsi masing-masing.
3. Tunjukkan tiga `Row` yang masing-masing berisi tiga `Expanded`. Jelaskan bagaimana `Expanded` membagi lebar, `SizedBox` memberi jarak, dan `Column` menyusun ikon serta teks.
4. Klik Transfer, jelaskan `onTap`, `context`, `MaterialPageRoute`, dan `builder`, lalu kembali ke Beranda.
5. Demonstrasikan Drawer, FAB, dan navigasi bawah. Jelaskan mengapa Beranda tetap menjadi halaman awal setelah kembali.
6. Ubah satu ikon, warna, atau judul secara langsung, kemudian jalankan hot reload dengan `r` pada terminal `flutter run`.
7. Perkecil layar atau perbesar teks. Jelaskan perbedaan fungsi `SafeArea` dan `SingleChildScrollView`.

## File implementasi

- `lib/main.dart`: entry point dan tema aplikasi E-Money.
- `lib/pages/menu_page.dart`: halaman utama dengan sembilan menu langsung dan seluruh navigasi.
- `lib/pages/transfer_page.dart`, `top_up_page.dart`, `payment_page.dart`, `pulsa_page.dart`, `data_package_page.dart`, `bill_page.dart`, `history_page.dart`, `promo_page.dart`, `profile_page.dart`: sembilan halaman tujuan.
- `lib/legacy/perpustakaan_app.dart`: kode awal lengkap yang dipertahankan.
- `test/widget_test.dart`: pengujian yang menggantikan test counter bawaan yang merujuk `MyApp` yang sudah tidak ada pada project awal. Test awal disimpan di `docs/widget_test_awal.dart.txt`.
- `docs/`: panduan asesmen, identitas, dan bukti screenshot.
- `tools/`: alat bantu dokumentasi; bukan dependency aplikasi.

## Referensi

- [FluSim Pertemuan 3](https://flu-sim.vercel.app/#/meeting/3) - materi yang diberikan dalam instruksi tugas.
- [Dokumentasi Navigator.push](https://api.flutter.dev/flutter/widgets/Navigator/push.html)
- [Dokumentasi Scaffold](https://api.flutter.dev/flutter/material/Scaffold-class.html)
- [Dokumentasi SafeArea](https://api.flutter.dev/flutter/widgets/SafeArea-class.html)


## Versi laporan yang dapat diedit

Versi Word tersedia pada output/docx/laporan_pertemuan_3_152023088.docx. Teks laporan, tabel identitas, widget tree, dan kode navigasi dapat diedit. Logo dan screenshot aplikasi tetap berupa gambar. Versi Google Docs ada di folder ChatGPT pada Google Drive:

https://docs.google.com/document/d/1E4xEU0gxkuiya5nPpf0rOCsyVbr2qR-k8mhwBgivc7I
