# Eldoria 0.12: deck bawaan dan respons

Fajar menggunakan 13 monster, 6 spell, dan 1 trap, dengan Naga Bara 2500 ATK, Penjaga Fajar 1700 ATK, tiga Peri Astral, damage langsung, buff, dan Segel Hening. Rincian pengujian keseimbangan ada di fajar-balance.md. Gerhana memakai 12 monster, 4 trap, dan 4 spell untuk mengendalikan serangan dan mempertahankan sumber daya. Keduanya punya 20 kartu; untuk sementara pemain memilih deck bawaan dan tidak dapat mengedit susunan kartu.

## Aturan zona

Masing-masing pihak punya tiga zona monster dan tiga zona spell/trap. Zona spell/trap lawan ada di kiri baris lawan; zona milikmu ada di kanan barismu. Klik trap di tangan lalu pilih zona kosong untuk memasangnya tertutup. Bot melakukan hal yang sama. Trap tidak boleh dipakai pada giliran dipasang. Identitas trap Nyx tidak dibocorkan melalui teks, tooltip, atau hover.

Spell aktif dari tangan menempati satu zona kosong sementara. Spell berada di zona itu selama menunggu respons, lalu ke grave setelah rantai selesai, termasuk jika efek dibatalkan. Tiga zona penuh berarti spell dari tangan belum bisa diaktifkan. Tidak ada spell permanen atau pemasangan spell tertutup dalam set ini.

## Prioritas dan rantai

Spell atau pernyataan serangan memberikan prioritas kepada lawan. Sisi yang tidak punya respons legal otomatis lewat. Sisi yang punya trap legal memilih trap atau Lewati; pemain tidak dibatasi timer. Aktivasi trap mereset hitungan lewat dan memindahkan prioritas kepada lawan. Dua lewat berturut-turut menyelesaikan efek dari link terakhir ke pertama. Semua aksi biasa dikunci selama ada rantai.

Contoh: serangan Nyx → Cermin pemain → Segel Nyx → Segel pemain. Segel pemain membatalkan Segel Nyx; Cermin lalu membatalkan serangan dan memberi 300 damage. Serangan yang dibatalkan tetap menghabiskan jatah serangan monster itu.

- Cermin Pembalasan: hanya membalas pernyataan serangan lawan; membatalkan dan memberi 300 damage.
- Belenggu Spektral: hanya membalas pernyataan serangan lawan; menurunkan ATK 500 permanen di papan, lalu serangan dihitung dengan ATK baru.
- Segel Hening: membalas spell atau trap lawan yang terakhir diaktifkan; membatalkan efek, bukan pemasangan/summon atau biaya tribute.
- Efek summon, perisai, dan skill tetap berjalan; tiga trap ini tidak memenuhi syarat untuk merespons efek tersebut. Ini merupakan subset aturan Eldoria, bukan implementasi seluruh aturan Yu-Gi-Oh.

## Koleksi dan pilihan deck

Galeri tetap menampilkan seluruh 18 jenis kartu dengan cerita dan efek terpisah. Deck builder sedang dinonaktifkan: tidak ada tombol editor, layar editor tidak dibuat di runtime, dan pilihan deck serta susunan yang benar-benar masuk duel hanya berasal dari dua preset. Data deck kustom lama tidak dihapus, tetapi tidak dapat dipilih untuk duel saat ini. Pilihan deck bawaan, deck Nyx, dan kesulitan tetap disimpan lokal.

Gerhana terdiri dari Penjaga Senja ×3, Burung Hantu Perak ×2, Penyihir Cermin ×2, Naga Noctis ×2, Oracle Rembulan ×1, Peri Astral ×2; Cermin Pembalasan ×2, Segel Hening ×1, Belenggu Spektral ×1; serta Jam Pasir Astral, Berkah Fajar, Badai Aether, dan Retakan Langit masing-masing satu.

Penjaga Senja memasang satu Cermin dari deck sekali per duel per pihak. Marker hanya dikonsumsi jika Cermin berhasil dipindahkan ke zona kosong. Pemasangan tidak mengambil kartu dari luar deck, tidak mengabaikan waktu tunggu trap, dan tetap menghitung konservasi 20 kartu.

## Keterbacaan trap

Pilih trap dari tangan pada Main Phase: zona kosong milikmu di kanan papan akan berwarna emas dan bertuliskan PASANG DI SINI. Tombol zona salah dinonaktifkan selama memilih trap. Klik satu zona untuk memasang; status MENUNGGU berubah menjadi SIAP pada giliran berikutnya. Saat ada pemicu yang sah, panel respons muncul otomatis, termasuk pada giliran Nyx.

Trap yang diselesaikan tampil satu per satu: kartu dibuka di area tangan, panel menerangkan nama/pemilik/efek, dan geometri khas menuju target. Trap yang dibatalkan juga ditampilkan dengan tanda silang. Cermin menampilkan bidang pemantul dan sinar balik; Segel membentuk rantai silang pada rune tengah; Belenggu melingkari penyerang dengan sulur berduri. Serangan yang masih sah, angka damage, LP, dan hasil duel ditunda sampai presentasi trap selesai. Semua antrean dibersihkan saat duel diulang.

## Kesulitan Nyx

Santai memilih monster secara sederhana, tidak memakai skill, dan kadang melewatkan trap. Normal memakai penilaian serangan, spell berguna, posisi bertahan, dan respons legal. Sulit mempertimbangkan nilai tribute serta pertahanan pada pembukaan, mendahulukan Cermin, dan menghemat Segel terhadap heal yang tidak mendesak. Ketiganya memakai informasi publik dan trap sendiri; bot tidak membaca identitas trap tertutup pemain dalam evaluasi langkahnya. Ini heuristik, belum pencarian banyak giliran atau sistem tingkat kesulitan terlatih.

## Verifikasi

Test strategi menjalankan kedua urutan pembuka, dua arketipe, dan tiga kesulitan; memeriksa konservasi 20 kartu termasuk zona spell/trap, LP, dan duel selesai. Tes unit mencakup timing trap, respons berantai, pembatalan, penurunan ATK sebelum damage, slot penuh, deck-out, validasi deck, simpan/muat, dan pemulihan cadangan. Tes UI memakai deck bawaan, memverifikasi klik nyata ke zona emas, dan menjalankan rantai empat link melalui panel pemain dan respons otomatis Nyx. Galeri memeriksa keunikan piksel ilustrasi seluruh 18 kartu. Efek visual diuji dengan renderer native Godot.
