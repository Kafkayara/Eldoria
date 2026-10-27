# Eldoria v0.17 — Rimba / Pemulihan

Rimba adalah deck bawaan ketiga. Dapat dipilih langsung oleh pemain maupun Nyx dalam duel bebas, tanpa harus menyelesaikan mode cerita. Susunan 20 kartu: 12 monster, 7 spell, 1 trap. Editor deck tetap dinonaktifkan.

## Riset dan keputusan desain

[Designing for Golgari — Mark Rosewater / Wizards of the Coast](https://magic.wizards.com/en/news/making-magic/designing-golgari-2012-11-26) membedakan pemulihan ke tangan, ke deck, dan kembali langsung ke medan, serta membahas kekuatan yang tumbuh dari Grave. Eldoria mengambil prinsip penggunaan kembali sumber daya, dengan batas yang lebih sederhana: monster kembali ke tangan/deck dan tetap tunduk pada normal summon. Tidak ada kebangkitan massal atau loop pemanggilan tanpa batas.

[An Introduction to Deckbuilding — Pokémon TCG](https://www.pokemon.com/uk/features/designing-a-deck-from-scratch) menekankan dukungan yang sesuai dengan strategi deck. [Contoh strategi Eelektrik resmi](https://www.pokemon.com/us/features/pokemon-tcg-strategy-charging-up-your-deck-with-eelektrik) memperlihatkan penggunaan sumber daya dari discard. Dalam Eldoria, Fenrir dan monster ALAM lain saling mendukung; tidak menambah sistem Energy atau mata uang pertarungan baru. Teks lengkap dua laman Pokémon dibatasi tampilan iframe pada pembaca web; informasi tersebut didukung kutipan hasil pencarian resmi. Seluruh nama, ilustrasi, aturan khusus, dan cerita Eldoria dibuat sendiri.

## Lima kartu baru

- Penjaga Tunas: level 4, 1700/1400. Saat summon, pulihkan satu monster ALAM level 4 atau kurang dari Grave ke tangan. Sekali per duel untuk seluruh salinannya; batas hanya terpakai jika berhasil.
- Rusa Lumut: level 4, 1500/2000. Saat summon, pulihkan 400 LP.
- Naga Akar Purba: level 6, 2200/1800; satu tribute. Saat summon mendapat +150 ATK per monster ALAM di Grave, maksimal tiga (+450). Tribute ALAM ikut dihitung. Bonus tetap selama monster di papan, bukan bonus dinamis.
- Benih Pulang: pulihkan satu ALAM level 4 atau kurang dari Grave ke tangan dengan statistik dasar. Tetap perlu normal summon.
- Lingkar Musim: kembalikan target ALAM level 4 atau kurang ke dasar deck, ambil satu kartu, pulihkan 400 LP.

Target pemulihan otomatis memakai ATK dasar tertinggi; jika seri, pilih kartu yang paling akhir masuk Grave. Aturan ini tertulis pada kartu dan tidak menambah popup keputusan. Jika tidak ada target, spell ditolak tanpa menghabiskan kartu atau menambah riwayat Undo. Semua pemulihan kembali ke definisi dasar, sehingga buff, debuff, perisai, status serangan, dan UID lama tidak terbawa.

## Susunan deck

Penjaga Tunas ×3; Rusa Lumut ×2; Naga Akar Purba ×2; Fenrir Zamrud ×3; Peri Astral ×2; Benih Pulang ×2; Lingkar Musim ×1; Berkah Fajar ×2; Retakan Langit ×1; Badai Aether ×1; Segel Hening ×1.

## Kenyamanan dan visual

Tombol GRAVE pada kedua sisi papan membuka daftar kartu publik, jumlah monster ALAM, nilai statistik dasar, serta target pemulihan saat ini. Tidak mengungkap trap yang masih tertutup. Membuka panel menahan langkah AI yang masih menunggu dan mencegah input ke papan di belakangnya.

Setiap kartu baru memiliki ilustrasi tersendiri, simbol, serta VFX berbatas durasi dengan dukungan Efek Ringkas dan kecepatan animasi. Naga Akar Purba mendapat cut-in sendiri dan menunjukkan ATK setelah bonus tribute. Pembaca kartu menjelaskan bonus yang sudah ditetapkan. Galeri memuat 25 jenis kartu dengan 25 sumber gambar berbeda.

Cara dasar memakai Rimba: biarkan monster ALAM yang terpakai menjadi sumber daya; summon naga ketika Grave cukup terisi, lalu pulihkan monster untuk giliran berikutnya. Memulihkan terlalu cepat mengurangi bonus naga yang belum di-summon. Setelah bonus ditetapkan, pemulihan berikutnya tidak menurunkan ATK naga itu. Penjaga Tunas tidak memberi normal summon tambahan.

AI hanya ditambah kemampuan memainkan dua jenis spell baru bila ada target sah. Penilaian taktis umum, bonus tersembunyi, dan tingkat kesulitan lama tidak ditingkatkan. Fajar dan Gerhana tidak diubah susunan atau statistiknya.

## Buku II — Kebun untuk yang Pulang

Tiga bab/duel, dialog kalah, dua pilihan ekspresif, catatan kenangan, dan epilog. Cerita baru memperkenalkan Sera, penjaga tunas, serta Banyu yang perlu tempat bagi hidupnya setelah cedera dan banjir. Tema pemulihan diterjemahkan menjadi tindakan membangun jalan bersama, bukan mengembalikan segala sesuatu persis seperti dulu.

Buku II terbuka setelah lima bab Buku I disahkan. Pilih MODE CERITA, lalu Buku II / Rimba. Progres kedua buku disimpan terpisah. Data lama Buku I, posisi baca, dan pilihan tetap dipertahankan; kolom simpanan lama juga tetap tersedia. Duel yang belum selesai tetap diulang dari awal saat melanjutkan.

Naskah lengkap mengandung spoiler: docs/story-book-two.md. Ilustrasi kartu Rimba dipakai sebagai latar dan lambang kenangan buku baru. Belum memakai pengisi suara.

## Pengujian

Benchmark akhir memakai seed baru yang sama untuk pasangan posisi deck dan urutan pembuka, tiga tingkat AI, 3.000 duel per lawan:

- Rimba melawan Fajar: 1.358/3.000 kemenangan (45,27%). Per tingkat: Santai 503/1.000; Normal 433/1.000; Sulit 422/1.000.
- Rimba melawan Gerhana: 1.586/3.000 kemenangan (52,87%). Per tingkat: Santai 661/1.000; Normal 457/1.000; Sulit 468/1.000.
- Total Rimba 2.944/6.000 (49,07%), nol duel macet. Ini patokan simulasi AI melawan AI, bukan jaminan hasil pemain. Matchup dan tingkat kesulitan memiliki hasil berbeda.

Reproduksi: Godot --headless --path PROJECT --script res://tests/bench_rimba.gd -- --samples=250 --offset=20000.

10.712 pemeriksaan model baru lulus, termasuk 120 duel Buku II dan Rimba mirror serta konservasi tepat 20 kartu. UI baru 77; VFX 286 (25 profil); galeri 127 (25 ilustrasi unik); Buku I model 913 dengan 400 duel dan UI 145; Undo 70; strategi lama 41.416 dengan 240 duel; pengaturan 25 pemeriksaan lulus. Pengujian mencakup pemulihan, pembatalan Segel, statistik dasar, batas sekali per duel, tribute, batas bonus, daur ulang deck kosong, Undo, serta simpan/muat dua buku.

## Berkas ilustrasi

Dibuat dengan built-in image_gen, mode generate. Prompt lengkap: assets/art/rimba_image_prompts.json.

- C:/Users/Kafka/Documents/anime-card-duel/assets/art/grove.png
- C:/Users/Kafka/Documents/anime-card-duel/assets/art/stag.png
- C:/Users/Kafka/Documents/anime-card-duel/assets/art/verdant.png
- C:/Users/Kafka/Documents/anime-card-duel/assets/art/renewal.png
- C:/Users/Kafka/Documents/anime-card-duel/assets/art/compost.png

## Mencoba

F8, muat ulang perubahan jika diminta Godot, F5. Pilih Rimba / Pemulihan di DECK KAMU untuk langsung bermain; DECK NYX juga mendukung Rimba. Lihat kelima kartu di Galeri Kartu. Klik GRAVE pada papan untuk mempelajari target pemulihan.
