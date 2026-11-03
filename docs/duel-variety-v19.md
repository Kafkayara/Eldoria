# Eldoria v0.19 — Jejak Strategi

Semua sembilan kartu baru langsung tersedia. Katalog sekarang berisi 34 jenis kartu dengan ilustrasi berbeda. Tidak ada syarat bab, hadiah acak, atau mata uang.

## Mulai mencoba

Jalankan main.tscn atau tekan F5 di Godot 4.7. Pilih RACIK DECK / SEMUA KARTU TERBUKA untuk menyalin preset, mengganti kartu, lalu SIMPAN & GUNAKAN DECK. Deck kustom tersedia pada pilihan DECK KAMU dalam duel bebas. Deck cerita tetap mengikuti bab.

## Kartu baru

- Pembawa Bara: level 3, 1400 ATK / 1000 DEF; memberi +400 ATK kepada monster yang disummon menggunakan dirinya sebagai tribute.
- Sumpah Fajar: +700 ATK sampai akhir giliran, dengan larangan serangan langsung. Membutuhkan monster lawan; tidak menumpuk.
- Benteng Cahaya: trap yang memberi monster yang diserang +700 ATK/DEF sampai akhir giliran.
- Penenun Senja: level 4, 1400 ATK / 1600 DEF; saat summon boleh mengubah satu monster lawan menjadi bertahan.
- Langkah ke Balik Cermin: bayar 500 LP untuk mengembalikan monster lawan level 4 atau kurang ke tangan. Biaya tetap dibayar jika dibatalkan.
- Arsip Rembulan: mengambil trap pilihan dari Grave, maksimal satu aktivasi per giliran. Trap yang dipasang kembali tetap harus menunggu.
- Perawat Akar: level 3, 1600 ATK / 2300 DEF; boleh menukar satu monster ALAM kecil di Grave dengan draw, dengan menaruh target di dasar deck.
- Jalinan Akar: +400 ATK/DEF per monster ALAM di Grave, maksimal tiga, hingga akhir giliran. Jumlah dihitung saat resolusi.
- Jejak yang Tumbuh: trap yang memulihkan monster ALAM pilihan dan mengurangi ATK penyerang 400 hingga akhir giliran.

Angka Pembawa Bara, Perawat Akar, dan Jalinan Akar disesuaikan dari rancangan awal setelah simulasi. Efek dan tujuan strateginya dipertahankan.

## Pengalaman bermain

Pemulihan dari Grave kini memakai pilihan target. Panel menampilkan tujuan perpindahan dan statistik dasar kartu yang akan dipulihkan. Efek summon opsional dapat dilewati. Efek sementara dan larangan serangan langsung dijelaskan dalam detail monster. Undo mengembalikan biaya, target, bonus, respons, dan penanda cerita.

Preset tetap berukuran 20 kartu, maksimal tiga salinan. Fajar berisi 13 monster / 5 spell / 2 trap; Gerhana dan Rimba masing-masing 12 monster / 5 spell / 3 trap. Semua preset memuat tiga kartu baru sesuai identitasnya.

Bab 3 Buku I, Sembilan Belas Detik, memakai deck baru dan mengaitkan Arsip Rembulan dengan kebiasaan Nyx memutar rekaman. Dua komentar kontekstual dapat muncul tanpa menghentikan duel. Bab tetap bisa selesai tanpa memicu komentar. Simpanan dan pilihan cerita lama dipertahankan.

## Verifikasi dan batas

Aturan baru, target hilang, biaya yang dibatalkan, durasi efek, Undo, pilihan target, deck builder, dan komentar cerita memiliki pengujian tambahan. Pengujian lama mencakup duel, strategi, Rimba, cerita, visual novel, galeri, VFX, UI, audio, koin, dan penyimpanan. Tampilan builder, pilihan target, dan menu diperiksa melalui hasil render Godot.

Benchmark final: 10.800 duel, sembilan kombinasi pasangan/tingkat AI, kedua posisi deck dan urutan pembuka. Semua selesai tanpa macet, aksi AI ilegal, atau perubahan jumlah kartu. Sampel: 300 seed per kombinasi, masing-masing empat permutasi.

Normal: Fajar menang 39,83% melawan Gerhana dan 59,42% melawan Rimba; Gerhana menang 54,83% melawan Rimba. Sulit: 43,17%, 60,50%, dan 56,08% pada pasangan yang sama. Dua hasil sedikit melewati sasaran 40–60%; hasil ini sudah ditinjau sebagai titik awal, bukan klaim keseimbangan akhir. Angka tersebut mengukur AI melawan AI; uji manusia tetap diperlukan untuk menilai keseruan dan keseimbangan.

Ilustrasi dibuat menggunakan image_gen bawaan; sembilan berkas berada di assets/art/{cinder,oath,bastion,weaver,mirror_step,archive,tender,roots,trail}.png. Prompt tercatat di assets/prompts/expansion_v19.json. Tidak menggunakan aset franchise lain.

## Reproduksi

Gunakan Godot 4.7 dengan --headless --path . --audio-driver Dummy --script res://tests/test_expansion.gd. Jalankan juga test_expansion_edges.gd, test_expansion_ui.gd, dan test_expansion_story.gd dengan pola sama. Benchmark: --script res://tests/bench_expansion.gd -- --samples=300.
