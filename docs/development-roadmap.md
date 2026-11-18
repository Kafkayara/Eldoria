# Usulan pengembangan Eldoria

Disiapkan 18 November 2026 berdasarkan kode lokal pada commit `301825b` (`mode defen`). Urutan berikut merupakan rekomendasi untuk ditinjau pengguna. Dokumen ini tidak menyatakan fitur yang direncanakan sudah dibuat.

## Arah yang disarankan

Utamakan duel yang jelas, enak disentuh, dan menyenangkan diulang. Eldoria sudah mempunyai 34 kartu, tiga identitas deck, cerita dua buku, deck builder, serta presentasi summon 2.5D. Peningkatan berikutnya dapat memakai konten itu untuk memperbaiki pengalaman setiap pertandingan.

Tiga arah yang dapat dipilih adalah memoles duel, memperluas konten solo, atau mengembangkan multiplayer. Polesan duel memberi dampak pada seluruh mode dan menjadi urutan yang disarankan. Konten solo cocok setelah pemain memahami aturan dan menikmati pertandingan. Multiplayer memerlukan rancangan tambahan untuk sinkronisasi state, validasi aksi, koneksi terputus, dan pengoperasian server sehingga perlu fase tersendiri.

## Urutan pekerjaan

| Tahap | Pekerjaan | Hasil yang diharapkan dan cara menerima |
| --- | --- | --- |
| 1. Arena dan posisi kartu | Tinjau proporsi kartu arena, serang tegak dan bertahan menyamping, rotasi pergantian posisi, statistik yang terbaca, area klik, dan snapshot animasi target | Kedua sisi bisa dibedakan sekilas. Kartu muat di zona tanpa tumpang tindih. Summon bertahan, menerima serangan, perubahan posisi oleh efek, mode Ringkas, dan Undo tampil konsisten pada 1280×720. Periksa lewat render dan interaksi nyata. |
| 2. Respons aksi | Sorot sumber dan target legal, jelaskan alasan aksi tidak tersedia, beri preview hasil pertempuran berdasarkan informasi terbuka, rapikan perpindahan giliran dan urutan trap | Pemain tahu kartu mana yang aktif, apa yang dapat dilakukan, dan mengapa LP berubah. Preview memperhitungkan DEF, piercing, dan shield. Efek trap yang tersembunyi tetap menjadi informasi tersembunyi. |
| 3. Duel pengenalan | Buat tutorial singkat yang dapat dilewati dan diulang, memakai deck serta aturan yang ada | Pemain mempraktikkan summon, tribute, posisi bertahan, attack, trap, dan akhir giliran. Uji dengan pemain baru dan catat titik kebingungan. |
| 4. Kedalaman bermain ulang | Tinjau data matchup yang ada, uji manusia, lalu sesuaikan kartu atau perilaku AI yang terbukti bermasalah. Pertimbangkan duel tantangan dengan tujuan khusus | Tiga deck terasa berbeda. Tantangan mempunyai tujuan dan kondisi gagal jelas. Setiap perubahan balance dibandingkan dengan baseline pada seed yang sama dan kedua urutan pembuka. |
| 5. Identitas visual | Poles arena bertema, audio aksi, serta aset monster andalan beresolusi lebih tinggi. Pertimbangkan ilustrasi dengan bagian depan dan belakang terpisah untuk parallax | Efek memperjelas kejadian. Teks dan LP terbaca saat impact. Ukur frame time pada normal, Ringkas, dan 2x di perangkat sasaran sebelum meningkatkan jumlah efek. |
| 6. Demo yang bisa dibagikan | Siapkan ekspor Windows, petunjuk singkat, pemeriksaan save/load, dan uji instalasi bersih | Pemain lain bisa membuka demo, bermain sampai hasil, menutup game, dan melanjutkan progres. Catat versi serta masalah yang diketahui. |

Selesaikan satu tahap yang dapat dicoba sebelum berpindah ke tahap berikutnya. Jadwal ditentukan setelah audit tahap pertama dan kapasitas pengerjaan diketahui.

## Detail tahap pertama

Kartu zona dibuat berukuran 146×142 di `main.gd`. `_set_field_pose()` memutar kartu bertahan −90° dan menyesuaikan skala. Bentuk yang hampir persegi membuat perbedaan siluet kecil meskipun orientasinya berubah. Tinjau render terlebih dahulu, lalu pilih proporsi kartu yang memberi kesan portrait saat menyerang dan landscape saat bertahan dalam batas zona yang ada.

Perubahan dimensi harus meninjau `_zone_center`, origin dan pivot ghost summon, attack, serta `_hold_target`. Beberapa snapshot masih memakai ukuran 146×142 dan offset 73×71. Pertahankan pusat efek, area klik, keterbacaan nama/statistik, dan panel detail yang mengikuti seleksi.

Rotasi seluruh kartu turut memutar tulisan. Usulan desainnya adalah memakai indikator ATK/DEF yang tetap terbaca di dekat kartu bila render menunjukkan kebutuhan tersebut. Penempatan serta ukuran final perlu dinilai dari tampilan game.

## Verifikasi dan batas informasi

Catatan pengembangan sebelumnya melaporkan 29 script tes lolos setelah implementasi 2.5D. Sesudah perubahan posisi bertahan, yang dijalankan adalah `test_cinematic_duel.gd` dengan 20 pemeriksaan dan nol kegagalan. Tes tersebut belum secara khusus membuktikan siluet, area klik kartu berotasi, atau keterbacaan posisi bertahan. Pada penyusunan roadmap ini kode dibaca, tanpa menjalankan ulang tes atau playtest.

Sebelum mengklaim tahap selesai, jalankan pemeriksaan sesuai perubahan, periksa render, dan catat bukti otomatis serta interaksi manual secara terpisah. Hasil simulasi AI pada dokumentasi merupakan baseline historis, bukan pengganti uji manusia.

## Pembaruan implementasi tahap 1 — 18 November 2026

Tahap 1 sudah diimplementasikan dan siap dicoba: badan kartu 68×94/94×68, informasi horizontal, area klik 146×142, rotasi mengikuti kecepatan, serta geometri snapshot bersama. Rincian di atas mengenai rotasi seluruh kartu adalah kondisi sebelum perubahan ini.

13 script regresi relevan lolos. Tes arena baru mencakup 142 pemeriksaan headless dan 147 dengan penyimpanan lima render Godot. Render 1280×720 serta interaksi jendela melalui mouse/keyboard telah diperiksa oleh agen. Ini belum merupakan playtest manusia. Laporan, gambar, reproduksi, dan batas warning audio saat shutdown tersedia pada [hasil tahap 1](arena-stage-one.md). Tahap 2 menunggu tinjauan pengguna.
