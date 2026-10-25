# Eldoria v0.10 — Astral Drive

Peningkatan visual dan musik duel telah dipasang ke proyek Godot lokal. Jalankan ulang lewat F8 → Reload jika diminta → F5.

- Glow berlapis, portal summon, partikel pengisian, gelombang benturan, dan serpihan untuk monster yang dihancurkan.
- Naga Bara dan Naga Noctis mendapat sorotan ilustrasi singkat pada summon pertama masing-masing per pihak per duel. Mode Ringkas melewatinya.
- Burung Hantu Perak memakai sapuan bulu, Penyihir Cermin pecahan cermin, Noctis aliran gerhana, dan Jam Pasir lintasan waktu. Identitas kartu dan tiga trap dipertahankan.
- Ilustrasi bereaksi halus pada hover, sementara tulisan tetap diam.
- Musik orisinal First Light / Astral Drive: 144 BPM, E minor, 32 bar, loop 53,33 detik dengan dua lapisan tersinkron. Lapisan tambahan masuk pada Battle Phase dan lebih kuat pada LP rendah.
- Pengatur BGM terpisah dari efek suara; nilainya tersimpan lokal. Audio OFF menjeda kedua lapisan.
- Summon monster andalan, benturan besar, dan trap mendapat aksen suara baru.

## Dasar riset

[Hearthstone — Developer Insights: The Art Behind THE SCIENCE](https://hearthstone.blizzard.com/en-gb/news/22552047/developer-insights-the-art-behind-the-science): efek memperjelas informasi papan, mempertahankan identitas kartu, serta merayakan momen besar tanpa membebani semua aksi.

[Yu-Gi-Oh! Duel Links — General Information](https://eu-support.konami.com/hc/en-gb/articles/9659823107479-Yu-Gi-Oh-Duel-Links-General-Information): monster andalan memperoleh presentasi visual khusus. Implementasi Eldoria memakai ilustrasi 2D yang telah tersedia.

[Marvel — Inside the Art of MARVEL SNAP](https://www.marvel.com/articles/games/inside-the-art-of-marvel-snap): kombinasi ilustrasi, efek kedalaman, dan animasi membuat kartu terasa hidup. Eldoria mengambil prinsip lapisan gerak tersebut, bukan mengklaim memiliki model monster 3D.

Musik dikomposisi khusus dari instrumen sintetis dan drum buatan proyek. Tidak memakai rekaman, sampel, atau melodi soundtrack game lain.


## Implementasi dan batas presentasi

`effects.gd` mempertahankan batas delapan event dan waktu benturan semula. Lapisan glow menggunakan CanvasItemMaterial additive pada renderer Compatibility, sedangkan garis/bentuk inti tetap pada lapisan terpisah. Kedua lapisan berhenti menggambar efek saat antrean habis dan menghormati panel modal. Mode Ringkas menampilkan simbol identitas singkat tanpa glow, gerak ilustrasi, atau cut-in.

`ace_cutin.gd` menampilkan ilustrasi dengan gerak terpisah dari teks selama 1,05 detik. Input normal dan AI menunggu jendela ini selesai, lalu input aktif kembali. Satu kombinasi pihak/kartu hanya diputar sekali per duel, dan reset membersihkan status serta node presentasi. Layar panduan/detail/menu tetap berada di depan secara visual.

`tools/generate_duel_score.py` menyintesis dua stem stereo 44,1 kHz 16-bit dengan panjang sama: 2.352.000 frame. Aransemen memiliki intro, bagian utama, bridge, dan lapisan akhir; delay sirkular mempertahankan ekor pada batas loop. Metadata peak/RMS ada di assets/audio/first_light_score.json. Batas loop diperiksa pada data PCM aktual; tidak ada sampel yang mencapai clipping digital.

Director musik menyalakan kedua stem bersama, mengatur fade volume 0,7 detik saat konteks berubah, dan menjaga lapisan urgensi tetap berjalan senyap agar tidak memulai frasa baru saat LP berubah. Menu lebih tenang; Battle Phase menambah arpeggio/perkusi, LP <=1500 menambah intensitas. Slider BGM 0 membuat kedua stem senyap tanpa mengubah efek suara, dan tombol Audio menjeda keduanya.

Perubahan ini menargetkan kepuasan aksi dan keterbacaan, bukan menjanjikan durasi bermain atau retensi tertentu tanpa playtest. Aturan kartu serta pembatasan dua deck bawaan tidak diubah pada versi ini.

## Verifikasi

Tes presentasi native memeriksa cut-in satu kali, pemulihan input, mode Ringkas, occlusion, kedua stream audio, sinkronisasi stem, mute, slider, simpan volume, dan idle renderer. Tes VFX menggambar 18 profil pada berbagai fase, sedangkan tes trap memeriksa antrean, respons, LP, kemenangan, dan restart. Tes aturan menjalankan 240 duel campuran pada tiga kesulitan.
