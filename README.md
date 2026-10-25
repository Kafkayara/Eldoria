# Eldoria

Prototipe game duel kartu 2D yang dibuat dengan **Godot 4.7**, dengan target awal Windows/PC.

## Menjalankan proyek

1. Clone repository ini atau unduh ZIP lalu ekstrak.
2. Buka Godot 4.7, pilih **Import**, lalu pilih file `project.godot`.
3. Buka proyek dan tekan **F5**.

## Fitur saat ini

- Tiga zona monster pemain dan tiga zona monster lawan.
- Tampilan LP awal 4.000 untuk masing-masing pemain.
- Kartu contoh **Penjaga Fajar**, dengan ATK 1600 dan DEF 1200.
- Klik kartu untuk melihat detail, lalu klik zona pemain untuk summon.
- Tombol **Ulang Latihan** untuk mengembalikan kondisi awal.

Prototipe ini belum mencakup pergantian giliran, pertarungan, AI, atau multiplayer.

## Berkas utama

- `main.tscn`: papan duel dan antarmuka.
- `main.gd`: pemilihan kartu, isi zona pemain, dan latihan summon.
- `card.tscn`: scene kartu yang dapat digunakan kembali.
- `card.gd`: data dan signal pemilihan kartu.

## Menyimpan perubahan ke GitHub

Simpan scene dan script di Godot, lalu gunakan GitHub Desktop untuk meninjau perubahan, membuat commit, dan memilih **Push origin**.

Folder cache Godot, cadangan lokal, dan hasil build dikecualikan melalui `.gitignore`. File `.uid` dan `.import` tetap disertakan.
