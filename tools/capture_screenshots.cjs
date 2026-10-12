const fs = require('node:fs');
const path = require('node:path');
const { createRequire } = require('node:module');
const runtimeRequire = process.env.CODEX_NODE_MODULES
  ? createRequire(path.join(process.env.CODEX_NODE_MODULES, '_capture.cjs'))
  : require;
const { chromium } = runtimeRequire('playwright');
let browser;

async function main() {
  const headless = process.argv.includes('--headless');
  browser = headless
    ? await chromium.launch({
        headless:true,
        executablePath:process.env.CHROME_EXECUTABLE || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
      })
    : await chromium.connectOverCDP('http://127.0.0.1:9222');
  const context = headless
    ? await browser.newContext({viewport:{width:390, height:844}, deviceScaleFactor:2})
    : browser.contexts()[0];
  const page = headless
    ? await context.newPage()
    : context.pages().find(p => p.url().startsWith('http://127.0.0.1:7357'));
  if (!page) throw new Error('Jalankan Flutter pada port 7357 terlebih dahulu.');
  const output = path.resolve('docs/screenshots');
  fs.mkdirSync(output, {recursive:true});
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  page.on('console', message => {
    if (message.type() === 'error') errors.push(message.text());
  });
  await page.setViewportSize({width:390, height:844});
  if (headless) await page.goto('http://127.0.0.1:7357/');
  await page.waitForSelector('flutter-view', {state:'attached'});
  await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
  const shot = async name => {
    await page.waitForTimeout(1000);
    await page.screenshot({path:path.join(output, name)});
  };
  await page.getByRole('button', {name:'Transfer', exact:true}).waitFor();
  await shot('01_menu_page.png');
  await page.getByRole('button', {name:'Open navigation menu', exact:true}).click();
  await page.getByRole('button', {name:'Profil', exact:true}).waitFor();
  await shot('02_drawer.png');
  await page.getByRole('button', {name:'Beranda', exact:true}).click();
  await page.getByRole('button', {name:'Transfer', exact:true}).waitFor();
  const checks = [{action:'Drawer Beranda', result:'Drawer tertutup, MenuPage tetap aktif'}];
  const destinations = [
    ['Transfer', '03_transfer.png'], ['Top Up', '04_top_up.png'],
    ['Bayar', '05_bayar.png'], ['Pulsa', '06_pulsa.png'],
    ['Paket Data', '07_paket_data.png'], ['Tagihan', '08_tagihan.png'],
    ['Riwayat', '09_riwayat.png'], ['Promo', '10_promo.png'],
    ['Profil', '11_profil.png'],
  ];
  for (const [label, filename] of destinations) {
    await page.getByRole('button', {name:label, exact:true}).click();
    await page.getByRole('heading', {name:label, exact:true}).waitFor();
    await shot(filename);
    await page.getByRole('button', {name:'Kembali ke Beranda', exact:true}).click();
    await page.getByRole('button', {name:'Transfer', exact:true}).waitFor();
    checks.push({action:`Menu ${label}`, result:'Halaman tujuan dan kembali berhasil'});
  }
  await page.getByRole('button', {name:'Tambah saldo', exact:true}).click();
  await page.getByRole('heading', {name:'Top Up', exact:true}).waitFor();
  await page.getByRole('button', {name:'Kembali ke Beranda', exact:true}).click();
  await page.getByRole('button', {name:'Transfer', exact:true}).waitFor();
  checks.push({action:'FloatingActionButton', result:'Top Up dan kembali berhasil'});
  for (const [label, tab] of [['Riwayat', 'Riwayat Tab 2 of 3'], ['Profil', 'Profil Tab 3 of 3']]) {
    await page.getByRole('button', {name:tab, exact:true}).click();
    await page.getByRole('heading', {name:label, exact:true}).waitFor();
    await page.getByRole('button', {name:'Kembali ke Beranda', exact:true}).click();
    await page.getByRole('button', {name:'Transfer', exact:true}).waitFor();
    checks.push({action:`BottomNavigationBar ${label}`, result:'Halaman tujuan dan kembali berhasil'});
  }
  await page.getByRole('button', {name:'Open navigation menu', exact:true}).click();
  await page.getByRole('button', {name:'Profil', exact:true}).click();
  await page.getByRole('heading', {name:'Profil', exact:true}).waitFor();
  await page.getByRole('button', {name:'Kembali ke Beranda', exact:true}).click();
  await page.getByRole('button', {name:'Transfer', exact:true}).waitFor();
  checks.push({action:'Drawer Profil', result:'Profil terbuka dan Drawer tertutup setelah kembali'});

  const source = fs.readFileSync('lib/pages/menu_page.dart', 'utf8').split('\n');
  const start = source.findIndex(line => line.includes("key: const Key('menu_transfer')"));
  const end = source.findIndex((line, index) => index > start && line.includes('child: Container('));
  const snippet = source.slice(start - 1, end).map(line => line.replace(/^ {26}/, '')).join('\n') + '\n)';
  fs.writeFileSync(path.join(output, 'navigator_push.txt'), snippet + '\n');
  const escape = text => text.replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
  const codePage = await context.newPage();
  await codePage.setViewportSize({width:1050, height:600});
  await codePage.setContent(`<html><head><meta charset="utf-8"><style>
    * { box-sizing:border-box } body { margin:0; padding:44px; background:#f5f7fb; color:#163345; font-family:Arial,sans-serif }
    h1 { margin:0 0 12px; font-size:28px } p { font-size:16px; color:#526579 }
    pre { margin-top:30px; border:1px solid #dce4ee; border-radius:18px; padding:28px; background:white; font:20px/1.55 Menlo,monospace; }
  </style></head><body><h1>Navigator.push() - Menu Transfer</h1>
  <p>lib/pages/menu_page.dart | baris ${start} - ${end} | NIM 152023088</p><pre>${escape(snippet)}</pre></body></html>`);
  await codePage.screenshot({path:path.join(output, '12_navigator_push.png')});
  await codePage.close();
  fs.writeFileSync(path.join(output, 'browser_checks.json'), JSON.stringify({
    browser:await browser.version(), url:page.url(), viewport:page.viewportSize(),
    captureMode:headless ? 'headless' : 'interactive',
    platform:'Chrome web; ukuran viewport mobile, bukan emulator Android/iOS', checks, errors,
  }, null, 2) + '\n');
  if (errors.length) throw new Error(`Browser errors: ${errors.join('\n')}`);
  console.log(`${checks.length} alur berhasil; 12 screenshot tersimpan di docs/screenshots.`);
  await browser.close();
}
main().catch(error => { console.error(error); process.exitCode = 1; }).finally(async () => {
  if (browser?.isConnected()) await browser.close();
});
