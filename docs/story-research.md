# Eldoria v0.16 — Riset dan mode cerita

Dikerjakan 26 Oktober 2026. Cerita dan dialog Eldoria ditulis orisinal untuk dunia, tokoh, serta kartu yang sudah ada. Rujukan digunakan untuk mempelajari pendekatan emosional dan hubungan antara cerita dengan permainan.

## Rujukan yang dibaca

1. [The Gift of the Magi — O. Henry, Project Gutenberg](https://www.gutenberg.org/files/7256/7256-h/7256-h.htm). Cerita memperlihatkan kepedulian lewat keputusan dan benda yang bernilai bagi tokohnya. Penerapan Eldoria: mangkuk yang diperbaiki, jahitan yang tidak sempurna, porsi roti, dan daftar belanja menjadi penanda hubungan. Eldoria tidak menggunakan tokoh, pertukaran hadiah, dialog, atau alur cerita tersebut.
2. [Spiritfarer — Thunder Lotus](https://thunderlotusgames.com/games/spiritfarer/). Deskripsi resmi menekankan waktu yang dijalani bersama, merawat, membangun kenangan, dan berpisah. Penerapan Eldoria: pembaca mengenal kebiasaan Liora sebelum konflik penutup; akhir menyisakan dukacita yang dijalani bersama, bukan kesembuhan instan. Tidak mengambil dunia arwah, kapal, tokoh, atau adegannya.
3. [Pyre FAQ — Supergiant Games](https://www.supergiantgames.com/blog/pyre-faq/). Pengembang menjelaskan kampanye yang mengakui hasil menang maupun kalah. Penerapan Eldoria: setiap bab memiliki respons kekalahan yang ditulis, kesempatan mencoba lagi, dan progres sebelumnya tetap tersimpan. Eldoria tetap mensyaratkan kemenangan untuk membuka bab berikutnya; ini adaptasi prinsip mengakui kegagalan, bukan menyalin sistem percabangan Pyre.

## Buku I — Jendela yang Menghadap Pagi

Aren pulang setelah tiga tahun berpisah dari rumah. Nyx mempertahankan rekaman suara kakaknya yang telah meninggal, sementara lingkungan mereka mulai kehilangan kenangan kecil. Konfliknya menyangkut cara menjaga seseorang tanpa menghabiskan kehidupan orang-orang yang masih tinggal.

Lima bab, lima duel, epilog, 90 halaman dialog termasuk variasi hasil dan pilihan. Tokoh: Aren, Liora, Nyx, Rana, Iria. Ada tiga pilihan ekspresif yang mendapat tanggapan kemudian dan mengubah bagian epilog. Pilihan tidak mengubah statistik, memaksa tokoh mati, atau mengunci akhir buruk tersembunyi. Nyx tetap perlu menjelaskan dan memperbaiki akibat tindakannya; satu duel tidak menghapus tanggung jawab atau dukacitanya.

Bab pertama memakai Fajar melawan Fajar dengan AI Santai yang sudah ada. Bab 2, 3, dan 5 memakai Fajar melawan Gerhana. Bab 4 menukar sudut pandang: pemain menggunakan Gerhana melawan rekaman latihan Fajar. Keputusan AI dan keseimbangan kartu tidak diubah. Belum ada deck ketiga.

## Cara mencoba

F8, muat ulang perubahan jika diminta Godot, lalu F5. Pada menu utama pilih MODE CERITA / BUKU I, kemudian MULAI KISAH.

- Teks dibaca tanpa penghitung waktu. Lanjut/Sebelumnya mengatur halaman; Enter/Spasi dapat melanjutkan. Pada pilihan dialog, pilih salah satu tanggapan.
- Bab/Jeda kembali ke daftar bab. Progres dialog, pilihan, dan bab tersimpan otomatis pada perangkat.
- Coin flip tetap menentukan urutan duel. Nama lawan, penanda bab/deck, log, dan hasil mengikuti tokoh cerita.
- Setelah menang, Undo tetap tersedia. Bab baru disahkan ketika pemain menekan LANJUT CERITA atau meninggalkan hasil menuju BUKU CERITA. Undo sebelum itu tidak membuka bab secara keliru.
- Kekalahan memiliki dialog tersendiri dan bisa dicoba lagi. Bab sebelumnya tetap terbuka. Bab yang sudah terbuka bisa dibaca ulang, serta Catatan Kenangan bertambah setelah bab selesai.
- Duel yang ditinggalkan saat masih berjalan diulang dari awal saat melanjutkan; posisi kartu di tengah duel belum disimpan. Dialog dan checkpoint bab tetap tersimpan.
- Mode duel bebas tetap memakai dua pilihan deck dan tingkat kesulitan yang dipilih pemain. Pilihan cerita tidak menimpa preferensi duel bebas.

## Pemeriksaan

913 pemeriksaan model lulus, termasuk 400 duel simulasi (80 per bab, kedua urutan pembuka) tanpa duel macet. Semua matchup dapat dimenangkan. Pemeriksaan UI cerita sebanyak 145 lulus: urutan lima bab hingga epilog, seluruh halaman muat pada panel baca, pilihan, penanda lawan, penyimpanan, kalah/coba lagi, Undo kemenangan, batas progres, dan kembali ke duel bebas. Pengaturan 25, coin/teks kartu 97, serta Undo UI/musik 15 juga lulus. Tampilan diperiksa dengan renderer native pada 1280×720.

## Pengembangan cerita berikutnya

Buku I memiliki penutupnya sendiri. Deck ketiga nanti diperkenalkan lewat tokoh, konflik, dan perjalanan baru; bukan sekadar hadiah kartu atau mengganti nama musuh dalam cerita ini. Saat menambah Buku II, pertahankan arsip dan pilihan Buku I dengan migrasi progres per buku. Belum ada bab atau deck ketiga yang dibuat pada pembaruan ini.

## Berkas

Naskah lengkap dengan spoiler: docs/story-book-one.md. Data cerita: scripts/story_data.gd. Pembaca dan alur: scripts/story_view.gd dan scripts/story_flow.gd.

Ilustrasi latar dibuat dengan built-in image_gen, mode generate. Hasil disimpan di C:/Users/Kafka/Documents/anime-card-duel/assets/story/window_morning.png. Prompt final: assets/story/image_prompt.json. Kartu dan simbol kenangan memakai ilustrasi Eldoria yang sudah tersedia. Dialog disajikan sebagai teks, belum memakai pengisi suara.
