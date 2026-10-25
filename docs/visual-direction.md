# Arah visual Eldoria 0.6

Dokumen implementasi untuk menjaga perubahan visual berikutnya tetap konsisten.

## Acuan

- Blizzard, [Developer Insights: The Art Behind THE SCIENCE](https://hearthstone.blizzard.com/en-gb/news/22552047/developer-insights-the-art-behind-the-science): efek membantu pemain membaca keadaan papan dan memperkuat identitas karakter/kelas.
- Riot, [Clarity in League](https://www.leagueoflegends.com/en-us/news/dev/clarity-in-league/): utamakan informasi permainan, hierarki perhatian, arah gerakan yang jelas, dan pembatasan keramaian visual.

Arah observatorium adalah keputusan desain Eldoria berdasarkan prinsip tersebut. Penilaian “AI slop” bersifat subjektif; target implementasi adalah konsistensi, keterbacaan, dan hubungan antara aksi dengan hasil.

## Material dan hierarki

- Papan: batu tulis matte, garis ukir stasioner, tanda ukur, dan tepi kuningan bersudut.
- Kartu monster: permukaan gading seperti kartu cetak; kartu spell: hijau pucat.
- Nama dan statistik memakai tinta gelap dengan kontras tinggi.
- Ornamen kecil dipakai sebagai simbol identitas, bukan dekorasi bergerak terus-menerus.
- Ilustrasi versi sebelumnya tetap menjadi aset gambar kartu. Pembaruan ini memakai gambar tersebut di dalam bingkai dan bahasa bentuk yang konsisten.
- Efek baru digambar lewat geometri dan animasi native Godot; tidak memerlukan gambar generatif baru.
- Panel info dan kontrol tetap tenang ketika efek dimainkan. Menu/detail menutupi efek; pratinjau kartu tetap berada di atas efek.

## Identitas kartu

- Penjaga Fajar: lambang pedang, crest matahari saat masuk, tebasan cahaya saat menyerang.
- Naga Bara: lambang api, lidah api saat masuk, semburan api bertaper dan bara saat menyerang.
- Oracle Rembulan: lambang bulan sabit, orbit bulan saat masuk, komet bulan saat menyerang.
- Fenrir Zamrud: lambang cakar, daun melingkar saat masuk, tiga goresan melengkung dan serpihan daun saat menyerang.
- Aegis Surya: lambang perisai, bidang pelindung saat masuk, shield ram saat menyerang; perisai retak ketika perlindungan sekali pakainya dipakai.
- Peri Astral: lambang bintang, orbit bintang saat masuk, tiga proyektil bintang saat menyerang.
- Badai Aether: petir bercabang menuju lawan.
- Suaka Surya: matahari terbit dan garis pemulihan ke atas.
- Berkah Fajar: pedang tegak bersayap pada monster yang diberkati.
- Retakan Langit: celah gelap bergerigi dan pecahan magenta pada target.

## Sequencing dan batas

- Setiap profil mempunyai antisipasi, gerak/aksi, benturan, dan peluruhan.
- Benturan normal: sekitar 0,34–0,52 detik; summon: 0,42 detik.
- Umur efek penuh dibatasi hingga 1,15 detik.
- Snapshot kartu menjaga sumber/target terbaca sebelum hasil diungkap.
- Penghitungan LP, angka kerusakan, dan hasil akhir mengikuti waktu benturan.
- Maksimal delapan event efek aktif sekaligus.
- Efek berhenti memproses saat tidak ada event. Latar tidak menjalankan animasi idle.
- Mode Efek Ringkas mempertahankan simbol dan target, dengan durasi 0,32 detik dan tanpa perpindahan kartu.

## Kode dan pemeriksaan

- `scripts/sigils.gd`: simbol yang dipakai bersama oleh bingkai kartu dan efek.
- `scripts/effects.gd`: sepuluh profil, geometri, umur efek, dan cap.
- `scripts/effects_painter.gd`: lapisan gambar efek di atas snapshot kartu.
- `scripts/arena.gd`: meja observatorium.
- `scripts/duel.gd`: cue kartu yang hanya dikeluarkan ketika aksi diterima.
- `main.gd`: penerjemahan cue menjadi source/target, snapshot, penghitungan LP, dan mode efek.
- `tests/test_vfx.gd`: sumber/target kedua sisi, enam summon, enam serangan, empat cast, sampel geometri beberapa fase, mode ringkas, penutupan oleh modal, cleanup, dan urutan kemenangan.

