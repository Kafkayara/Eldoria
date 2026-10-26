extends RefCounted

const BOOK_ID = "jendela_pagi"
const TITLE = "Jendela yang Menghadap Pagi"
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
				"text": "Tiga tahun setelah Malam Retak, Aren pulang dengan sepatu yang kemasukan air. Di sepanjang jalan, toko-toko sudah tutup. Hanya jendela dapur kakaknya yang masih menyala."
			},
			{
				"speaker": "Aren",
				"text": "Aku tahu Liora tidak akan membukakan pintu. Aku ikut menguburkannya. Tapi tanganku tetap mengetuk tiga kali, seperti dulu."
			},
			{
				"speaker": "Rana",
				"text": "Masuk. Kau masih mengetuk sebelum mengelap kaki. Kakakmu pasti mengomel."
			},
			{
				"speaker": "Narasi",
				"text": "Rana, penjaga gerbang yang merawat rumah selama Aren pergi, menggeser semangkuk sup. Di bibir mangkuk ada garis emas tipis, mengikuti retak yang sangat dikenalnya."
			},
			{
				"speaker": "Aren",
				"text": "Mangkuk ini pecah waktu aku menjatuhkannya. Liora bilang mau memperbaikinya setelah hujan berhenti."
			},
			{
				"speaker": "Rana",
				"text": "Aku yang memperbaiki. Lama sekali aku menunggu orang lain melakukannya."
			},
			{
				"speaker": "Narasi",
				"text": "Di meja ada kursi kosong milik Nyx. Dulu ia selalu datang menjelang makan, membawa alasan untuk meminjam buku. Liora selalu memasak terlalu banyak."
			},
			{
				"speaker": "Rana",
				"text": "Nyx tinggal di menara sekarang. Setiap malam ia menyalakan Suaka, dan suara Liora terdengar dari sana. Pagi makin terlambat tiba di lingkungan ini."
			},
			{
				"speaker": "Aren",
				"text": "Surat Nyx cuma berbunyi: pulanglah sebelum aku lupa mengapa aku menunggu. Aku kira itu caranya meminta maaf."
			},
			{
				"speaker": "Rana",
				"text": "Mungkin itu caranya meminta tolong. Bawa kartu-kartu Liora. Sebelum ke menara, berlatihlah denganku. Kau tidak perlu pura-pura masih ingat semuanya."
			},
			{
				"speaker": "Narasi",
				"text": "Duel di Eldoria menyalurkan ikatan pada kartu penjaga. Ia dapat membuka segel aether tanpa melukai pemegangnya. Kali ini, Aren hanya perlu belajar memegangnya lagi."
			}
		],
		"win": [
			{
				"speaker": "Rana",
				"text": "Nah. Tanganmu masih gemetar, tetapi kau sudah berhenti meminta maaf setiap kali mengambil kartu."
			},
			{
				"speaker": "Narasi",
				"text": "Rana menyelipkan serbet bersih ke dalam tas Aren. Di ujungnya, Liora pernah menjahit matahari kecil. Salah satu sinarnya lebih pendek."
			},
			{
				"speaker": "Rana",
				"text": "Ia menjahit itu saat menunggumu pulang dari perjalanan pertama. Berkali-kali ia salah hitung karena menoleh ke jendela."
			},
			{
				"speaker": "Aren",
				"text": "Waktu itu aku pulang terlambat dua hari. Aku tidak pernah tahu ia menunggu."
			},
			{
				"speaker": "Rana",
				"text": "Jangan buru-buru menghukum dirimu untuk hal yang baru kau ketahui. Temui Iria di arsip. Ia tahu apa yang sedang dinyalakan Nyx."
			}
		],
		"loss": [
			{
				"speaker": "Rana",
				"text": "Supnya belum dingin. Duduk dulu. Kalah latihan tidak membuatmu terlambat menjadi adiknya."
			},
			{
				"speaker": "Narasi",
				"text": "Rana mengembalikan kartu satu per satu, menghadap ke arah Aren. Tidak ada yang diambil darinya. Ia boleh mencoba lagi."
			}
		]
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
				"text": "Di arsip, Iria sedang memberi label pada stoples kosong. Pada satu label tertulis aroma hujan di atap dapur. Pada yang lain: lagu yang dinyanyikan terlalu pelan."
			},
			{
				"speaker": "Iria",
				"text": "Ini bukan benda yang bisa kumasukkan ke stoples. Aku menuliskan apa yang mulai hilang dari ingatan warga. Supaya mereka tahu ada sesuatu yang pernah mereka miliki."
			},
			{
				"speaker": "Aren",
				"text": "Suaka mengambil ingatan? Nyx tidak bilang apa-apa."
			},
			{
				"speaker": "Iria",
				"text": "Saat menara retak, Nyx menemukan rekaman Liora di dalam aether. Ia menahan peluruhan rekaman itu. Setiap malam Suaka meminjam tenaga dari kenangan lingkungan ini. Cahaya pagi pun tertahan di balik selubungnya."
			},
			{
				"speaker": "Iria",
				"text": "Tidak ada orang hidup di dalamnya, Aren. Suaka tidak tahu apa yang terjadi setelah rekaman dibuat. Namun mengetahui itu tidak membuat Nyx lebih mudah mematikannya."
			},
			{
				"speaker": "Narasi",
				"text": "Iria memperlihatkan daftar Rana: wajah Liora masih diingat, rasa sup buatannya tidak. Aren memikirkan sup yang baru saja ia makan. Ia pun tidak yakin apakah rasanya sama."
			},
			{
				"speaker": "Iria",
				"text": "Segel arsip melindungi serpihan ingatan yang tersisa. Kita perlu membukanya dengan duel. Sebelum itu, tulis sesuatu tentang Liora yang sungguh milikmu. Tidak harus hari ketika ia meninggal."
			},
			{
				"speaker": "Aren / pilihanmu",
				"text": "Apa yang pertama kali Aren tulis?",
				"choice": "memory",
				"options": [
					{
						"value": "care",
						"text": "Ia menyisakan bagian roti yang paling empuk untuk kami."
					},
					{
						"value": "laughter",
						"text": "Ia tertawa saat sinar matahari jahitannya salah hitung."
					}
				]
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"variant": "memory",
				"variants": {
					"care": "Aren menulis tentang tangan Liora yang selalu mendorong bagian roti paling empuk ke piring orang lain. Ingatan itu tidak bersuara, tetapi ia tahu tangan siapa yang sedang diingatnya.",
					"laughter": "Aren menggambar matahari dengan satu sinar yang terlalu pendek. Ia teringat Liora menertawakan jahitannya sendiri, lalu menolak memperbaikinya karena menurutnya matahari juga boleh mengantuk."
				},
				"text": "Aren menulis tentang tangan Liora yang selalu mendorong bagian roti paling empuk ke piring orang lain. Ingatan itu tidak bersuara, tetapi ia tahu tangan siapa yang sedang diingatnya."
			},
			{
				"speaker": "Iria",
				"text": "Tulisanmu bisa tinggal di luar menara. Ini juga tulisan Liora, ditemukan di meja kerja Nyx. Ia menyimpannya di arsip sebelum berhenti turun."
			},
			{
				"speaker": "Narasi",
				"text": "Kertas itu bukan surat perpisahan. Di atasnya ada daftar belanja, jadwal mengantar obat, dan catatan tentang panci yang gagangnya mulai longgar."
			},
			{
				"speaker": "Aren",
				"text": "Ia masih punya rencana untuk besok."
			},
			{
				"speaker": "Iria",
				"text": "Ya. Jangan biarkan hari terakhir mengambil seluruh tempat dalam hidupnya. Bawa ini. Nyx mungkin sudah lupa bahwa ada hal lain yang bisa dibaca."
			}
		],
		"loss": [
			{
				"speaker": "Iria",
				"text": "Segelnya masih utuh. Kenangan yang kita lindungi juga. Tidak ada yang hilang karena percobaan ini."
			},
			{
				"speaker": "Iria",
				"text": "Perhatikan kartu tertutupku. Kau boleh mengambil waktu sebelum memutuskan. Aku akan menunggumu siap."
			}
		]
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
				"text": "Di tangga menara, suara sendok menyentuh cangkir. Lalu suara Liora: Aren sudah makan? Nyx, ambil roti itu. Suara itu berhenti. Sembilan belas detik kemudian, sendok kembali menyentuh cangkir."
			},
			{
				"speaker": "Nyx",
				"text": "Rekamannya dari musim hujan sebelum Malam Retak. Ia sedang menyiapkan sarapan. Aku sudah mendengarnya begitu sering sampai tahu kapan ia menarik napas."
			},
			{
				"speaker": "Aren",
				"text": "Kau tidak menunggunya kembali. Kau tahu ini rekaman."
			},
			{
				"speaker": "Nyx",
				"text": "Aku tahu. Tapi minggu lalu aku mencoba mengingat suaranya tanpa menyalakan Suaka. Yang kudengar cuma suara orang lain yang hampir mirip. Aku takut suatu hari aku tidak tahu bedanya."
			},
			{
				"speaker": "Narasi",
				"text": "Aren melihat bantalan jari Nyx penuh bekas tinta. Di dinding ada sembilan belas garis, ditulis berulang-ulang. Di bawahnya, satu kalimat dicoret sampai kertasnya berlubang: jangan lupa."
			},
			{
				"speaker": "Aren",
				"text": "Rana sudah lupa rasa sup Liora. Iria menuliskan kehilangan orang lain setiap pagi. Aku tidak bisa bilang ini baik-baik saja."
			},
			{
				"speaker": "Nyx",
				"text": "Kalau kau ingin mematikan Suaka, kau harus membuka segel yang kupasang. Aku belum sanggup membantumu melakukan itu. Aku ingin sanggup. Itu yang paling memalukan."
			},
			{
				"speaker": "Aren / pilihanmu",
				"text": "Apa yang Aren katakan kepada Nyx?",
				"choice": "reply",
				"options": [
					{
						"value": "honest",
						"text": "Aku marah. Tapi aku tidak akan meninggalkanmu di sini."
					},
					{
						"value": "uncertain",
						"text": "Aku juga belum tahu caranya pulang setelah kehilangan dia."
					}
				]
			},
			{
				"speaker": "Nyx",
				"text": "Kalau begitu, jangan bilang kau tahu persis apa yang kurasakan. Duduklah satu putaran. Setelah itu, kita lihat apakah tanganku bisa melepaskan segelnya."
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Segel pertama terbuka. Suara Liora berhenti di tengah bunyi cangkir. Nyx tetap menatap lantai, menunggu kalimat yang biasanya datang sesudahnya."
			},
			{
				"speaker": "Nyx",
				"text": "Bukan aku yang berhasil ia jawab. Tak satu pun pertanyaanku berubah selama tiga tahun, dan tak satu pun jawabannya bertambah."
			},
			{
				"speaker": "Aren",
				"text": "Kau bisa menanyakan sesuatu padaku. Aku mungkin tidak tahu jawabannya. Tapi aku bisa mendengarkan."
			},
			{
				"speaker": "Nyx",
				"text": "Ada rekaman latihan yang belum kubuka. Ia membuatnya untukmu, waktu kau ingin berhenti belajar karena selalu kalah. Aku takut kau menganggapnya sebagai kesempatan bertemu dia lagi."
			},
			{
				"speaker": "Narasi",
				"text": "Aren meletakkan daftar belanja di antara mereka. Nyx mengenali lipatan di sudutnya. Untuk pertama kali, ia turun satu anak tangga."
			}
		],
		"loss": [
			{
				"speaker": "Nyx",
				"text": "Aku masih menahan segelnya. Itu saja yang terjadi. Aku tidak ingin kemenangan ini berarti kau harus pergi."
			},
			{
				"speaker": "Narasi",
				"text": "Aren duduk di anak tangga sebelahnya. Mereka menunggu sampai suara cangkir selesai berulang. Kali ini, Nyx tidak harus mendengarnya sendirian."
			}
		]
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
				"text": "Pakai Gerhana-ku. Rekaman ini memakai Fajar. Dulu Liora bilang kau selalu ingin segera menyerang karena tidak tahan melihat siapa pun menunggumu."
			},
			{
				"speaker": "Aren",
				"text": "Ia juga pernah bilang menahan pintu agar orang lain sempat lewat itu sebuah keterampilan. Waktu itu kukira ia cuma menyuruhku membantu belanja."
			},
			{
				"speaker": "Narasi",
				"text": "Nyx tertawa kecil. Lalu mereka sama-sama terdiam, terkejut mendengar suara itu masih bisa keluar."
			},
			{
				"speaker": "Nyx",
				"text": "Ini susunan latihan yang direkam, bukan pikirannya. Ia tidak bisa melihat kita sekarang. Kalau kau ingin berhenti, kita berhenti."
			},
			{
				"speaker": "Aren",
				"text": "Aku mengerti. Aku ingin melihat bagaimana ia mengajariku sebelum aku menjadikan semua kenangan tentangnya begitu berat."
			},
			{
				"speaker": "Rekaman Liora",
				"text": "Tidak apa-apa menunggu satu giliran. Aku masih di sini. Kalau tanganmu sudah siap, kita mulai."
			},
			{
				"speaker": "Narasi",
				"text": "Di meja aether, kartu-kartu Fajar terbuka seperti kebiasaan yang lama tertidur. Aren memegang Gerhana, merasakan bekas lipatan yang ditinggalkan Nyx pada selubung deck-nya."
			}
		],
		"win": [
			{
				"speaker": "Rekaman Liora",
				"text": "Nah, giliranmu menjaga."
			},
			{
				"speaker": "Narasi",
				"text": "Rekaman berakhir. Tidak ada ucapan selamat yang mengetahui apa yang baru mereka lalui. Hanya kalimat lama yang akhirnya didengar Aren dengan cara berbeda."
			},
			{
				"speaker": "Nyx",
				"text": "Pada Malam Retak, aku meminta Liora menunggu sampai tangga aman. Ia mendengar anak-anak terjebak di dapur umum. Ia pergi sebelum aku selesai bicara."
			},
			{
				"speaker": "Aren",
				"text": "Aku juga sering menyusun malam itu supaya ada keputusan yang bisa kuubah. Padahal aku tidak ada di sana. Kau ada. Aku seharusnya bertanya bagaimana kau pulang."
			},
			{
				"speaker": "Nyx",
				"text": "Ia takut, Aren. Ia bilang begitu kepadaku. Aku lelah mendengar orang menyebutnya seolah ia tidak pernah takut."
			},
			{
				"speaker": "Narasi",
				"text": "Mereka membaca daftar belanja Liora. Di bawah obat dan benang ada catatan: jangan pakai panci kecil kalau Nyx datang. Ia selalu bilang sudah makan."
			},
			{
				"speaker": "Nyx",
				"text": "Aku lapar sekali malam itu. Aku masih ingat ia menyodorkan rotinya. Itu bagian yang tidak bisa kuambil dari rekaman."
			}
		],
		"loss": [
			{
				"speaker": "Nyx",
				"text": "Kita matikan latihannya dulu. Kau tidak sedang mengecewakannya. Rekaman ini tidak menilai hidupmu."
			},
			{
				"speaker": "Aren",
				"text": "Aku ingin mencoba lagi. Bukan supaya ia bangga. Aku ingin tahu apakah aku bisa melindungi sesuatu tanpa terus menahannya di tempat."
			}
		]
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
				"text": "Menjelang pagi, Iria datang membawa catatan warga. Rana membawa termos. Tidak seorang pun menanyakan mengapa Nyx belum mematikan menara."
			},
			{
				"speaker": "Iria",
				"text": "Aku bisa menjaga arsipnya. Aku tidak bisa menjanjikan ingatan yang sudah habis akan kembali. Yang masih kita ingat bisa kita tuliskan bersama."
			},
			{
				"speaker": "Nyx",
				"text": "Aku ingin membuka Suaka. Tapi inti segelnya harus dilepas oleh dua ikatan sekaligus. Satu membuka jalur, satu menahan aether agar tidak merusak rumah-rumah di bawah."
			},
			{
				"speaker": "Aren",
				"text": "Aku membawa Fajar. Kau pegang Gerhana."
			},
			{
				"speaker": "Nyx",
				"text": "Duel terakhir ini mengurai segelnya, bukan menentukan siapa yang berhak merindukan Liora. Kalau aku takut di tengah jalan, jangan anggap aku berubah menjadi musuhmu."
			},
			{
				"speaker": "Aren",
				"text": "Aku tidak akan memintamu kuat sepanjang waktu."
			},
			{
				"speaker": "Narasi",
				"text": "Di bawah mereka, lampu dapur masih menyala. Aren menyentuh matahari kecil pada serbetnya. Satu sinarnya pendek. Ia tidak mencoba merapikannya."
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Ketika jalur Fajar terbuka, Nyx menahan kedua sisi segel dengan Gerhana. Tangannya gemetar. Ia tidak melepaskan kartu sebelum arus terakhir melewati rumah-rumah."
			},
			{
				"speaker": "Nyx",
				"text": "Aku mau mendengar suaranya sekali lagi."
			},
			{
				"speaker": "Aren",
				"text": "Aku tahu."
			},
			{
				"speaker": "Narasi",
				"text": "Suaka sudah padam. Mereka menunggu beberapa saat tanpa berpura-pura akan ada kalimat terakhir. Di luar, pedagang roti mengangkat tirai tokonya. Cahaya menyentuh anak tangga yang lama hanya mengenal lampu."
			},
			{
				"speaker": "Nyx",
				"text": "Besok aku akan menemui Rana dan orang-orang di arsip. Aku harus menjelaskan yang kulakukan. Setelah itu... mungkin aku masih ingin kembali ke menara."
			},
			{
				"speaker": "Aren",
				"text": "Besok aku temani. Kita bawa sarapan."
			}
		],
		"loss": [
			{
				"speaker": "Nyx",
				"text": "Jalur Fajar tertutup terlalu cepat. Aku menahan arusnya lagi. Tidak ada rumah yang rusak. Kita masih punya waktu."
			},
			{
				"speaker": "Rana",
				"text": "Termosnya cukup untuk kita semua. Minum dulu, lalu coba lagi kalau sudah siap. Pagi tidak perlu kau tanggung sendirian."
			}
		]
	}
]
const ENDING = [
	{
		"speaker": "Narasi",
		"text": "Beberapa hari kemudian, tidak semua kenangan kembali. Rana memasak sup dengan takaran baru. Nyx membantu Iria mencatat kehilangan warga. Ada yang belum mau berbicara dengannya. Ia belajar menerima itu tanpa meminta Aren membelanya."
	},
	{
		"speaker": "Narasi",
		"text": "Aren dan Nyx pulang ke dapur. Di jendela ada bekas minyak lampu. Aren membersihkannya dengan hati-hati, menyisakan tempat bagi sesuatu yang ingin ia mulai."
	},
	{
		"speaker": "Aren / pilihanmu",
		"text": "Apa yang mereka putuskan untuk dilakukan bersama?",
		"choice": "ritual",
		"options": [
			{
				"value": "lamp",
				"text": "Nyalakan lampu setiap senja untuk orang yang pulang terlambat."
			},
			{
				"value": "table",
				"text": "Buka dapur seminggu sekali untuk siapa pun yang ingin makan bersama."
			}
		]
	},
	{
		"speaker": "Narasi",
		"variant": "ritual",
		"variants": {
			"lamp": "Malam pertama, Rana melihat lampu itu dari gerbang dan mampir setelah tugasnya selesai. Ia tidak perlu mengetuk lama. Nyx sudah membuka pintu sebelum Aren mengangkat kepala.",
			"table": "Pada hari pertama dapur dibuka, Rana datang membawa sayur. Seorang anak dari rumah sebelah membantu menata mangkuk. Nyx menambah air ke panci sebelum ada yang perlu meminta."
		},
		"text": "Malam pertama, Rana melihat lampu itu dari gerbang dan mampir setelah tugasnya selesai. Ia tidak perlu mengetuk lama. Nyx sudah membuka pintu sebelum Aren mengangkat kepala."
	},
	{
		"speaker": "Narasi",
		"variant": "memory",
		"variants": {
			"care": "Aren menyisihkan bagian roti paling empuk. Kali ini ia menanyakan siapa yang menginginkannya, lalu mengambil satu bagian untuk dirinya sendiri.",
			"laughter": "Nyx menjahit matahari pada lap baru. Satu sinarnya terlalu pendek. Aren tertawa sampai harus meletakkan sendoknya, dan Nyx sengaja tidak memperbaikinya."
		},
		"text": "Aren menyisihkan bagian roti paling empuk. Kali ini ia menanyakan siapa yang menginginkannya, lalu mengambil satu bagian untuk dirinya sendiri."
	},
	{
		"speaker": "Narasi",
		"variant": "reply",
		"variants": {
			"honest": "Aren masih marah ketika melihat beberapa baris kosong di buku arsip. Nyx tidak meminta amarah itu cepat selesai. Ia datang membantu menuliskan cerita yang masih mereka ingat.",
			"uncertain": "Mereka masih belajar bagaimana rasanya pulang. Kadang Nyx duduk lama di depan pintu. Aren membiarkannya duduk, lalu menaruh dua cangkir di dekat ambang."
		},
		"text": "Aren masih marah ketika melihat beberapa baris kosong di buku arsip. Nyx tidak meminta amarah itu cepat selesai. Ia datang membantu menuliskan cerita yang masih mereka ingat."
	},
	{
		"speaker": "Narasi",
		"text": "Mangkuk biru dipakai lagi. Retaknya tetap terlihat setiap kali terkena cahaya. Daftar belanja Liora disimpan di laci, bersama resep baru dan tagihan yang belum dibayar."
	},
	{
		"speaker": "Nyx",
		"text": "Aku belum makan."
	},
	{
		"speaker": "Narasi",
		"text": "Aren menoleh. Nyx tidak menambahkan alasan untuk meminjam buku, atau mengatakan ia hanya sebentar. Ia menarik kursinya dan duduk."
	},
	{
		"speaker": "Aren",
		"text": "Kalau begitu kita pakai panci besar."
	}
]
