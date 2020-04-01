package db

var planets = []string{
	"Arkas",
	"Orbitar",
	"Taphao Thong",
	"Dimidium",
	"Galileo",
	"Amateru",
	"Dagon",
	"Tadmor",
	"Hypatia",
	"Quijote",
	"Thestias",
	"Saffar",
	"Fortitudo",
	"Draugr",
	"Eburonia",
	"Mastika",
	"Caleuche",
	"Ditsö̀",
	"Asye",
	"Finlay",
	"Toge",
	"Noifasui",
	"Lete",
	"Trimobe",
	"Xólotl",
	"Laligurans",
	"Perwana",
	"Tumearandu",
	"Leklsullun",
	"Negoiu",
	"Dopere",
	"Eiger",
	"Sazum",
	"Barajeel",
}

func ValidatePlanet(planet string) bool {
	for _, v := range planets {
		if v == planet {
			return true
		}
	}
	return false
}

func ListPlanets() []string {
	return planets
}
