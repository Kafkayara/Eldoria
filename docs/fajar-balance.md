# Eldoria v0.12 — Fajar vs Gerhana

## Perubahan yang diterapkan

- Naga Bara: ATK 2200 → 2500; DEF 1500, kebutuhan satu tribute, dan burn summon 300 tetap sama.
- Penjaga Fajar: ATK 1600 → 1700; DEF 1200, tetap monster normal.
- Peri Astral pada deck Fajar: 2 → 3 salinan; Oracle Rembulan 2 → 1.
- Suaka Surya pada deck Fajar: 2 → 1; tambahkan Segel Hening ×1.
- Komposisi Fajar: 13 monster, 6 spell, 1 trap, tetap 20 kartu dan maksimal 3 salinan per jenis.
- Gerhana tetap 12 monster, 4 spell, 4 trap. Naga Noctis tetap 2300 ATK / 1900 DEF dan perisai satu kehancuran battle.

## Tujuan desain

Bara menjadi ace penyerang yang mempunyai ATK lebih tinggi daripada Noctis, sementara Noctis menjaga identitas pertahanan. Bara dapat menghabiskan perisai Noctis dan tetap bertahan dalam pertukaran biasa, tetapi trap masih penting: Belenggu menurunkan Bara tanpa dukungan menjadi 2000 ATK, sehingga Noctis bisa menang. Berkah Fajar sebelum serangan meningkatkan Bara menjadi 2900, lalu 2400 setelah Belenggu; cukup untuk tetap menekan Noctis.

Fajar juga mendapat kartu draw lebih banyak dan satu respons terhadap trap, bukan hanya angka ATK. Segel harus dipasang pada giliran sebelumnya agar sah membalas Cermin/Belenggu. Tidak ada kekebalan trap, penghapusan perisai gratis, atau perubahan aturan damage. Musik, Undo, dan pembatasan deck bawaan tetap dipertahankan.

## Verifikasi keseimbangan

Sampel penyesuaian awal memakai beberapa kandidat. Setelah memilih kandidat, verifikasi final memakai 250 seed baru (indeks 20000–20249), kedua posisi deck, kedua urutan pembuka, dan tiga tingkat AI. Total 3.000 duel untuk versi lama dan 3.000 duel untuk versi final pada seed yang sama. AI serta aturan duel tidak diubah selama perbandingan; kedua sisi dikendalikan kebijakan AI yang sama dan tidak memakai Undo.

Versi lama: Fajar 920/3000 = 30.67%; Gerhana 69.33%.
Versi final: Fajar 1451/3000 = 48.37%; Gerhana 51.63%.

Rincian Fajar final: Santai 546/1000, Normal 428/1000, Sulit 477/1000. Saat Fajar mulai: 840/1500; saat Gerhana mulai: 611/1500. Semua duel selesai; tidak ada kasus melewati batas aksi. Angka ini mengukur matchup simulasi dengan heuristik yang tersedia, bukan menjamin win rate pemain manusia atau menyamakan semua urutan pembuka.

Benchmark dapat dijalankan lewat `tests/bench_balance.gd -- --variant=current --samples=250 --seed-start=20000`. Varian baseline membekukan komposisi/statistik Fajar v0.11, sedangkan current memakai katalog runtime saat ini.

`tests/test_fajar_balance.gd` memeriksa kedua naga, shield, trap, Berkah, Segel, serta Undo. `tests/test_balance_ui.gd` memeriksa statistik di menu/detail/papan dan perhitungan damage yang terlihat. Tes aturan lama diperluas agar duel otomatis menangani trap yang kini tersedia pada Fajar.

## Cara mencoba

F8 → Reload jika diminta → F5, pilih Fajar / Serangan. Gunakan Peri Astral untuk mengisi tangan dan menyiapkan tribute, pasang Segel lebih awal, lalu dukung Naga Bara dengan Berkah Fajar sebelum Battle.
