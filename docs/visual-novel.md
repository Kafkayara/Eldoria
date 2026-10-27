# Eldoria v0.18 — Visual novel dan penulisan ulang cerita

Diterapkan 27 Oktober 2026. Seluruh naskah Eldoria orisinal. Riset dipakai untuk pola penyajian dan penulisan, bukan menyalin cerita, karakter, atau ilustrasi game lain.

## Temuan riset dan penerapan

- **STEINS;GATE — petunjuk resmi MAGES.** Kontrol resminya memisahkan lanjut teks, backlog, menyembunyikan kotak pesan, skip teks yang sudah dibaca, dan Auto. Eldoria memakai fungsi-fungsi dasar tersebut dengan tombol yang terlihat dan pintasan PC. Skip hanya melewati teks yang selesai ditampilkan; tidak melompati pilihan atau masuk duel. Sumber: https://game.mages.co.jp/smapho/app_steinsgate.html
- **STEINS;GATE: Linear Bounded Phenogram — situs resmi Spike Chunsoft.** Cerita dari sudut anggota kelompok memperlihatkan pikiran dan sisi pribadi tokoh. Penerapan editorial Eldoria: tujuan pribadi, hubungan, dan detail keseharian diperkenalkan sebelum penjelasan konflik. Pikiran Aren diberi label batin. Ini interpretasi desain kami, bukan klaim bahwa alur Eldoria mengikuti game tersebut. Sumber: https://spike-chunsoft.com/SteinsGateElite/phenogram/home.html
- **Ren’Py: Dialogue and Narration.** Identitas pembicara dan narasi dipisahkan. Eldoria memakai kotak dialog bawah layar, nama/warna/peran pembicara, dan label khusus rekaman serta kenangan. Memilih format ADV satu ucapan per halaman menjaga latar dan tokoh terlihat pada 1280×720. Sumber: https://www.renpy.org/doc/html/dialogue.html
- **Ren’Py: History.** Pembaca dapat meninjau percakapan terdahulu. Eldoria menyimpan sampai 80 entri teks yang selesai ditampilkan per buku, beserta pembicaranya. Ini riwayat baca, bukan rewind keadaan duel. Sumber: https://www.renpy.org/doc/html/history.html
- **Ren’Py: GUI.** Tata letak, ukuran, dan gaya teks dapat disesuaikan. Eldoria menyediakan ukuran 26/30, kecepatan 0–80 huruf/detik, jeda Auto, latar kotak gelap, serta pemeriksaan semua halaman dan variasi pada kedua ukuran. Sumber: https://www.renpy.org/doc/html/gui.html
- **Failbetter: Fallen London Writer Guidelines III.** Tulisan ringkas, detail yang dapat diamati, dan konteks tindakan lebih berguna daripada tumpukan penjelasan abstrak. Dialog Eldoria dipecah menjadi respons pendek; konsekuensi Suaka ditunjukkan lewat resep Rana dan laporan warga. Sumber: https://www.failbettergames.com/news/fallen-london-writer-guidelines-part-iii
- **The Oxford Editors: Writing Dialogue.** Percakapan perlu suara yang berbeda dan tujuan dalam adegan. Rana menyatakan perhatian lewat makanan/pekerjaan; Iria menjelaskan secara tepat; Nyx ragu dan menghindar sebelum mengakui tanggung jawab; Aren bertanya langsung. Ini keputusan penulisan Eldoria, bukan jaminan respons emosional pembaca. Sumber: https://www.theoxfordeditors.co.uk/about/free-advice-for-authors/writing-dialogue

Riset menggunakan dokumentasi dan materi penerbit yang dapat diakses; bukan pengakuan telah memainkan seluruh game pembanding. Format, fitur, dan tulisan diimplementasikan langsung dalam Godot, tanpa menambah dependensi Ren’Py.

## Tokoh dan hubungan

- **Aren (22)**: tokoh pemain, kurir, adik Liora. Pulang setelah surat Nyx. Ia perlu memahami keadaan kota sebelum menentukan apa yang harus dilakukan.
- **Liora (25 ketika meninggal)**: kakak Aren, pengelola dapur warga, mengajari Aren dan Nyx bermain kartu. Meninggal pada Malam Retak tiga tahun lalu. Hanya tampil dalam kenangan atau rekaman yang ditandai.
- **Nyx (23)**: sahabat masa kecil Aren, teknisi Suaka, dekat dengan keluarga Liora. Takut kehilangan ingatan tentang suara Liora; tindakannya punya akibat bagi warga dan membutuhkan pertanggungjawaban.
- **Rana (52)**: tetangga, penjaga gerbang, dipanggil Bibi oleh Aren. Menjaga rumah selama Aren pergi dan menjadi pembimbing latihan awal.
- **Iria (34)**: arsiparis dan rekan kerja Nyx. Menjelaskan kerusakan Suaka, menyimpan laporan, dan mengawasi prosedur penghentian mesin.
- **Sera (23)**: penjaga kebun, putri Banyu, pemilik Rimba. Terlalu banyak bekerja sendiri karena mengira kebun harus sempurna agar ayahnya mau pulang.
- **Banyu (56)**: ayah Sera, petani/perancang pengairan. Selamat dari banjir tetapi cedera dan belum siap tinggal kembali dekat sungai. Tetap berguna melalui pengetahuannya.

Profil baru terbuka ketika tokoh muncul di adegan. Pengetahuan tokoh dari buku yang pernah dibaca juga tersedia. Profil memberi hubungan dasar; tidak membocorkan hasil akhir konflik. Hanya dua potret sekaligus; pembicara ketiga memakai pergantian pasangan tampilan.

## Aturan dunia dan alur (spoiler)

**Buku I, lima bab dan epilog / 161 halaman:** rumah dan keluarga → arsip dan dampak mesin → menemui Nyx → rekaman latihan Liora → mematikan Suaka → kehidupan sesudahnya. Suaka menyimpan gambar/suara, bukan jiwa; rekaman tidak dapat menjawab ucapan baru. Mesin rusak mengambil tenaga dari kenangan warga dan menyerap cahaya sekitar. Waktu tidak berhenti. Duel merupakan cara menata pengaman aether; LP bukan nyawa. Kegagalan menutup pengaman agar bisa diulang. Nyx tidak langsung dimaafkan semua orang setelah mesin padam.

**Buku II, tiga bab dan epilog / 73 halaman:** mengantar benih dan membuka jalan kaki → bertemu Banyu serta membuka pengairan → memperbaiki jembatan untuk gerobak bersama → kebun mulai tumbuh. Penjaga Saluran adalah sistem pengaman, bukan tokoh baru. Jalan kaki pada bab pertama belum berarti jembatan sudah aman untuk gerobak. Pemulihan Rimba menjadi cara membantu pekerjaan, tanpa mengubah aturan kartu.

Ada lima pilihan percakapan pada dua buku dengan tanggapan/callback; tidak dipasarkan sebagai banyak rute atau ending terpisah. Sebagian halaman merupakan respons kalah yang hanya dibaca saat kalah. Buku II tetap terbuka setelah lima bab Buku I. Tiga deck bawaan, statistik, mekanik, dan AI tidak diubah pembaruan ini.

## Cara mencoba dan kontrol

1. F8 di Godot jika game masih berjalan. Muat ulang file eksternal bila diminta, lalu F5.
2. Menu → Mode Cerita → Buku I → Bab 1. Pembaca lama sebaiknya membaca ulang Bab 1 untuk pengantar hubungan dan aturan dunia baru.
3. Klik layar / Enter / Space: tampilkan seluruh kalimat dulu jika masih mengetik; berikutnya lanjut. Pada pilihan jawaban, pilih tombolnya.
4. Sebelumnya: satu halaman ke belakang dalam adegan. Riwayat: 80 ucapan terakhir yang selesai ditampilkan. Tokoh: gambar, peran, dan hubungan. Tujuan bab: tempat, tujuan, alasan duel, deck.
5. Auto: membaca otomatis sampai pilihan/akhir adegan. Lewati dibaca: berhenti pada teks atau variasi yang belum dibaca. Keduanya tidak memilih jawaban atau memulai duel otomatis.
6. H / klik kanan: sembunyikan atau tampilkan kotak pesan. Pengetikan berhenti selama kotak tersembunyi. Klik kiri pertama mengembalikan kotak.
7. Bacaan: ukuran 26/30, kecepatan teks, jeda Auto 1–8 detik. Kecepatan 0 menampilkan ucapan langsung. Setelan disimpan; Auto tidak aktif sendiri saat game dibuka.
8. Esc menutup panel; dari adegan kembali ke daftar bab. Efek Ringkas menghilangkan transisi latar.

## Simpanan dan kompatibilitas

Versi berkas simpan tetap 1; bidang pembaca baru memakai vn_revision 2, ID halaman, tokoh dikenal, teks dibaca, dan riwayat. Bab selesai dan pilihan lama dipertahankan. Karena naskah ditulis ulang, posisi adegan dari versi sebelumnya dimulai lagi dari awal adegan tersebut, dengan pemberitahuan. Save baru memakai ID halaman stabil. Duel yang terputus tetap dimulai ulang; ini bukan save keadaan duel tengah giliran. Pengujian memakai folder APPDATA terpisah dari simpanan pemain.

## Visual dan batasan

13 gambar baru dibuat lewat built-in image_gen: 7 potret transparan 1024×1536 dan 6 latar 1672×941. Latar dapur siang yang sudah ada dipakai kembali. Sumber final dan prompt tiap aset ada di assets/vn/image_prompts.json. Tidak ada pemotongan/pengubahan raster lewat Python. Tekstur dimuat saat dibutuhkan dan digunakan ulang selama pembaca aktif. Pembicara lebih terang; tokoh lain diredupkan; rekaman Liora memakai tampilan pudar dan penanda tertulis.

Ini visual novel 2D dengan potret statis: belum ada voice acting, animasi bibir, ekspresi per kalimat, maupun pengujian ekspor HP. Musik orisinal yang sudah ada dipakai pada volume menu/cerita yang lebih pelan, tanpa stem urgensi duel. Penilaian apakah dialog menyentuh tetap memerlukan pembacaan pemain.

## Verifikasi

- test_visual_novel.gd: **1.456 pemeriksaan lulus**, dijalankan dengan renderer Windows; seluruh halaman/variasi pada font 26/30 muat. Mencakup dua-klik, history, migrasi, bookmark, Auto, pilihan, skip variasi baru, profil, pause, fokus toolbar/Space, serta save/reload pengaturan.
- test_story_ui.gd: **211 pemeriksaan lulus** pada renderer Windows, lima bab sampai tamat, hasil kalah, coin, simpan/reload dan Undo kemenangan sebelum komit.
- test_rimba_ui.gd: **99 pemeriksaan lulus**, tiga bab Buku II, unlock dan pemisahan progres buku.
- test_story.gd: **982 pemeriksaan / 400 duel** lulus; test_rimba.gd: **10.712 pemeriksaan / 120 duel** lulus.
- test_comfort_ui.gd: **25**, test_undo.gd: **70**, test_undo_ui.gd: **15** pemeriksaan lulus.
- Gambar komposit diperiksa dari tangkapan viewport game; metadata seluruh potret memiliki alpha transparan. Tidak ada kegagalan pengujian final.

Naskah lengkap dengan semua pilihan dan respons kalah: story-book-one.md dan story-book-two.md. Pratinjau disimpan di output percakapan, tidak dijadikan aset runtime.
