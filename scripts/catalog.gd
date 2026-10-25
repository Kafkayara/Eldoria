extends RefCounted

# Definisi kartu dipisahkan dari aturan dan tampilan.
const CARDS = {
	"dawn": {"id":"dawn", "name":"Penjaga Fajar", "kind":"monster", "element":"CAHAYA", "atk":1600, "def":1200, "level":4, "art":0, "effect":"", "text":"Ksatria Eldoria yang menjaga cahaya terakhir. Monster tanpa efek khusus."},
	"ember": {"id":"ember", "name":"Naga Bara", "kind":"monster", "element":"API", "atk":2200, "def":1500, "level":6, "art":1, "effect":"burn", "text":"Perlu 1 tribute: korbankan monstermu dengan ATK terendah (atau zona yang kamu pilih). Saat summon, berikan 300 kerusakan ke lawan."},
	"oracle": {"id":"oracle", "name":"Oracle Rembulan", "kind":"monster", "element":"BULAN", "atk":1200, "def":1700, "level":3, "art":2, "effect":"heal", "text":"Saat summon: pulihkan 400 LP. Penyembuh yang membaca takdir di antara bintang."},
	"fenrir": {"id":"fenrir", "name":"Fenrir Zamrud", "kind":"monster", "element":"ALAM", "atk":1800, "def":900, "level":4, "art":3, "effect":"", "text":"Roh hutan dengan serangan tinggi. Lindungi ia dari musuh yang lebih kuat."},
	"warden": {"id":"warden", "name":"Aegis Surya", "kind":"monster", "element":"CAHAYA", "atk":900, "def":2100, "level":4, "art":0, "effect":"shield", "text":"Sekali selama berada di papan, bertahan dari kehancuran akibat serangan. Kerusakan LP tetap berlaku."},
	"sprite": {"id":"sprite", "name":"Peri Astral", "kind":"monster", "element":"BULAN", "atk":1000, "def":800, "level":2, "art":2, "effect":"draw", "text":"Saat summon: ambil 1 kartu. Cahaya kecil yang membuka jalan menuju kombinasi berikutnya."},
	"storm": {"id":"storm", "name":"Badai Aether", "kind":"spell", "element":"SPELL", "atk":0, "def":0, "level":0, "art":4, "effect":"damage", "text":"Aktifkan dari tangan: berikan 500 kerusakan langsung ke LP lawan."},
	"sanctuary": {"id":"sanctuary", "name":"Suaka Surya", "kind":"spell", "element":"SPELL", "atk":0, "def":0, "level":0, "art":5, "effect":"restore", "text":"Aktifkan dari tangan: pulihkan 700 LP, hingga maksimal 4000 LP."},
	"blessing": {"id":"blessing", "name":"Berkah Fajar", "kind":"spell", "element":"SPELL", "atk":0, "def":0, "level":0, "art":5, "effect":"buff", "text":"Pilih 1 monster milikmu: tambah 400 ATK dan 400 DEF selama monster itu berada di papan."},
	"eclipse": {"id":"eclipse", "name":"Retakan Langit", "kind":"spell", "element":"SPELL", "atk":0, "def":0, "level":0, "art":4, "effect":"destroy", "text":"Pilih dan hancurkan 1 monster lawan dengan ATK 1800 atau kurang. Aegis hanya melindungi dari serangan."}
}
const DECK = ["dawn","dawn","dawn","ember","ember","oracle","oracle","fenrir","fenrir","fenrir","warden","sprite","sprite","storm","storm","sanctuary","sanctuary","blessing","blessing","eclipse"]

static func card(id: String) -> Dictionary:
	return CARDS[id].duplicate(true)

static func deck() -> Array:
	var result: Array = []
	for id in DECK:
		result.append(card(id))
	return result
