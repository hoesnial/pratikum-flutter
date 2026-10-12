"""Bangun laporan Pertemuan 3 mengikuti format PDF contoh milik mahasiswa."""
import io
import json
import os
from pathlib import Path

from pypdf import PdfReader, PdfWriter
from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas
from reportlab.lib.utils import ImageReader

ROOT = Path(__file__).resolve().parents[1]
IDENTITY = json.loads((ROOT / 'docs/identitas.json').read_text())
OUTPUT = ROOT / 'output/pdf/laporan_pertemuan_3_152023088.pdf'
TEMPLATE = ROOT / 'docs/report_assets/cover_template.pdf'
SHOTS = ROOT / 'docs/screenshots'
W, H = letter
LEFT = 59.025
RIGHT = 552.975
WIDTH = RIGHT - LEFT

# Pertahankan nilai kelas jika sebelumnya sudah diisi langsung pada PDF.
student_class = IDENTITY.get('kelas') or ''
if OUTPUT.exists() and not student_class:
    fields = PdfReader(OUTPUT).get_fields() or {}
    student_class = str(fields.get('kelas_mahasiswa', {}).get('/V', ''))

font_dirs = [
    Path(os.environ.get('REPORT_FONT_DIR', '/Applications/Microsoft Word.app/Contents/Resources/DFonts')),
    Path('/System/Library/Fonts/Supplemental'),
    Path('C:/Windows/Fonts'),
    Path('/usr/share/fonts/truetype/msttcorefonts'),
]

def font_file(*names):
    for directory in font_dirs:
        for name in names:
            candidate = directory / name
            if candidate.exists():
                return str(candidate)
    raise FileNotFoundError(f'Font {names[0]} diperlukan untuk menyamai contoh. Atur REPORT_FONT_DIR jika perlu.')

pdfmetrics.registerFont(TTFont('Calibri', font_file('Calibri.ttf', 'calibri.ttf')))
pdfmetrics.registerFont(TTFont('Calibri-Bold', font_file('Calibrib.ttf', 'calibrib.ttf')))
pdfmetrics.registerFont(TTFont('Calibri-Italic', font_file('Calibrii.ttf', 'calibrii.ttf')))

buffer = io.BytesIO()
C = canvas.Canvas(buffer, pagesize=letter)
C.setTitle('Laporan Tugas 3 Praktikum Flutter')
C.setAuthor(IDENTITY['nama'])
C.setSubject('Aplikasi E-Money, Scaffold, dan Navigator.push()')


def text(x, baseline, value, font='Calibri', size=11):
    C.setFillColor(colors.black)
    C.setFont(font, size)
    C.drawString(x, baseline, value)


def centered(baseline, value, font='Calibri-Italic', size=10, center=306):
    C.setFillColor(colors.black)
    C.setFont(font, size)
    C.drawCentredString(center, baseline, value)


def paragraph(baseline, value, size=11, leading=15.25, width=WIDTH):
    words = value.split()
    line = ''
    for word in words:
        candidate = (line + ' ' + word).strip()
        if line and pdfmetrics.stringWidth(candidate, 'Calibri', size) > width:
            text(LEFT, baseline, line, size=size)
            baseline -= leading
            line = word
        else:
            line = candidate
    if line:
        text(LEFT, baseline, line, size=size)
    assert baseline >= 56, 'Konten melewati margin bawah.'
    return baseline


def footer(number):
    text(512.97, 38.75, 'Halaman', size=9)
    text(547.47, 38.75, str(number), size=11)


def heading(value, baseline=724.97, size=16):
    text(LEFT, baseline, value, font='Calibri-Bold', size=size)


def screenshot(filename, top=80.31, box_width=115.5, box_height=206.01, center=306):
    image = ImageReader(str(SHOTS / filename))
    iw, ih = image.getSize()
    scale = min(box_width / iw, box_height / ih)
    width, height = iw * scale, ih * scale
    C.drawImage(image, center - width / 2, H - top - height, width, height)
    return H - top - box_height


def widget_tree():
    # Diagram vektor dalam ukuran dan posisi gambar Widget Tree pada contoh.
    C.saveState()
    C.translate(185.38, H - 420.83 - 220.99)
    border = colors.HexColor('#BFDBFE')
    arrow_color = colors.HexColor('#94A3B8')

    def edge(x1, y1, x2, y2):
        C.setStrokeColor(arrow_color)
        C.setFillColor(arrow_color)
        C.setLineWidth(0.45)
        C.line(x1, y1, x2, y2)
        if y2 < y1:
            p = C.beginPath()
            p.moveTo(x2, y2)
            p.lineTo(x2 - 1.3, y2 + 2.4)
            p.lineTo(x2 + 1.3, y2 + 2.4)
            p.close()
            C.drawPath(p, fill=1, stroke=0)

    def node(x, y, width, height, label, fill='#F8FAFC', stroke=border, ink=colors.black):
        C.setFillColor(colors.HexColor(fill))
        C.setStrokeColor(stroke)
        C.setLineWidth(0.45)
        C.roundRect(x - width / 2, y - height / 2, width, height, 4, fill=1, stroke=1)
        lines = label.split('\n')
        C.setFont('Calibri', 4.8)
        C.setFillColor(ink)
        first = y + (len(lines) - 1) * 2.9 - 1.6
        for i, line in enumerate(lines):
            assert pdfmetrics.stringWidth(line, 'Calibri', 4.8) <= width - 3, label
            C.drawCentredString(x, first - i * 5.8, line)

    edge(120, 202, 120, 194)
    edge(120, 177, 120, 166)
    C.setStrokeColor(arrow_color)
    C.setLineWidth(0.45)
    C.line(120, 151, 120, 147)
    C.line(22, 147, 219, 147)
    for x in [22, 66, 120, 173, 219]:
        edge(x, 147, x, 144)
        edge(x, 126, x, 119.5)
    for top, bottom in [(95.5, 87), (69, 63), (45, 39), (21, 15)]:
        edge(120, top, 120, bottom)

    node(120, 210, 43, 16, 'MaterialApp', fill='#2F61F4', stroke=colors.HexColor('#2F61F4'), ink=colors.white)
    node(120, 185, 61, 17, 'MenuPage\nStatefulWidget', fill='#E2EDFF')
    node(120, 158.5, 39, 15, 'Scaffold', fill='#DFF5FF')
    node(22, 135, 35, 18, 'AppBar', fill='#DFF5FF')
    node(66, 135, 35, 18, 'Drawer', fill='#EEF0FF')
    node(120, 135, 35, 18, 'body', fill='#DDFCEB', stroke=colors.HexColor('#34D399'))
    node(173, 135, 43, 18, 'FloatingAction\nButton', fill='#FFF1DF')
    node(219, 135, 43, 18, 'BottomNavigation\nBar', fill='#F2EAFE')
    node(22, 107.5, 42, 24, 'Column\nJudul\nNama + NIM')
    node(66, 107.5, 42, 24, 'ListView\nDrawerHeader\nListTile')
    node(120, 107.5, 50, 24, 'SafeArea\nCenter\nConstrainedBox')
    node(173, 107.5, 42, 24, 'Navigator.push\nTopUpPage')
    node(219, 107.5, 43, 24, 'Beranda\nRiwayat\nProfil')
    node(120, 78, 65, 18, 'SingleChildScrollView\nColumn')
    node(120, 54, 63, 18, '3 Row -> 9 Expanded', fill='#FFE9EE', stroke=colors.HexColor('#FB7185'))
    node(120, 30, 78, 18, 'Material -> InkWell\nContainer -> Column')
    node(120, 8, 72, 14, 'Icon + SizedBox + Text')
    C.restoreState()


# Halaman 1: cover contoh dipakai langsung agar logo, tabel, dan jaraknya sama.
# Hanya judul tugas yang diganti. Lebar judul disamakan dengan judul pada contoh.
title = 'Laporan Tugas 3 Praktikum Flutter'
C.setFillColor(colors.black)
title_text = C.beginText(174.83, 700.97)
title_text.setFont('Calibri-Bold', 18)
title_text.setCharSpace((262.35 - pdfmetrics.stringWidth(title, 'Calibri-Bold', 18)) / (len(title) - 1))
title_text.textOut(title)
C.drawText(title_text)
C.showPage()

# Halaman 2 mengikuti penempatan heading, gambar, caption, dan paragraf contoh.
heading('Bukti Tampilan Aplikasi')
screenshot('01_menu_page.png')
centered(485.9, 'Gambar 1 Tampilan MenuPage')
paragraph(462.9, 'Pengujian interaksi dilakukan dengan menekan menu E-Money. Setiap menu membuka halaman tujuan berbeda menggunakan Navigator.push(). AppBar menampilkan nama dan NIM mahasiswa.')
heading('Widget Tree', baseline=422.13, size=14)
paragraph(398.38, 'Widget tree berikut menunjukkan susunan antarmuka dari widget akar sampai komponen pada setiap menu. Struktur ini menempatkan AppBar, Drawer, body, tombol aksi, dan navigasi bawah di dalam Scaffold.')
widget_tree()
centered(131.55, 'Gambar 2 Widget tree')
footer(2)
C.showPage()

# Halaman tambahan memakai font, ukuran gambar, caption, dan margin yang sama.
heading('Bukti Navigasi Antarhalaman')
left_center = LEFT + WIDTH / 4
right_center = LEFT + 3 * WIDTH / 4
for filename, label, center in [
    ('02_drawer.png', 'Gambar 3 Drawer', left_center),
    ('03_transfer.png', 'Gambar 4 Halaman Transfer', right_center),
]:
    bottom = screenshot(filename, center=center)
    centered(bottom - 19.78, label, center=center)
for filename, label, center in [
    ('04_top_up.png', 'Gambar 5 Halaman Top Up', left_center),
    ('06_pulsa.png', 'Gambar 6 Halaman Pulsa', right_center),
]:
    bottom = screenshot(filename, top=351.8, center=center)
    centered(bottom - 19.78, label, center=center)
paragraph(192.5, 'Drawer menyediakan menu Beranda dan Profil. Menu Transfer, Top Up, dan Pulsa membuka halaman yang berbeda. Setiap halaman memiliki AppBar, ikon, nama halaman, serta tombol kembali ke Beranda.')
paragraph(138, 'Screenshot diambil dari aplikasi yang berjalan di Chrome pada ukuran layar 390 x 844. Seluruh menu pada baris pertama, kedua, dan ketiga dapat diklik dan kembali ke MenuPage.')
footer(3)
C.showPage()

heading('Implementasi Navigasi')
code_image = ImageReader(str(SHOTS / '12_navigator_push.png'))
iw, ih = code_image.getSize()
code_height = WIDTH * ih / iw
C.drawImage(code_image, LEFT, H - 80.31 - code_height, width=WIDTH, height=code_height)
centered(H - 80.31 - code_height - 19.78, 'Gambar 7 Potongan kode Navigator.push()')
heading('Cara Kerja Navigasi', baseline=382, size=14)
paragraph(358.25, 'Ketukan pada InkWell menjalankan onTap. Navigator.push() menambahkan MaterialPageRoute ke tumpukan halaman, lalu builder membuat TransferPage. MenuPage tetap tersimpan di bawahnya. Navigator.pop() atau tombol kembali menutup halaman tujuan dan menampilkan MenuPage lagi.')
heading('Fungsi Komponen Scaffold', baseline=279, size=14)
for baseline, value in [
    (255.25, 'Scaffold: menyediakan kerangka utama halaman aplikasi Material.'),
    (240, 'AppBar: menampilkan judul E-Money, nama mahasiswa, dan NIM.'),
    (224.75, 'body: menampilkan saldo demo serta tiga baris menu E-Money.'),
    (209.5, 'Drawer: menyediakan navigasi samping ke Beranda dan Profil.'),
    (194.25, 'SafeArea: menjaga konten dari notch, status bar, dan area navigasi sistem.'),
    (179, 'FloatingActionButton: membuka Top Up sebagai aksi tambah saldo.'),
    (163.75, 'BottomNavigationBar: menyediakan akses Beranda, Riwayat, dan Profil.'),
]:
    text(LEFT, baseline, value)
heading('Hasil Pengujian', baseline=128, size=14)
paragraph(104.25, 'flutter analyze: No issues found! Tujuh pengujian widget lulus, termasuk layout layar kecil. Empat belas alur navigasi berhasil diperiksa langsung di Chrome.')
text(LEFT, 65.5, 'Kelas:', size=11)
C.acroForm.textfield(
    name='kelas_mahasiswa', tooltip='Kelas mahasiswa - isi sebelum pengumpulan',
    x=91, y=61.5, width=150, height=17, value=student_class, maxlen=40,
    fontName='Helvetica', fontSize=10, textColor=colors.black,
    fillColor=colors.white, borderColor=colors.HexColor('#D9D9D9'),
    borderStyle='underlined', borderWidth=0.5, forceBorder=True,
)
text(253, 65.5, 'Isi kelas sebelum pengumpulan.', size=9)
footer(4)
C.showPage()
C.save()

reader = PdfReader(io.BytesIO(buffer.getvalue()))
writer = PdfWriter()
writer.clone_document_from_reader(reader)
writer.pages[0].merge_page(PdfReader(TEMPLATE).pages[0], over=False)
writer.add_metadata({
    '/Title':'Laporan Tugas 3 Praktikum Flutter',
    '/Author':IDENTITY['nama'],
    '/Subject':'Aplikasi E-Money, Scaffold, dan Navigator.push()',
})
OUTPUT.parent.mkdir(parents=True, exist_ok=True)
with OUTPUT.open('wb') as stream:
    writer.write(stream)

# Pastikan dokumen baru dan kolom kelas tetap lengkap setelah penggabungan cover.
final = PdfReader(OUTPUT)
assert len(final.pages) == 4
assert all(abs(float(p.mediabox.width)-612)<0.01 and abs(float(p.mediabox.height)-792)<0.01 for p in final.pages)
all_text='\n'.join(p.extract_text() for p in final.pages)
assert 'Laporan Tugas 3 Praktikum Flutter' in all_text
assert 'Laporan Tugas 2 Praktikum Flutter' not in all_text
for required in [IDENTITY['nama'], IDENTITY['nim'], 'Widget Tree', 'Navigator.push()', 'No issues found!']:
    assert required in all_text, required
fields=final.get_fields() or {}
assert set(fields)=={'kelas_mahasiswa'}
assert str(fields['kelas_mahasiswa'].get('/V',''))==student_class
widgets=[]
for p in final.pages:
    for ref in p.get('/Annots',[]):
        widget=ref.get_object()
        if widget.get('/Subtype')=='/Widget': widgets.append(widget)
assert len(widgets)==1
assert str(widgets[0].get('/V',''))==student_class
assert widgets[0].get('/AP') and widgets[0]['/AP'].get('/N')
print(f'PDF diperbarui: {OUTPUT} (4 halaman Letter, cover asli, format mengikuti contoh).')
