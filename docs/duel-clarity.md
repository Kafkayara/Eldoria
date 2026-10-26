# Eldoria v0.13 — Petunjuk duel

Tahap pertama dari urutan pengembangan yang disepakati. Tahap AI belum dikerjakan.

- Monster milik pemain menampilkan kesiapan menyerang, posisi bertahan, serangan yang sudah dipakai, atau menunggu respons.
- Kartu tangan menampilkan apakah bisa dimainkan. Arahkan kursor atau klik untuk membaca alasan: giliran, fase, batas summon, tribute, zona penuh, atau tidak ada target sah.
- Sorotan zona untuk spell dan summon hanya muncul jika kartu dapat dimainkan.
- Pilih penyerang pada Battle, lalu arahkan kursor ke monster lawan. Komando Duel memperkirakan kerusakan LP, kehancuran monster, dan penggunaan perisai. Serangan langsung diperkirakan ketika papan lawan kosong.
- Perkiraan memakai keadaan papan saat ini; trap tertutup diberi peringatan tanpa membuka identitasnya. Klik target tetap langsung menyerang.
- Statistik yang meningkat berwarna hijau, yang menurun merah. Panel kartu besar menampilkan selisih ATK/DEF dari nilai awal, dan tooltip statistik merinci nilainya.
- Status trap MENUNGGU/SIAP dan respons bertahap tetap dipertahankan.

Validasi: 15 pemeriksaan petunjuk dan tampilan, 70 pemeriksaan Undo, serta pengujian integrasi klik duel lulus. Tidak mengubah statistik kartu, aturan pertarungan, atau keputusan AI.

Untuk mencoba: F8, muat ulang perubahan jika diminta Godot, lalu F5. Pada Battle, pilih monster dan arahkan kursor ke lawan sebelum mengkliknya.
