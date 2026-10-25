# Eldoria 0.8: deck dan respons

Fajar menggunakan monster agresif, damage langsung, dan buff. Gerhana memakai 12 monster, 6 trap, dan 2 spell untuk mengendalikan serangan dan mempertahankan sumber daya. Keduanya punya 20 kartu; pemain bebas mencampur kartu melalui deck builder.

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

## Koleksi dan simpanan

Semua 18 jenis kartu tersedia sebanyak maksimal tiga salinan per deck; belum ada pembelian, pembukaan paket, atau progres membuka kartu. Buka Koleksi & Deck Builder, pilih deck dasar, klik ganda koleksi untuk menambah atau isi deck untuk mengurangi. Panel tengah membedakan Efek Kartu dan Cerita. Deck valid harus tepat 20 kartu, maksimal 3 salinan per jenis, minimal 8 monster.

Simpan & Gunakan membuat salinan kustom dari preset; menyimpan deck kustom memperbaruinya. Preset asli tetap tersedia. Deck aktif dan pilihan Nyx/kesulitan disimpan di user://eldoria_collection_v1.json. Penyimpanan membuat berkas sementara dan cadangan; simpanan rusak dipulihkan dari cadangan jika memungkinkan, lalu preset menjadi fallback. Progres duel tidak disimpan. Pengujian menggunakan nama berkas terpisah dari profil pemain.

## Kesulitan Nyx

Santai memilih monster secara sederhana, tidak memakai skill, dan kadang melewatkan trap. Normal memakai penilaian serangan, spell berguna, posisi bertahan, dan respons legal. Sulit mempertimbangkan nilai tribute serta pertahanan pada pembukaan, mendahulukan Cermin, dan menghemat Segel terhadap heal yang tidak mendesak. Ketiganya memakai informasi publik dan trap sendiri; bot tidak membaca identitas trap tertutup pemain dalam evaluasi langkahnya. Ini heuristik, belum pencarian banyak giliran atau sistem tingkat kesulitan terlatih.

## Verifikasi

Test strategi menjalankan kedua urutan pembuka, dua arketipe, dan tiga kesulitan; memeriksa konservasi 20 kartu termasuk zona spell/trap, LP, dan duel selesai. Tes unit mencakup timing trap, respons berantai, pembatalan, penurunan ATK sebelum damage, slot penuh, deck-out, validasi deck, simpan/muat, dan pemulihan cadangan. Tes UI menggunakan deck kustom asli lalu menjalankan rantai empat link melalui panel pemain dan respons otomatis Nyx. Galeri memeriksa keunikan piksel ilustrasi seluruh 18 kartu. Efek visual diuji dengan renderer native Godot.
