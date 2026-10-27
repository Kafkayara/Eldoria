# Aset Eldoria 0.3

## Ilustrasi

Metode: **imagegen bawaan**, bukan CLI/API terpisah.

Berkas proyek: `assets/art/eldoria_atlas.png` (1536×1024).
Lokasi tersimpan: `C:\Users\Kafka\Documents\anime-card-duel\assets\art\eldoria_atlas.png`.

Atlas dibaca langsung sebagai grid tiga kolom dan dua baris oleh Godot. Ilustrasi tidak dipotong atau diubah menjadi enam berkas bitmap. Sejak versi 0.5, atlas dipakai oleh enam jenis kartu dengan enam sel berbeda. Aegis Surya, Peri Astral, Berkah Fajar, dan Retakan Langit memakai gambar individual. Seluruh 10 jenis kartu kini memiliki ilustrasi berbeda. Rincian empat gambar baru dan prompt final tersedia di V05_ILLUSTRATIONS.md dan folder prompts/.

Prompt final:

> Create a single production game-art texture ATLAS for an original anime fantasy card duel game called Eldoria. Landscape canvas, exactly 3 equal-width columns and 2 equal-height rows, all SIX rectangular cells fill their own area edge-to-edge without borders, padding, gaps, labels, UI, text or watermarks. This is a texture atlas sampled as a precise 3x2 grid by the game engine, so keep boundaries exactly at thirds of width and half of height. Premium hand-painted Japanese fantasy trading-card illustration, intricate cinematic lighting, crisp silhouettes legible at thumbnail sizes, consistent art direction. TOP LEFT: Dawn Guardian, handsome silver-haired anime knight in white and gold armor, radiant sword, rising sun and ancient city, turquoise accents. TOP MIDDLE: Ember Wyvern, majestic original crimson and obsidian dragon with gold horns breathing a sweeping arc of fire, volcanic sky. TOP RIGHT: Moon Oracle, silver-haired ethereal anime sorceress in indigo robes, crescent staff, glowing moon, violet star magic. BOTTOM LEFT: Verdant Fenrir, powerful original emerald wolf spirit with luminous jade antlers amid enchanted forest mist, dynamic pose. BOTTOM MIDDLE: Aether Tempest, dramatic blue lightning spiral erupting from an arcane crystal, dynamic spell illustration with cyan and purple energy. BOTTOM RIGHT: Solar Sanctuary, magnificent golden crystal floating above white stone temple, radiant protective rings, warm healing light. All six compositions centered on their own cells, important subject not crossing grid boundaries. No existing franchise characters or logos.

## Audio

Berkas proyek: `assets/audio/`.
Lokasi tersimpan: `C:\Users\Kafka\Documents\anime-card-duel\assets\audio\`.

- `astral_theme.wav`: loop stereo 24 detik, pad harmonik Am–F–C–G dan arpeggio.
- `click.wav`, `draw.wav`: bunyi UI singkat.
- `summon.wav`, `attack.wav`, `spell.wav`, `heal.wav`: efek aksi.
- `win.wav`, `lose.wav`: fanfare hasil duel.

Semua audio disintesis dari gelombang sinus, envelope, harmonik, dan noise deterministik pada 22050 Hz, PCM 16-bit. Tidak ada suara karakter atau rekaman franchise lain. Musik dapat dimatikan lewat tombol Audio.

Sumber pembuat audio yang dapat dijalankan ulang ada di `tools/generate_audio.py`.


## Gerhana (versi 0.8)

Atlas orisinal baru dibuat dengan tool imagegen bawaan dan disimpan di `C:/Users/Kafka/Documents/anime-card-duel/assets/art/gerhana_atlas.png`. Grid 4 kolom × 2 baris dipakai langsung oleh Godot: Penjaga Senja, Burung Hantu Perak, Penyihir Cermin, Naga Noctis, Cermin Pembalasan, Segel Hening, Belenggu Spektral, Jam Pasir Astral. Kartu lama tidak diganti. Total koleksi sekarang 18 ilustrasi berbeda. Prompt final lengkap ada di `assets/prompts/gerhana_atlas.txt`; tidak memakai CLI atau API key.


## Musik Astral Drive (versi 0.10)

Komposisi orisinal proyek, dibuat dengan `tools/generate_duel_score.py` tanpa rekaman atau sampel game lain. `first_light_battle.wav` dan `first_light_urgency.wav` adalah dua stem stereo 44,1 kHz 16-bit, masing-masing 32 bar pada 144 BPM (53,33 detik). Metadata teknis ada di `first_light_score.json`. File ambient lama dipertahankan sebagai aset historis; runtime memakai komposisi baru.

Aksen baru: `ace_summon.wav`, `heavy_impact.wav`, `trap_reveal.wav`, seluruhnya sintesis orisinal dari generator yang sama. Preview 20 detik tersedia di output chat.


## Jejak Fajar (versi 0.11, musik runtime saat ini)

`path_of_dawn.ogg` dan `path_of_dawn_strings.ogg` menggantikan Astral Drive sebagai musik runtime. Komposisi orisinal berdurasi 160 detik, 96 BPM, D minor, 64 bar. Menggunakan instrumen berbasis sampel GeneralUser GS 2.0.3 oleh S. Christian Collins, dirender dengan FluidSynth 2.6.1. Lisensi penuh tersedia di `assets/audio/GeneralUser-LICENSE.txt`; sumber: https://github.com/mrbumpy409/GeneralUser-GS dan https://www.schristiancollins.com/ . Musik tidak memakai melodi atau rekaman anime lain.

Source komposisi dan renderer: `tools/compose_anime_score.py`. Metadata audio terdekode ada di `path_of_dawn_score.json`. SoundFont dan binary renderer hanya digunakan sebagai alat pengembangan lokal, tidak dibundel di runtime. Aksen SFX versi sebelumnya tetap digunakan.


## v0.14 — Tombak Surya dan Selubung Gerhana

Dua ilustrasi orisinal dibuat dengan built-in image_gen: assets/art/tombak_surya.png dan assets/art/selubung_gerhana.png. Prompt final disimpan pada assets/art/deck_identity_prompts.json. Ilustrasi dipakai sebagai tekstur penuh yang berbeda untuk masing-masing kartu; tidak mengganti gambar kartu lain. Visual cast dan simbolnya digambar dengan kode Godot.


## v0.16 — Buku I

Latar dapur, jendela, lampu, dan mangkuk biru untuk Jendela yang Menghadap Pagi dibuat dengan built-in image_gen. Aset: assets/story/window_morning.png. Prompt final: assets/story/image_prompt.json. Dipakai sebagai latar mode cerita; tidak menggantikan ilustrasi kartu atau menambah kartu/deck.


## v0.17 — Rimba

Lima ilustrasi orisinal dibuat dengan built-in image_gen: assets/art/grove.png, stag.png, verdant.png, renewal.png, dan compost.png. Prompt lengkap tersedia pada assets/art/rimba_image_prompts.json. Masing-masing kartu memakai sumber gambar berbeda. Simbol/VFX dibuat dengan kode; latar Buku II menggunakan ilustrasi Lingkar Musim.
