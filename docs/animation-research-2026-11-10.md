# Riset animasi Eldoria

Tanggal: 10 November 2026. Status: riset dan usulan, belum implementasi atau desain yang disetujui.

## Metode dan batas

Membaca sumber pengembang, diskusi pemain, serta kode Eldoria. Ini bukan pengukuran frame dari rekaman gameplay, survei representatif, atau hasil playtest. Dua percakapan pengembangan terdahulu belum berhasil ditemukan melalui pencarian konteks; dokumentasi dan kode proyek menjadi dasar kontinuitas. Runtime Godot pada review sebelumnya crash saat menjalankan tes; pengujian visual perlu dipulihkan sebelum menyatakan peningkatan berhasil.

## Temuan sumber

- Duel Links: Konami menonjolkan suara karakter anime dan animasi 3D monster andalan. Pelajaran untuk Eldoria: perlakukan naga andalan sebagai peristiwa khusus. Tidak berarti Eldoria perlu semua monster berbentuk 3D.
- Pokemon TCG Pocket: pengembang menekankan rasa memegang kartu fisik, suara, sudut pandang, dan parallax/immersive illustration. Adaptasi: gerak, kedalaman, pencahayaan ilustrasi; bukan menambahkan ekonomi pack ke Eldoria.
- Master Duel: pengumuman resmi menekankan kombinasi animasi, musik, dan suara. Diskusi pemain mengeluhkan waktu resolusi rantai dan animasi berulang. Keluhan ini bersifat anekdotal, bukan pendapat semua pemain.
- Runeterra: Riot secara eksplisit mengurangi durasi animasi dan input blocking untuk draw, unit, serta awal ronde. Pemain juga mengapresiasi cinematic level-up, sekaligus mengeluhkan repetisi dan durasi. Adaptasi: momen besar jarang, aksi rutin cepat.
- Hearthstone: VFX berfungsi menjelaskan papan, memperkuat identitas kelas, dan merayakan peristiwa penting. Bentuk serta material sama pentingnya dengan warna.

## Kondisi kode saat ini

- scripts/effects.gd: 34 profil, efek geometri, glow additive, batas 8 event, mode ringkas. Banyak profil berbagi impact 0,42 dan durasi 0,95 detik.
- scripts/ace_cutin.gd: banner ilustrasi 696 x 240, durasi dasar 1,05 detik; variasi warna dan slogan. Belum berupa koreografi terpisah untuk tiap naga.
- main.gd _animate_attack: gerak mundur 4 px dan maju 10 px; efek proyektil membawa sebagian besar aksi.
- main.gd _play_trap_visuals: presentasi berurutan 1,15 detik per trap pada 1x; empat trap berarti 4,6 detik presentasi sebelum efek lanjutan, di luar waktu memilih respons.
- Sinkronisasi LP, snapshot target, pembatalan melalui session, Undo, kecepatan 1x/1,5x/2x, dan reduced motion sudah ada. Harus dipertahankan.

## Pilihan arah (belum dipilih pengguna)

1. Polish 2D: perbaiki easing, gerak kartu, audio, impact. Perubahan paling terbatas; lompatan visual juga terbatas.
2. Sinematik 2.5D selektif (rekomendasi): kartu/ilustrasi berlapis, koreografi khusus tiga naga, impact dan finisher; tetap pada renderer Compatibility. Memerlukan pemisahan aset foreground/background atau masker bila ingin parallax nyata.
3. Monster 3D: model, rig, animasi dan pencahayaan baru. Potensi spektakel tinggi, tetapi merupakan perluasan produksi aset dan integrasi yang jauh lebih besar.

## Usulan pengalaman untuk arah 2

- Kartu biasa: lift, bayangan, sedikit kemiringan, dan pendaratan jelas. Gerak mengikuti sumber serta zona tujuan sebenarnya.
- Naga Bara: bara tertarik ke pusat, retakan menyala, siluet/ilustrasi naga muncul, semburan api mengikuti arah serangan.
- Naga Noctis: cahaya meredup lokal, gerhana terbentuk, serpihan cermin/perak berputar, perisai menutup di akhir summon.
- Naga Akar Purba: akar muncul dari zona, menautkan jejak Grave, daun terbuka, naga tampil dengan denyut hijau hangat. Jangan bocorkan informasi tersembunyi.
- Serangan: persiapan singkat, percepatan, impact terlokalisasi, recoil target, perubahan LP dan suara pada titik yang sama. Getaran hanya arena; panel baca tetap stabil.
- Trap: flip dari slot asli, tunjukkan hubungan sumber/target dan urutan resolusi; pembatalan punya tanda berbeda dari efek berhasil.
- Finisher: baru diputar setelah hasil lethal benar-benar dipastikan sesudah respons, lalu transisi hasil. Deck-out memiliki presentasi berbeda dari serangan terakhir.
- Mode ringkas tetap mempertahankan informasi hasil tanpa shake, flash besar atau cinematic. Kecepatan visual tidak mengubah tempo musik.

Target awal untuk diuji, bukan durasi yang diukur dari game referensi: hover 0,10-0,16 detik; draw 0,20-0,30; summon biasa 0,40-0,65; serangan 0,55-0,85; ace pertama 1,6-2,2; finisher 1,0-1,5. Ace berikutnya memakai versi singkat; besar kecilnya damage menentukan intensitas, bukan selalu menambah durasi.

## Verifikasi yang diperlukan saat implementasi

1. Pulihkan cara menjalankan Godot dan buat capture baseline sebelum/sesudah pada seed serta situasi sama.
2. Uji summon tiga naga, shield, attack vs DEF, piercing, direct lethal, spell lethal, deck-out, serta rantai negate.
3. Uji Undo di tengah efek, restart/menu, pergantian kecepatan dan mode ringkas; tidak ada node, suara, atau callback tersisa.
4. Ukur frame time di perangkat sasaran. Sasaran awal 60 FPS bukan klaim performa saat ini.
5. Playtest: apakah pemain mengenali target/hasil; apakah momen besar berkesan; apakah setelah beberapa duel mereka ingin melewati efek.

## Sumber

- https://eu-support.konami.com/hc/en-gb/articles/9659823107479-Yu-Gi-Oh-Duel-Links-General-Information
- https://corporate.pokemon.co.jp/en/topics/detail/t-28/
- https://www.konami.com/games/us/en/topics/1888/
- https://playruneterra.com/en-us/news/patch-0-9-0-notes
- https://playruneterra.com/en-us/news/state-of-the-beta/
- https://playruneterra.com/en-us/news/game-updates/patch-5-10-notes
- https://hearthstone.blizzard.com/en-gb/news/22552047/developer-insights-the-art-behind-the-science
- https://www.reddit.com/r/masterduel/comments/1gbxth1
- https://www.reddit.com/r/LegendsOfRuneterra/comments/1l0lo2u
- https://www.reddit.com/r/LegendsOfRuneterra/comments/1d8t18b/are_there_any_plans_for_a_speed_up_2x_3x_function/
- https://docs.godotengine.org/en/stable/classes/class_tween.html
- https://docs.godotengine.org/en/stable/tutorials/shaders/screen-reading_shaders.html

## Hasil pencarian skill

Skill komunitas, bukan paket resmi Godot. Statistik berikut adalah tampilan direktori ketika diperiksa dan bisa berubah. Belum ada instalasi.

- godot-animation dari gamedev-skills/awesome-gamedev-agent-skills: direktori menampilkan 10,5K instalasi dan 8,0K stars repository; relevan untuk AnimationPlayer dan Tween. https://www.skills.sh/gamedev-skills/awesome-gamedev-agent-skills/godot-animation
- godot-gdscript-patterns dari wshobson/agents: direktori menampilkan 18,2K instalasi dan 42,3K stars repository; relevan untuk struktur, signal dan performa, bukan penentu kualitas artistik. https://www.skills.sh/wshobson/agents/godot-gdscript-patterns

Popularitas bukan jaminan kebenaran. API harus dicocokkan dengan dokumentasi Godot dan versi proyek. Pencarian CLI tidak memberikan hasil pada sesi ini; temuan di atas diperoleh dari direktori web dan halaman repository.
