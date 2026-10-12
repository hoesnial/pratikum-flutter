import 'package:flutter/material.dart';

import '../legacy/perpustakaan_app.dart';
import 'transfer_page.dart';
import 'top_up_page.dart';
import 'payment_page.dart';
import 'pulsa_page.dart';
import 'data_package_page.dart';
import 'bill_page.dart';
import 'history_page.dart';
import 'promo_page.dart';
import 'profile_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 0;

  Future<void> _onBottomNavigationTap(int index) async {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) return;

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            index == 1 ? const HistoryPage() : const ProfilePage(),
      ),
    );

    // Setelah halaman tujuan ditutup, Beranda kembali menjadi item aktif.
    if (!mounted) return;
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100 * MediaQuery.textScalerOf(context).scale(1),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'E-Money',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              'Muhamad Husni Al Muhjiri',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              'NIM 152023088',
              style: TextStyle(fontSize: 12, color: Color(0xFFDCF2F7)),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        semanticLabel: 'Menu navigasi E-Money',
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0E7490)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF0E7490),
                      child: Icon(Icons.account_balance_wallet_outlined),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Muhamad Husni Al Muhjiri',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'NIM 152023088',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              key: const Key('drawer_home'),
              leading: const Icon(Icons.home_outlined),
              title: const Text('Beranda'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              key: const Key('drawer_profile'),
              leading: const Icon(Icons.person_outline),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Praktikum sebelumnya'),
              subtitle: const Text('Aplikasi perpustakaan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: const Text('Praktikum sebelumnya')),
                      body: const PerpustakaanApp(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 88),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Halo, Husni!',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF163345),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Semua kebutuhan dalam satu dompet.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF526579)),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0E7490), Color(0xFF149B9B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saldo demo',
                                style: TextStyle(
                                  color: Color(0xFFDCF2F7),
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Rp 250.000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 38,
                          color: Color(0xFFDCF2F7),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Layanan E-Money',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF163345),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Baris 1: setiap Container menu ditulis langsung.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Material(
                          color: const Color(0xFFEAF3FF),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_transfer'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const TransferPage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.send,
                                    color: Color(0xFF2563EB),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text('Transfer', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: const Color(0xFFE8F7EE),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_top_up'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const TopUpPage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    color: Color(0xFF16844A),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text('Top Up', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: const Color(0xFFF1EBFF),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_payment'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const PaymentPage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.qr_code_scanner,
                                    color: Color(0xFF7C3AED),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text('Bayar', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Baris 2: setiap Container menu ditulis langsung.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Material(
                          color: const Color(0xFFFFF2E4),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_pulsa'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const PulsaPage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.phone_android,
                                    color: Color(0xFFC96A0B),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text('Pulsa', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: const Color(0xFFE4F7FC),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_data_package'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const DataPackagePage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.wifi,
                                    color: Color(0xFF087F9B),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Paket Data',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: const Color(0xFFFFECEB),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_bill'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const BillPage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    color: Color(0xFFD13D3D),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text('Tagihan', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Baris 3: setiap Container menu ditulis langsung.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Material(
                          color: const Color(0xFFEEF0FF),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_history'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const HistoryPage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.history,
                                    color: Color(0xFF4F46C9),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text('Riwayat', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: const Color(0xFFFDEBF3),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_promo'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const PromoPage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.local_offer,
                                    color: Color(0xFFBF3B7D),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text('Promo', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: const Color(0xFFE4F6F2),
                          borderRadius: BorderRadius.circular(18),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const Key('menu_profile'),
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Color(0xFF0D8476),
                                    size: 30,
                                  ),
                                  SizedBox(height: 10),
                                  Text('Profil', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah saldo',
        backgroundColor: const Color(0xFF0E7490),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(builder: (context) => const TopUpPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavigationTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0E7490),
        unselectedItemColor: const Color(0xFF64748B),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
