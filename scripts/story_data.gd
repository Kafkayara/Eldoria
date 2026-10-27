extends RefCounted
const BOOK_ID = "jendela_pagi"
const TITLE = "Jendela yang Menghadap Pagi"
const BOOK_NUMBER = "I"
const SCRIPT_REVISION = 2
const PREMISE = "Aren pulang karena surat Nyx. Kenali orang-orang yang ditinggalkannya dan cari cara menghentikan Suaka tanpa melukai warga."
const BACKGROUND = "res://assets/vn/backgrounds/kitchen_night.png"
const SCENE_CARDS = ["sanctuary", "hourglass", "mirror", "lunar_veil", "blessing"]
const CHOICES = {"memory": ["care", "laughter"], "reply": ["honest", "uncertain"], "ritual": ["lamp", "table"]}
const CHAPTERS = [
	{
		"id": "lamp",
		"title": "Lampu yang Belum Padam",
		"place": "Dapur di gerbang timur",
		"opponent": "Rana",
		"player_deck": "fajar",
		"enemy_deck": "fajar",
		"difficulty": "easy",
		"focus": "Pegang kembali kartu Fajar. Bangun papan sebelum memanggil naga.",
		"memory": "Mangkuk biru diperbaiki. Bukan supaya retaknya hilang, tetapi supaya bisa dipakai lagi.",
		"intro": [
			{
				"speaker": "Narasi",
				"text": "Tiga tahun setelah Malam Retak, Aren kembali ke rumahnya di Eldoria. Mantelnya basah. Dari jendela dapur, cahaya lampu jatuh ke jalan.",
				"bg": "kitchen_night",
				"cast": [
					"aren"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.000"
			},
			{
				"speaker": "Aren",
				"text": "Nyx, aku sudah pulang. Sekarang jelaskan kenapa suratmu cuma berbunyi: Ren, aku butuh bantuan.",
				"bg": "kitchen_night",
				"cast": [
					"aren"
				],
				"focus": "aren",
				"thought": true,
				"id": "jendela_pagi.lamp.intro.001"
			},
			{
				"speaker": "Narasi",
				"text": "Aren biasanya mengantar barang antarkota. Selama tiga tahun ia selalu menemukan pekerjaan baru sebelum sempat pulang. Kali ini ia tidak mengambil kiriman berikutnya.",
				"bg": "kitchen_night",
				"cast": [
					"aren"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.002"
			},
			{
				"speaker": "Rana",
				"text": "Aren? Berdiri di sana tidak akan membuat bajumu kering. Masuk.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.003"
			},
			{
				"speaker": "Aren",
				"text": "Bibi Rana. Kau masih menjaga rumah ini?",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.004"
			},
			{
				"speaker": "Rana",
				"text": "Tentu. Lalu siapa yang akan mengusir bocah-bocah dari kebunmu? Sepatunya lepas dulu. Aku baru mengepel.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.005"
			},
			{
				"speaker": "Narasi",
				"text": "Rana adalah tetangga lama keluarga Aren dan penjaga gerbang timur. Selama Aren merantau, dialah yang merawat rumah peninggalan Liora.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.006"
			},
			{
				"speaker": "Aren",
				"text": "Aku menerima surat Nyx. Dia tidak ada di rumahnya.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.007"
			},
			{
				"speaker": "Rana",
				"text": "Dia di Suaka. Menara penyimpan rekaman dekat observatorium. Sekarang dia teknisi di sana.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.008"
			},
			{
				"speaker": "Aren",
				"text": "Nyx yang dulu bahkan tidak bisa membetulkan engsel lemari?",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.009"
			},
			{
				"speaker": "Rana",
				"text": "Engsel itu kau yang merusaknya. Dia cuma ikut disalahkan.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.010"
			},
			{
				"speaker": "Aren",
				"text": "...Iya. Benar.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.011"
			},
			{
				"speaker": "Rana",
				"text": "Duduk dulu. Ada sesuatu tentang menara itu yang perlu kau dengar.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.012"
			},
			{
				"speaker": "Aren",
				"text": "Apa yang terjadi?",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.013"
			},
			{
				"speaker": "Rana",
				"text": "Orang-orang mendengar suara Liora dari sana. Nyx memutarnya hampir setiap malam.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.014"
			},
			{
				"speaker": "Aren",
				"text": "Kakakku meninggal saat Malam Retak. Aku ikut menguburkannya. Mendengar namanya disebut seperti ini tetap membuatku ingin menoleh ke pintu.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": true,
				"id": "jendela_pagi.lamp.intro.015"
			},
			{
				"speaker": "Liora",
				"text": "Aren, tasnya jangan di meja makan. Nyx juga mau duduk di situ.",
				"bg": "kitchen_day",
				"cast": [
					"aren",
					"liora"
				],
				"focus": "liora",
				"thought": false,
				"context": "Kenangan Aren • Sebelum Malam Retak",
				"id": "jendela_pagi.lamp.intro.016"
			},
			{
				"speaker": "Aren",
				"text": "Aku cuma mau mengambil roti.",
				"bg": "kitchen_day",
				"cast": [
					"aren",
					"liora"
				],
				"focus": "aren",
				"thought": false,
				"context": "Kenangan Aren • Sebelum Malam Retak",
				"id": "jendela_pagi.lamp.intro.017"
			},
			{
				"speaker": "Liora",
				"text": "Kalau begitu cuci tangan. Mengambil roti juga pakai tangan, kan?",
				"bg": "kitchen_day",
				"cast": [
					"aren",
					"liora"
				],
				"focus": "liora",
				"thought": false,
				"context": "Kenangan Aren • Sebelum Malam Retak",
				"id": "jendela_pagi.lamp.intro.018"
			},
			{
				"speaker": "Narasi",
				"text": "Rana meletakkan mangkuk biru di depan Aren. Retak di tepinya kini tersambung oleh garis emas.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.019"
			},
			{
				"speaker": "Aren",
				"text": "Kakak belum sempat memperbaiki mangkuk ini.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.020"
			},
			{
				"speaker": "Rana",
				"text": "Aku yang membetulkannya. Tidak sebagus pekerjaan Liora. Masih agak miring kalau diletakkan di meja.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.021"
			},
			{
				"speaker": "Aren",
				"text": "Tidak apa-apa. Terima kasih.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.022"
			},
			{
				"speaker": "Rana",
				"text": "Besok temui Iria di arsip. Dia tahu keadaan Suaka. Jangan langsung masuk menara tanpa bicara dengannya.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.023"
			},
			{
				"speaker": "Aren",
				"text": "Lalu sekarang?",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.024"
			},
			{
				"speaker": "Rana",
				"text": "Sekarang habiskan supmu. Setelah itu, latihan kartu denganku. Aku perlu tahu kau masih bisa menjaga dirimu.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.025"
			},
			{
				"speaker": "Narasi",
				"text": "Rana mengeluarkan deck Fajar milik Liora. Duel latihan ini tidak melukai mereka; LP hanya menunjukkan kekuatan susunan kartu. Aren merapikan kartunya dan duduk berhadapan dengan Rana.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.lamp.intro.026"
			}
		],
		"win": [
			{
				"speaker": "Rana",
				"text": "Lumayan. Kau masih suka menyerang sebelum membaca kartu lawan.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.win.000"
			},
			{
				"speaker": "Aren",
				"text": "Aku dulu juga begitu?",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.win.001"
			},
			{
				"speaker": "Rana",
				"text": "Lebih parah. Liora harus menyuruhmu duduk lagi setiap kali kau merasa sudah menang.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.win.002"
			},
			{
				"speaker": "Narasi",
				"text": "Rana memasukkan serbet bersih ke tas Aren. Di ujungnya ada jahitan matahari dengan satu sinar terlalu pendek.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.lamp.win.003"
			},
			{
				"speaker": "Aren",
				"text": "Ini buatan Kakak.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.win.004"
			},
			{
				"speaker": "Rana",
				"text": "Ya. Bawa ke menara. Nyx mungkin belum makan sejak kemarin. Dan kali ini, pulanglah untuk makan malam.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.win.005"
			}
		],
		"loss": [
			{
				"speaker": "Rana",
				"text": "Kartu latihanmu jatuh, bukan harga dirimu. Ambil dulu. Kita coba pelan-pelan.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.loss.000"
			},
			{
				"speaker": "Aren",
				"text": "Aku sudah lupa banyak.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.lamp.loss.001"
			},
			{
				"speaker": "Rana",
				"text": "Makanya kita latihan di dapur. Aku tidak mengirimmu ke menara dengan tangan gemetar seperti itu.",
				"bg": "kitchen_night",
				"cast": [
					"aren",
					"rana"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.lamp.loss.002"
			}
		],
		"goal": "Temui Nyx untuk mengetahui mengapa ia meminta Aren pulang. Berlatih dengan Rana sebelum memasuki menara.",
		"why_duel": "Ini latihan aman untuk mengingat penggunaan kartu Fajar. LP mengukur kekuatan susunan kartu, bukan nyawa pemain."
	},
	{
		"id": "names",
		"title": "Nama yang Tinggal Separuh",
		"place": "Arsip di bawah observatorium",
		"opponent": "Iria",
		"player_deck": "fajar",
		"enemy_deck": "gerhana",
		"difficulty": "normal",
		"focus": "Sisakan satu zona untuk spell. Siapkan Segel sebelum menghadapi trap.",
		"memory": "Suara yang disimpan Suaka hanyalah rekaman. Menyalakannya menghabiskan ingatan kecil orang-orang di sekitarnya.",
		"intro": [
			{
				"speaker": "Narasi",
				"text": "Keesokan paginya, Aren tiba di arsip observatorium. Iria, arsiparis Eldoria, menunggunya dengan buku laporan terbuka.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.names.intro.000"
			},
			{
				"speaker": "Iria",
				"text": "Rana bilang kau akan datang. Kau Aren, adik Liora?",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.001"
			},
			{
				"speaker": "Aren",
				"text": "Ya. Aku ingin menemui Nyx. Aku dengar dia menyimpan suara kakakku.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.intro.002"
			},
			{
				"speaker": "Iria",
				"text": "Benar. Suaka merekam kejadian lewat aether. Seperti menyimpan gambar dan suara, bukan menyimpan orangnya.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.003"
			},
			{
				"speaker": "Aren",
				"text": "Jadi itu bukan Liora.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.intro.004"
			},
			{
				"speaker": "Iria",
				"text": "Itu rekaman Liora saat ia masih hidup. Rekamannya tidak bisa menjawab pertanyaan baru.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.005"
			},
			{
				"speaker": "Narasi",
				"text": "Iria menggeser buku laporan. Nama Rana tertulis di halaman pertama.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.names.intro.006"
			},
			{
				"speaker": "Iria",
				"text": "Alat itu sudah rusak. Nyx menahannya tetap hidup. Akibatnya Suaka terus mengambil tenaga dari kenangan warga di sekitarnya.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.007"
			},
			{
				"speaker": "Aren",
				"text": "Mengambil kenangan?",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.intro.008"
			},
			{
				"speaker": "Iria",
				"text": "Rana ingat wajah Liora, tetapi tidak lagi ingat takaran sup yang mereka buat bersama. Ada warga yang lupa lagu yang selalu dinyanyikan ibunya. Laporannya bertambah.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.009"
			},
			{
				"speaker": "Aren",
				"text": "Dan pagi yang katanya tidak datang?",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.intro.010"
			},
			{
				"speaker": "Iria",
				"text": "Waktunya berjalan biasa. Selubung Suaka menyerap cahaya untuk menjaga rekamannya. Jadi rumah-rumah dekat menara tetap remang meski matahari sudah terbit.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.011"
			},
			{
				"speaker": "Aren",
				"text": "Nyx tahu?",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.intro.012"
			},
			{
				"speaker": "Iria",
				"text": "Aku sudah memperingatkannya. Dia menutup akses ke inti alat. Surat untukmu itu pertama kalinya dia meminta bantuan sejak itu.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.013"
			},
			{
				"speaker": "Aren",
				"text": "Kenapa kau tidak memutus tenaganya saja?",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.intro.014"
			},
			{
				"speaker": "Iria",
				"text": "Aether yang tertahan bisa meluap ke permukiman. Kita perlu membuka pengamannya bertahap. Aku menyimpan petunjuknya di arsip tersegel.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.015"
			},
			{
				"speaker": "Aren",
				"text": "Apa yang harus kulakukan?",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.intro.016"
			},
			{
				"speaker": "Iria",
				"text": "Bantu aku membuka susunan Gerhana di pintu arsip. Tapi tulis satu kenanganmu tentang Liora dulu. Kita jangan hanya menyisakan rekaman di menara.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.intro.017"
			},
			{
				"speaker": "Narasi",
				"text": "Kenangan mana yang ingin kamu tulis tentang Liora?",
				"choice": "memory",
				"options": [
					{
						"value": "care",
						"text": "Dia selalu menyisihkan roti paling empuk untuk kami."
					},
					{
						"value": "laughter",
						"text": "Dia menertawakan jahitan mataharinya sendiri."
					}
				],
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"id": "jendela_pagi.names.intro.018",
				"thought": false
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Aren menulis tentang roti yang diam-diam dipindahkan Liora ke piringnya. Ia berhenti, lalu menambahkan: Liora juga selalu menyuruhku mencuci tangan.",
				"variant": "memory",
				"variants": {
					"care": "Aren menulis tentang roti yang diam-diam dipindahkan Liora ke piringnya. Ia berhenti, lalu menambahkan: Liora juga selalu menyuruhku mencuci tangan.",
					"laughter": "Aren menggambar matahari dengan satu sinar pendek. Ia menulis bahwa Liora menolak memperbaikinya: mataharinya sedang mengantuk, katanya."
				},
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "",
				"id": "jendela_pagi.names.win.000"
			},
			{
				"speaker": "Iria",
				"text": "Pintu arsipnya terbuka. Ini petunjuk pengamannya. Berikan pada Nyx. Dia akan tahu bagian mana yang belum dilepas.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.win.001"
			},
			{
				"speaker": "Narasi",
				"text": "Di dalam map ada selembar kertas lain: daftar belanja Liora, diselamatkan dari meja kerjanya.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.names.win.002"
			},
			{
				"speaker": "Aren",
				"text": "Obat, benang, beras... Dia masih menyusun pekerjaan untuk besok.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.win.003"
			},
			{
				"speaker": "Iria",
				"text": "Simpan. Menara itu hanya merekam sebagian kecil hidupnya. Ini juga bagian dari dia.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.win.004"
			},
			{
				"speaker": "Aren",
				"text": "Aku akan menemui Nyx. Kalau dia tetap menolak?",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.win.005"
			},
			{
				"speaker": "Iria",
				"text": "Dengarkan dulu apa yang ia takutkan. Lalu ingatkan dia bahwa rumah-rumah di bawah menara juga masih dihuni orang.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.win.006"
			}
		],
		"loss": [
			{
				"speaker": "Iria",
				"text": "Susunannya belum terbuka. Aether di dalam masih aman.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.loss.000"
			},
			{
				"speaker": "Aren",
				"text": "Aku terlalu cepat menghabiskan kartu.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.names.loss.001"
			},
			{
				"speaker": "Iria",
				"text": "Perhatikan zona tertutupku. Kau boleh menunggu sebelum memilih serangan berikutnya. Kita coba lagi.",
				"bg": "archive",
				"cast": [
					"aren",
					"iria"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.names.loss.002"
			}
		],
		"goal": "Cari tahu apa yang rusak di Suaka dan ambil catatan yang diperlukan untuk masuk menara.",
		"why_duel": "Pintu arsip aether dipasangi susunan Gerhana. Aren membuka pengamannya sementara Iria menjaga aliran rekaman tetap stabil."
	},
	{
		"id": "nineteen",
		"title": "Sembilan Belas Detik",
		"place": "Tangga menara Suaka",
		"opponent": "Nyx",
		"player_deck": "fajar",
		"enemy_deck": "gerhana",
		"difficulty": "normal",
		"focus": "Perisai tidak mencegah kerusakan LP. Cermin dan Belenggu dapat mengubah hasil serangan.",
		"memory": "Nyx mempertahankan sembilan belas detik sarapan biasa karena takut tak lagi dapat mengingat suara Liora.",
		"intro": [
			{
				"speaker": "Narasi",
				"text": "Di ruang Suaka, kristal kecil menyala di tengah lingkaran logam. Nyx duduk di lantai dengan buku catatan di lutut.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.000"
			},
			{
				"speaker": "Nyx",
				"text": "Ren. Kau benar-benar pulang.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.001"
			},
			{
				"speaker": "Aren",
				"text": "Kau memintaku pulang. Aku menunggu penjelasan.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.002"
			},
			{
				"speaker": "Nyx",
				"text": "Sebentar. Rekamannya hampir selesai.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.003"
			},
			{
				"speaker": "Narasi",
				"text": "Terdengar sendok menyentuh cangkir. Lalu suara Liora dari kristal.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.004"
			},
			{
				"speaker": "Rekaman Liora",
				"text": "Aren sudah makan? Nyx, ambil rotinya. Jangan tunggu disuruh dua kali.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "liora",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.005",
				"context": "Rekaman Liora / Dibuat sebelum Malam Retak"
			},
			{
				"speaker": "Narasi",
				"text": "Kristal meredup. Setelah hening sejenak, bunyi sendok yang sama terdengar lagi.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.006"
			},
			{
				"speaker": "Nyx",
				"text": "Sembilan belas detik. Sarapan biasa, setahun sebelum Malam Retak. Itu yang masih bisa kuselamatkan.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.007"
			},
			{
				"speaker": "Aren",
				"text": "Iria sudah menjelaskan cara kerja alat ini. Dia juga menunjukkan laporan warga.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.008"
			},
			{
				"speaker": "Nyx",
				"text": "Aku membacanya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.009"
			},
			{
				"speaker": "Aren",
				"text": "Lalu kenapa kau tetap menyalakannya?",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.010"
			},
			{
				"speaker": "Nyx",
				"text": "Aku mencoba mematikannya sekali. Aku berusaha mengingat suara Liora sendiri, tapi... aku tidak yakin lagi mana suaranya, mana yang kubayangkan.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.011"
			},
			{
				"speaker": "Nyx",
				"text": "Aku tahu ini merugikan orang lain. Aku terus bilang: satu malam lagi. Lalu malam berikutnya aku bilang begitu lagi.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.012"
			},
			{
				"speaker": "Aren",
				"text": "Rana sudah kehilangan sesuatu tentang Kakak. Kau tidak bisa mengambil kenangan orang lain untuk menjaga milikmu.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.013"
			},
			{
				"speaker": "Nyx",
				"text": "Aku tahu. Itu sebabnya aku mengirim surat. Tapi sekarang kau di sini, aku tetap belum sanggup menyentuh tuasnya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.014"
			},
			{
				"speaker": "Narasi",
				"text": "Apa yang ingin kamu katakan kepada Nyx?",
				"choice": "reply",
				"options": [
					{
						"value": "honest",
						"text": "Aku marah, Nyx. Tapi aku tidak akan pergi begitu saja."
					},
					{
						"value": "uncertain",
						"text": "Aku juga takut lupa. Kita cari caranya bersama."
					}
				],
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"id": "jendela_pagi.nineteen.intro.015",
				"thought": false
			},
			{
				"speaker": "Nyx",
				"text": "Baik. Kita mulai dari pengaman luar. Aku tahan arusnya dengan Gerhana. Buka jalurnya pakai Fajar.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.016"
			},
			{
				"speaker": "Aren",
				"text": "Kalau susunanku gagal?",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.017"
			},
			{
				"speaker": "Nyx",
				"text": "Pengamannya menutup lagi. Kita bisa mengulang. Yang penting jangan mencabut kristalnya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.018"
			},
			{
				"speaker": "Narasi",
				"text": "Aren meletakkan petunjuk Iria di lantai. Untuk pertama kalinya malam itu, Nyx menggeser buku catatannya dan memberi tempat untuknya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.nineteen.intro.019"
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Pengaman luar terbuka. Rekaman berhenti di tengah bunyi cangkir. Nyx menahan napas, menunggu kalimat yang biasanya menyusul.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.000"
			},
			{
				"speaker": "Nyx",
				"text": "Dia tidak pernah menjawabku, ya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.001"
			},
			{
				"speaker": "Aren",
				"text": "Rekamannya memang tidak bisa.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.002"
			},
			{
				"speaker": "Nyx",
				"text": "Aku menanyakan hal yang sama berkali-kali, meskipun aku tahu jawabannya akan tetap sama.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.003"
			},
			{
				"speaker": "Aren",
				"text": "Tanya padaku. Aku mungkin tidak tahu jawabannya, tapi aku bisa mendengarnya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.004"
			},
			{
				"speaker": "Nyx",
				"text": "Ada satu rekaman latihan Liora untukmu. Aku belum berani membukanya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.005"
			},
			{
				"speaker": "Aren",
				"text": "Kenapa?",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.006"
			},
			{
				"speaker": "Nyx",
				"text": "Aku tidak ingin kau mengira dia menunggu di dalam alat ini.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.007"
			},
			{
				"speaker": "Aren",
				"text": "Aku mengerti. Tunjukkan. Aku ingin ingat hal lain tentang dia, bukan cuma bagaimana dia meninggal.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.win.008"
			}
		],
		"loss": [
			{
				"speaker": "Nyx",
				"text": "Pengaman menutup lagi. Tidak ada yang pecah.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.loss.000"
			},
			{
				"speaker": "Aren",
				"text": "Kau kelihatan lebih lega daripada aku.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.loss.001"
			},
			{
				"speaker": "Nyx",
				"text": "Aku... belum siap tadi. Kita berhenti sebentar, lalu coba lagi. Kau tetap di sini?",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.nineteen.loss.002"
			},
			{
				"speaker": "Aren",
				"text": "Iya. Geser sedikit. Aku juga ingin duduk.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.nineteen.loss.003"
			}
		],
		"goal": "Temui Nyx, dengarkan alasannya, dan buka pengaman luar Suaka tanpa merusak rekaman di dalam.",
		"why_duel": "Nyx menjaga pengaman dengan Gerhana; Aren memakai Fajar untuk membuka jalurnya. Kemenangan membuka akses, bukan menentukan hidup-mati Nyx."
	},
	{
		"id": "hands",
		"title": "Tangan yang Menahan",
		"place": "Ruang rekaman latihan",
		"opponent": "Rekaman Liora",
		"player_deck": "gerhana",
		"enemy_deck": "fajar",
		"difficulty": "normal",
		"focus": "Di bab ini kamu memakai Gerhana. Bertahan, siapkan trap, lalu cari waktu untuk membalas.",
		"memory": "Aren menerima Gerhana dari Nyx. Kartu pertahanan juga pernah menjadi cara Liora mengajarkan kepedulian.",
		"intro": [
			{
				"speaker": "Nyx",
				"text": "Ini Gerhana-ku. Pinjam dulu. Rekaman latihannya memakai Fajar.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.intro.000"
			},
			{
				"speaker": "Aren",
				"text": "Kakak memang suka menyuruhku menahan serangan sebelum boleh membalas.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.intro.001"
			},
			{
				"speaker": "Nyx",
				"text": "Kau selalu bilang bertahan itu membosankan.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.intro.002"
			},
			{
				"speaker": "Aren",
				"text": "Aku sembilan belas tahun dan merasa sudah tahu semuanya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.intro.003"
			},
			{
				"speaker": "Nyx",
				"text": "Ya. Menyebalkan sekali.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.intro.004"
			},
			{
				"speaker": "Narasi",
				"text": "Aren tertawa pendek. Nyx ikut tersenyum, lalu menunduk untuk memasang kristal latihan.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.hands.intro.005"
			},
			{
				"speaker": "Nyx",
				"text": "Pola ini akan menjalankan duel yang dulu ia siapkan. Suaranya juga sudah direkam. Dia tidak bisa melihat kita sekarang.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.intro.006"
			},
			{
				"speaker": "Aren",
				"text": "Aku tahu. Mulai saja.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.intro.007"
			},
			{
				"speaker": "Rekaman Liora",
				"text": "Kalau bingung, jangan asal menyerang. Baca dulu. Aku tidak sedang mengejarmu.",
				"bg": "tower",
				"cast": [
					"aren",
					"liora"
				],
				"focus": "liora",
				"thought": false,
				"context": "Rekaman latihan • Liora semasa hidup",
				"id": "jendela_pagi.hands.intro.008"
			},
			{
				"speaker": "Aren",
				"text": "Persis seperti dulu. Bahkan nada kesalnya juga sama.",
				"bg": "tower",
				"cast": [
					"aren",
					"liora"
				],
				"focus": "aren",
				"thought": true,
				"context": "Rekaman latihan • Liora semasa hidup",
				"id": "jendela_pagi.hands.intro.009"
			}
		],
		"win": [
			{
				"speaker": "Rekaman Liora",
				"text": "Nah. Sekarang giliranmu menjaga.",
				"bg": "tower",
				"cast": [
					"aren",
					"liora"
				],
				"focus": "liora",
				"thought": false,
				"context": "Rekaman latihan berakhir",
				"id": "jendela_pagi.hands.win.000"
			},
			{
				"speaker": "Narasi",
				"text": "Rekaman berakhir di sana. Tidak ada sapaan baru atau jawaban untuk tiga tahun yang telah lewat.",
				"bg": "tower",
				"cast": [
					"aren",
					"liora"
				],
				"focus": "",
				"thought": false,
				"context": "Rekaman latihan berakhir",
				"id": "jendela_pagi.hands.win.001"
			},
			{
				"speaker": "Aren",
				"text": "Aku hampir lupa dia sering kesal kalau aku tidak membaca kartu.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.win.002"
			},
			{
				"speaker": "Nyx",
				"text": "Orang-orang sekarang hanya bercerita tentang keberaniannya di Malam Retak.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.win.003"
			},
			{
				"speaker": "Aren",
				"text": "Kau bersamanya malam itu. Apa yang sebenarnya terjadi?",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.win.004"
			},
			{
				"speaker": "Nyx",
				"text": "Ada anak-anak terjebak di dapur umum. Liora mau menjemput mereka. Aku bilang tangganya belum aman.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.win.005"
			},
			{
				"speaker": "Nyx",
				"text": "Dia bilang dia juga takut. Lalu dia meminta aku menjaga jalan keluar. Aku terus memikirkan apa yang terjadi kalau aku menahannya lebih lama.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.win.006"
			},
			{
				"speaker": "Aren",
				"text": "Aku sering menyalahkan diriku karena waktu itu sedang bekerja di luar kota. Kita sama-sama mencari bagian yang bisa diubah, ya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.win.007"
			},
			{
				"speaker": "Narasi",
				"text": "Aren membuka daftar belanja dari Iria. Nyx menunjuk satu catatan di bawah daftar obat.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.hands.win.008"
			},
			{
				"speaker": "Nyx",
				"text": "Jangan pakai panci kecil kalau Nyx datang. Ia selalu bilang sudah makan.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.win.009"
			},
			{
				"speaker": "Aren",
				"text": "Kau memang selalu bilang begitu.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.win.010"
			},
			{
				"speaker": "Nyx",
				"text": "Karena aku malu datang terus. Padahal aku lapar. Dia tahu.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.win.011"
			},
			{
				"speaker": "Aren",
				"text": "Yang ini bisa kita simpan tanpa menyalakan Suaka. Kertasnya ada. Kita juga masih ingat.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.win.012"
			}
		],
		"loss": [
			{
				"speaker": "Nyx",
				"text": "Latihannya bisa dimatikan dulu.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.loss.000"
			},
			{
				"speaker": "Aren",
				"text": "Tidak perlu. Aku ingin mencoba lagi. Aku baru mulai ingat cara Kakak bermain.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.hands.loss.001"
			},
			{
				"speaker": "Nyx",
				"text": "Baik. Perhatikan kapan perlu memasang trap. Aku bantu menjelaskan kalau kau mau.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.hands.loss.002"
			}
		],
		"goal": "Buka rekaman latihan Liora dan lihat kembali bagaimana ia mengajari Aren menjaga orang lain.",
		"why_duel": "Lawan ini adalah pola latihan yang direkam, bukan arwah Liora. Aren meminjam Gerhana dari Nyx untuk menghadapi susunan Fajar lama."
	},
	{
		"id": "morning",
		"title": "Jendela yang Menghadap Pagi",
		"place": "Puncak menara, menjelang fajar",
		"opponent": "Nyx",
		"player_deck": "fajar",
		"enemy_deck": "gerhana",
		"difficulty": "normal",
		"focus": "Fajar membuka jalan; Gerhana menahan tekanan. Gunakan penguatan dan respons dengan sabar.",
		"memory": "Aren dan Nyx membuka Suaka bersama. Suara berhenti, tetapi tulisan, cerita, dan hubungan mereka tetap ada.",
		"intro": [
			{
				"speaker": "Narasi",
				"text": "Menjelang fajar, Iria tiba membawa petunjuk pelepasan inti. Rana menyusul dengan termos dan roti.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.morning.intro.000"
			},
			{
				"speaker": "Iria",
				"text": "Pengaman luar sudah terbuka. Tinggal inti. Jalur Fajar harus dibuka sambil arusnya ditahan susunan Gerhana.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.morning.intro.001"
			},
			{
				"speaker": "Nyx",
				"text": "Aku pegang Gerhana. Aren, kau buka jalurnya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.morning.intro.002"
			},
			{
				"speaker": "Aren",
				"text": "Kau yakin?",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.morning.intro.003"
			},
			{
				"speaker": "Nyx",
				"text": "Tidak sepenuhnya. Tapi aku ingin berhenti mengambil kenangan orang lain.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.morning.intro.004"
			},
			{
				"speaker": "Iria",
				"text": "Aku akan mengawasi alatnya. Kalau susunan kalian gagal, pengaman menutup dan kita ulangi. Jangan memaksa tuasnya.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.morning.intro.005"
			},
			{
				"speaker": "Rana",
				"text": "Dan jangan menahan napas terus. Kalian berdua pucat sekali.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.morning.intro.006"
			},
			{
				"speaker": "Aren",
				"text": "Sesudah ini kita makan di rumah, Nyx.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.morning.intro.007"
			},
			{
				"speaker": "Nyx",
				"text": "Aku mungkin masih akan meminta kau menunggu sebentar.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.morning.intro.008"
			},
			{
				"speaker": "Aren",
				"text": "Aku bisa menunggu. Tapi Suaka tetap kita matikan.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.morning.intro.009"
			},
			{
				"speaker": "Narasi",
				"text": "Nyx mengangguk. Ia menutup buku catatannya, lalu meletakkan Gerhana di hadapannya. Aren mengeluarkan Fajar.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.morning.intro.010"
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Arus terakhir mengalir keluar dari inti. Nyx menahan susunannya sampai Iria memberi isyarat. Cahaya kristal padam.",
				"bg": "tower_dawn",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.morning.win.000"
			},
			{
				"speaker": "Nyx",
				"text": "Aku masih ingin mendengar suaranya sekali lagi.",
				"bg": "tower_dawn",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.morning.win.001"
			},
			{
				"speaker": "Aren",
				"text": "Aku tahu.",
				"bg": "tower_dawn",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.morning.win.002"
			},
			{
				"speaker": "Narasi",
				"text": "Mereka tetap duduk beberapa saat. Kali ini bunyi cangkir tidak kembali. Dari bawah menara terdengar pedagang membuka tirai tokonya.",
				"bg": "tower_dawn",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "",
				"thought": false,
				"id": "jendela_pagi.morning.win.003"
			},
			{
				"speaker": "Nyx",
				"text": "Aku harus menemui Rana dan warga yang melapor ke arsip. Aku belum tahu harus bilang apa.",
				"bg": "tower_dawn",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.morning.win.004"
			},
			{
				"speaker": "Aren",
				"text": "Mulai dengan mengatakan yang sebenarnya.",
				"bg": "tower_dawn",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.morning.win.005"
			},
			{
				"speaker": "Nyx",
				"text": "Temani aku besok? Setelah itu... mungkin aku masih ingin datang ke menara.",
				"bg": "tower_dawn",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.morning.win.006"
			},
			{
				"speaker": "Aren",
				"text": "Iya. Kita bawa sarapan.",
				"bg": "tower_dawn",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "aren",
				"thought": false,
				"id": "jendela_pagi.morning.win.007"
			}
		],
		"loss": [
			{
				"speaker": "Iria",
				"text": "Pengaman menutup. Arusnya masih tertahan dengan aman.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "iria",
				"thought": false,
				"id": "jendela_pagi.morning.loss.000"
			},
			{
				"speaker": "Nyx",
				"text": "Aku menahannya terlalu kuat. Bukan hanya salahmu, Ren.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "nyx",
				"thought": false,
				"id": "jendela_pagi.morning.loss.001"
			},
			{
				"speaker": "Rana",
				"text": "Minum dulu. Petunjuknya bisa kalian baca lagi sesudah tangan kalian berhenti gemetar.",
				"bg": "tower",
				"cast": [
					"aren",
					"nyx"
				],
				"focus": "rana",
				"thought": false,
				"id": "jendela_pagi.morning.loss.002"
			}
		],
		"goal": "Buka inti Suaka dengan aman agar menara berhenti mengambil tenaga dari lingkungan.",
		"why_duel": "Fajar membuka jalur pelepasan, Gerhana menahan arus. Duel ini menata dua susunan kartu untuk mematikan mesin secara bertahap."
	}
]
const ENDING = [
	{
		"speaker": "Narasi",
		"text": "Beberapa hari kemudian, Rana mencoba takaran sup baru. Sebagian kenangan yang diambil Suaka belum kembali.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"rana"
		],
		"focus": "",
		"thought": false,
		"id": "jendela_pagi.ending.000"
	},
	{
		"speaker": "Rana",
		"text": "Terlalu asin?",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"rana"
		],
		"focus": "rana",
		"thought": false,
		"id": "jendela_pagi.ending.001"
	},
	{
		"speaker": "Aren",
		"text": "Sedikit.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"rana"
		],
		"focus": "aren",
		"thought": false,
		"id": "jendela_pagi.ending.002"
	},
	{
		"speaker": "Rana",
		"text": "Nyx bilang pas. Rupanya dia masih takut mengkritik makanan di rumah ini.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"rana"
		],
		"focus": "rana",
		"thought": false,
		"id": "jendela_pagi.ending.003"
	},
	{
		"speaker": "Narasi",
		"text": "Nyx membantu Iria mencatat laporan warga. Ada orang yang belum mau berbicara dengannya. Ia tidak meminta Aren membelanya.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "",
		"thought": false,
		"id": "jendela_pagi.ending.004"
	},
	{
		"speaker": "Nyx",
		"text": "Boleh aku membantu di sini juga? Aku tidak ingin terus menunggu di menara.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "nyx",
		"thought": false,
		"id": "jendela_pagi.ending.005"
	},
	{
		"speaker": "Aren",
		"text": "Kita mulai dari sesuatu yang bisa kita lakukan setiap minggu.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "aren",
		"thought": false,
		"id": "jendela_pagi.ending.006"
	},
	{
		"speaker": "Narasi",
		"text": "Kegiatan apa yang ingin kalian mulai bersama?",
		"choice": "ritual",
		"options": [
			{
				"value": "lamp",
				"text": "Nyalakan lampu untuk orang yang pulang terlambat."
			},
			{
				"value": "table",
				"text": "Buka dapur untuk tetangga seminggu sekali."
			}
		],
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "aren",
		"id": "jendela_pagi.ending.007",
		"thought": false
	},
	{
		"speaker": "Narasi",
		"text": "Malam berikutnya, Rana melihat lampu dapur dari gerbang. Ia mampir setelah selesai berjaga. Nyx membukakan pintu sebelum ia perlu mengetuk lagi.",
		"variant": "ritual",
		"variants": {
			"lamp": "Malam berikutnya, Rana melihat lampu dapur dari gerbang. Ia mampir setelah selesai berjaga. Nyx membukakan pintu sebelum ia perlu mengetuk lagi.",
			"table": "Pada hari pertama dapur dibuka, Rana membawa sayur. Nyx menambah air ke panci ketika tetangga berikutnya datang. Aren mengambil mangkuk tambahan."
		},
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "",
		"id": "jendela_pagi.ending.008"
	},
	{
		"speaker": "Narasi",
		"text": "Aren menyisihkan bagian roti yang empuk. Ia membagikannya, lalu mengambil satu untuk dirinya sendiri.",
		"variant": "memory",
		"variants": {
			"care": "Aren menyisihkan bagian roti yang empuk. Ia membagikannya, lalu mengambil satu untuk dirinya sendiri.",
			"laughter": "Nyx menjahit lap baru. Mataharinya punya satu sinar yang terlalu pendek. Aren tertawa saat melihatnya; kali ini tidak ada yang mencoba memperbaikinya."
		},
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "",
		"id": "jendela_pagi.ending.009"
	},
	{
		"speaker": "Narasi",
		"text": "Kadang Aren masih marah ketika membaca halaman laporan yang belum lengkap. Nyx tetap datang membantu. Mereka tidak memaksa percakapan itu cepat selesai.",
		"variant": "reply",
		"variants": {
			"honest": "Kadang Aren masih marah ketika membaca halaman laporan yang belum lengkap. Nyx tetap datang membantu. Mereka tidak memaksa percakapan itu cepat selesai.",
			"uncertain": "Kadang Nyx masih duduk lama di depan pintu sebelum masuk. Aren menaruh dua cangkir di ambang, lalu duduk di sebelahnya."
		},
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "",
		"id": "jendela_pagi.ending.010"
	},
	{
		"speaker": "Narasi",
		"text": "Mangkuk biru dipakai lagi. Daftar belanja Liora disimpan di laci, bersama resep baru dan tagihan yang belum dibayar.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "",
		"thought": false,
		"id": "jendela_pagi.ending.011"
	},
	{
		"speaker": "Nyx",
		"text": "Ren. Aku belum makan.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "nyx",
		"thought": false,
		"id": "jendela_pagi.ending.012"
	},
	{
		"speaker": "Aren",
		"text": "Bagus. Aku juga belum. Ambil panci besar, ya.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "aren",
		"thought": false,
		"id": "jendela_pagi.ending.013"
	},
	{
		"speaker": "Narasi",
		"text": "Nyx menarik kursinya. Kali ini ia tidak mengatakan hanya akan meminjam buku sebentar.",
		"bg": "kitchen_day",
		"cast": [
			"aren",
			"nyx"
		],
		"focus": "",
		"thought": false,
		"id": "jendela_pagi.ending.014"
	}
]
