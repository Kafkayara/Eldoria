extends RefCounted
const BOOK_ID = "akar_esok"
const TITLE = "Kebun untuk yang Pulang"
const BOOK_NUMBER = "II"
const SCRIPT_REVISION = 2
const PREMISE = "Aren dan Nyx mengantar benih kepada Sera. Bantu ia membangun jalan kebun sambil mengenal ayahnya, Banyu, dan deck Rimba."
const BACKGROUND = "res://assets/vn/backgrounds/garden.png"
const SCENE_CARDS = ["grove", "renewal", "verdant"]
const CHOICES = {"seed": ["save", "share"], "route": ["slow", "together"]}
const CHAPTERS = [
	{
		"id": "seed",
		"title": "Benih di Lipatan Kain",
		"place": "Jalan kebun di utara Eldoria",
		"opponent": "Sera",
		"player_deck": "fajar",
		"enemy_deck": "rimba",
		"difficulty": "normal",
		"focus": "Rimba memulihkan ALAM dari Grave. Batas normal summon tetap satu; manfaatkan tekanan Fajar.",
		"memory": "Sera mempertahankan jalan kebun karena ayahnya, Banyu, belum kembali setelah banjir. Mengembalikan sesuatu tidak harus menghapus bekas perubahannya.",
		"intro": [
			{
				"speaker": "Narasi",
				"text": "Beberapa pekan setelah Suaka dimatikan, Aren dan Nyx mengantar kantong benih titipan Rana ke kebun utara.",
				"bg": "garden",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.seed.intro.000"
			},
			{
				"speaker": "Aren",
				"text": "Untuk Banyu dan putrinya, Sera. Dulu Banyu mengirim sayur ke dapur Kakak.",
				"bg": "garden",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.intro.001"
			},
			{
				"speaker": "Nyx",
				"text": "Rana menitipkan pesan juga?",
				"bg": "garden",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "akar_esok.seed.intro.002"
			},
			{
				"speaker": "Aren",
				"text": "Katanya, mereka tidak perlu mengirim hasil panen kalau kebunnya belum siap. Kita hanya mengantar ini.",
				"bg": "garden",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.intro.003"
			},
			{
				"speaker": "Narasi",
				"text": "Di ujung jalan, seorang perempuan mengangkat tunas dari sela batu. Sera mengibaskan tanah dari sarung tangannya ketika melihat mereka.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.seed.intro.004"
			},
			{
				"speaker": "Sera",
				"text": "Kalian yang membawa benih? Taruh di bangku. Jangan di tanah, masih basah.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.intro.005"
			},
			{
				"speaker": "Aren",
				"text": "Kau Sera? Aku Aren. Ini Nyx. Rana yang menyuruh kami mengantar.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.intro.006"
			},
			{
				"speaker": "Sera",
				"text": "Aku sudah menunggu kantong itu. Ayah menyimpannya sebelum banjir.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.intro.007"
			},
			{
				"speaker": "Aren",
				"text": "Banyu belum kembali?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.intro.008"
			},
			{
				"speaker": "Sera",
				"text": "Dia tinggal di kota seberang. Tangannya cedera. Aku ingin kebun ini rapi sebelum menjemputnya.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.intro.009"
			},
			{
				"speaker": "Narasi",
				"text": "Hampir semua petak belum ditanami, tetapi jalan menuju rumah sudah disapu berkali-kali.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.seed.intro.010"
			},
			{
				"speaker": "Aren",
				"text": "Apa yang bisa kami bantu?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.intro.011"
			},
			{
				"speaker": "Sera",
				"text": "Jembatannya. Akar penjaga mengunci aksesnya. Bantu buka jalan setapak dulu. Gerobak belum boleh lewat sampai papan dan talinya diperbaiki.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.intro.012"
			},
			{
				"speaker": "Aren",
				"text": "Dengan duel kartu?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.intro.013"
			},
			{
				"speaker": "Sera",
				"text": "Ya. Kau pegang Fajar. Aku tahan akarnya dengan Rimba. Kalau gagal, jalurnya menutup lagi. Fondasinya tetap aman.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.intro.014"
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Jalan setapak menuju kebun terbuka. Di sisi lain, papan jembatan yang rusak masih ditandai tali. Sera merapikan kartu yang kembali ke tangannya.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.seed.win.000"
			},
			{
				"speaker": "Sera",
				"text": "Pemulihan Rimba mengembalikan monster ke tangan. Aku tetap harus menunggu giliran untuk memanggilnya lagi.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.win.001"
			},
			{
				"speaker": "Aren",
				"text": "Kau sudah membersihkan jalan sampai ke rumah. Kenapa petak kebunnya belum ditanami?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.win.002"
			},
			{
				"speaker": "Sera",
				"text": "Aku selalu mengerjakan jalan itu dulu. Ayah biasa pulang lewat sana.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.win.003"
			},
			{
				"speaker": "Aren",
				"text": "Kau sudah bilang dia boleh datang sebelum semuanya selesai?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.win.004"
			},
			{
				"speaker": "Sera",
				"text": "Belum. Aku pikir... seharusnya aku bisa menyiapkan tempatnya dulu.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.win.005"
			}
		],
		"loss": [
			{
				"speaker": "Sera",
				"text": "Jalurnya menutup. Akar di bawah masih menahan fondasi.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.loss.000"
			},
			{
				"speaker": "Aren",
				"text": "Kita coba lagi?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.seed.loss.001"
			},
			{
				"speaker": "Sera",
				"text": "Bisa. Minum dulu. Aku juga perlu mengistirahatkan tangan.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.seed.loss.002"
			}
		],
		"goal": "Antarkan benih titipan Rana kepada Sera dan buka jalur pejalan kaki menuju kebunnya.",
		"why_duel": "Akar penjaga mengunci akses jembatan. Fajar membuka jalan setapak sementara Rimba menjaga fondasi. Jembatan belum aman untuk gerobak."
	},
	{
		"id": "soil",
		"title": "Tanah yang Tidak Sama",
		"place": "Saluran air di bawah kebun",
		"opponent": "Penjaga Saluran",
		"player_deck": "rimba",
		"enemy_deck": "gerhana",
		"difficulty": "normal",
		"focus": "Pakai Rimba: pulihkan Fenrir atau Penjaga Tunas, lalu tribute saat siap. Isi Grave membantu naga.",
		"memory": "Banyu masih hidup, tetapi tangannya tidak bisa bekerja seperti dulu. Ia menawarkan pengetahuan tentang air, bukan janji untuk kembali menjadi orang yang sama.",
		"intro": [
			{
				"speaker": "Narasi",
				"text": "Esoknya, Banyu datang dengan gerobak kecil. Ayah Sera itu membawa papan gambar; pergelangan tangan kirinya masih dibalut.",
				"bg": "garden",
				"cast": [
					"aren",
					"banyu"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.soil.intro.000"
			},
			{
				"speaker": "Banyu",
				"text": "Aren? Aku mengenali pin di mantelmu. Dulu Liora yang memakainya.",
				"bg": "garden",
				"cast": [
					"aren",
					"banyu"
				],
				"focus": "banyu",
				"thought": false,
				"id": "akar_esok.soil.intro.001"
			},
			{
				"speaker": "Aren",
				"text": "Iya. Rana menitipkan benih untuk kalian. Sera sudah menyimpannya.",
				"bg": "garden",
				"cast": [
					"aren",
					"banyu"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.soil.intro.002"
			},
			{
				"speaker": "Sera",
				"text": "Ayah datang lebih awal. Aku belum selesai membetulkan pagar.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.soil.intro.003"
			},
			{
				"speaker": "Banyu",
				"text": "Aku datang karena kau mengundangku. Pagarnya bisa menunggu.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "banyu",
				"thought": false,
				"id": "akar_esok.soil.intro.004"
			},
			{
				"speaker": "Sera",
				"text": "Aku bawakan cangkul. Yang ringan.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.soil.intro.005"
			},
			{
				"speaker": "Banyu",
				"text": "Tolong pakai untukmu dulu. Tanganku belum kuat menggali. Aku bisa menggambar jalur airnya.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "banyu",
				"thought": false,
				"id": "akar_esok.soil.intro.006"
			},
			{
				"speaker": "Sera",
				"text": "Kalau jembatan dan rumahnya sudah pulih, Ayah bisa tinggal di sini lagi.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.soil.intro.007"
			},
			{
				"speaker": "Banyu",
				"text": "Sera, aku belum siap tinggal dekat sungai itu. Bukan karena pekerjaanmu kurang baik.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "banyu",
				"thought": false,
				"id": "akar_esok.soil.intro.008"
			},
			{
				"speaker": "Narasi",
				"text": "Sera meletakkan cangkul di samping bangku. Ia membuka kantong benih, tetapi tidak langsung menuangkannya.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.soil.intro.009"
			},
			{
				"speaker": "Aren",
				"text": "Tanah keringnya cukup untuk satu petak. Kita mulai dari mana?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.soil.intro.010"
			},
			{
				"speaker": "Narasi",
				"text": "Apa langkah pertamamu untuk benih itu?",
				"choice": "seed",
				"options": [
					{
						"value": "save",
						"text": "Tanam benih keluarga di petak yang sudah siap."
					},
					{
						"value": "share",
						"text": "Bagikan sebagian benih ke petak milik tetangga."
					}
				],
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"id": "akar_esok.soil.intro.011",
				"thought": false
			},
			{
				"speaker": "Sera",
				"text": "Baik. Pinjam Rimba-ku. Aku bantu Ayah membaca arah airnya.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.soil.intro.012"
			},
			{
				"speaker": "Aren",
				"text": "Siapa Penjaga Saluran yang tertulis di papan itu?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.soil.intro.013"
			},
			{
				"speaker": "Sera",
				"text": "Bukan orang. Itu nama pengaman lama. Susunan Gerhana menahan pintu air sampai jalurnya aman. Buka dengan Rimba, pelan-pelan.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.soil.intro.014"
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Air mencapai petak pertama tanpa mengikis tepinya. Banyu menggeser papan gambarnya agar Sera bisa melihat bagian yang ia ubah.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.soil.win.000"
			},
			{
				"speaker": "Sera",
				"text": "Alurnya berbeda dari gambar lama.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.soil.win.001"
			},
			{
				"speaker": "Banyu",
				"text": "Dasar sungainya sudah berubah. Kalau dipaksa ke jalur lama, petak ini kebanjiran lagi.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "banyu",
				"thought": false,
				"id": "akar_esok.soil.win.002"
			},
			{
				"speaker": "Sera",
				"text": "Aku juga terus mencoba membuat tempat ini sama seperti sebelum banjir.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.soil.win.003"
			},
			{
				"speaker": "Banyu",
				"text": "Beri aku bangku di dekat petak itu. Aku bisa datang duduk dan memeriksa air. Untuk sekarang, itu cukup.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "banyu",
				"thought": false,
				"id": "akar_esok.soil.win.004"
			},
			{
				"speaker": "Narasi",
				"text": "Sera menandai tempat bangku di gambar. Kali ini ia menulis nama Banyu di sana, bukan daftar pekerjaan untuknya.",
				"bg": "garden",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.soil.win.005"
			}
		],
		"loss": [
			{
				"speaker": "Sera",
				"text": "Salurannya belum terbuka. Jangan memulihkan semua kartu sebelum memanggil naga; bonusnya dihitung dari ALAM yang masih di Grave.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.soil.loss.000"
			},
			{
				"speaker": "Banyu",
				"text": "Ada bagian gambarku yang kurang jelas juga. Kita periksa bersama sebelum mengulang.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "banyu",
				"thought": false,
				"id": "akar_esok.soil.loss.001"
			}
		],
		"goal": "Bantu Banyu dan Sera mengaktifkan saluran air untuk petak tanam pertama.",
		"why_duel": "Penjaga Saluran adalah susunan pengaman aether, bukan orang baru. Pola Gerhana-nya harus dibuka agar air tidak menggerus tanah."
	},
	{
		"id": "bridge",
		"title": "Jembatan untuk Esok",
		"place": "Jembatan akar di atas sungai",
		"opponent": "Sera",
		"player_deck": "rimba",
		"enemy_deck": "rimba",
		"difficulty": "normal",
		"focus": "Bonus naga dihitung sekali saat summon. Setelah itu, pulihkan kartu untuk menyiapkan giliran berikutnya.",
		"memory": "Jembatan dibuka dengan pekerjaan bersama. Sera menjaga kebunnya tanpa menuntut ayahnya memulihkan hidup yang persis sama.",
		"intro": [
			{
				"speaker": "Narasi",
				"text": "Papan baru ditumpuk di dekat jembatan. Sera membawa daftar pekerjaan. Namanya tertulis di hampir setiap baris.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.bridge.intro.000"
			},
			{
				"speaker": "Aren",
				"text": "Bagian mana yang boleh kukerjakan?",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.bridge.intro.001"
			},
			{
				"speaker": "Sera",
				"text": "Aku perlu memeriksa tali, fondasi, papan...",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.bridge.intro.002"
			},
			{
				"speaker": "Aren",
				"text": "Aku tanya bagian untukku, Sera.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.bridge.intro.003"
			},
			{
				"speaker": "Sera",
				"text": "Oh. Maaf. Aku terbiasa memeriksa semuanya sendiri.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.bridge.intro.004"
			},
			{
				"speaker": "Nyx",
				"text": "Aku bisa memeriksa tali bersama Banyu. Dia sudah menggambar simpul yang perlu diganti.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "nyx",
				"thought": false,
				"id": "akar_esok.bridge.intro.005"
			},
			{
				"speaker": "Narasi",
				"text": "Sera mengambil penghapus. Beberapa baris di daftarnya akhirnya kosong.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.bridge.intro.006"
			},
			{
				"speaker": "Narasi",
				"text": "Bagaimana kamu menawarkan bantuan kepada Sera?",
				"choice": "route",
				"options": [
					{
						"value": "slow",
						"text": "Kita selesaikan satu bagian dulu, lalu istirahat bersama."
					},
					{
						"value": "together",
						"text": "Bagi pekerjaannya. Percayakan satu bagian pada kami."
					}
				],
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"id": "akar_esok.bridge.intro.007",
				"thought": false
			},
			{
				"speaker": "Sera",
				"text": "Baik. Kau pegang Rimba di sisi jalan. Aku menahan akar di sisi kebun.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.bridge.intro.008"
			},
			{
				"speaker": "Aren",
				"text": "Bonus naga dihitung saat summon, kan? Setelah itu aku bisa memulihkan kartu tanpa mengurangi bonusnya.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "aren",
				"thought": false,
				"id": "akar_esok.bridge.intro.009"
			},
			{
				"speaker": "Sera",
				"text": "Betul. Siapkan giliran berikutnya juga. Kalau ada akar yang lepas, kita punya kartu untuk menyambungnya lagi.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.bridge.intro.010"
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Papan terakhir terpasang. Akar penjaga merentang ke sisi sungai yang baru, sementara orang-orang menyingkirkan serpihan dari jalan.",
				"bg": "garden_restored",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.bridge.win.000"
			},
			{
				"speaker": "Sera",
				"text": "Aku kira Ayah baru mau datang kalau aku sudah memperbaiki semuanya.",
				"bg": "garden_restored",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.bridge.win.001"
			},
			{
				"speaker": "Banyu",
				"text": "Kau hanya perlu bilang aku boleh datang. Bangku yang catnya belum kering juga boleh.",
				"bg": "garden_restored",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "banyu",
				"thought": false,
				"id": "akar_esok.bridge.win.002"
			},
			{
				"speaker": "Sera",
				"text": "Kalau begitu jangan duduk dulu. Aku benar-benar baru mengecatnya.",
				"bg": "garden_restored",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.bridge.win.003"
			},
			{
				"speaker": "Narasi",
				"text": "Banyu tertawa. Sera meletakkan cangkul, lalu mencari kain untuk menutup bangku.",
				"bg": "garden_restored",
				"cast": [
					"sera",
					"banyu"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.bridge.win.004"
			}
		],
		"loss": [
			{
				"speaker": "Sera",
				"text": "Fondasinya masih aman. Kita periksa lagi dari dua sisi.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "sera",
				"thought": false,
				"id": "akar_esok.bridge.loss.000"
			},
			{
				"speaker": "Narasi",
				"text": "Sera menunggu Nyx selesai melaporkan bagian talinya. Ia tidak lagi berlari memeriksa semua bagian sebelum orang lain sempat menjawab.",
				"bg": "garden",
				"cast": [
					"aren",
					"sera"
				],
				"focus": "",
				"thought": false,
				"id": "akar_esok.bridge.loss.001"
			}
		],
		"goal": "Perbaiki papan dan tali jembatan, lalu atur akar penopangnya agar gerobak hasil panen bisa lewat.",
		"why_duel": "Dua susunan Rimba bekerja dari sisi berlawanan: satu menahan fondasi dan satu membuka jalur. Sera tidak lagi mengerjakannya sendirian."
	}
]
const ENDING = [
	{
		"speaker": "Narasi",
		"text": "Petak keluarga tumbuh lebih dulu. Sera menuliskan tanggal tanam, lalu menyimpan benih sisanya untuk petak yang belum siap.",
		"variant": "seed",
		"variants": {
			"save": "Petak keluarga tumbuh lebih dulu. Sera menuliskan tanggal tanam, lalu menyimpan benih sisanya untuk petak yang belum siap.",
			"share": "Tetangga membawa pot dan wadah yang berbeda-beda. Saat melewati rumah mereka, Sera mengenali daun yang sama dengan yang tumbuh di kebunnya."
		},
		"bg": "garden_restored",
		"cast": [
			"aren",
			"sera"
		],
		"focus": "",
		"id": "akar_esok.ending.000"
	},
	{
		"speaker": "Narasi",
		"text": "Sore itu Sera berhenti bekerja ketika cahaya mencapai bangku. Pekerjaannya belum selesai. Ia tetap duduk bersama ayahnya.",
		"variant": "route",
		"variants": {
			"slow": "Sore itu Sera berhenti bekerja ketika cahaya mencapai bangku. Pekerjaannya belum selesai. Ia tetap duduk bersama ayahnya.",
			"together": "Daftar pekerjaan ditempel dekat jembatan. Ada nama Aren, Nyx, Banyu, dan beberapa tetangga. Sera tidak mengisi kembali ruang kosong dengan namanya sendiri."
		},
		"bg": "garden_restored",
		"cast": [
			"sera",
			"banyu"
		],
		"focus": "",
		"id": "akar_esok.ending.001"
	},
	{
		"speaker": "Narasi",
		"text": "Banyu tetap tinggal di kota seberang. Dua kali seminggu ia datang memeriksa air dan duduk di bangku. Sera mulai menanyakan kabarnya sebelum menanyakan kapan ia akan pulang.",
		"bg": "garden_restored",
		"cast": [
			"sera",
			"banyu"
		],
		"focus": "",
		"thought": false,
		"id": "akar_esok.ending.002"
	},
	{
		"speaker": "Sera",
		"text": "Ini daun sup untuk Rana. Belum banyak. Tolong bilang tidak perlu menunggu kiriman berikutnya.",
		"bg": "garden_restored",
		"cast": [
			"aren",
			"sera"
		],
		"focus": "sera",
		"thought": false,
		"id": "akar_esok.ending.003"
	},
	{
		"speaker": "Aren",
		"text": "Akan kusampaikan. Deck Rimba-nya juga kukembalikan.",
		"bg": "garden_restored",
		"cast": [
			"aren",
			"sera"
		],
		"focus": "aren",
		"thought": false,
		"id": "akar_esok.ending.004"
	},
	{
		"speaker": "Sera",
		"text": "Bawa saja dulu. Kalian masih akan membantu warga lain, kan? Aku punya susunan cadangan.",
		"bg": "garden_restored",
		"cast": [
			"aren",
			"sera"
		],
		"focus": "sera",
		"thought": false,
		"id": "akar_esok.ending.005"
	},
	{
		"speaker": "Nyx",
		"text": "Kami akan menjaganya.",
		"bg": "garden_restored",
		"cast": [
			"aren",
			"sera"
		],
		"focus": "nyx",
		"thought": false,
		"id": "akar_esok.ending.006"
	},
	{
		"speaker": "Aren",
		"text": "Kutulis namamu di kantongnya. Rana pasti senang mendapat kabar darimu.",
		"bg": "garden_restored",
		"cast": [
			"aren",
			"sera"
		],
		"focus": "aren",
		"thought": false,
		"id": "akar_esok.ending.007"
	}
]
