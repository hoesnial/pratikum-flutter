import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praktikum_flutter/main.dart';
import 'package:praktikum_flutter/pages/bill_page.dart';
import 'package:praktikum_flutter/pages/data_package_page.dart';
import 'package:praktikum_flutter/pages/history_page.dart';
import 'package:praktikum_flutter/pages/menu_page.dart';
import 'package:praktikum_flutter/pages/payment_page.dart';
import 'package:praktikum_flutter/pages/profile_page.dart';
import 'package:praktikum_flutter/pages/promo_page.dart';
import 'package:praktikum_flutter/pages/pulsa_page.dart';
import 'package:praktikum_flutter/pages/top_up_page.dart';
import 'package:praktikum_flutter/pages/transfer_page.dart';

Future<void> openApp(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
  await tester.pumpWidget(const EMoneyApp());
  await tester.pumpAndSettle();
}

const destinations = <(String, Type, String)>[
  ('transfer', TransferPage, 'Transfer'),
  ('top_up', TopUpPage, 'Top Up'),
  ('payment', PaymentPage, 'Bayar'),
  ('pulsa', PulsaPage, 'Pulsa'),
  ('data_package', DataPackagePage, 'Paket Data'),
  ('bill', BillPage, 'Tagihan'),
  ('history', HistoryPage, 'Riwayat'),
  ('promo', PromoPage, 'Promo'),
  ('profile', ProfilePage, 'Profil'),
];

void main() {
  testWidgets('Sembilan menu membuka halaman berbeda dan bisa kembali', (
    tester,
  ) async {
    await openApp(tester);
    expect(find.text('Muhamad Husni Al Muhjiri'), findsOneWidget);
    expect(find.text('NIM 152023088'), findsOneWidget);

    for (final (key, page, title) in destinations) {
      final menu = find.byKey(Key('menu_$key'));
      await tester.ensureVisible(menu);
      await tester.pumpAndSettle();
      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.byType(page), findsOneWidget);
      expect(find.text('Halaman $title'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(MenuPage), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(MenuPage))).canPop(),
        isFalse,
      );
    }
  });

  testWidgets('Drawer Beranda menutup menu dan Profil melakukan push', (
    tester,
  ) async {
    await openApp(tester);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('drawer_home')));
    await tester.pumpAndSettle();
    final menuScaffold = tester.state<ScaffoldState>(
      find.descendant(
        of: find.byType(MenuPage),
        matching: find.byType(Scaffold),
      ),
    );
    expect(menuScaffold.isDrawerOpen, isFalse);
    expect(
      Navigator.of(tester.element(find.byType(MenuPage))).canPop(),
      isFalse,
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('drawer_profile')));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(menuScaffold.isDrawerOpen, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bottom navigation mengembalikan item aktif ke Beranda', (
    tester,
  ) async {
    await openApp(tester);
    for (final (label, page, index) in [
      ('Riwayat', HistoryPage, 1),
      ('Profil', ProfilePage, 2),
    ]) {
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(page), findsOneWidget);
      expect(
        tester
            .widget<BottomNavigationBar>(
              find.byType(BottomNavigationBar, skipOffstage: false),
            )
            .currentIndex,
        index,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
            .currentIndex,
        0,
      );
    }
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(
      Navigator.of(tester.element(find.byType(MenuPage))).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'FloatingActionButton membuka Top Up dan tombol kembali bekerja',
    (tester) async {
      await openApp(tester);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(TopUpPage), findsOneWidget);
      await tester.tap(find.text('Kembali ke Beranda'));
      await tester.pumpAndSettle();
      expect(find.byType(MenuPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final (size, scale) in [
    (const Size(320, 568), 1.0),
    (const Size(320, 568), 2.0),
    (const Size(844, 390), 1.0),
  ]) {
    testWidgets(
      'Layout $size skala $scale tidak overflow dan bisa dinavigasi',
      (tester) async {
        await openApp(tester, size: size, textScale: scale);
        expect(tester.takeException(), isNull);
        for (final (key, page, _) in destinations) {
          await tester.ensureVisible(find.byKey(Key('menu_$key')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(Key('menu_$key')));
          await tester.pumpAndSettle();
          expect(find.byType(page), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.pageBack();
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      },
    );
  }
}
