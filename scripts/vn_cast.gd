extends RefCounted
const PEOPLE = {
	"aren": {
		"name": "Aren",
		"role": "Kurir • Adik Liora • Tokoh yang kamu mainkan",
		"about": "Aren, 22 tahun, bekerja mengantar barang di luar Eldoria. Ia pulang setelah Nyx meminta bantuan. Deck Fajar milik kakaknya mengingatkannya pada rumah, tetapi ia belum tahu apa yang terjadi di Suaka.",
		"relation": "Liora adalah kakaknya. Nyx sahabat masa kecilnya. Rana menjaga rumah selama ia pergi.",
		"color": "#a8c5da"
	},
	"liora": {
		"name": "Liora",
		"role": "Kakak Aren • Pengelola dapur warga",
		"about": "Liora meninggal pada Malam Retak, tiga tahun sebelum cerita dimulai, ketika menolong warga. Semasa hidup ia mengurus dapur bersama dan mengajari Aren serta Nyx bermain kartu penjaga. Di cerita ia hanya hadir dalam kenangan atau rekaman.",
		"relation": "Kakak Aren; teman dekat Nyx; mengenal Rana sejak mereka tinggal bertetangga.",
		"color": "#e1bb89"
	},
	"nyx": {
		"name": "Nyx",
		"role": "Teknisi Suaka • Sahabat masa kecil Aren",
		"about": "Nyx, 23 tahun, merawat alat perekam kenangan bernama Suaka. Ia mengirim surat meminta Aren pulang. Ia mengenal Liora sejak kecil dan masih menyimpan rekaman suaranya.",
		"relation": "Sahabat Aren. Sering makan di dapur Liora. Bekerja sama dengan arsiparis Iria sebelum mengurung diri di menara.",
		"color": "#c4b2df"
	},
	"rana": {
		"name": "Rana",
		"role": "Penjaga gerbang • Tetangga keluarga Aren",
		"about": "Rana menjaga gerbang timur Eldoria dan merawat rumah Liora selama Aren merantau. Aren memanggilnya Bibi. Ia terbiasa menolong lewat hal praktis: makanan hangat, rumah yang terawat, dan latihan sebelum perjalanan.",
		"relation": "Tetangga dekat Aren dan Liora; mengenal Nyx sejak kecil.",
		"color": "#d8a18a"
	},
	"iria": {
		"name": "Iria",
		"role": "Arsiparis Eldoria • Penyelidik kerusakan Suaka",
		"about": "Iria mencatat laporan warga dan menyimpan arsip aether. Ia mengenal cara kerja Suaka. Ia membantu Aren memisahkan kenangan yang masih mereka punya dari rekaman yang hanya mengulang masa lalu.",
		"relation": "Rekan kerja Nyx di observatorium. Aren menemuinya atas saran Rana.",
		"color": "#91c6bd"
	},
	"sera": {
		"name": "Sera",
		"role": "Penjaga kebun • Putri Banyu • Pemilik deck Rimba",
		"about": "Sera merawat kebun keluarga dan memperbaiki jalan yang rusak oleh banjir. Ia ingin ayahnya pulang, tetapi sering mengambil semua pekerjaan sendiri. Ia memakai kartu Rimba untuk menata akar dan memulihkan sumber daya.",
		"relation": "Putri Banyu. Aren dan Nyx menemuinya saat mengantar kantong benih titipan Rana.",
		"color": "#afca8e"
	},
	"banyu": {
		"name": "Banyu",
		"role": "Petani • Ayah Sera • Perancang saluran air",
		"about": "Banyu selamat dari banjir, tetapi pergelangan tangannya cedera dan ia kini tinggal di kota seberang. Ia belum bisa menggali seperti dulu. Ia tetap membantu kebun lewat pengetahuan tentang pengairan.",
		"relation": "Ayah Sera; dulu mengirim sayuran untuk dapur Liora.",
		"color": "#d4bb90"
	}
}
static func id_for(speaker: String) -> String:
	if speaker == "Rekaman Liora": return "liora"
	for id in PEOPLE:
		if speaker.begins_with(PEOPLE[id]["name"]): return id
	return ""
