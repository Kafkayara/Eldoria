# Eldoria — Chronicles of the First Light

Game duel kartu anime orisinal untuk PC, dibuat dengan **Godot 4.7**. Versi ini adalah prototipe solo yang bisa dimainkan hingga menang atau kalah.

## Mulai bermain

1. Import `project.godot` di Godot 4.7.
2. Tekan **F5** atau buka `main.tscn` dan tekan **F6**.
3. Pilih **Mulai Duel**. Tombol **Panduan** menjelaskan aturan di dalam game.
4. Simpan perubahan di editor dan pilih Reload jika Godot mendeteksi file berubah.

Resolusi desain 1600×900; jendela awal 1280×720 dengan proporsi tetap. Antarmuka dibangun oleh `main.gd` saat game berjalan.

## Fitur versi 0.3

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
- Enam ilustrasi orisinal dalam satu atlas, animasi summon/serangan, musik ambient, dan delapan efek suara.
- Tombol audio, panduan yang bisa digulir, rematch, dan kembali ke menu.
- Menang melalui LP lawan habis atau lawan kehabisan kartu saat harus draw.

Ini belum mencakup trap/chain, multiplayer, deck builder, penyimpanan koleksi, atau ekspor/pengujian Android/iOS.

## Cara mengontrol

- Klik kartu di tangan untuk memilih. Klik lagi untuk membatalkan.
- Monster: pilih mode summon, lalu klik zona pemain.
- Naga Bara: klik zona kosong untuk tribute otomatis monster dengan ATK terendah; atau klik zona monster yang ingin dikorbankan.
- Badai Aether dan Suaka Surya: klik untuk mengaktifkan langsung.
- Berkah Fajar: pilih monster milikmu.
- Retakan Langit: pilih monster lawan dengan ATK ≤1800.
- Battle: pilih monster milikmu, lalu monster lawan. Jika papan lawan kosong, pilih **Serang Langsung**.
- Gunakan **Ubah Posisi** pada Main Phase, mulai giliran setelah summon.
- Klik **Akhiri Giliran** untuk memberi giliran kepada Nyx.
- **Esc** membuka menu; progres duel tidak disimpan ketika memulai duel baru.

## Struktur proyek

- `main.tscn`, `main.gd`: layar utama dan penghubung input, model, serta audio.
- `scripts/catalog.gd`: definisi kartu dan komposisi deck.
- `scripts/duel.gd`: aturan duel; tidak bergantung pada tampilan.
- `scripts/ai.gd`: pemilihan tindakan lawan.
- `scripts/card_view.gd`: bingkai kartu dan pembacaan ilustrasi atlas.
- `scripts/arena.gd`, `scripts/effects.gd`: latar dan efek animasi.
- `assets/art/`: atlas enam ilustrasi.
- `assets/audio/`: musik dan efek suara yang dibuat khusus.
- `tests/test_duel.gd`: pengujian aturan dan 100 duel otomatis.
- `tests/test_ui.gd`: pengujian alur antarmuka, giliran AI, audio, dan restart.
- `card.tscn`, `card.gd`: contoh kartu dari tahap belajar sebelumnya; tampilan baru menggunakan `scripts/card_view.gd`.
- `backups/`: salinan lokal sebelum perubahan; tidak diunggah ke Git.

## Pengujian

Dengan executable Godot di PATH:

```powershell
godot --headless --path . --script res://tests/test_duel.gd
godot --headless --path . --audio-driver Dummy --script res://tests/test_ui.gd
```

Pengujian aturan mencakup tribute, batas summon, posisi, target spell, buff, healing, damage, shield, serangan langsung, kemenangan, deck out, serta 100 duel otomatis dengan pemeriksaan jumlah kartu dan batas LP.

Ilustrasi dibuat dengan imagegen bawaan. Musik dan efek suara disintesis khusus untuk prototipe ini, tanpa rekaman atau aset dari franchise lain. Prompt ilustrasi dan rincian audio ada di `assets/ASSETS.md`.

## GitHub

Setelah menyimpan perubahan di Godot, tinjau perubahan dengan `git status`, buat commit, lalu `git push`. Cache, cadangan lokal, dan hasil build dikecualikan oleh `.gitignore`.
