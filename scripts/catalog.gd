extends RefCounted

# Definisi kartu dipisahkan dari aturan dan tampilan.
const CARDS = {
	"dawn": {"id":"dawn", "name":"Penjaga Fajar", "kind":"monster", "element":"CAHAYA", "atk":1600, "def":1200, "level":4, "art":0, "effect":"", "lore":"Ksatria Eldoria yang menjaga cahaya terakhir di gerbang kota.", "text":"Monster normal tanpa efek khusus."},
	"ember": {"id":"ember", "name":"Naga Bara", "kind":"monster", "element":"API", "atk":2200, "def":1500, "level":6, "art":1, "effect":"burn", "lore":"Dari perut gunung purba, naga ini membawa bara yang tak pernah padam.", "text":"Tribute: korbankan 1 monster (zona pilihan, atau ATK terendah). Saat summon: berikan 300 kerusakan ke LP lawan."},
	"oracle": {"id":"oracle", "name":"Oracle Rembulan", "kind":"monster", "element":"BULAN", "atk":1200, "def":1700, "level":3, "art":2, "effect":"heal", "lore":"Di bawah rembulan, sang oracle membaca takdir melalui pantulan bintang.", "text":"Saat summon: pulihkan 400 LP, hingga maksimal 4000 LP."},
	"fenrir": {"id":"fenrir", "name":"Fenrir Zamrud", "kind":"monster", "element":"ALAM", "atk":1800, "def":900, "level":4, "art":3, "effect":"", "lore":"Roh penjaga hutan zamrud yang memburu siapa pun yang mengusik tanahnya.", "text":"Monster normal tanpa efek khusus."},
	"warden": {"id":"warden", "name":"Aegis Surya", "kind":"monster", "element":"CAHAYA", "atk":900, "def":2100, "level":4, "art":0, "art_file":"res://assets/art/aegis_surya.png", "art_focus":0.32, "effect":"shield", "lore":"Ditempa untuk menahan malam, Aegis menyimpan sinar matahari di dalam perisainya.", "text":"Sekali selama berada di papan, bertahan dari kehancuran akibat serangan. Kerusakan LP tetap berlaku."},
	"sprite": {"id":"sprite", "name":"Peri Astral", "kind":"monster", "element":"BULAN", "atk":1000, "def":800, "level":2, "art":2, "art_file":"res://assets/art/peri_astral.png", "art_focus":0.36, "effect":"draw", "lore":"Peri kecil merangkai cahaya bintang menjadi jalan bagi mereka yang tersesat.", "text":"Saat summon: ambil 1 kartu dari deck."},
	"storm": {"id":"storm", "name":"Badai Aether", "kind":"spell", "element":"SPELL", "atk":0, "def":0, "level":0, "art":4, "effect":"damage", "lore":"Aether yang terlepas dari langit menjelma menjadi badai di atas Eldoria.", "text":"Aktifkan dari tangan: berikan 500 kerusakan langsung ke LP lawan."},
	"sanctuary": {"id":"sanctuary", "name":"Suaka Surya", "kind":"spell", "element":"SPELL", "atk":0, "def":0, "level":0, "art":5, "effect":"restore", "lore":"Di balik reruntuhan kuil, matahari masih menyinari tempat para penjaga beristirahat.", "text":"Aktifkan dari tangan: pulihkan 700 LP, hingga maksimal 4000 LP."},
	"blessing": {"id":"blessing", "name":"Berkah Fajar", "kind":"spell", "element":"SPELL", "atk":0, "def":0, "level":0, "art":5, "art_file":"res://assets/art/berkah_fajar.png", "art_focus":0.46, "effect":"buff", "lore":"Sayap fajar menyelimuti sebilah pedang, membawa harapan untuk pertempuran berikutnya.", "text":"Pilih 1 monster milikmu: tambah 400 ATK dan 400 DEF selama monster itu berada di papan."},
	"eclipse": {"id":"eclipse", "name":"Retakan Langit", "kind":"spell", "element":"SPELL", "atk":0, "def":0, "level":0, "art":4, "art_file":"res://assets/art/retakan_langit.png", "art_focus":0.4, "effect":"destroy", "lore":"Langit yang retak memperlihatkan kehampaan di balik cahaya bintang.", "text":"Pilih dan hancurkan 1 monster lawan dengan ATK 1800 atau kurang. Perlindungan Aegis tidak mencegah efek ini."},
	"sentinel": {"id":"sentinel","name":"Penjaga Senja","kind":"monster","element":"BULAN","atk":1700,"def":1300,"level":4,"art":0,"night_art":0,"effect":"twilight_setup","lore":"Ia menjaga tangga observatorium ketika cahaya terakhir menghilang.","text":"Sekali per duel, saat summon: pasang 1 Cermin Pembalasan dari deck ke zona spell/trap kosong. Trap baru aktif mulai giliran berikutnya."},
	"owl": {"id":"owl","name":"Burung Hantu Perak","kind":"monster","element":"BULAN","atk":1100,"def":2000,"level":4,"art":0,"night_art":1,"effect":"","lore":"Sayap peraknya meredam suara di antara pepohonan malam.","text":"Monster normal tanpa efek khusus."},
	"witch": {"id":"witch","name":"Penyihir Cermin","kind":"monster","element":"BULAN","atk":1400,"def":1400,"level":3,"art":0,"night_art":2,"effect":"draw","lore":"Di setiap serpihan cermin ia melihat satu kemungkinan masa depan.","text":"Saat summon: ambil 1 kartu dari deck."},
	"noctis": {"id":"noctis","name":"Naga Noctis","kind":"monster","element":"BULAN","atk":2300,"def":1900,"level":6,"art":0,"night_art":3,"effect":"shield","lore":"Naga obsidian bangkit setiap kali bulan menelan matahari.","text":"Tribute: korbankan 1 monster. Sekali di papan, bertahan dari kehancuran akibat serangan; kerusakan LP tetap berlaku."},
	"mirror": {"id":"mirror","name":"Cermin Pembalasan","kind":"trap","element":"TRAP","atk":0,"def":0,"level":0,"art":0,"night_art":4,"effect":"reflect","lore":"Permukaan perak memantulkan bukan wajah, melainkan niat buruk.","text":"Respons serangan lawan: batalkan serangan dan berikan 300 kerusakan ke LP penyerang."},
	"seal": {"id":"seal","name":"Segel Hening","kind":"trap","element":"TRAP","atk":0,"def":0,"level":0,"art":0,"night_art":5,"effect":"negate","lore":"Rantai kuno mengunci kata terakhir dari sebuah mantra.","text":"Respons spell atau trap lawan: batalkan efek terakhir dalam rantai. Dapat membalas trap pembatalan."},
	"thorns": {"id":"thorns","name":"Belenggu Spektral","kind":"trap","element":"TRAP","atk":0,"def":0,"level":0,"art":0,"night_art":6,"effect":"weaken","lore":"Duri tanpa wujud menahan pedang sebelum menyentuh tanah.","text":"Respons serangan lawan: ATK monster penyerang turun 500 selama berada di papan. Serangan tetap berlanjut."},
	"hourglass": {"id":"hourglass","name":"Jam Pasir Astral","kind":"spell","element":"SPELL","atk":0,"def":0,"level":0,"art":0,"night_art":7,"effect":"insight","lore":"Sebutir pasir menyimpan ingatan langit sebelum fajar.","text":"Aktifkan dari tangan: ambil 2 kartu. Kehabisan deck saat mengambil kartu berarti kalah."}
}
const DECK = ["dawn","dawn","dawn","ember","ember","oracle","oracle","fenrir","fenrir","fenrir","warden","sprite","sprite","storm","storm","sanctuary","sanctuary","blessing","blessing","eclipse"]

static func card(id: String) -> Dictionary:
	return CARDS[id].duplicate(true)

const GERHANA = ["sentinel","sentinel","sentinel","owl","owl","witch","witch","noctis","noctis","oracle","sprite","sprite","mirror","mirror","seal","thorns","hourglass","blessing","storm","eclipse"]
const PRESETS = {"fajar":{"name":"Fajar / Serangan","cards":DECK},"gerhana":{"name":"Gerhana / Kontrol","cards":GERHANA}}

static func type_text(c: Dictionary) -> String:
	if c["kind"] == "trap":
		return "TRAP / JEBakan RESPONS".to_upper()
	return "SPELL / MAGI AKTIF" if c["kind"] == "spell" else "%s / LEVEL %d" % [c["element"],c["level"]]

static func validate(ids: Array) -> String:
	if ids.size() != 20:
		return "Deck harus tepat 20 kartu (%d saat ini)." % ids.size()
	var counts := {}
	var monsters: int = 0
	for id in ids:
		if not id is String or not CARDS.has(id):
			return "Deck memuat kartu yang tidak dikenal."
		counts[id] = int(counts.get(id,0))+1
		if counts[id] > 3:
			return "Maksimal 3 salinan untuk setiap kartu."
		if CARDS[id]["kind"] == "monster":
			monsters += 1
	if monsters < 8:
		return "Deck memerlukan minimal 8 monster."
	return ""

static func deck(ids: Array = DECK) -> Array:
	var result: Array = []
	for id in ids:
		result.append(card(id))
	return result
