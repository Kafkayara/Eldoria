# Eldoria — Chronicles of the First Light

Game duel kartu anime orisinal untuk PC, dibuat dengan **Godot 4.7**. Versi ini adalah prototipe solo yang bisa dimainkan hingga menang atau kalah.

## Mulai bermain

1. Import `project.godot` di Godot 4.7.
2. Tekan **F5** atau buka `main.tscn` dan tekan **F6**.
3. Pilih **Galeri Kartu** untuk melihat semua kartu, atau **Mulai Duel** untuk bermain. Tombol **Panduan** menjelaskan aturan di dalam game.
4. Simpan perubahan di editor dan pilih Reload jika Godot mendeteksi file berubah.

Resolusi desain dan jendela awal 1280×720 dengan proporsi tetap. Teks utama memakai ukuran 16–22 px; nama kartu kecil dapat dibagi menjadi dua baris. Antarmuka dibangun oleh `main.gd` saat game berjalan.

## Pembaruan: lempar koin dan teks kartu

- **Mulai Duel** dan **Duel Lagi** membuka lempar koin acak dengan dua hasil berpeluang sama: gambar matahari berarti kamu mulai; angka I berarti Nyx mulai.
- Hasil ditampilkan sebelum tombol **Masuk Arena** aktif. Nyx otomatis bermain jika mendapat giliran pertama.
- Kedua pihak mendapat empat kartu awal. Pihak pertama tidak menarik kartu tambahan atau menyerang di giliran pertama; pihak kedua menarik kartu saat gilirannya dimulai.
- Esc atau Kembali membatalkan lempar koin. Mode Efek Ringkas menampilkan hasil tanpa animasi putaran.
- Semua kartu memiliki **Efek Kartu** dan **Cerita** di area terpisah pada panel duel, galeri, dan detail besar. Area teks dapat digulir bila panjang.
- Pengujian tambahan: `tests/test_coin.gd` mencakup kedua hasil, pembatalan, bot mulai, mode ringkas, dan teks sepuluh kartu.

## Pembaruan versi 0.6 — Observatorium

- Arah visual meja duel observatorium: batu tulis matte, ukiran statis, tepi kuningan, dan kartu cetak gading/hijau pucat.
- Nama/statistik berwarna tinta gelap dan setiap jenis kartu mempunyai simbol khas.
- Sepuluh profil efek dengan bentuk dan timing berbeda: enam monster memakai efek summon serta serangan; empat spell memakai efek aktivasi.
- Efek memanfaatkan geometri dan partikel native Godot, dengan batas delapan event aktif.
- Snapshot kartu, LP, angka damage, dan layar kemenangan mengikuti saat benturan.
- Tombol **Efek: Normal / Ringkas** di header. Mode ringkas mempertahankan identitas kartu dan target tanpa perpindahan kartu.
- Efek berada di atas kartu dan di belakang panel baca/menu; renderer berhenti saat efek habis.
- Dasar riset, keputusan desain, dan identitas tiap kartu ada di `docs/visual-direction.md`.

## Pembaruan versi 0.5

- **Galeri Kartu** di menu awal menampilkan seluruh jenis kartu dari katalog game.
- Pencarian nama, elemen, atau efek; filter Semua / Monster / Spell; urutan abjad.
- Klik kartu untuk membaca panel detail, klik kanan atau klik ganda untuk memperbesar, dan E untuk membuka kartu yang dipilih.
- Esc menutup detail kembali ke galeri; tombol Kembali ke Menu menutup galeri.
- Galeri dapat digunakan tanpa memulai duel dan tidak mengubah deck, tangan, LP, atau giliran.
- Seluruh **10 jenis kartu memakai ilustrasi berbeda**. Salinan jenis kartu yang sama tetap memakai gambar yang sama.
- Ilustrasi baru untuk Aegis Surya (golem pelindung), Peri Astral (peri bintang), Berkah Fajar (pedang diberkati), dan Retakan Langit (celah kosmik).
- Penentuan gambar dipakai bersama oleh galeri, detail, tangan, papan, dan animasi.

## Pembaruan versi 0.4

- Tata letak asli 1280×720: ukuran teks tidak lagi diperkecil dari desain 1600×900.
- Nama kartu dua baris bila perlu, angka ATK/DEF terpisah, kontras teks ditingkatkan, dan posisi gambar disesuaikan agar karakter tetap terlihat.
- Pratinjau kartu besar setelah kursor berada di kartu selama 0,38 detik.
- Detail penuh lewat klik kanan, tombol E, atau tombol Perbesar Kartu; Esc menutupnya.
- AI menunggu saat detail kartu atau panduan dibuka.
- Log duel dapat dibuka/tutup sebagai panel di kanan, dengan teks lebih besar.
- Animasi kartu berpindah dari tangan ke zona saat summon dan gerakan maju saat menyerang.
- LP dihitung bertahap setelah benturan, termasuk penanganan pembaruan berurutan dan restart.
- Target serangan dan spell yang sesuai disorot.
- Penjelasan hitungan serangan memiliki area tersendiri di bawah papan.
- Tombol serang langsung dan ubah posisi menyesuaikan kesiapan monster.

## Fondasi duel

- Menu utama, arena animasi, panel detail, log duel, dan layar kemenangan/kekalahan.
- Duel offline melawan **Nyx**, dengan jeda tindakan yang bisa diikuti.
- Deck 20 kartu per pemain, empat kartu awal, tiga zona monster, dan LP awal 4000.
- Sepuluh jenis kartu: enam monster dan empat spell.
- Normal summon sekali per giliran; Naga Bara membutuhkan satu tribute.
- Posisi menyerang/bertahan, pergantian posisi, dan satu serangan per monster per giliran.
- Main Phase, Battle Phase, akhir giliran, dan draw otomatis.
- Pemain pertama tidak dapat menyerang pada giliran pertama.
- Efek draw, heal, burn, buff, destroy, serta perisai satu kali untuk Aegis Surya.
- Skill **Kebangkitan Fajar**: pulihkan 800 LP saat LP ≤2500, sekali per duel.
- Sepuluh ilustrasi orisinal: enam sel atlas dan empat gambar terpisah; animasi summon/serangan, musik ambient, dan delapan efek suara.
- Tombol audio, panduan yang bisa digulir, rematch, dan kembali ke menu.
- Menang melalui LP lawan habis atau lawan kehabisan kartu saat harus draw.

Ini belum mencakup trap/chain, multiplayer, deck builder, penyimpanan koleksi, atau ekspor/pengujian Android/iOS.

## Cara mengontrol

- Arahkan kursor untuk melihat pratinjau lebih besar.
- Klik kanan kartu, tekan **E**, atau klik **Perbesar Kartu** untuk membuka detail penuh.
- Klik kiri kartu di tangan untuk memilih. Klik lagi untuk membatalkan.
- Monster: pilih mode summon, lalu klik zona pemain.
- Naga Bara: klik zona kosong untuk tribute otomatis monster dengan ATK terendah; atau klik zona monster yang ingin dikorbankan.
- Badai Aether dan Suaka Surya: klik untuk mengaktifkan langsung.
- Berkah Fajar: pilih monster milikmu.
- Retakan Langit: pilih monster lawan dengan ATK ≤1800.
- Battle: pilih monster milikmu, lalu monster lawan. Jika papan lawan kosong, pilih **Serang Langsung**.
- Gunakan **Ubah Posisi** pada Main Phase, mulai giliran setelah summon.
- Klik **Akhiri Giliran** untuk memberi giliran kepada Nyx.
- **Esc** menutup detail, panduan, atau log terlebih dahulu; setelah itu membuka menu. Progres duel tidak disimpan ketika memulai duel baru.

## Struktur proyek

- `main.tscn`, `main.gd`: layar utama dan penghubung input, model, serta audio.
- `scripts/catalog.gd`: definisi kartu dan komposisi deck.
- `scripts/duel.gd`: aturan duel; tidak bergantung pada tampilan.
- `scripts/ai.gd`: pemilihan tindakan lawan.
- `scripts/card_view.gd`: bingkai dan tampilan kartu.
- `scripts/card_art.gd`: pemilihan gambar dan area ilustrasi setiap jenis kartu.
- `scripts/sigils.gd`: simbol kartu dan bahasa bentuk efek.
- `scripts/effects_painter.gd`: lapisan efek yang memperhatikan panel modal.
- `docs/visual-direction.md`: panduan material, sumber riset, dan identitas efek.
- `scripts/gallery.gd`: galeri, pencarian, filter, dan panel detail sebelum duel.
- `scripts/arena.gd`, `scripts/effects.gd`: latar dan efek animasi.
- `assets/art/`: atlas enam ilustrasi dan empat ilustrasi individual.
- `assets/audio/`: musik dan efek suara yang dibuat khusus.
- `tests/test_vfx.gd`: validasi sepuluh profil efek, source/target kedua sisi, semua fase geometri, mode ringkas, dan waktu kemenangan.
- `tests/test_gallery.gd`: keunikan isi gambar untuk 10 jenis kartu, pencarian/filter, detail, navigasi, dan pemeriksaan bahwa galeri tidak mengubah duel.
- `tests/test_duel.gd`: pengujian aturan dan 100 duel otomatis.
- `tests/test_ui.gd`: pengujian alur antarmuka, zoom/hover kartu, giliran dan jeda AI, animasi LP, log, audio, dan restart.
- `card.tscn`, `card.gd`: contoh kartu dari tahap belajar sebelumnya; tampilan baru menggunakan `scripts/card_view.gd`.
- `backups/`: salinan lokal sebelum perubahan; tidak diunggah ke Git.

## Pengujian

Dengan executable Godot di PATH:

```powershell
godot --headless --path . --audio-driver Dummy --script res://tests/test_vfx.gd
godot --headless --path . --audio-driver Dummy --script res://tests/test_gallery.gd
godot --headless --path . --script res://tests/test_duel.gd
godot --headless --path . --audio-driver Dummy --script res://tests/test_ui.gd
```

Pengujian aturan mencakup tribute, batas summon, posisi, target spell, buff, healing, damage, shield, serangan langsung, kemenangan, deck out, serta 100 duel otomatis dengan pemeriksaan jumlah kartu dan batas LP.

Ilustrasi dibuat dengan imagegen bawaan. Musik dan efek suara disintesis khusus untuk prototipe ini, tanpa rekaman atau aset dari franchise lain. Prompt ilustrasi dan rincian audio ada di `assets/ASSETS.md`.

## GitHub

Setelah menyimpan perubahan di Godot, tinjau perubahan dengan `git status`, buat commit, lalu `git push`. Cache, cadangan lokal, dan hasil build dikecualikan oleh `.gitignore`.
