# Eldoria: Variasi Duel dan Sembilan Kartu Baru

Status: rancangan untuk ditinjau; belum diterapkan ke game.

## Tujuan dan keputusan

Pemain ingin Eldoria kuat dalam strategi duel dan cerita. Keluhan utama sekarang adalah kartu yang berulang. Semua kartu tambahan langsung tersedia tanpa syarat progres, mata uang, atau pembelian. Pengembangan memakai Godot dan struktur game yang sudah ada.

Pendekatan yang dipilih adalah mengembangkan satu bab bersama duelnya. Memperluas cerita dahulu menunda variasi permainan; memperluas duel saja menunda hubungan mekanik dengan karakter. Paket ini memperbarui tiga deck yang tersedia dan memakai Bab 3 Buku I, Sembilan Belas Detik, sebagai contoh hubungan duel dan cerita.

## Cakupan

- Tambahkan sembilan kartu unik sehingga katalog berisi 34 jenis.
- Semua tersedia di galeri dan deck builder sejak awal. Tidak memerlukan penyelesaian bab.
- Aktifkan kembali deck builder dan pemilihan deck kustom untuk duel bebas. Aturan tetap: 20 kartu, maksimal tiga salinan, minimal delapan monster. Pemilihan deck cerita tetap diatur bab.
- Perbarui preset Fajar, Gerhana, dan Rimba; ukuran tetap 20. Setiap preset memakai satu salinan masing-masing dari tiga kartu barunya. Ganti tiga kartu lama berdasarkan simulasi dan pengujian, pertahankan monster andalan serta jumlah monster minimal.
- AI memahami seluruh efek baru. Pemain dapat memilih target Grave secara eksplisit.
- Bab 3 memakai Gerhana baru dan dialog kontekstual terbatas, tanpa menambah bab atau mengubah pilihan/progres cerita lama.

## Aturan bersama

Angka berikut adalah titik awal untuk keseimbangan, bukan angka final. Monster level 4 atau kurang menggunakan normal summon yang sama dengan kartu lama. Spell memakai zona sementara dan dapat dibalas Segel Hening. Trap menunggu hingga giliran setelah pemasangan, memakai jendela respons lama, dan diselesaikan dari efek terakhir ke pertama. Identitas target mengikuti UID monster, bukan nomor zona. Target yang hilang membuat efek bertarget gagal; biaya yang sudah dibayar tidak dikembalikan.

Bonus sementara berakhir saat giliran aktif selesai, termasuk jika diberikan saat giliran lawan. Undo memulihkan biaya, target, bonus, penanda sekali pakai, status serangan, urutan deck dan RNG. Tidak ada perubahan pada kekalahan saat harus menarik dari deck kosong.

## Fajar: menyerang dengan komitmen

1. **Pembawa Bara** — monster API, level 3, ATK 1200 / DEF 1000. Jika dipakai sebagai tribute, monster yang disummon lewat tribute tersebut mendapat +400 ATK selama berada di papan. Tidak berlaku saat dihancurkan atau dikorbankan untuk spell. Jika summon menggunakan target kosong, bonus tetap mengikuti monster yang benar.
2. **Sumpah Fajar** — spell. Pilih monster sendiri yang belum menyerang: ATK +700 hingga akhir giliran, tidak dapat menyerang langsung pada giliran ini. Hanya legal jika lawan memiliki monster. Tidak memberi serangan tambahan dan tidak menumpuk pada target yang sama dalam satu giliran.
3. **Benteng Cahaya** — trap, respons ketika lawan menyerang monster sendiri. Monster yang diserang mendapat +700 ATK dan DEF sampai akhir giliran. Serangan tetap berlangsung. Tidak legal terhadap serangan langsung; tidak otomatis membatalkan atau meniadakan damage.

Keputusan: mempertahankan monster kecil atau menjadikannya tribute; berkomitmen menyerang papan lawan atau menunggu peluang serangan langsung.

## Gerhana: posisi dan tempo

4. **Penenun Senja** — monster BULAN, level 4, ATK 1400 / DEF 1600. Saat summon, boleh memilih satu monster lawan dalam posisi menyerang untuk diubah menjadi bertahan. Boleh dilewati. Perubahan dari efek ini tidak memakai kesempatan perubahan posisi manual target. Tidak membuka jendela respons summon baru.
5. **Langkah ke Balik Cermin** — spell. Bayar 500 LP, lalu pilih satu monster lawan level 4 atau kurang untuk dikembalikan ke tangan. Aktivasi membutuhkan LP lebih dari 500. Biaya dibayar saat aktivasi dan tetap terpakai jika dibatalkan. Statistik, perisai, dan bonus target kembali ke data dasar di tangan; target dihapus dari papan tanpa masuk Grave.
6. **Arsip Rembulan** — spell. Pilih satu trap di Grave sendiri untuk dikembalikan ke tangan. Maksimal satu aktivasi Arsip Rembulan per pihak per giliran, termasuk jika dibatalkan. Trap yang dipasang kembali tetap menunggu hingga giliran berikutnya. Tidak legal tanpa target.

Keputusan: membuka celah dengan posisi, mengeluarkan LP untuk tempo, atau memakai satu kartu untuk mendapatkan kembali respons lama.

## Rimba: memilih penggunaan Grave

7. **Perawat Akar** — monster ALAM, level 3, ATK 1000 / DEF 1500. Saat summon, boleh memilih satu monster ALAM level 4 atau kurang di Grave sendiri dan menaruhnya di dasar deck, lalu menarik satu kartu. Tidak memulihkan LP. Jika tidak ada target, summon tetap legal dan efek dilewati.
8. **Jalinan Akar** — spell. Pilih satu monster ALAM sendiri. ATK dan DEF bertambah 200 untuk setiap monster ALAM di Grave sendiri, maksimal tiga, hingga akhir giliran. Jumlah dihitung saat resolusi; aktivasi membutuhkan setidaknya satu monster ALAM di Grave. Tidak menumpuk pada target yang sama dalam satu giliran.
9. **Jejak yang Tumbuh** — trap, respons serangan lawan. Pilih satu monster ALAM level 4 atau kurang di Grave sendiri. Kembalikan ke tangan, lalu kurangi ATK penyerang sebesar 400 hingga akhir giliran. Serangan tetap berlangsung. Legal pada serangan langsung, tetapi membutuhkan target Grave. Jika penyerang hilang, pemulihan tetap berjalan; jika target Grave hilang, seluruh efek gagal.

Benih Pulang dan efek Penjaga Tunas juga menggunakan pilihan target Grave. AI memilih targetnya sendiri. Lingkar Musim menggunakan pilihan yang sama untuk pengembalian ke dasar deck. Bonus Naga Akar Purba yang sudah diberikan saat summon tetap tidak berubah ketika isi Grave berubah.

Keputusan: mempertahankan bahan di Grave untuk penguatan, mengembalikannya ke tangan, atau menukarnya dengan draw.

## Antarmuka dan ilustrasi

Pilihan target menampilkan kartu legal, tujuan perpindahan, dan tombol batal sebelum aksi dikomit. Biaya spell baru dikomit setelah target dipilih. Untuk trap, target dipilih sebelum respons masuk rantai. Efek summon dengan target memakai langkah pilihan tersendiri; tombol Lewati melanjutkan summon tanpa efek opsional. Selama pilihan tertunda, input aksi lain dan AI tertahan. Pembatalan pilihan summon berarti melewati efek opsional; Undo tetap membatalkan seluruh aksi summon.

Efek sementara, larangan serangan langsung, dan biaya LP tampil dalam teks kartu, detail monster, petunjuk aksi, dan log. Tambahkan ilustrasi unik untuk sembilan kartu dengan gaya Eldoria; gunakan jalur pemuatan gambar yang sudah tersedia. Efek visual boleh menggunakan pola elemen yang ada dengan aksen berbeda. Mode Ringkas dan kecepatan animasi tetap bekerja.

## Bab 3: Sembilan Belas Detik

Pertahankan naskah pokok, identitas Liora sebagai rekaman/kenangan, syarat menang, pilihan, dan navigasi bab. Nyx memakai Gerhana baru; Aren memakai Fajar baru. Pembuka singkat menghubungkan cara Nyx mengembalikan kartu dengan kebiasaannya memutar rekaman.

Maksimal dua komentar singkat per duel: satu setelah Nyx pertama kali berhasil memulihkan trap melalui Arsip Rembulan; satu ketika Aren pertama kali berhasil menyerang setelah trap Nyx dibatalkan. Komentar tampil sebagai pemberitahuan yang tidak memblokir, menunggu rantai dan animasi selesai, dan tidak membuka layar VN di tengah input. Komentar bersifat opsional terhadap jalannya duel; bab tetap dapat ditamatkan tanpa pemicu tersebut. Undo memulihkan penanda komentar agar tidak menampilkan kejadian yang dibatalkan. Hasil menang/kalah tetap menuju alur bab lama.

## AI dan keseimbangan

AI memakai informasi publik papan/Grave dan tangannya sendiri. Tidak membaca tangan atau urutan deck pemain. AI mempertimbangkan damage setelah buff, larangan serangan langsung, biaya LP, nilai tribute, target pemulihan, serta konsekuensi perubahan posisi. Tingkat kesulitan lama tetap tersedia.

Bandingkan sebelum/sesudah dengan seed sama, ketiga pasangan deck, kedua posisi pembuka, dan tiga kesulitan. Sasaran awal preset adalah tidak ada pasangan yang konsisten melewati 60% kemenangan pada Normal dan Sulit; ini pemicu peninjauan, bukan jaminan keseimbangan manusia. Periksa duel terlalu panjang, tangan tanpa aksi berguna, dan loop pemulihan. Aturan kartu dapat disesuaikan jika sasaran gagal, tetapi perubahan mekanik besar perlu dibahas kembali.

## Verifikasi penerimaan

- Sembilan kartu legal, dapat dilihat, dan dapat ditambahkan sebelum bermain cerita.
- Setiap efek memiliki uji keberhasilan, target ilegal/hilang, durasi, pembatalan jika berlaku, dan Undo.
- Uji rantai trap, pembukaan giliran, bonus tribute, kembali ke tangan tanpa buff, dan batas aktivasi.
- Deck kustom tersimpan, dimuat, dipilih di duel bebas, dan ditolak jika invalid.
- Penyimpanan lama dan progres kedua buku tetap dapat dimuat.
- Semua preset valid; simulasi selesai tanpa loop atau pelanggaran jumlah kartu.
- Mainkan Bab 3, satu duel bebas setiap preset, dan satu duel deck kustom; periksa tampilan target, teks, ilustrasi, dan ringkasan hasil.
- Jalankan pengujian lama yang relevan. Catat bila Godot atau akses tulis proyek belum tersedia; jangan menyatakan pengujian lulus tanpa hasil.

## Batas dan ruang keputusan pelaksana

Tidak menambah multiplayer, gacha, mata uang, deck keempat, bab baru, atau aturan reshuffle otomatis. Pertahankan pola data Dictionary yang dipakai proyek; tidak perlu migrasi seluruh katalog ke Resource untuk paket ini. Penataan kode hanya dilakukan saat diperlukan untuk target/efek baru. Pelaksana menentukan pemisahan fungsi, nama ID kartu, tata letak pilihan target, pilihan tiga kartu yang diganti setiap preset, dan rincian ilustrasi. Tidak menghapus komentar atau data penyimpanan lama.
