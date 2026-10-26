# Eldoria v0.14 — Identitas deck

Tahap 3 selesai. Peningkatan keputusan Nyx ditunda sesuai permintaan; tahap berikutnya dalam urutan pengembangan adalah mode tantangan singkat.

## Fajar: tekanan dan penguatan

Tombak Surya ×1 menggantikan satu Badai Aether. Pilih monster sendiri pada Main Phase: ATK +500, DEF -300 (minimal 0), dan MENEMBUS selama monster berada di papan. Saat melawan posisi bertahan dan ATK lebih tinggi dari DEF, selisihnya mengurangi LP lawan. Perisai dapat menyelamatkan target, tetapi tidak mencegah kerusakan LP. Melawan posisi menyerang, perhitungan normal tetap berlaku.

Contoh: Penjaga Fajar 1700/1200 menjadi 2200/900. Melawan Burung Hantu Perak bertahan dengan DEF 2000, serangan memberi 200 kerusakan LP. Berkah Fajar dapat ditambahkan untuk tekanan lebih besar; Segel Hening membantu membalas Cermin dan Belenggu. DEF yang turun membuat posisi bertahan lebih berisiko.

## Gerhana: pertahanan dan serangan balik

Selubung Gerhana ×1 menggantikan Berkah Fajar. Pilih monster sendiri pada Main Phase: ATK/DEF +400 dan satu perisai kehancuran akibat serangan. Perisai tidak menumpuk; jika sudah habis, kartu ini dapat memulihkannya. Pertahanan ini tidak mencegah kerusakan LP atau penghancuran oleh spell.

Contoh: Noctis dengan perisai habis menjadi 2700/2300 dan memperoleh kembali satu perisai. Atau lindungi Burung Hantu agar menjadi tembok DEF 2400, lalu gunakan jebakan untuk menyiapkan serangan balik.

## Interaksi dan tampilan

- Kedua spell dapat dibatalkan oleh Segel Hening; target harus tetap sama dan masih berada di papan saat resolusi.
- Belenggu menurunkan ATK sebelum damage MENEMBUS dihitung. Cermin membatalkan serangan termasuk damage menembus.
- Undo mengembalikan perubahan statistik, status menembus, perisai, kartu, serta akibat respons.
- Setiap kartu memiliki ilustrasi, simbol, cerita, efek tertulis, dan visual cast berbeda. Galeri sekarang memuat 20 jenis kartu: 10 monster, 7 spell, 3 trap.
- Komando Duel dan laporan damage memperhitungkan MENEMBUS. Ikon status serta detail kartu menjelaskan efek yang sedang aktif.
- Kedua deck tetap tepat 20 kartu. Fajar: 13 monster, 6 spell, 1 trap. Gerhana: 12 monster, 4 spell, 4 trap. Editor deck tetap ditunda.

## Pengujian

Perbandingan pada seed baru yang dipasangkan, tiga tingkat AI, kedua posisi deck, kedua urutan pembuka, 3.000 duel per versi:

- Sebelum kartu baru: Fajar 1.465/3.000 (48,83%), Gerhana 51,17%.
- Sesudah: Fajar 1.519/3.000 (50,63%), Gerhana 49,37%.
- Semua duel selesai, tidak ada duel macet. Ini simulasi AI melawan AI, bukan jaminan win rate pemain.
- Sesudah per tingkat: Santai 584/1.000; Normal 442/1.000; Sulit 493/1.000 kemenangan Fajar.

23 pemeriksaan aturan kartu, 13 pemeriksaan UI, 230 pemeriksaan VFX (20 profil unik), 107 pemeriksaan galeri (20 ilustrasi unik), dan 41.415 pemeriksaan strategi (240 duel, 680 respons) lulus tanpa kegagalan.

Reproduksi benchmark: Godot --headless --path PROJECT --script res://tests/bench_identity.gd -- --samples=250 --seed-start=50000. Kondisi awal sebelum menggunakan deck v0.13 yang dibekukan melalui penggantian kartu baru; definisi monster dan logika Nyx sama.

## Mencoba

F8, muat ulang perubahan jika diminta Godot, kemudian F5. Buka Galeri Kartu dan cari Tombak Surya atau Selubung Gerhana. Klik kiri spell pada Main Phase, lalu klik monster sendiri yang menyala. Tombak tidak langsung menyerang; lanjut ke Battle dan pilih target.

## Ilustrasi

Dibuat dengan built-in image_gen, mode generate. Prompt lengkap disimpan di assets/art/deck_identity_prompts.json.

- C:/Users/Kafka/Documents/anime-card-duel/assets/art/tombak_surya.png
- C:/Users/Kafka/Documents/anime-card-duel/assets/art/selubung_gerhana.png
