# Eldoria v0.15 — Kenyamanan bermain

Tahap 5 selesai. Tahap 2 (peningkatan Nyx) dan tahap 4 (tantangan singkat) masih ditunda sesuai permintaan pemain.

## Pengaturan

Tersedia melalui tombol PENGATURAN pada menu utama dan sisi kanan layar duel, di antara Log dan Audio.

- Volume musik dan efek suara terpisah, masing-masing 0–100%. Slider BGM lama di papan tetap sinkron dengan slider musik pada pengaturan.
- Pilihan animasi Normal (1x), Cepat (1,5x), dan Sangat Cepat (2x). Animasi kartu, VFX, coin flip, ace cut-in, gerak LP, serta jeda presentasi duel mengikuti pilihan ini. Musik dan efek suara mempertahankan tempo/pitch asli.
- Efek ringkas dapat diaktifkan terpisah dari kecepatan. Pilihan volume, kecepatan, dan efek ringkas disimpan otomatis secara lokal, termasuk saat memulai ulang game. Simpanan lama tetap dapat dimuat dengan nilai bawaan untuk pilihan baru.
- Membuka Pengaturan atau panduan singkat menahan langkah berikutnya dari Nyx serta respons otomatis yang masih menunggu. Animasi yang sedang berjalan tetap menyelesaikan kecepatannya sendiri. Pilihan respons pemain selalu menunggu pemain, tanpa batas waktu.

## Panduan singkat

Tiga halaman: menyiapkan papan; menyerang dan membaca perkiraan; respons trap dan Undo. Dibuka lewat Cara bermain di menu, tombol Panduan singkat di Pengaturan, atau dari panduan lengkap. Tombol Baca aturan lengkap tetap tersedia. Esc menutup panel teratas.

## Hasil duel

Layar hasil diperluas dengan LP akhir, jumlah giliran, total kerusakan dan pemulihan LP, trap yang berhasil aktif, serangan terbesar, dan lima momen terakhir. Kerusakan berlebih dihitung sebatas LP yang benar-benar berkurang. Serangan terbesar menghitung serangan monster yang mengurangi LP; damage spell/trap masuk total kerusakan.

Catatan mengikuti keadaan duel. Undo mengembalikan statistik, momen, dan serangan terbesar bersama keadaan papan, termasuk Undo saat hasil sudah terbuka. Trap yang dibatalkan tidak dihitung sebagai trap berhasil aktif. Presentasi tertunda tidak menambah statistik lagi. Duel baru membersihkan catatan duel sebelumnya.

## Pemeriksaan

- Pengaturan, panduan, ringkasan, migrasi preferensi, volume terpisah, tempo musik tetap, kecepatan VFX, AI menunggu panel, overkill, respons berantai, dan Undo: 25 pemeriksaan lulus.
- Undo model: 70 pemeriksaan lulus.
- Undo UI dan musik loop: 15 pemeriksaan lulus.
- Presentasi/ace/musik: 22 pemeriksaan lulus.
- Alur klik dua kartu v0.14: 13 pemeriksaan lulus.
- Tampilan Pengaturan, panduan, dan hasil diperiksa dengan renderer native Godot pada 1280×720.

Perubahan tidak mengubah susunan deck, statistik kartu, aturan pertarungan, atau keputusan taktis Nyx. Ringkasan berlaku untuk duel saat ini, belum berupa riwayat pertandingan yang disimpan permanen.

## Mencoba

F8, muat ulang jika Godot meminta, lalu F5. Buka Pengaturan untuk mengubah volume dan kecepatan; klik Cara bermain untuk panduan singkat. Selesaikan duel untuk melihat ringkasannya. Pilihan tersimpan di profil lokal perangkat.
