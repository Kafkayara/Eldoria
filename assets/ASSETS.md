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
