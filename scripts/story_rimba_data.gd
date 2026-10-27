extends RefCounted
const BOOK_ID = "akar_esok"
const TITLE = "Kebun untuk yang Pulang"
const BOOK_NUMBER = "II"
const PREMISE = "Aren dan Nyx menemui Sera di jalan kebun yang terputus. Tiga bab tentang pulih, meminta bantuan, dan memberi tempat bagi perubahan."
const BACKGROUND = "res://assets/art/compost.png"
const SCENE_CARDS = ["grove","renewal","verdant"]
const CHOICES = {"seed":["save","share"],"route":["slow","together"]}
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
				"text": "Beberapa pekan setelah Suaka padam, Rana menyelipkan kantong benih ke tas Aren. Di lipatannya tertulis nama Banyu. Ia pernah mengantar sayur ke dapur Liora, sebelum banjir memutus jalan kebun."
			},
			{
				"speaker": "Rana",
				"text": "Kalau bertemu putrinya, bilang tidak apa-apa kalau musim ini ia belum bisa mengirim apa pun. Jangan pulang membawa janji yang belum sanggup ia buat."
			},
			{
				"speaker": "Narasi",
				"text": "Di ujung jalan, Aren dan Nyx menemukan seorang penjaga sedang mengangkat tunas dari sela batu. Sera tidak meminta mereka menunggu. Ia menunjuk dua sekop yang tersandar di pohon."
			},
			{
				"speaker": "Sera",
				"text": "Kalau mau lewat, bantu pindahkan tanah ini. Akar sudah menyambung jalannya, tetapi segel aether di bawah jembatan belum stabil."
			},
			{
				"speaker": "Aren",
				"text": "Kami membawa benih untuk Banyu. Rana bilang ia belum kembali ke rumah."
			},
			{
				"speaker": "Sera",
				"text": "Ayah tinggal di kota seberang sekarang. Katanya kebun ini milikku. Aku ingin mengembalikannya seperti dulu sebelum menjemputnya."
			},
			{
				"speaker": "Nyx",
				"text": "Seperti dulu itu banyak sekali pekerjaan untuk dua tangan."
			},
			{
				"speaker": "Sera",
				"text": "Itulah gunanya Rimba. Kartu yang sudah jatuh masih bisa menjadi bekal. Mari buka jalurnya dengan duel. Kalian pegang Fajar; aku menahan akar di sisi kebun."
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Segel pertama terbuka. Sera mengambil kartu yang kembali ke tangannya, meluruskan sudutnya, lalu memasukkannya ke selubung. Bukan sudut yang sama dengan sebelum ia jatuh."
			},
			{
				"speaker": "Sera",
				"text": "Pemulihan mengembalikan monster ke tangan, bukan langsung ke papan. Aku masih harus menunggu giliran untuk memanggilnya. Hutan pun tidak bisa dipaksa tumbuh dua kali lebih cepat."
			},
			{
				"speaker": "Aren",
				"text": "Kenapa kau masih bekerja di dekat jalan yang runtuh, bukan di kebun?"
			},
			{
				"speaker": "Sera",
				"text": "Karena dari jalan inilah Ayah biasanya pulang. Aku terus membenahinya lebih dulu. Kebunku sendiri belum sempat kutanami."
			}
		],
		"loss": [
			{
				"speaker": "Sera",
				"text": "Akar menutup jalurnya lagi. Tidak apa-apa. Tunas yang tadi kita pindahkan masih aman."
			},
			{
				"speaker": "Narasi",
				"text": "Mereka duduk di sisi jalan. Sera membagi air dari botolnya, lalu menunggu Aren mengumpulkan kartu. Tak satu pun benih harus dibuang karena duel ini."
			}
		]
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
				"text": "Banyu datang ke saluran dengan gerobak kecil berisi papan. Sera langsung meraih cangkul untuknya, lalu berhenti ketika melihat pergelangan tangan ayahnya yang dibalut."
			},
			{
				"speaker": "Banyu",
				"text": "Bawa cangkul itu untukmu. Aku menggambar alur airnya. Tanganku belum kuat untuk menggali, tetapi aku masih ingat ke mana air mencari jalan."
			},
			{
				"speaker": "Sera",
				"text": "Kalau jembatannya sudah pulih, Ayah bisa pulang. Aku bisa membetulkan bagian lainnya."
			},
			{
				"speaker": "Banyu",
				"text": "Aku senang kau menyisakan tempat untukku. Tapi aku juga perlu tempat untuk diriku yang sekarang. Aku belum sanggup tinggal di rumah dekat sungai itu lagi."
			},
			{
				"speaker": "Narasi",
				"text": "Sera mengusap kantong benih yang dibawa Aren. Ada cukup tanah kering untuk satu petak kecil; petak yang lain masih perlu dibersihkan bersama."
			},
			{
				"speaker": "Aren",
				"text": "Apa yang ingin kita mulai dari petak ini?"
			},
			{
				"speaker": "Aren / pilihanmu",
				"text": "Benih mana yang mereka tanam lebih dulu?",
				"choice": "seed",
				"options": [
					{
						"value": "save",
						"text": "Simpan benih keluarga di petak yang sudah siap."
					},
					{
						"value": "share",
						"text": "Bagikan sebagian benih ke kebun tetangga."
					}
				]
			},
			{
				"speaker": "Nyx",
				"text": "Kita bisa menjaga benih yang belum ditanam. Tidak semua yang dibawa pulang harus segera dipakai."
			},
			{
				"speaker": "Sera",
				"text": "Pinjam Rimba-ku, Aren. Segel saluran ini memakai pertahanan Gerhana. Kali ini aku ingin melihat jalan yang kau pilih dengan kartu-kartuku, bukan mengerjakannya sendiri."
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Aliran air mencapai petak pertama tanpa menggerus tanah di tepinya. Banyu meminta papan gambarnya digeser sedikit. Sera menggesernya tanpa menyodorkan cangkul lagi."
			},
			{
				"speaker": "Banyu",
				"text": "Kau mengembalikan salurannya dengan baik. Bagian lama yang runtuh tidak perlu kau bangun di tempat yang sama."
			},
			{
				"speaker": "Sera",
				"text": "Aku takut kalau kebunnya berubah, Ayah tidak akan mengenali jalan pulang."
			},
			{
				"speaker": "Banyu",
				"text": "Tulis namaku di bangku dekat petak itu. Aku bisa datang duduk. Untuk sekarang, itu caraku pulang."
			},
			{
				"speaker": "Narasi",
				"text": "Nyx memeriksa tali gerobak agar Banyu tidak perlu mengangkat papan dengan tangan yang sakit. Ia tidak mengatakan bahwa ia mengerti semuanya. Ia hanya mengikatnya sedikit lebih longgar."
			}
		],
		"loss": [
			{
				"speaker": "Sera",
				"text": "Airnya belum bisa lewat. Kita tahan dulu. Mengambil kartu dari Grave terlalu cepat juga bisa membuat bonus naga lebih kecil."
			},
			{
				"speaker": "Banyu",
				"text": "Ada bagian gambarku yang kurang jelas. Coba lihat bersamaku sebelum kita mulai lagi. Ini bukan pekerjaan satu orang."
			}
		]
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
				"text": "Akar purba menopang jembatan dari bawah. Di atasnya, papan-papan baru menunggu dipasang. Sera datang membawa daftar pekerjaan, dengan namanya tertulis di hampir setiap baris."
			},
			{
				"speaker": "Aren",
				"text": "Siapa yang boleh membantu kalau semua baris ini sudah kau isi?"
			},
			{
				"speaker": "Sera",
				"text": "Aku belum terbiasa menulis nama orang lain untuk pekerjaan yang takut kutinggalkan."
			},
			{
				"speaker": "Nyx",
				"text": "Tulis namaku di bagian tali. Aku bisa memeriksanya bersama Banyu."
			},
			{
				"speaker": "Narasi",
				"text": "Sera menghapus beberapa baris. Serpihan penghapus jatuh di antara tulisan yang masih terlalu rapat. Aren menunggu sampai ia mengangkat kepala."
			},
			{
				"speaker": "Aren / pilihanmu",
				"text": "Bagaimana Aren menawarkan bantuan?",
				"choice": "route",
				"options": [
					{
						"value": "slow",
						"text": "Kita kerjakan satu bagian dulu, lalu beristirahat bersama."
					},
					{
						"value": "together",
						"text": "Bagikan pekerjaannya; kau tidak harus memeriksa semuanya sendiri."
					}
				]
			},
			{
				"speaker": "Sera",
				"text": "Baik. Dua ikatan Rimba untuk menata akar jembatan. Satu menahan fondasi, satu membuka jalur baru. Kali ini, kalau ada yang jatuh, kita punya cara membawanya kembali."
			},
			{
				"speaker": "Narasi",
				"text": "Aren mengambil deck pinjaman itu. Di tepi sungai, Banyu duduk dengan papan gambar di lutut. Ia sudah menulis namanya sendiri pada bangku yang belum selesai dicat."
			}
		],
		"win": [
			{
				"speaker": "Narasi",
				"text": "Naga Akar Purba mengangkat punggungnya sampai papan terakhir terpasang. Ketika segel terbuka, ia tidak menarik akar dari tanah lama. Ia merentangkannya ke sisi sungai yang baru."
			},
			{
				"speaker": "Sera",
				"text": "Aku kira Ayah mau pulang kalau aku bisa memperbaiki semuanya."
			},
			{
				"speaker": "Banyu",
				"text": "Aku datang karena kau mengundangku. Bukan karena kau sudah selesai."
			},
			{
				"speaker": "Narasi",
				"text": "Sera meletakkan cangkul di samping bangku. Ia duduk bersama ayahnya sementara Aren dan Nyx menyingkirkan serpihan papan dari jalur pejalan kaki."
			}
		],
		"loss": [
			{
				"speaker": "Sera",
				"text": "Fondasinya masih menahan kita. Kita belum selesai, tetapi kita juga tidak kembali ke awal."
			},
			{
				"speaker": "Narasi",
				"text": "Sera meminta orang-orang memeriksa bagian mereka masing-masing. Kali ini ia tidak mendahului semua jawaban. Aren menyimpan kartu, lalu membuka botol air untuk dibagi."
			}
		]
	}
]
const ENDING = [
	{
		"speaker": "Narasi",
		"variant": "seed",
		"variants": {
			"save": "Petak kecil keluarga tumbuh lebih dulu. Sera menulis tanggal di tepinya, bukan janji kapan seluruh kebun harus selesai. Benih yang tersisa disimpan untuk musim berikutnya.",
			"share": "Tetangga datang membawa pot yang berbeda-beda. Beberapa benih keluarga Sera tumbuh jauh dari kebunnya sendiri. Ketika ia menyusuri jalan, ia mengenali daun yang sama di jendela orang lain."
		},
		"text": "Petak kecil keluarga tumbuh lebih dulu. Sera menulis tanggal di tepinya, bukan janji kapan seluruh kebun harus selesai. Benih yang tersisa disimpan untuk musim berikutnya."
	},
	{
		"speaker": "Narasi",
		"variant": "route",
		"variants": {
			"slow": "Setiap sore, Sera berhenti ketika matahari menyentuh bangku. Ada hari ketika pekerjaan belum banyak berubah. Di bangku itu, ia mulai bisa membicarakan hal selain bagian yang rusak.",
			"together": "Daftar pekerjaan ditempel di dekat jembatan. Beberapa nama ditulis dengan huruf miring, beberapa terlalu besar. Sera menahan diri untuk tidak menuliskan namanya di setiap ruang kosong."
		},
		"text": "Setiap sore, Sera berhenti ketika matahari menyentuh bangku. Ada hari ketika pekerjaan belum banyak berubah. Di bangku itu, ia mulai bisa membicarakan hal selain bagian yang rusak."
	},
	{
		"speaker": "Narasi",
		"text": "Banyu tetap tinggal di kota seberang. Dua kali seminggu ia datang memeriksa air dan duduk di bangku. Sera belajar menanyakan kabarnya sebelum menanyakan kapan ia akan pulang."
	},
	{
		"speaker": "Sera",
		"text": "Bawa ini untuk Rana. Panennya belum banyak. Jangan bilang ia harus menunggu kiriman berikutnya."
	},
	{
		"speaker": "Narasi",
		"text": "Aren menerima segenggam daun sup dan deck Rimba yang kini boleh ia bawa. Nyx menyelipkan selembar kertas bersih di sampingnya, untuk daftar pekerjaan yang belum mereka tahu."
	},
	{
		"speaker": "Aren",
		"text": "Kita tulis namamu sebagai pengirim. Tidak perlu kata maaf di bawahnya."
	}
]
