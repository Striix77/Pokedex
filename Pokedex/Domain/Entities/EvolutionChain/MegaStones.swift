import Foundation

enum MegaStones {
    static func condition(for pokemonName: String) -> EvolutionCondition {
        let trigger = EvolutionNamedEntry(name: "mega-evolution")
        let stone = stoneByPokemonName[pokemonName].map { EvolutionNamedEntry(name: $0) }
        let move = pokemonName == "rayquaza-mega" ? EvolutionNamedEntry(name: "dragon-ascent") : nil
        return EvolutionCondition(
            minLevel: nil, minHappiness: nil, minAffection: nil,
            timeOfDay: nil, needsOverworldRain: nil, turnUpsideDown: nil,
            item: stone, evolutionTrigger: trigger, location: nil, move: move, type: nil
        )
    }

    private static let stoneByPokemonName: [String: String] = [
        "venusaur-mega":    "venusaurite",
        "charizard-mega-x": "charizardite-x",
        "charizard-mega-y": "charizardite-y",
        "blastoise-mega":   "blastoisinite",
        "alakazam-mega":    "alakazite",
        "gengar-mega":      "gengarite",
        "kangaskhan-mega":  "kangaskhanite",
        "pinsir-mega":      "pinsirite",
        "gyarados-mega":    "gyaradosite",
        "aerodactyl-mega":  "aerodactylite",
        "mewtwo-mega-x":    "mewtwonite-x",
        "mewtwo-mega-y":    "mewtwonite-y",
        "ampharos-mega":    "ampharosite",
        "scizor-mega":      "scizorite",
        "heracross-mega":   "heracronite",
        "houndoom-mega":    "houndoominite",
        "tyranitar-mega":   "tyranitarite",
        "blaziken-mega":    "blazikenite",
        "gardevoir-mega":   "gardevoirite",
        "mawile-mega":      "mawilite",
        "aggron-mega":      "aggronite",
        "medicham-mega":    "medichamite",
        "manectric-mega":   "manectite",
        "banette-mega":     "banettite",
        "absol-mega":       "absolite",
        "garchomp-mega":    "garchompite",
        "lucario-mega":     "lucarionite",
        "abomasnow-mega":   "abomasite",
        "sceptile-mega":    "sceptilite",
        "swampert-mega":    "swampertite",
        "sableye-mega":     "sablenite",
        "sharpedo-mega":    "sharpedonite",
        "camerupt-mega":    "cameruptite",
        "altaria-mega":     "altarianite",
        "glalie-mega":      "glalitite",
        "salamence-mega":   "salamencite",
        "metagross-mega":   "metagrossite",
        "latias-mega":      "latiasite",
        "latios-mega":      "latiosite",
        "lopunny-mega":     "lopunnite",
        "gallade-mega":     "galladite",
        "audino-mega":      "audinite",
        "diancie-mega":     "diancite",
        "beedrill-mega":    "beedrillite",
        "pidgeot-mega":     "pidgeotite",
        "slowbro-mega":     "slowbronite",
        "steelix-mega":     "steelixite",
    ]
}
