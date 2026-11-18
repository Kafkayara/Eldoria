# Handoff Eldoria ke chat Codex baru

Disiapkan 18 November 2026. Buka folder `C:\Users\Kafka\Documents\anime-card-duel` sebagai workspace Codex. File proyek menjadi sumber utama untuk kondisi terkini. Percakapan lama mungkin tidak tersedia pada chat baru.

## Kondisi yang diperiksa

- Nama game Eldoria — Chronicles of the First Light, Godot 4.7, GDScript, renderer GL Compatibility, resolusi desain 1280×720.
- Remote `https://github.com/Kafkayara/Eldoria.git`.
- HEAD saat dibaca `301825b`, pesan `mode defen`. Working tree bersih sebelum penambahan dua dokumen handoff dan roadmap ini. Periksa ulang status sebelum mengedit.
- 34 jenis kartu, tiga deck utama Fajar, Gerhana, dan Rimba. Preset 20 kartu, maksimal tiga salinan. Ada AI, pilihan target/Grave, trap/chain, deck kustom, dan Undo.
- Cerita Buku I dan II memakai pembaca visual novel, pilihan, bookmark, dan penyimpanan progres.
- Preferensi musik/efek, kecepatan animasi 1x/1,5x/2x, dan mode Ringkas tersedia.
- Summon pertama Naga Bara (`ember`), Noctis (`noctis`), Akar Purba (`verdant`) memiliki panggung 2.5D 1,9 detik pada 1x. Ada foil hover, gerak summon/serangan/target, trap reveal dari slot, suara impact, dan gelombang finisher.
- Posisi bertahan diputar −90° oleh `_set_field_pose()`. Kartu zona 146×142 sehingga perlu pemeriksaan siluet dan keterbacaan sebelum menyebutnya selesai secara visual.

## Peta kode

| Berkas | Peran |
| --- | --- |
| `project.godot`, `main.tscn` | Konfigurasi dan entry point |
| `main.gd` | UI arena, input, presentasi aksi, koordinasi model, AI, cerita, dan pembatalan animasi |
| `scripts/duel.gd` | Model duel, aturan, sinyal, snapshot Undo |
| `scripts/catalog.gd`, `scripts/ai.gd` | Katalog/preset dan keputusan AI |
| `scripts/card_view.gd`, `scripts/card_art.gd` | Tampilan kartu dan pemetaan ilustrasi |
| `scripts/effects.gd`, `scripts/effects_painter.gd`, `scripts/sigils.gd` | Profil VFX dan renderer |
| `scripts/ace_cutin.gd`, `scripts/shaders/card_depth.gdshader` | Presentasi summon 2.5D |
| `scripts/deck_builder.gd`, `scripts/deck_store.gd` | Deck builder, preferensi, penyimpanan |
| `scripts/story_*.gd`, `scripts/vn_*.gd` | Cerita dan pembaca visual novel |
| `tests/test_*.gd`, `tests/bench_*.gd` | Pemeriksaan otomatis dan benchmark |

Baca `README.md`, `docs/cinematic-duel.md`, `docs/duel-variety-v19.md`, `docs/music-and-undo.md`, dan `docs/development-roadmap.md`. Dokumen riset animasi ada pada `docs/animation-research-2026-11-10.md`. Bedakan catatan historis dengan kode terbaru.

## Hal yang harus dijaga saat meneruskan

Pengguna meminta perubahan langsung pada folder proyek, berkomunikasi dalam Bahasa Indonesia, dan ingin hasil yang dapat langsung dicoba. Selesaikan satu lingkup kerja sampai terverifikasi. Tanyakan keputusan produk yang berpengaruh besar ketika konteks belum menjawabnya.

Periksa perubahan lokal dan pertahankan pekerjaan pengguna. Semua model, save, cerita, input, dan animasi saling terhubung melalui `main.gd`. Hormati token `session`, reset visual, antrean trap, dan pembatalan callback saat Undo/restart/menu. Mode Ringkas serta kecepatan animasi harus konsisten. Shader ilustrasi memakai vertex tint untuk mengikuti fade parent.

Perubahan seleksi tangan yang terangkat dan gulir deskripsi kartu sudah menjadi bagian proyek. Cek perilakunya setelah menyentuh layout/input. Pakai aset Eldoria dan catat asal aset baru.

## Menjalankan dan memeriksa

Import `project.godot` di Godot 4.7 dan F5. Engine yang dipakai sesi lama berada di bawah path berikut. Periksa ketersediaannya pada komputer saat ini.

```text
C:\Users\Kafka\Documents\Codex\2026-10-30\google-drive-plugin-google-drive-openai-6\work\godot47\Godot_v4.7-stable_win64_console.exe
```

Untuk tes gunakan `--headless --path . --audio-driver Dummy --log-file <log-yang-dapat-ditulis> --script res://tests/<nama>.gd`.

Gunakan APPDATA sementara terpisah per script di lokasi yang benar-benar bisa ditulis, misalnya di `C:\Users\Kafka\AppData\Local\Temp`. Tes mengubah preferensi dan simpanan. Profil bersama sebelumnya menyebabkan state tes saling terbawa. Lokasi TEMP sandbox tertentu juga pernah menyebabkan kegagalan save/reload. Log eksplisit mengatasi masalah startup runtime pada sesi sebelumnya.

Tes yang relevan dengan arena antara lain `test_cinematic_duel`, `test_presentation`, `test_vfx`, `test_ui`, `test_undo_ui`, `test_comfort_ui`, `test_hand_selection`, dan `test_card_description_scroll`. Pilih sesuai perubahan. `tests/preview_cinematic.gd` dapat menghasilkan render PNG dengan argumen `-- --capture-dir=<folder-yang-sudah-ada>` pada renderer grafis.

Status historis dan batas verifikasi dijelaskan pada roadmap. Chat baru perlu melaporkan pemeriksaan yang benar-benar dijalankannya.

## Pekerjaan berikutnya yang disarankan

Mulai dari tahap 1 pada `docs/development-roadmap.md`. Audit tampilan posisi serang/bertahan, pusat transformasi, ukuran snapshot, area klik, dan keterbacaan statistik. Tampilkan temuan konkret dan usulan perubahan yang terukur sebelum memperluas lingkup. Tahap-tahap berikutnya merupakan usulan prioritas.

## Pembaruan setelah pengerjaan tahap 1 — 18 November 2026

Tahap 1 telah dikerjakan langsung di workspace; baca `docs/arena-stage-one.md` dan kode terbaru. Catatan dimensi serta rotasi di atas menggambarkan kondisi sebelumnya. Badan kartu sekarang 68×94 dan berputar secara visual di dalam zona klik 146×142; label tetap horizontal. Tween posisi berada di CardView, sementara main.gd menyelaraskan animasi, snapshot, reset, dan preferensi.

13 script relevan lolos; tes baru `tests/test_field_layout.gd` menghasilkan 142 pemeriksaan headless atau 147 pada renderer grafis. Bukti render dan interaksi jendela dibedakan dari playtest manusia. Warning resource musik saat menutup sesi desktop dengan audio Dummy masih dicatat sebagai batas. Tahap 2 belum dikerjakan dan menunggu tinjauan pengguna. Perubahan belum di-commit atau di-push oleh agen; periksa kembali Git sebelum melanjutkan.
