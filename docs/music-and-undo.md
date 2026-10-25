# Eldoria v0.11 — Jejak Fajar & Undo

## Musik

Komposisi orisinal Jejak Fajar / Path of Dawn berdurasi penuh 2 menit 40 detik, 96 BPM, 64 bar. Aransemen memakai seruling/shakuhachi, senar, cello, koto, piano, dan taiko yang lebih renggang. Ada pembukaan, tema, bagian reflektif, pengembangan, dan kembali ke pembukaan; bagian akhir tidak fade-out ke hening. Kedua loop diputar tersinkron dan lapisan tambahan dibuat lebih pelan daripada versi sebelumnya.

Instrumen dirender dari sampel GeneralUser GS 2.0.3 oleh S. Christian Collins memakai FluidSynth 2.6.1. Ini komposisi baru untuk Eldoria, bukan rekaman atau melodi Naruto. Kredit dan lisensi instrumen disertakan dalam proyek. Runtime hanya memerlukan berkas Ogg yang sudah dirender; pemain tidak perlu memasang perender atau SoundFont.

Versi penuh dapat didengar melalui eldoria-jejak-fajar-full.wav atau eldoria-jejak-fajar-full.ogg. Pratinjau loop 16 detik memperdengarkan delapan detik terakhir yang disambung dengan delapan detik pertama.

## Undo

Gunakan tombol UNDO di panel kanan atau Ctrl+Z. Setiap tekan memulihkan satu langkah pemain beserta akibatnya: kartu, urutan deck, hasil draw, tribute, zona monster/spell/trap, LP, perisai, skill, dan respons lawan. Respons pemain pada gilirannya sendiri juga dapat dikembalikan ke jendela keputusan sebelumnya.

Undo boleh digunakan saat animasi atau respons Nyx masih tertunda. Callback lama dibatalkan supaya LP, animasi, atau layar hasil tidak muncul lagi setelah keadaan dipulihkan. Undo juga tersedia pada layar hasil jika aksi penentu terjadi pada giliran pemain yang belum ditutup.

Setelah Akhiri Giliran ditekan, riwayat giliran itu dikunci dan dikosongkan. Undo tidak dapat melewati giliran lawan. Urutan kartu dan keadaan acak dipulihkan, sehingga pengulangan langkah tidak mengacak ulang hasil draw.

Cara memuat: F8 → Reload jika diminta → F5.

Kredit instrumen: https://github.com/mrbumpy409/GeneralUser-GS/blob/main/documentation/LICENSE.txt
Perender: https://www.fluidsynth.org/


## Detail teknis

Snapshot undo dibentuk hanya sebelum aksi pemain yang sudah lulus validasi. Snapshot mencakup seluruh state model di SNAPSHOT_FIELDS serta seed/state RNG, dan dibatasi 64 entri per giliran. Aksi bot tidak membuat checkpoint pemain. Respons pemain pada giliran sendiri dapat menyimpan snapshot rantai parsial; prioritas dan hitungan pass ikut dipulihkan. End turn yang ditolak saat rantai tertunda tidak menghapus riwayat; end turn yang berhasil selalu menghapusnya.

UI menyimpan riwayat log, kartu yang diperiksa, status presentasi ace, dan mode summon pada checkpoint yang sama. Saat undo, nomor sesi dinaikkan untuk membatalkan coroutine AI, damage tertunda, presentasi trap, cut-in, dan kemenangan. Tween LP dibatalkan dan counter disetel langsung ke LP hasil pemulihan. Undo tidak menyimpan profil musik atau pilihan deck karena keduanya bukan akibat langkah duel.

Komposisi ditulis sebagai MIDI orisinal dengan tiga siklus render untuk menghangatkan ekor reverb; siklus tengah diambil tepat 7.056.000 frame pada 44,1 kHz. Loop utama dan lapisan strings mempunyai panjang identik, lalu diekspor ke Ogg Vorbis. Tidak ada fade-out hening; transisi mikro pada batas sampel mencegah putusnya gelombang. Metadata decode berada di assets/audio/path_of_dawn_score.json. Kedua stem diuji melewati batas loop dalam Godot, bukan hanya memeriksa durasi file.

SoundFont dan executable renderer tidak dimasukkan ke runtime atau repositori game. Lisensi instrumen berada di assets/audio/GeneralUser-LICENSE.txt. Source yang dapat dirender ulang: tools/compose_anime_score.py. Source dan file musik versi terdahulu dipertahankan sebagai riwayat pengembangan, tetapi tidak digunakan oleh runtime versi ini.

## Pengujian

- tests/test_undo.gd: 70 pemeriksaan, termasuk snapshot penuh, draw deterministik, tribute, skill, shield, summon Sentinel, menang/kalah, rantai respons, dan batas akhir giliran.
- tests/test_undo_ui.gd: klik mouse nyata, Ctrl+Z, batalkan respons AI tertunda, cut-in, tween LP, undo pada layar hasil, dan pemutaran kedua stem melintasi titik loop.
- tests/test_presentation.gd dan pengujian duel/trap lama tetap dijalankan untuk memastikan kompatibilitas.
