import 'package:flutter/material.dart';

void main() {
  runApp(const PerpustakaanApp());
}

class PerpustakaanApp extends StatelessWidget {
  const PerpustakaanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perpustakaan Kampus',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087BEA),
        ),
      ),
      home: const HalamanPerpustakaan(),
    );
  }
}

class DataMenu {
  final String judul;
  final String deskripsi;
  final IconData ikon;
  final Color warnaLatar;
  final Color warnaUtama;

  const DataMenu({
    required this.judul,
    required this.deskripsi,
    required this.ikon,
    required this.warnaLatar,
    required this.warnaUtama,
  });
}

const List<DataMenu> daftarMenu = [
  DataMenu(
    judul: 'Daftar Buku',
    deskripsi: 'Lihat koleksi buku yang tersedia',
    ikon: Icons.menu_book_rounded,
    warnaLatar: Color(0xFFE1F3FF),
    warnaUtama: Color(0xFF1688DD),
  ),
  DataMenu(
    judul: 'Tambah Buku',
    deskripsi: 'Tambahkan data buku baru',
    ikon: Icons.add_circle_rounded,
    warnaLatar: Color(0xFFE4F9E9),
    warnaUtama: Color(0xFF19AD59),
  ),
  DataMenu(
    judul: 'Riwayat Peminjaman',
    deskripsi: 'Lihat buku yang pernah dipinjam',
    ikon: Icons.history_rounded,
    warnaLatar: Color(0xFFFFF0DA),
    warnaUtama: Color(0xFFF39A22),
  ),
  DataMenu(
    judul: 'Kategori Buku',
    deskripsi: 'Jelajahi buku berdasarkan kategori',
    ikon: Icons.category_rounded,
    warnaLatar: Color(0xFFEDE6FF),
    warnaUtama: Color(0xFF7B4FE9),
  ),
  DataMenu(
    judul: 'Buku Favorit',
    deskripsi: 'Lihat buku yang disimpan',
    ikon: Icons.favorite_rounded,
    warnaLatar: Color(0xFFFFE6EC),
    warnaUtama: Color(0xFFFF4F73),
  ),
  DataMenu(
    judul: 'Profil Saya',
    deskripsi: 'Lihat dan kelola informasi akun',
    ikon: Icons.account_circle_rounded,
    warnaLatar: Color(0xFFE3F2FD),
    warnaUtama: Color(0xFF397FC4),
  ),
];

class HalamanPerpustakaan extends StatefulWidget {
  const HalamanPerpustakaan({super.key});

  @override
  State<HalamanPerpustakaan> createState() => _HalamanPerpustakaanState();
}

class _HalamanPerpustakaanState extends State<HalamanPerpustakaan> {
  String kataPencarian = '';

  List<DataMenu> get menuTersaring {
    if (kataPencarian.trim().isEmpty) {
      return daftarMenu;
    }

    return daftarMenu.where((menu) {
      return menu.judul
          .toLowerCase()
          .contains(kataPencarian.toLowerCase());
    }).toList();
  }

  void bukaMenu(DataMenu menu) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${menu.judul} dipilih'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 145,
        automaticallyImplyLeading: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF087BEA),
                Color(0xFF12A1F3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        titleSpacing: 16,
        title: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Husni!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Muhamad Husni Al Muhjiri • 152023088',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_rounded,
                    color: Color(0xFF087BEA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 43,
              child: TextField(
                onChanged: (nilai) {
                  setState(() {
                    kataPencarian = nilai;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari menu atau buku...',
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 21,
                  ),
                  suffixIcon: const Icon(
                    Icons.tune_rounded,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: menuTersaring.isEmpty
                ? const Center(
                    child: Text('Menu tidak ditemukan'),
                  )
                : GridView.builder(
                    itemCount: menuTersaring.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      final menu = menuTersaring[index];

                      return KartuMenu(
                        menu: menu,
                        ketikaDitekan: () => bukaMenu(menu),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class KartuMenu extends StatelessWidget {
  final DataMenu menu;
  final VoidCallback ketikaDitekan;

  const KartuMenu({
    super.key,
    required this.menu,
    required this.ketikaDitekan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: menu.warnaLatar,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: ketikaDitekan,
        child: Stack(
          children: [
            Positioned(
              right: -12,
              bottom: -10,
              child: Icon(
                menu.ikon,
                size: 92,
                color: menu.warnaUtama.withValues(alpha: 0.13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: menu.warnaUtama,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      menu.ikon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    menu.judul,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    menu.deskripsi,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 29,
                      height: 29,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: menu.warnaUtama,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}