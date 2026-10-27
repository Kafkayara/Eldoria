# Eldoria — Chronicles of the First Light

Game duel kartu anime orisinal untuk PC, dibuat dengan **Godot 4.7**. Versi ini adalah prototipe solo yang bisa dimainkan hingga menang atau kalah.

## Mulai bermain

1. Import `project.godot` di Godot 4.7.
2. Tekan **F5** atau buka `main.tscn` dan tekan **F6**.
3. Pilih **Galeri Kartu** untuk melihat semua kartu, atau **Mulai Duel** untuk bermain. Tombol **Panduan** menjelaskan aturan di dalam game.
4. Simpan perubahan di editor dan pilih Reload jika Godot mendeteksi file berubah.

Resolusi desain dan jendela awal 1280×720 dengan proporsi tetap. Teks utama memakai ukuran 16–22 px; nama kartu kecil dapat dibagi menjadi dua baris. Antarmuka dibangun oleh `main.gd` saat game berjalan.

## Versi 0.18 — Cerita dalam format visual novel

Buku I dan II ditulis ulang menjadi 234 halaman: peran dan hubungan tujuh tokoh diperkenalkan jelas, tujuan bab dan alasan duel dapat dibuka kembali. Pembaca memakai kotak dialog bawah layar, tujuh potret transparan, enam latar baru, riwayat, profil tokoh, Auto, skip teks dibaca, dan pengaturan font/kecepatan tersimpan. Rekaman Liora dibedakan dari kenangan dan kejadian sekarang. Bab serta pilihan lama dipertahankan; adegan dari naskah lama dimulai lagi dari awal adegan. Coba lewat Mode Cerita → Buku I → Bab 1. Riset, kontrol, dan hasil pengujian: [visual novel](docs/visual-novel.md). Naskah spoiler: [Buku I](docs/story-book-one.md) dan [Buku II](docs/story-book-two.md).

## Versi 0.17 — Rimba / Pemulihan dan Buku II

Deck ketiga langsung tersedia dalam duel bebas: 12 monster, 7 spell, 1 trap, dengan lima kartu baru dan mekanik pemulihan ALAM dari Grave. Tombol Grave menampilkan target pemulihan. Galeri/VFX memuat 25 kartu unik. Buku II: Kebun untuk yang Pulang menambah tiga bab setelah lima bab Buku I, dengan progres buku lama tetap tersimpan. Benchmark 6.000 duel tanpa macet: Rimba 45,27% vs Fajar dan 52,87% vs Gerhana. Riset, cara bermain, hasil uji, serta batasan: [deck Rimba](docs/rimba-deck.md). Naskah baru dengan spoiler: [Buku II](docs/story-book-two.md).

## Versi 0.16 — Buku I: Jendela yang Menghadap Pagi

Mode cerita pendek berisi lima bab/duel, epilog, 90 halaman dialog termasuk hasil kalah, tiga pilihan yang ditanggapi lagi dalam epilog, penyimpanan posisi baca, pilihan bab, dan catatan kenangan. Buku pertama memakai Fajar serta Gerhana; belum menambah deck ketiga. Mulai lewat MODE CERITA / BUKU I pada menu. Riset, petunjuk, dan batasan: [mode cerita](docs/story-research.md). Naskah lengkap mengandung spoiler: [Buku I](docs/story-book-one.md).

## Versi 0.15 — Kenyamanan bermain

Pengaturan tersedia di menu dan duel: volume musik/efek terpisah, kecepatan animasi 1x/1,5x/2x, efek ringkas tersimpan, panduan singkat tiga halaman, dan ringkasan hasil yang mengikuti Undo. Musik mempertahankan tempo asli. Detail dan pengujian: [kenyamanan bermain](docs/play-comfort.md).

## Versi 0.14 — Tombak dan Selubung

Dua kartu pendukung baru memperjelas identitas deck: Tombak Surya memberi tekanan lewat damage menembus DEF; Selubung Gerhana memulihkan perisai dan mendukung serangan balik. Masing-masing satu salinan di deck bawaan, ilustrasi dan VFX unik, galeri 20 jenis kartu. Perbandingan 3.000 duel per versi: Fajar 48,83% → 50,63%; semua duel selesai. Rincian, batasan, cara memakai, dan pengujian: [identitas deck](docs/deck-identity.md).

## Versi 0.12 — Keseimbangan Fajar / Gerhana

- Naga Bara 2200 → **2500 ATK**, mempertahankan tribute satu monster, 1500 DEF, dan burn summon 300. Noctis tetap 2300 ATK dengan perisai satu kali: Bara menekan, Noctis bertahan.
- Penjaga Fajar 1600 → **1700 ATK**.
- Fajar menukar satu Oracle menjadi Peri Astral ketiga, serta satu Suaka Surya menjadi Segel Hening. Total 13 monster, 6 spell, 1 trap; Gerhana tidak diubah.
- Tooltip pilihan deck dan panduan di dalam game menjelaskan dukungan Fajar. Data kartu, detail, dan sorotan ace mengikuti statistik baru.
- Verifikasi final 3.000 duel per versi pada seed baru yang sama: Fajar **30,67% → 48,37%**, Gerhana final 51,63%. Mencakup kedua posisi deck, kedua urutan pembuka, dan tiga tingkat AI. Hasil simulasi adalah patokan pengujian, bukan jaminan win rate pemain.
- Rincian dan reproduksi: `docs/fajar-balance.md`; benchmark: `tests/bench_balance.gd`. Tes matchup khusus di `tests/test_fajar_balance.gd` dan pengujian tampilan di `tests/test_balance_ui.gd`.

## Versi 0.11 — Jejak Fajar & Undo

- Musik baru **Jejak Fajar / Path of Dawn**, komposisi orisinal 2 menit 40 detik pada 96 BPM. Instrumen berbasis sampel: seruling/shakuhachi, senar, cello, koto, piano, dan perkusi taiko yang renggang. Aransemen lebih lapang daripada Astral Drive; loop tidak berhenti atau fade-out ke hening.
- Dua stem Ogg tersinkron dengan lapisan tambahan yang jauh lebih pelan. Pemain tetap bisa mengatur slider BGM dan tombol Audio. Tidak perlu menginstal alat musik/render apa pun untuk bermain.
- **Undo / Ctrl+Z** mengembalikan satu langkah pemain beserta seluruh akibatnya, termasuk LP, kartu, draw, tribute, skill, perisai, dan respons trap lawan.
- Undo dapat membatalkan animasi/AI response tertunda dan tersedia pada layar hasil untuk aksi di giliran pemain yang belum diakhiri. Setelah **Akhiri Giliran**, riwayat dikosongkan dan tidak dapat melewati giliran lawan.
- Urutan deck dan state RNG ikut dipulihkan; undo tidak mengacak ulang hasil draw.
- Penjelasan dan kredit: `docs/music-and-undo.md`. Komposisi baru: `tools/compose_anime_score.py`; lisensi instrumen: `assets/audio/GeneralUser-LICENSE.txt`.

## Versi 0.10 — Astral Drive

- Portal summon, glow additive berlapis, partikel pengisian, gelombang benturan, dan pecahan target yang dihancurkan, dengan identitas 18 kartu tetap berbeda.
- Sorotan ilustrasi singkat untuk Naga Bara / Naga Noctis pada summon pertama tiap pihak per duel. Mode Ringkas melewatinya; input dan AI menunggu sorotan selesai.
- Gerak halus pada ilustrasi saat hover; teks tetap diam. Burung Hantu, Penyihir Cermin, Noctis, dan Jam Pasir kini memakai bentuk serangan/aktivasi khusus.
- Backsound orisinal **First Light / Astral Drive**: 144 BPM, loop 53,33 detik, aransemen synth/electro-fantasi dengan drum, bass, melodi utama dan arpeggio.
- Dua lapisan audio tersinkron: menu lebih tenang, Battle Phase menambah lapisan, dan LP rendah menaikkan intensitas. Volume BGM terpisah dari SFX dan disimpan lokal; Audio OFF menjeda kedua lapisan.
- Aksen suara baru untuk summon monster andalan, benturan besar, dan pembukaan trap.
- Riset dan detail implementasi ada di `docs/presentation-research.md`. Komposisi dapat dibuat ulang melalui `tools/generate_duel_score.py` (numpy + scipy).
- Tes khusus `tests/test_presentation.gd` memeriksa presentasi dan audio di Godot native. Tetap memakai dua deck bawaan; editor deck masih dinonaktifkan.

## Versi 0.9 — Trap lebih jelas, Gerhana diperbarui

- Duel sementara hanya menggunakan **Fajar** dan **Gerhana**. Tombol dan akses deck builder dinonaktifkan; deck kustom lama tidak ditawarkan atau digunakan. Galeri koleksi tetap tersedia. Berkas editor dan data lama dipertahankan untuk pengembangan berikutnya.
- Memilih trap di tangan menyorot zona kosong milikmu dengan warna emas dan tulisan **PASANG DI SINI**. Zona yang tidak sah tidak dapat dipilih. Instruksi di kanan papan menjelaskan lokasi pemasangan.
- Trap yang baru dipasang menampilkan **MENUNGGU**; mulai giliran berikutnya menampilkan **SIAP**. Respons muncul otomatis saat syarat terpenuhi; pemain memilih trap atau Lewati.
- Gerhana kini 20 kartu: **12 monster + 4 spell + 4 trap**. Komposisi trap: Cermin Pembalasan ×2, Segel Hening ×1, Belenggu Spektral ×1. Dukungan spell: Jam Pasir Astral, Berkah Fajar, Badai Aether, dan Retakan Langit, masing-masing satu.
- **Penjaga Senja**: sekali per duel untuk masing-masing pihak, saat summon, memasang satu Cermin Pembalasan dari deck ke zona spell/trap kosong. Trap itu tetap menunggu sampai giliran berikutnya. Efek tidak terpakai jika zona penuh atau Cermin tidak ada di deck.
- Efek summon/serangan Penjaga Senja memakai tombak bulan. Cermin memakai pantulan perak, Segel rantai ungu, dan Belenggu sulur biru pada target.
- Setiap trap mendapat animasi buka kartu dan panel penjelasan. Rantai banyak trap ditampilkan berurutan, termasuk trap yang dibatalkan. Serangan lanjutan, angka damage, LP, dan kemenangan menunggu presentasi trap.
- `tests/test_trap_clarity.gd` menguji klik mouse nyata pada zona, status menunggu/siap, Sentinel sekali per duel, deck bawaan saja, ketiga animasi trap, respons berantai, kemenangan dan restart. `tests/test_strategy_ui.gd` menjalankan alur ini sebagai pengganti pengujian editor yang sedang dinonaktifkan.

## Versi 0.8 — Gerhana, respons, dan deck builder

- **Dua deck siap pakai**: Fajar / Serangan dan Gerhana / Kontrol. Pilih deck kamu, deck Nyx, dan kesulitan Santai / Normal / Sulit di menu utama.
- **18 jenis kartu** dengan gambar berbeda: 10 monster, 5 spell, 3 trap. Delapan ilustrasi Gerhana ada di atlas baru, terpisah dari kartu awal.
- Tiga zona spell/trap per pihak. Trap dipasang tertutup dan baru dapat digunakan mulai giliran setelah pemasangan. Spell memakai satu zona sementara selama aktivasi.
- **Cermin Pembalasan** membatalkan serangan dan memantulkan 300 damage; **Belenggu Spektral** menurunkan ATK penyerang 500 sebelum damage; **Segel Hening** membatalkan spell/trap terakhir, termasuk respons Segel lawan.
- Jendela respons hanya muncul jika ada pilihan legal. Tidak ada batas waktu untuk pemain. Nyx juga dapat merespons dan membalas respons.
- Rantai selesai setelah dua pihak lewat berturut-turut, dari link terakhir ke pertama. Efek summon/skill belum memiliki jebakan respons dalam set kartu ini.
- **Koleksi & Deck Builder**: semua kartu tersedia, cari/lihat kartu, tambah/kurangi, beri nama, simpan deck baru atau perbarui deck buatanmu, dan langsung gunakan melawan Nyx.
- Deck harus tepat 20 kartu, maksimal 3 salinan per jenis, dan minimal 8 monster. Preset tetap tersedia saat kamu menyimpan variasinya.
- Simpanan lokal `user://eldoria_collection_v1.json` menyimpan deck kustom, pilihan deck, dan kesulitan. Cadangan `.bak` dipakai jika simpanan utama tidak terbaca. Progres duel tidak disimpan.
- Rincian aturan dan cakupan ada di `docs/decks-and-responses.md`; prompt ilustrasi di `assets/prompts/gerhana_atlas.txt`.

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
- Delapan belas jenis kartu: sepuluh monster, lima spell, dan tiga trap.
- Normal summon sekali per giliran; Naga Bara dan Naga Noctis membutuhkan satu tribute.
- Posisi menyerang/bertahan, pergantian posisi, dan satu serangan per monster per giliran.
- Main Phase, Battle Phase, akhir giliran, dan draw otomatis.
- Pemain pertama tidak dapat menyerang pada giliran pertama.
- Efek draw, heal, burn, buff, destroy, serta perisai satu kali untuk Aegis Surya.
- Skill **Kebangkitan Fajar**: pulihkan 800 LP saat LP ≤2500, sekali per duel.
- Delapan belas ilustrasi orisinal: dua atlas dan empat gambar terpisah; animasi summon/serangan, musik ambient, dan delapan efek suara.
- Tombol audio, panduan yang bisa digulir, rematch, dan kembali ke menu.
- Menang melalui LP lawan habis atau lawan kehabisan kartu saat harus draw.

Duel ini memakai rantai respons sederhana untuk spell/trap dan serangan. Multiplayer, sistem ekonomi/buka paket, serta ekspor/pengujian Android/iOS belum ditambahkan.

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
- Trap: pilih dari tangan, lalu klik zona spell/trap kosong milikmu. Pada jendela respons, pilih trap atau Lewati.
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
- `scripts/deck_store.gd`, `scripts/deck_builder.gd`: validasi, penyimpanan, koleksi, dan editor deck.
- `tests/test_strategy.gd`, `tests/test_strategy_ui.gd`: rantai respons, simpan/muat/pemulihan, deck kustom, dan 240 duel campuran pada tiga kesulitan.
- `scripts/gallery.gd`: galeri, pencarian, filter, dan panel detail sebelum duel.
- `scripts/arena.gd`, `scripts/effects.gd`: latar dan efek animasi.
- `assets/art/`: dua atlas ilustrasi dan empat ilustrasi individual.
- `assets/audio/`: musik dan efek suara yang dibuat khusus.
- `tests/test_vfx.gd`: validasi delapan belas profil efek, source/target kedua sisi, semua fase geometri, mode ringkas, dan waktu kemenangan.
- `tests/test_gallery.gd`: keunikan isi gambar untuk 18 jenis kartu, pencarian/filter, detail, navigasi, dan pemeriksaan bahwa galeri tidak mengubah duel.
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


## v0.13 — Petunjuk duel

Penanda kesiapan monster, alasan kartu belum bisa dimainkan, perubahan statistik, dan perkiraan hasil serangan tersedia. Lihat [petunjuk duel](docs/duel-clarity.md).
